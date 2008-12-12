Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYLLTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYLLTSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYLLTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:18:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLLTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:18:22 -0500
Message-ID: <4942B90F.6050807@vlnb.net>
Date: Fri, 12 Dec 2008 22:18:39 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Dynamic switching of io_context
Content-Type: multipart/mixed;
 boundary="------------030101090001090501080001"
X-Provags-ID: V01U2FsdGVkX1/cd47t9qYe+I28aWAlcl/yDfcMQByYtTq+cNe
 dL2SnIqdjr8zeAh5Ru858lAQRbiRlx5uNsH4DLQ1WW4fwCdJS4
 wqXssyZ8xIzo0p715nu5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030101090001090501080001
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

Hello Jens,

In SCST (http://scst.sf.net) in some cases IO can be submitted 
asynchronously. This is possible for pass-through (i.e. using 
scsi_execute_async()) and BLOCKIO (i.e. using direct bio interface, see 
blockio_exec_rw() in 
http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/src/dev_handlers/scst_vdisk.c?revision=614&view=markup) 
backend. For them there's no need to have a per device pool of threads, 
one or more global thread(s) can perfectly do all the work. But it is 
very desirable for performance that all the IO is submitted in a 
dedicated IO context for each initiator (i.e. client), which originated 
it. I.e. commands from initiator 1 submitted in IO context IOC1, from 
initiator 2 - IOC2, etc. Most likely, the same approach would be very 
useful for NFS server as well.

To achieve that it is necessary to have a possibility to switch IO 
context of the threads on the fly. I tried to implement that (see the 
attached patch), but hit BUG_ON(!cic->dead_key) in cic_free_func(), when 
session for initiator with the corresponding IO context was being 
destroyed by scst_free_tgt_dev(). At that point it was guaranteed that 
there was no outstanding IO with this IO context.

So, I had to go to a more defensive approach to have for each pool of 
threads, including threads for async. IO, a dedicated IO context, which 
is currently implemented.

Could you advice please what was going wrong? What should I do to 
achieve what's desired?

Thanks,
Vlad

--------------030101090001090501080001
Content-Type: text/x-patch;
 name="tgt_dev_io_context.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tgt_dev_io_context.diff"

Index: scst/include/scst.h
===================================================================
--- scst/include/scst.h	(revision 583)
+++ scst/include/scst.h	(working copy)
@@ -1516,6 +1516,8 @@ struct scst_tgt_dev {
 	spinlock_t thr_data_lock;
 	struct list_head thr_data_list;
 
+	struct io_context *tgt_dev_ioc;
+
 	spinlock_t tgt_dev_lock;	/* per-session device lock */
 
 	/* List of UA's for this device, protected by tgt_dev_lock */
Index: scst/src/scst_lib.c
===================================================================
--- scst/src/scst_lib.c	(revision 583)
+++ scst/src/scst_lib.c	(working copy)
@@ -542,6 +542,12 @@ static struct scst_tgt_dev *scst_alloc_a
 	for (i = 0; i < (int)ARRAY_SIZE(tgt_dev->sn_slots); i++)
 		atomic_set(&tgt_dev->sn_slots[i], 0);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 25)
+#if defined(CONFIG_BLOCK) && defined(SCST_ALLOC_IO_CONTEXT_EXPORTED)
+	tgt_dev->tgt_dev_ioc = alloc_io_context(GFP_KERNEL, -1);
+#endif
+#endif
+
 	if (dev->handler->parse_atomic &&
 	    (sess->tgt->tgtt->preprocessing_done == NULL)) {
 		if (sess->tgt->tgtt->rdy_to_xfer_atomic)
@@ -685,6 +691,8 @@ static void scst_free_tgt_dev(struct scs
 			scst_del_cmd_threads(vtt->threads_num);
 	}
 
+	put_io_context(tgt_dev->tgt_dev_ioc);
+
 	kmem_cache_free(scst_tgtd_cachep, tgt_dev);
 
 	TRACE_EXIT();
Index: scst/src/dev_handlers/scst_vdisk.c
===================================================================
--- scst/src/dev_handlers/scst_vdisk.c	(revision 583)
+++ scst/src/dev_handlers/scst_vdisk.c	(working copy)
@@ -751,6 +753,14 @@ static int vdisk_do_job(struct scst_cmd 
 			scst_thr_data_get(&thr->hdr);
 		} else
 			thr = container_of(d, struct scst_vdisk_thr, hdr);
+
+		EXTRACHECKS_WARN_ON(tsk->io_context);
+		/*
+		 * No need to call ioc_task_link(), because io_context will be
+		 * cleared in the end of this function.
+		 */
+		tsk->io_context = tgt_dev->tgt_dev_ioc;
+		TRACE_DBG_SPECIAL("io_context %p", tsk->io_context);
 	} else {
 		thr = &nullio_thr_data;
 		scst_thr_data_get(&thr->hdr);
@@ -1004,6 +1014,8 @@ out_done:
 	cmd->scst_cmd_done(cmd, SCST_CMD_STATE_DEFAULT, SCST_CONTEXT_SAME);
 
 out_thr:
+	tsk->io_context = NULL;
+
 	if (likely(thr != NULL))
 		scst_thr_data_put(&thr->hdr);
 

--------------030101090001090501080001--
