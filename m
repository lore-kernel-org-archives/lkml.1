Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbZAWR5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbZAWR5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZAWR51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:57:27 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:45950 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbZAWR50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GOH0/QqJ6Uml3yX4ENgMbKBl/t5Ak+lpfrLfNvAwckMcS9h68ey8h0j0M3sYO6nRH7
         xw+SkODjj2znhNiKm7BSEILOBFIiUE59Ua1HJ9voK1OhNEy1ZlplGpKIDuCuaWGJ6U2j
         BxysyEda8p/fjLSi4gwVNBS7eAcFjTRkHxCUs=
Message-ID: <497A0500.3080706@gmail.com>
Date: Fri, 23 Jan 2009 19:57:20 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: inline asm semantics: output constraint width smaller than input
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to build the kernel with LLVM 2.5 prerelease (using
llvm-gcc-4.2 frontend), however I am running into some inline asm
semantics issues, and after some discussion on LLVM bugzilla I would
like to know if you would be accepting patches for this:
http://llvm.org/bugs/show_bug.cgi?id=3373

The problem is when "a" output constraint is used with a variable of
smaller width than the
"0" input constraint.

Here are 2 examples:

int __ret_pu; unsigned long __pu_val;
return   ({asm volatile("call __put_user_" "8" : "=a" (__ret_pu) :"0"
                          (__pu_val), "c"(addr) : "ebx"); __ret_pu;});


unsigned char return_code;      /* %al */         
unsigned long address;          /* %ebx */ 
unsigned long length;           /* %ecx */
unsigned long entry;            /* %edx */
unsigned long flags;
__asm__("lcall *(%%edi); cld"
                : "=a" (return_code),
                  "=b" (address),
                  "=c" (length),
                  "=d" (entry)
                : "0" (service),
                  "1" (0),
                  "D" (&bios32_indirect));

There are 2 cases:
1. output is wider than input
2. output is narrower than input

Case 2 seems to occur lots of times on 64-bit (due to sizeof(int) != sizeof(unsigned long)), 
and a few times on 32-bit as well.

Would you accept patches that increase the portability of the inline asm statements? 
(essentially by adding casts for case 1, and introducing a temporary of correct width for case 2).

Please see: 
http://llvm.org/bugs/show_bug.cgi?id=3373#c6

Best regards,
--Edwin

