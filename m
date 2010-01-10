Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191Ab0AJNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0AJNgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 08:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032Ab0AJNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 08:36:32 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54978 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0AJNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 08:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oLvDvNQL/iX4rpoTUjYRjq8X11yXp9wc7wFQJ1U97iwjW/6mC/Hdh+5eJLzcC9y9up
         9a+B5HvMvtsUn5StLlr0ZzQ75m3NVM/uLcGVpOOQIr5cV7XCk5FCFx7+umutqd6p11PF
         +y2YsJcEGQsTxHU/v3/dtyyjEd18CkLezdaDI=
Date: Sun, 10 Jan 2010 16:36:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Brian Gerst <brgerst@gmail.com>, Christian Kujau <lists@nerdbynature.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100110133628.GC5189@lenovo>
References: <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de> <20100108215039.GD4967@lenovo> <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com> <20100110080940.GB5189@lenovo> <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 12:59:03PM +0000, Ian Campbell wrote:
> On Sun, 2010-01-10 at 11:09 +0300, Cyrill Gorcunov wrote:
> > On Sat, Jan 09, 2010 at 08:50:04PM -0500, Brian Gerst wrote:
> > ...
> > > > ---
> > > > x86: kernel_thread -- initialize SS to a known state
> > > >
> > > > Before the kernel_thread was converted into "C" we had
> > > > pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).
> > > >
> > > > Though I must admit I didn't find any *explicit* load of
> > > > %ss from this structure the better to be on a safe side
> > > > and set it to a known value.
> > > 
> > > It shouldn't make any difference, but maybe Xen is doing something
> > > subtle.  In 64-bit mode the %ss segment register is supposed to be
> > > ignored, which is why it is left set to zero.  It works properly on
> > > real hardware.  It can't hurt anything to put __KERNEL_DS back in, but
> > > I'd just like to know why Xen requires it if this does fix it.
> > 
> > Yeah, I didn't found any explicit %ss reloading for this _particular_
> > case (as I marked in patch changelog). So the only suspicious is Xen
> > itself. So as only Christian get ability to test -- we will see the
> > results.
> 
> The difference with Xen is that it must squash the RPL of SS (to 3 for
> 64 bit and 1 for 32 bit, 32 bit doesn't matter here though). Perhaps a
> NULL selector can only have RPL==0? (I'm away from my architecture docs
> so I can't check). In any case specifying a non-NULL SS selector allows
> the squashing to occur correctly.
> 
> However this is not the cause of the original "Guest switching to user
> mode with no user page tables" error. This is down to 
>         commit f443ff4201dd25cd4dec183f9919ecba90c8edc2
>         Author: Brian Gerst <brgerst@gmail.com>
>         Date:   Wed Dec 9 12:34:43 2009 -0500
>         
>             x86: Sync 32/64-bit kernel_thread
>             
>             Signed-off-by: Brian Gerst <brgerst@gmail.com>
>             LKML-Reference: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
>             Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> which on 64 bit resulted in changing regs.cs from "__KERNEL_CS" to
> "__KERNEL_CS | get_kernel_rpl()". The later seems more logical (and is
> correct for 32 bit) but on 64 bit we frequently use a pattern like "cmpl
> $3, CS(%rsp); je foo" quite a bit to detect return to user vs kernel and
> an RPL of 1 will unfortunately incorrectly trigger the return to
> userspace paths.
> 
> The correct fix is for the Xen backend to declare kernel RPL == 0 for 64
> bit guests -- the hyervisor already takes care of all the necessary
> squashing to ring 3 transparently (because making the guest worry about
> it would break the very common assumption that you can distinguish user
> from kernel CS by RPL).
> 
> With just the CS RPL fix below I see a GPF at kernel_thread_helper with
> SS=3 (hence my hypothesis about NULL selectors and non-zero RPL above).
> With both the SS and CS fixes things work fine.

any of CS,SS loaded with NULL descriptor should lead to #GP

> 
> Ian.
> 
> --- 
> Subject: xen: 64 bit kernel RPL should be 0.
> 
...

Good catch Ian! I've noted that Xen use it's own get_kernel_rpl
while discussing this problem in a chat. But I must admit *I simply don't know*
what Xen does, or how it works internally (neither I have will to learn it at
moment :)

That said -- I'm happy if yor patch fixes problem (and it looks that
get_kernel_rpl is guilty here indeed).

	-- Cyrill
