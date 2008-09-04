Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYIDJDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYIDJDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYIDJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:03:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757220AbYIDJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:03:29 -0400
Date: Thu, 4 Sep 2008 02:03:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for September 3
In-Reply-To: <20080904013743.0ecc9ec5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809040151080.3452@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903214634.ea17ff53.akpm@linux-foundation.org> <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org> <20080903223318.84b6ce8b.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org> <20080904012544.cabed847.akpm@linux-foundation.org> <20080904013743.0ecc9ec5.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Andrew Morton wrote:
> 
> ooh look, I fixed something:
> 
> --- a/drivers/pcmcia/cs.c~a
> +++ a/drivers/pcmcia/cs.c
> @@ -477,6 +477,8 @@ static int socket_setup(struct pcmcia_so
>  	 */
>  	msleep(vcc_settle * 10);
>  
> +	msleep(100);
> +

Heh. I'm hoping that it would help to just change vcc_settle to 50 
instead?

>  	skt->ops->get_status(skt, &status);
>  	if (!(status & SS_POWERON)) {
>  		cs_err(skt, "unable to apply power.\n");
> _
> 
> we seem not to be giving that card enough settling time.  Or is it
> a characteristic of the controller?  

No, I think it's mainly the card.

> It's a module option, but google(linux "unable to apply power") gets
> 859 hits.  Maybe the default is too short..

I certainly don't think it would be wrong to change it to a longer 
timeout. Although I also suspect that we should in that case try to exit 
early too, ie change it to something like

	for (i = 0; i < vcc_settle; i++) {
		msleep(10);
		skt->ops->get_status(skt, &status);
		if (status & SS_POWERON)
			break;
	}

or similar. But if changing it to 50 fixes it for you, that's probably a 
good minimal change for now.

> btw, do we really need to spew all this?
> 
> pccard: card ejected from slot 0
> 3c59x 0000:07:00.0: restoring config space at offset 0xf (was 0xffffffff, writing 0x50a0115)
> 3c59x 0000:07:00.0: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
...

No.

Although it's really a KERN_DEBUG(), so most people shouldn't even notice. 
I do wonder why somebody does pci_restore_state() when the card is 
ejected..

Oh. It's literally drivers/net/3c59x.c: vortex_remove_one(). So it's not 
the PCI or Cardbus layer, it's the driver itself doing odd things. I don't 
think it's worth worrying about. It's trying to restore the state and 
disable the device that was unplugged and no longer exists ;)

(Which can definitely be a useful thing if the remove_one is done because 
of some user-initiated driver removal. So I do understand why the driver 
has that code, it just doesn't make sense when the removal is due to the 
hardware itself going away).

		Linus
