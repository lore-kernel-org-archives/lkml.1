Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXEJCKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXEJCKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXEJCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:10:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57347 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbXEJCKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:10:32 -0400
Message-Id: <20070510020915.900170085@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:55:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       David Smith <dsmith@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 03/10] Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
Content-Disposition: inline; filename=linux-kernel-markers-header-visible-from-userspace.h
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:09:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of the things I'm starting to work on is adding support for your
kernel markers to systemtap.  I know the marker stuff is still in a bit
of flux because you are trying to meet the (sometimes conflicting)
requirements of the people on lkml.

One of the things systemtap is going to need is to be able to parse the
'__markers' section so it will be able to look up a user-specified
marker.  For instance, if the user says 'probe kernel.mark("foo") {}',
I've got to see if marker "foo" really exists.

There are 2 problems with this currently, since systemtap is a user-land
program:

1) include/linux/markers.h isn't currently installed by "make
headers_install"

2) even if include/linux/markers.h was installed, it is completely
surrounded by "#ifdef __KERNEL__"

So, I've attached a patch that tries to fix those 2 problems.  I've
moved "#ifdef __KERNEL__" down a bit past the structure and flag
definitions and included marker.h in Kbuild so it will get installed.

I'd appreciate any comments you have.   I'd like to get either this
patch or something like it included in the next version you post to lkml.

Signed-off-by: David Smith <dsmith@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/Kbuild   |    1 +
 include/linux/marker.h |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-05-09 18:15:55.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-05-09 21:44:47.000000000 -0400
@@ -14,8 +14,6 @@
  * See the file COPYING for more details.
  */
 
-#ifdef __KERNEL__
-
 struct __mark_marker_data;
 
 typedef void marker_probe_func(const struct __mark_marker_data *mdata,
@@ -35,8 +33,6 @@
 	void *enable;
 } __attribute__((packed));
 
-#ifdef CONFIG_MARKERS
-
 /* Marker flags : selects the mechanism used to connect the probes to the
  * markers and what can be executed within the probes. This is primarily
  * used at reentrancy-unfriendly sites. */
@@ -45,6 +41,10 @@
 #define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
 #define _MF_NR		3		/* Number of marker flags */
 
+#ifdef __KERNEL__
+
+#ifdef CONFIG_MARKERS
+
 /* Generic marker flavor always available */
 #define trace_mark_generic(flags, name, format, args...) \
 	do { \
Index: linux-2.6-lttng/include/linux/Kbuild
===================================================================
--- linux-2.6-lttng.orig/include/linux/Kbuild	2007-05-09 21:41:55.000000000 -0400
+++ linux-2.6-lttng/include/linux/Kbuild	2007-05-09 21:46:07.000000000 -0400
@@ -254,6 +254,7 @@
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
+unifdef-y += marker.h
 unifdef-y += mempolicy.h
 unifdef-y += mii.h
 unifdef-y += mman.h

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
