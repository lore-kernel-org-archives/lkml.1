Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYGAT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYGAT7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYGAT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:59:44 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:58042 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYGAT7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:59:43 -0400
Date: Tue, 1 Jul 2008 19:59:42 +0000
From: Sean Young <sean@mess.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080701195942.GA76608@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48696167.6050000@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 03:42:47PM -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> >
> >Maybe it really does require the far jump immediately after setting PE 
> >in cr0...
> >
> >Hm, I don't remember this paragraph being in vol 3a, section 8.9.1 
> >before.  Is it a recent addition?
> >
> >   Random failures can occur if other instructions exist between steps
> >   3 and 4 above.  Failures will be readily seen in some situations,
> >   such as when instructions that reference memory are inserted between
> >   steps 3 and 4 while in system management mode.
> >
> 
> I don't remember that, either.

Which document are we talking about? 

> Sean: could you try the following patch?
> 
> 	-hpa

> diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
> index ab049d4..141b6e2 100644
> --- a/arch/x86/boot/pmjump.S
> +++ b/arch/x86/boot/pmjump.S
> @@ -33,6 +33,8 @@ protected_mode_jump:
>  	movw	%cs, %bx
>  	shll	$4, %ebx
>  	addl	%ebx, 2f
> +	jmp	1f			# Short jump to serialize on 386/486
> +1:
>  
>  	movw	$__BOOT_DS, %cx
>  	movw	$__BOOT_TSS, %di
> @@ -40,8 +42,6 @@ protected_mode_jump:
>  	movl	%cr0, %edx
>  	orb	$X86_CR0_PE, %dl	# Protected mode
>  	movl	%edx, %cr0
> -	jmp	1f			# Short jump to serialize on 386/486
> -1:
>  
>  	# Transition to 32-bit mode
>  	.byte	0x66, 0xea		# ljmpl opcode

I'm afraid it doesn't work. Maybe I can find something in the AMD Elan
documentation. Would a fence make sense?

Thanks
Sean
