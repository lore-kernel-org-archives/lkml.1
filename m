Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYABSoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYABSoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYABSor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:44:47 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44704 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYABSor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:44:47 -0500
Date: Wed, 2 Jan 2008 18:43:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] procfs: provide slub's /proc/slabinfo
Message-ID: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB's new slabinfo isn't there: it looks as if a last minute change
to Pekka's patch left it dependent on CONFIG_SLAB at the procfs end:
allow for CONFIG_SLUB too.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
To minimize ifdeffery, this leaves it with S_IWUSR though unwritable:
I'm assuming that's acceptable.

 fs/proc/proc_misc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- 2.6.24-rc6-git/fs/proc/proc_misc.c	2007-10-20 08:04:13.000000000 +0100
+++ linux/fs/proc/proc_misc.c	2008-01-02 17:55:57.000000000 +0000
@@ -410,15 +410,18 @@ static const struct file_operations proc
 };
 #endif
 
-#ifdef CONFIG_SLAB
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 static int slabinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &slabinfo_op);
 }
+
 static const struct file_operations proc_slabinfo_operations = {
 	.open		= slabinfo_open,
 	.read		= seq_read,
+#ifdef CONFIG_SLAB
 	.write		= slabinfo_write,
+#endif
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
@@ -728,7 +731,7 @@ void __init proc_misc_init(void)
 #endif
 	create_seq_entry("stat", 0, &proc_stat_operations);
 	create_seq_entry("interrupts", 0, &proc_interrupts_operations);
-#ifdef CONFIG_SLAB
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 	create_seq_entry("slabinfo",S_IWUSR|S_IRUGO,&proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
