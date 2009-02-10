Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZBJVv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZBJVv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZBJVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:51:46 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36833 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbZBJVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QL7BGXjkWiQToTf0rrChS+Hdi1vVaRXMwJG+tT6/kuEOqGYSn/gwSSeAGE9ph1msGf
         RbEXI3zwbS3tvyWGrW8HWPcvtrJMOQEzwj6eEjkZzhN1uuN5AKShA+NvYDwa1Cdj2RaO
         9NkWiN7ArlFVfeEU+TdIsETaZ01vCDB0oWTxI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: move request type specific code from ide_end_drive_cmd() to callers (v2)
Date: Tue, 10 Feb 2009 22:52:12 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc4-next-20090210; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
References: <200902052129.40866.bzolnier@gmail.com>
In-Reply-To: <200902052129.40866.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902102252.13101.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: move request type specific code from ide_end_drive_cmd() to callers (v2)
> 
> * Move request type specific code from ide_end_drive_cmd() to callers.
> 
> * Remove stale ide_end_drive_cmd() documentation and drop no longer
>   used 'stat' argument.  Then rename the function to ide_complete_rq().
> 
> v2:
> * Fix handling of blk_pm_request() requests in task_no_data_intr().

v2->v3 interdiff:

...
v3:
* Some ide_no_data_taskfile() users (HPA code and HDIO_DRIVE_* ioctls
  handlers) access original command later so we need to update it in
  ide_complete_task().
...
diff -u b/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
--- b/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -147,12 +147,16 @@
 void ide_complete_task(ide_drive_t *drive, ide_task_t *task, u8 stat, u8 err)
 {
 	struct ide_taskfile *tf = &task->tf;
+	struct request *rq = task->rq;
 
 	tf->error = err;
 	tf->status = stat;
 
 	drive->hwif->tp_ops->tf_read(drive, task);
 
+	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
+		memcpy(rq->special, task, sizeof(*task));
+
 	if (task->tf_flags & IDE_TFLAG_DYN)
 		kfree(task);
 }
