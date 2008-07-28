Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYG1W3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYG1W3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYG1W3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:29:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYG1W3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:29:44 -0400
Date: Tue, 29 Jul 2008 00:29:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, travis@sgi.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, dsterba@suse.cz,
       jkosina@suse.cz
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
	error: invalid use of undefined type 'struct ipw_network'
Message-ID: <20080728222925.GA21012@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu> <20080728214153.GA30511@elte.hu> <20080728220631.GA8095@elte.hu> <20080728152056.8e83c4ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728152056.8e83c4ec.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Jul 2008 00:06:31 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of 
> > > undefined type 'struct ipw_network'
> > > 
> > > http://redhat.com/~mingo/misc/config-Mon_Jul_28_23_36_20_CEST_2008.bad
> > > 
> > > probably due to a string of commits to that file from today.
> > 
> > hm, has this version of the driver ever been built successfully? Because 
> > struct ipw_network is defined in network.c [only], and then used in 
> > hardware.c.
> > 
> > It could be changed to void * if the structure wasnt relied on by:
> > 
> >                         const int min_capacity =
> >                                 ipwireless_ppp_mru(hw->network + 2);
> > 
> > so changing it to void * would break this part of the code.
> > 
> > furthermore, what does that "hw->network + 2" mean? It points into 
> > la-la-land AFAICS, because it's initialized as:
> > 
> >         struct ipw_network *network =
> >                 kzalloc(sizeof(struct ipw_network), GFP_ATOMIC);
> > 
> > and then written into hw->network via:
> > 
> >         ipwireless_associate_network(hw, network);
> > 
> > it's getting late here, so i might be missing some really obvious 
> > solution (and Jiri is asleep i suspect), so below is a temporary patch 
> > that marks the driver CONFIG_BROKEN until this is resolved. This gets 
> > allyesconfig going on x86.
> 
> I suspect that this:
> 
> --- a/drivers/char/pcmcia/ipwireless/hardware.c~a
> +++ a/drivers/char/pcmcia/ipwireless/hardware.c
> @@ -568,7 +568,7 @@ static struct ipw_rx_packet *pool_alloca
>  			list_del(&packet->queue);
>  		} else {
>  			const int min_capacity =
> -				ipwireless_ppp_mru(hw->network + 2);
> +				ipwireless_ppp_mru(hw->network) + 2;
>  			int new_capacity;
>  
>  			spin_unlock_irqrestore(&hw->lock, flags);
> _
> 
> was intended.

ah, indeed. I see, this came from the 12/12 patch:

-                       static int min_capacity = 256;
+                       const int min_capacity =
+                               ipwireless_ppp_mru(hw->network + 2);

which was probably a last-minute change. So instead of turning the 
driver into something (while the author is sleeping) that was never 
tested before, i'd rather suggest to revert commit 
a01386924874c4d6d67f8a34e66f04452c2abb69, which seems a non-essential 
optimization to the driver and which apparently was not build tested, so 
quite likely not functionality tested either. It reverts cleanly here.

OTOH ... your change looks correct enough too.

	Ingo
