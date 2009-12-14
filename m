Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZLNEgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZLNEgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZLNEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:36:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:34412 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZLNEgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:36:47 -0500
Subject: Re: [PATCH] kfifo: fix warn_unused_result
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20091213142907.d0ac63da.akpm@linux-foundation.org>
References: <1260523108.27010.7.camel@wall-e>
	 <20091213142907.d0ac63da.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Dec 2009 05:36:39 +0100
Message-ID: <1260765399.6620.51.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 13.12.2009, 14:29 -0800 schrieb Andrew Morton:
> On Fri, 11 Dec 2009 10:18:28 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > As requested by Andrew Morton:
> > 
> > This patch fix the "ignoring return value of '...', declared with
> > attribute warn_unused_result" compiler warning in several users of the
> > new kfifo API.
> > 
> > The patch-set is against current mm tree from 11-Dec-2009
> > 
> > ...
> >
> > --- mmotm/drivers/char/nozomi.c	2009-12-11 08:31:46.670736197 +0100
> > +++ linux-2.6.32/drivers/char/nozomi.c	2009-12-11 09:25:46.941436203 +0100
> > @@ -685,8 +685,9 @@ static int nozomi_read_config_table(stru
> >  		dump_table(dc);
> >  
> >  		for (i = PORT_MDM; i < MAX_PORT; i++) {
> > -			kfifo_alloc(&dc->port[i].fifo_ul,
> > -				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
> > +			if (kfifo_alloc(&dc->port[i].fifo_ul,
> > +				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC))
> > +					BUG();
> 
> No, we can't do this.  GFP_ATOMIC allocations are unreliable and can
> fail.  The calling code *has* to detect the failure and then take some
> recovery action.
> 
> It would be better to leave the warning in place, rather than to add
> this runtime landmine.
> 

The problem is that the old code did not provide an error check. So i
don't think it is a land mine, because this drivers tries to allocate a
some kfifo inside an interrupt. But i think i am able to understand the
code and fix it.

> >  		input_sync(kp.dev);
> > -		kfifo_in_locked(&sonypi_device.input_fifo,
> > +		if (kfifo_in_locked(&sonypi_device.input_fifo,
> >  			(unsigned char *)&kp, sizeof(kp),
> > -			&sonypi_device.input_fifo_lock);
> > +			&sonypi_device.input_fifo_lock) != sizeof(kp))
> > +				BUG();
> 
> The rest of the patch seems to be adding BUG()s if kfifo_in() fails. 
> All over the place.
> 
> If that's the appropriate way to handle failure for these callsites
> then it would be neater to do this in the callee.  ie, add a new
> 
> unsigned int kfifo_in_nonpartial(struct kfifo *fifo,
>                         const unsigned char *from, unsigned int len)
> {
> 	unsigned int ret = kfifo_in(fifo, from, len);
> 
> 	BUG_ON(ret != len);
> 	return ret;
> }
> 

No, i don't like to idea to introduce a new API call, because i must
also introduce a 

kfifo_out_nonpartial()
kfifo_in_nonpartial_locked()
and
kfifo_out_nonpartial_locked()

I don't like this _locked functions, it is a design break and only
introduced for compatibility reasons.

This will also go way if i get the okay for the new kqueue API.

If it is okay, i will remove the __must_check from kfifo_in and
kfifo_in_locked. But the kfifo_out and kfifo_out_locked check must be
performed and if it fails, it is a real BUG.


