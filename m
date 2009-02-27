Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbZB0Ugx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbZB0Ugx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbZB0Uek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34814 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbZB0Uej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:39 -0500
Subject: [RFC][PATCH 6/8] mark /dev/null and zero as checkpointable
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:32 -0800
References: <20090227203425.F3B51176@kernel>
In-Reply-To: <20090227203425.F3B51176@kernel>
Message-Id: <20090227203432.5A9DF0FC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We currently have a special_file() check in the checkpoint
code which considers all special files as uncheckpointable.

Now that we have the f_op and a generic function, use that
to override these simple devices and make them OK to
checkpoint.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/drivers/char/mem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/mem.c~make-dev-null-work drivers/char/mem.c
--- linux-2.6.git/drivers/char/mem.c~make-dev-null-work	2009-02-27 12:07:39.000000000 -0800
+++ linux-2.6.git-dave/drivers/char/mem.c	2009-02-27 12:07:39.000000000 -0800
@@ -27,6 +27,7 @@
 #include <linux/splice.h>
 #include <linux/pfn.h>
 #include <linux/smp_lock.h>
+#include <linux/checkpoint.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -824,6 +825,7 @@ static const struct file_operations null
 	.read		= read_null,
 	.write		= write_null,
 	.splice_write	= splice_write_null,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 #ifdef CONFIG_DEVPORT
@@ -840,6 +842,7 @@ static const struct file_operations zero
 	.read		= read_zero,
 	.write		= write_zero,
 	.mmap		= mmap_zero,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 /*
_
