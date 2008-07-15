Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbYGOCLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbYGOCLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYGOCLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:11:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:24812 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYGOCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=W7I9jHkERCo2TZ9tCjA0Zwb32Qw3jZBhWpQ0dXQYryxUlp2Xm39l0t4DhaSK16H2tv
         obUpBGgo6rJXdZhvDK+pEFK8cb7/v8dCYa6/VQL/OxAIOOPiOA4LJd1yliWUvTTClIyb
         1aARvxklF5XTw23wqxPXyF3y4aFUGnywv59+Q=
Message-ID: <487C074E.8080309@gmail.com>
Date: Tue, 15 Jul 2008 04:11:26 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
References: <4877400B.1000400@gmail.com>
In-Reply-To: <4877400B.1000400@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060802020207000008040404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060802020207000008040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Török Edwin a écrit :
> Hi,
>
> Today's linux-next tree (commit
> 93847083e4791567931bd17c039cc35881cdad29) fails to boot:
> [built with gcc-4.2.4-3]
>
> BUG: Int 14: CR2 b0049dea
>      EDI 00000082 ESI 00000000 EBP c059be88 ESP c059be5c
>      EBX f000ec62 EDX 0000000e ECX c0595480 EAX f000ec62
>      err 00000000 EIP c0181ca0  CS 00000060 flg 00010082
> Stack:   00000040 c06a2ba0 000080d0 c0595480 c0000f19c c000f180 c0581120
> c059bea8
>          c02bf19b 00000000 00000080 c059beb8 c0000f194 c000f180 0000000a
> c059beb8
>          c03a1059 00000000 00000000 c059bed8 c05c4c7c  0009efff 00000000
> c04f4df4
>
> I get this as soon as I boot from grub2, strangely the error message is
> at the bottom of the screen, and I can't see the full message (scrolling
> won't work).
>
> The last kernel I built & booted was 2.6.26-rc8 from Linus's tree. I
> will try to built&boot 2.6.26-rc9, and then bisect.
>
> This happens on 32-bit Dell Inspiron 6400 (Intel Core Duo T2300 @1.66
> Ghz CPU),  Intel ICH-7 chipset, and a seagate SATA drive. 
> I will provide  full hardware details once I bisected the problem.
>
> Meanwhile, if somebody has an idea as to what is wrong?
>
> Best regards,
> --Edwin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

I got the same problem on an x86-PC and after looking at the stack, the 
problem comes from firmware_map_add_early() in drivers/firmware/memmap.c

The backtrace is the following:

kzalloc()
verify_dynamic_kobject_allocation()
kobject_init()
firmware_map_add_entry()
firmware_map_add_early()
e820_reserve_resources()
setup_arch() (in x86)

The problem is that verify_dynamic_kobject_allocation() calls kzalloc 
assuming that kmem_cache_init() has already been called. But it's not 
the case and it's too soon to call the kmalloc/kzalloc functions.

I don't know what is the real problem: the fact that kobject_init is 
called too soon or verify_dynamic_kobject_allocation() which calls 
kzalloc without making any assumption about its current context.

So here is just a patch to temporarily disable 
verify_dynamic_kobject_allocation() This function just checks the sanity 
of the code.



--------------060802020207000008040404
Content-Type: text/x-patch;
 name="disable_verify_dyn_kobject.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="disable_verify_dyn_kobject.diff"

--- a/lib/kobject.c	2008-07-15 02:55:08.000000000 +0200
+++ b/lib/kobject.c	2008-07-15 04:01:10.000000000 +0200
@@ -335,7 +335,6 @@
 		       "object, something is seriously wrong.\n", kobj);
 		dump_stack();
 	}
-	verify_dynamic_kobject_allocation(kobj);
 
 	kobject_init_internal(kobj);
 	kobj->ktype = ktype;

--------------060802020207000008040404--
