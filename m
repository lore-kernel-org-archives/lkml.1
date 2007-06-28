Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbXF1Oto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbXF1Oto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXF1Osz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:48:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2984 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761657AbXF1Osx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:48:53 -0400
Date: Thu, 28 Jun 2007 14:25:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Rafael Wysocki <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070628142532.GC5339@ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706192118.23706.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi all
> 
> Here's what I have after today's work.
> 
> I haven't yet been able to test on x86, but can confirm that it works okay on x86_64. I'm currently working towards testing it on my old Omnibook. My P4 desktop won't resume from suspend to ram at all, and hasn't produced any beeps.
> 
> I needed to move the BEEP invocation to after the data segment is reloaded, so that the test could access the variable. That was pretty tricky to find - no oops or anything bad prior, it just didn't beep when expected.
> 
> A couple of notes:
> 
> - I'd like to put the BEEP macro somewhere that can be shared by x86 32 and 64. If that's a good idea, any suggestions on where? Nothing occurs to me straight off.
> - I've just switched from Evo to Kmail. Please let me know if there's any mangling of the patch.
> 
> Regards,
> 
> Nigel
> 
>  arch/i386/kernel/acpi/wakeup.S   |   29 ++++++++++++++++++++++++++++-
>  arch/x86_64/kernel/acpi/wakeup.S |   25 +++++++++++++++++++++++++
>  include/linux/acpi.h             |    1 +
>  kernel/power/main.c              |   23 +++++++++++++++++++++++
>  4 files changed, 77 insertions(+), 1 deletion(-)
> diff -ruNp 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S 970-str-beep.patch-new/arch/i386/kernel/acpi/wakeup.S
> --- 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S	2007-06-19 12:15:25.000000000 +1000
> +++ 970-str-beep.patch-new/arch/i386/kernel/acpi/wakeup.S	2007-06-19 21:14:49.000000000 +1000
> @@ -11,7 +11,22 @@
>  #
>  # If physical address of wakeup_code is 0x12345, BIOS should call us with
>  # cs = 0x1234, eip = 0x05
> -# 
> +#
> +
> +#define BEEP \
> +	inb	$97, %al; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$3, %al; 	\
> +	outb	%al, $97; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-74, %al; 	\
> +	outb	%al, $67; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-119, %al; 	\
> +	outb	%al, $66; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$15, %al; 	\
> +	outb	%al, $66;
>  
>  ALIGN
>  	.align	4096
> @@ -31,6 +46,11 @@ wakeup_code:
>  	movw	%cs, %ax
>  	movw	%ax, %ds					# Make ds:0 point to wakeup_start
>  	movw	%ax, %ss
> +
> +	testl   $1, beep_flags - wakeup_code
> +	jz      1f
> +	BEEP
> +1:

Can we rename/reuse existing flag variable?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
