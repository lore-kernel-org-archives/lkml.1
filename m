Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbZFBLFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbZFBLFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZFBLFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:05:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:44295 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbZFBLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:05:14 -0400
Message-Id: <20090602110511.645421321@de.ibm.com>
References: <20090602105311.591592481@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 12:53:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 1/4] maccess: add weak attribute to probe_kernel_write
Content-Disposition: inline; filename=200-maccess-weak.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

probe_kernel_write() gets used to write to the kernel address space.
E.g. to patch the kernel (kgdb, ftrace, kprobes...). Some architectures
however enable write protection for the kernel text section, so that
writes to this region would fault.
This patch allows to specify an architecture specific version of
probe_kernel_write() which allows to handle and bypass write protection
of the text segment.
That way it is still possible to catch random writes to kernel text
and explicitly allow writes via this interface.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/mm/maccess.c linux-2.6-patched/mm/maccess.c
--- linux-2.6/mm/maccess.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6-patched/mm/maccess.c	2009-06-02 10:40:04.000000000 +0200
@@ -39,7 +39,7 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_kernel_write(void *dst, void *src, size_t size)
+long notrace __weak probe_kernel_write(void *dst, void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();

-- 
