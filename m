Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbZDBQxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbZDBQxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbZDBQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:51:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:6758 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932740AbZDBQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="678230239"
Date: Thu, 2 Apr 2009 09:51:17 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Message-ID: <20090402165117.GQ2661@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49D4E0C3.7080808@ru.mvista.com> <20090402162846.GO2661@linux.intel.com> <49D4E9EB.80207@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4E9EB.80207@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:38:03PM +0400, Sergei Shtylyov wrote:
> Hello.
>>>> +	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
>>>> +			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
>
>>>   The last 3 flags are going to be obsoleted too...
>
>> So if I remove them today, the command will still work?
>
>     s/obsoleted/renamed and moved to another other field/ -- I'm going to 
> submit a patchset refactoring 'struct ide_cmd and 'struct ide-taskfile' 
> at last...

Since I'm coding to today's kernel, not to a patch which doesn't exist
yet, taking them out won't work very well.

I've not been paying much attention to drivers/ide, so I've no idea
whether the following patch works.  It does at least compile:

+++ b/drivers/ide/ide-disk.c
@@ -407,7 +407,7 @@ static void idedisk_prepare_flush(struct request_queue *q, s
 static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
                                                        struct bio *bio)
 {
-       ide_task_t *task;
+       struct ide_cmd *task;
        unsigned size;
        struct page *page = alloc_page(GFP_KERNEL);
        if (!page)
@@ -432,8 +432,8 @@ static int idedisk_prepare_discard(struct request_queue *q, 
 
        task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
                           IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
-                          IDE_TFLAG_DYN;
-       task->data_phase = TASKFILE_OUT_DMA;
+                          IDE_TFLAG_DYN | IDE_TFLAG_WRITE;
+       task->protocol = ATA_PROT_DMA;
 
        rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
        rq->special = task;

If I've understood 0dfb991c6943c810175376b58d1c29cfe532541b correctly,
this should be equivalent.  Bart?
