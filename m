Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZBNDmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZBNDmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 22:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZBNDmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 22:42:40 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:40680 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZBNDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 22:42:40 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 22:42:39 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XQRXGG/6m+DjMmO3/f6mP2PpkbAkOsOgu2ImJj9QOyyCF/mxqmhg8FLuNp6UakH8MG
         vBLrWUZb890d90i2SZYpE1IYGHSE6qaWd0R+i3QaX9KbmksMblawKrGceIObhhL5eIfX
         7IHNaj4D7btKRMJ9lhhCo6m0mPe071KexqBsA=
MIME-Version: 1.0
Date: Sat, 14 Feb 2009 09:42:38 +0600
Message-ID: <b9df5fa10902131942q4670aa16s6c190fd99384943e@mail.gmail.com>
Subject: [PATCH -mm] kmemleak: Fix section mismatch in kmemleak.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Section mismatch

The function kmemleak_alloc() is called from kernel allocators.
kmemleak_alloc() calls log_early() but being log_early() marked as
__init it causes following section mismatches. Being called from
kernel allocators, kmemleak_allock() will be called after freeing up
the init memory and log_early() will also called. So, unmarking __init
from log_early() fixes the warning. If anything else please notice.

  LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x4f371): Section mismatch in reference
from the function kmemleak_alloc() to the function
.init.text:log_early()
The function kmemleak_alloc() references
the function __init log_early().
This is often because kmemleak_alloc lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f470): Section mismatch in reference
from the function kmemleak_free() to the function
.init.text:log_early()
The function kmemleak_free() references
the function __init log_early().
This is often because kmemleak_free lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f56f): Section mismatch in reference
from the function kmemleak_not_leak() to the function
.init.text:log_early()
The function kmemleak_not_leak() references
the function __init log_early().
This is often because kmemleak_not_leak lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f66e): Section mismatch in reference
from the function kmemleak_ignore() to the function
.init.text:log_early()
The function kmemleak_ignore() references
the function __init log_early().
This is often because kmemleak_ignore lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f786): Section mismatch in reference
from the function kmemleak_scan_area() to the function
.init.text:log_early()
The function kmemleak_scan_area() references
the function __init log_early().
This is often because kmemleak_scan_area lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: mm/built-in.o(.text+0x4f885): Section mismatch in reference
from the function kmemleak_no_scan() to the function
.init.text:log_early()
The function kmemleak_no_scan() references
the function __init log_early().
This is often because kmemleak_no_scan lacks a __init
annotation or the annotation of log_early is wrong.

Thanks.

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/mm/kmemleak.c	2009-02-13 11:23:55.000000000 +0600
+++ rakib/mm/kmemleak.c	2009-02-13 23:05:45.000000000 +0600
@@ -230,8 +230,8 @@ struct early_log {
 };

 /* early logging buffer and current position */
-static struct early_log __initdata early_log[200];
-static int __initdata crt_early_log;
+static struct early_log early_log[200];
+static int crt_early_log;

 static void kmemleak_disable(void);

@@ -682,7 +682,7 @@ static void object_no_scan(unsigned long
  * Log an early kmemleak_* call to the early_log buffer. These calls will be
  * processed later once kmemleak is fully initialized.
  */
-static void __init log_early(int op_type, const void *ptr, size_t size,
+static void log_early(int op_type, const void *ptr, size_t size,
 			     int min_count,
 			     unsigned long offset, size_t length)
 {
