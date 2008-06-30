Return-Path: <linux-kernel-owner+w=401wt.eu-S934126AbYF3VxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbYF3VxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933626AbYF3Vnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:43:52 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:54074 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933600AbYF3Vnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:43:51 -0400
Date: Mon, 30 Jun 2008 21:43:47 +0000
From: Sean Young <sean@mess.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080630214347.GA57988@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616161944.GA53539@atlantis.8hz.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 04:19:44PM +0000, Sean Young wrote:
> On Mon, Jun 16, 2008 at 06:37:12AM -0700, Jeremy Fitzhardinge wrote:
> > Rusty Russell wrote:
> > >On Monday 16 June 2008 22:11:39 Sean Young wrote:
> > >  
> > >>The symptons are either a crash or reboot on booting the kernel. No
> > >>printk's have occurred yet -- even with early printk on.
> > >>
> > >>2.6.15 worked on this board however current does not. I've bisected it to:
> > >>
> > >>	commit a24e785111a32ccb7cebafd24b1b1cb474ea8e5d
> > >>	Author: Rusty Russell <rusty@rustcorp.com.au>
> > >>	Date:   Sun Oct 21 16:41:35 2007 -0700
> > >>
> > >>	    i386: paravirt boot sequence
> > >>    
> > >
> > >Hi Sean,
> > >
> > >   Thanks for tracking this down.  Can we try reverting this in pieces to 
> > >   see exactly what the cause was?
> > >
> > >1) Revert arch/x86/boot/compressed/head_32.S
> > >2) If that doesn't fix it, Try removing the 8 lines which were added to 
> > >arch/x86/kernel/head_32.S
> > >  
> > And the arch/x86/boot/compressed/misc_32.c change too, just in case...
> 
> Reverting only head_32.S makes the problem go away. I didn't try any other
> changes.

Looking at the beginning of startup_32, it seems ds is used before it is set:

startup_32:
        cld
        /* test KEEP_SEGMENTS flag to see if the bootloader is asking
         * us to not reload segments */
        testb $(1<<6), BP_loadflags(%esi)
        jnz 1f

        cli
        movl $(__BOOT_DS),%eax
        movl %eax,%ds
        movl %eax,%es
        movl %eax,%fs
        movl %eax,%gs
        movl %eax,%ss
1:

Since the testb instruction is a dereference, ds is implicitly used. If
I move the testb to after "movl %eax,%ds" it seems to work (not that it
would make any sense there, but just to prove the point).

1) Am I barking up the wrong tree?

2) If I'm right I have no idea what the correct solution is; it seems that
   a chicken & egg issue is introduced.

Please advise. I am very new to all of this.


Sean
