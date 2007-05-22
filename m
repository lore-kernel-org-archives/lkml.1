Return-Path: <linux-kernel-owner+w=401wt.eu-S1763050AbXEVCOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763050AbXEVCOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXEVCOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:14:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:59521 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbXEVCOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kkDIKWP4LlviBrb6kFTpzFHo5QqTaxMz2EGLo4tOAMc35B2n58V+vWkhnyMfS2ZAD+iRCJ9q34U2wik44JeP6Wmv9rDDtD6L9isp0/hspTe1y7FJMcgB6tORoK7Yq6Sbl8skZdLYS2SDCGu1dQkofwA30Inqbxu75GcYT1GNDZg=
Message-ID: <a8e1da0705211914rf323f90kb67482e47992b5d7@mail.gmail.com>
Date: Tue, 22 May 2007 02:14:22 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4651CA63.9030903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464DDA40.6010101@zytor.com>
	 <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
	 <465124EA.1020801@zytor.com>
	 <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>
	 <46512821.9010905@zytor.com>
	 <a8e1da0705202239r31d03a5dyc2f0ce6a795e0124@mail.gmail.com>
	 <465138CC.3060605@zytor.com>
	 <a8e1da0705210141m4d9f0ccevde3060fefcc55537@mail.gmail.com>
	 <4651CA63.9030903@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> This implies a miscompile somewhere, *or* that your bios stomps on
> registers that gcc expect preserved, and adding printf's disturbs the
> register allocation sufficiently.

I think maybe it's caused by gcc optimize, so I add volatile to
read_sector inline assemblly, then kernel can boot successfully.

please check this patch :

diff -ur linux/arch/i386/boot/edd.c linux.new/arch/i386/boot/edd.c
--- linux/arch/i386/boot/edd.c  2007-05-22 10:08:59.000000000 +0000
+++ linux.new/arch/i386/boot/edd.c      2007-05-22 10:06:24.000000000 +0000
@@ -47,7 +47,7 @@
        ax = 0x4200;            /* Extended Read */
        si = (size_t)&dapa;
        dx = devno;
-       asm ("pushfl; stc; int $0x13; setc %%al; popfl"
+       asm volatile("pushfl; stc; int $0x13; setc %%al; popfl"
            : "+a" (ax), "+S" (si), "+d" (devno)
            : : "ebx", "ecx", "edi");

@@ -58,7 +58,7 @@
        cx = 0x0001;            /* Sector 0-0-1 */
        dx = devno;
        bx = (size_t)buf;
-       asm ("pushfl; stc; int $0x13; setc %%al; popfl"
+       asm volatile("pushfl; stc; int $0x13; setc %%al; popfl"
            : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
            : : "esi", "edi");

Regards
dave
