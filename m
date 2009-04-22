Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZDVHDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZDVHDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZDVHD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:03:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDVHDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:03:25 -0400
Date: Wed, 22 Apr 2009 09:01:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: New x86 warning
Message-ID: <20090422070157.GA28438@elte.hu>
References: <49EEBD3C.3060009@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEBD3C.3060009@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> On x86-32, this warning now appears for me in 2.6.30-rc3, and did 
> not appear in 2.6.29.
>
> drivers/acpi/acpica/tbfadt.c: In function 'acpi_tb_create_local_fadt':
> /spare/repo/linux-2.6/arch/x86/include/asm/string_32.h:75: warning:  
> array subscript is above array bounds

Last i checked it was a GCC bounds check bogosity. All attempts to 
work it around or annotate it sanely (without changing the assembly 
code) failed. (new ideas welcome)

The closest i came was the hacklet below to the assembly code. [with 
an intentionally corrupted patch header to make it harder to apply 
accidentally.]

The hacklet writes the fifth byte by writing two bytes from byte 
position 3.

> lspci, dmesg and .config attached.
>
> 	Jeff
>
> P.S.  It is unclear in MAINTAINERS whether x86@kernel.org should 
> be CC'd in addition to the other addresses listed, or as a 
> replacement for individual emails.

at your option. Cc:-ing maintainers directly can get faster 
treatment occasionally. Using the alias is shorter.

	Ingo

NOT-Signed-off-by-me:

+++ linux/arch/x86/include/asm/string_32.h
@@ -72,7 +72,7 @@ static __always_inline void *__constant_
 		return to;
 	case 5:
 		*(int *)to = *(int *)from;
-		*((char *)to + 4) = *((char *)from + 4);
+		*((short *)(char *)(to + 3)) = *((short *)(char *)(from + 3));
 		return to;
 	case 6:
 		*(int *)to = *(int *)from;
