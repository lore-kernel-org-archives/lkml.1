Return-Path: <linux-kernel-owner+w=401wt.eu-S1423144AbXBHJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423144AbXBHJHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423149AbXBHJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:07:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:64366 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423144AbXBHJHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YLBN5mx5tu7MLFCCz1WEhdme6XlP2wXTMMZWEYatTCynIS/7YNeAqFfnEOmE53tM3jgDw+Ks3rCpbDBpvvYEqk1hG+85tK64sOV510e3UWIz0whLteiqI3QSV0ad6lvyYHHcimOED1TRPxzJxfJeV+DXoEThuW+Ug/2wyHVOwT4=
Message-ID: <2375c9f90702080107v7088f835h7cdf5373d36d3c14@mail.gmail.com>
Date: Thu, 8 Feb 2007 17:07:28 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kfifo: overflow of unsigned integer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kfifo is a ring-buffer in kernel which can be used as a lock-free way
for concurrent read/write when there are only one producer and one
consumer. Details of its design can be found in kernel/kfifo.c and
include/linux/kfifo.h.

You will find that the 'in' and 'out' fields of 'struct kfifo' are
both represented as 'unsigned int' and in most cases 'in' is larger
than 'out' and their difference will NOT be  over 'size'.

Now the problem is that 'in' will be *smaller* than 'out' when 'in'
overflows and 'out' doesn't (Yes, this may occur quietly.). This is
NOT what we expect, though it may not cause any serious problems if we
carefully use kfifo*() functions. And this is really a bug. This bug
affects the kernel since version 2.6.10. I have tested this patch on
x86 machines.

Signed-off-by: WANG Cong  <xiyou.wangcong@gmail.com>

---

--- kernel/kfifo.c.orig	2007-02-07 19:42:51.000000000 +0800
+++ kernel/kfifo.c	2007-02-07 19:43:31.000000000 +0800
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/kfifo.h>
+#include <linux/compiler.h>

 /**
  * kfifo_init - allocates a new FIFO using a preallocated buffer
@@ -120,6 +121,12 @@ unsigned int __kfifo_put(struct kfifo *f
 {
 	unsigned int l;

+	/*If only fifo->in overflows, let both overflow!*/
+	if (unlikely(fifo->in < fifo->out)) {
+		fifo->out += fifo->size;
+		fifo->in  += fifo->size;
+	}
+
 	len = min(len, fifo->size - fifo->in + fifo->out);

 	/*
@@ -166,6 +173,12 @@ unsigned int __kfifo_get(struct kfifo *f
 {
 	unsigned int l;

+	/*If only fifo->in overflows, let both overflow!*/
+	if (unlikely(fifo->in < fifo->out)) {
+		fifo->out += fifo->size;
+		fifo->in  += fifo->size;
+	}
+
 	len = min(len, fifo->in - fifo->out);

 	/*
