Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYGOWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYGOWYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYGOWYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:24:03 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:55314 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYGOWYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:24:01 -0400
Date: Tue, 15 Jul 2008 22:23:59 +0000
From: Sean Young <sean@mess.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080715222359.GA70973@atlantis.8hz.com>
References: <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <20080701202014.GA77013@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701202014.GA77013@atlantis.8hz.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:20:14PM +0000, Sean Young wrote:
> On Tue, Jul 01, 2008 at 07:59:42PM +0000, Sean Young wrote:
> > On Mon, Jun 30, 2008 at 03:42:47PM -0700, H. Peter Anvin wrote:
> > > diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
> > > index ab049d4..141b6e2 100644
> > > --- a/arch/x86/boot/pmjump.S
> > > +++ b/arch/x86/boot/pmjump.S
> > > @@ -33,6 +33,8 @@ protected_mode_jump:
> > >  	movw	%cs, %bx
> > >  	shll	$4, %ebx
> > >  	addl	%ebx, 2f
> > > +	jmp	1f			# Short jump to serialize on 386/486
> > > +1:
> > >  
> > >  	movw	$__BOOT_DS, %cx
> > >  	movw	$__BOOT_TSS, %di
> > > @@ -40,8 +42,6 @@ protected_mode_jump:
> > >  	movl	%cr0, %edx
> > >  	orb	$X86_CR0_PE, %dl	# Protected mode
> > >  	movl	%edx, %cr0
> > > -	jmp	1f			# Short jump to serialize on 386/486
> > > -1:
> > >  
> > >  	# Transition to 32-bit mode
> > >  	.byte	0x66, 0xea		# ljmpl opcode
> > 
> > I'm afraid it doesn't work. Maybe I can find something in the AMD Elan
> > documentation. Would a fence make sense?
> 
> I was just trying to confirm this with postive and negative tests which 
> is failing. I'm probably being an idiot, please let systematically test
> this.

When I bisected this issue between latest and 2.6.23 the issue seemed to be
here (round about 2.6.24-rc1). Trying to repeat the same things on latest 
just led to confusion.

So I've started from scratch with contemporary trees and found something 
very different.

2.6.25: works
2.6.25.5: works
2.6.25.6: broken
2.6.25.10: broken
2.6.26: works

Now the issue which was introduced in 2.6.25.6 is that a rdtsc will be done
even though this CPU does not support it (before console_init(), leaving
me with only one led for output!). This issue has been fixed in 2.6.26 but 
not in 2.6.25-stable.

The protected mode jump was just a red herring (or at least whatever was 
broken back then is fixed now); 2.6.26 is working fine and that's good 
enough for me.

Thanks for all the help,

Sean
