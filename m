Return-Path: <linux-kernel-owner+w=401wt.eu-S933905AbZDBTiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbZDBTiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765122AbZDBTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:36:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57353 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760908AbZDBTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Blgdplfmq2iUF4v+PtbgTr1yIPPdOzbicQJ2aZ5ChIAtkLk9OZEC+OYcJGB2Gutcqw
         lakWThdyJ+bOYGmAZfwzkb1w5tbfWrXFr3eS/NrnQnkBNVRtazoo8IOTrVPOXRVEkLbw
         ZHOfSF7XZ+xGWeUygIyzoPbIC+kCi4EzMXVoI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Date: Thu, 2 Apr 2009 21:37:35 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D4E9EB.80207@ru.mvista.com> <20090402165117.GQ2661@linux.intel.com>
In-Reply-To: <20090402165117.GQ2661@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904022137.35671.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Matthew Wilcox wrote:
> On Thu, Apr 02, 2009 at 08:38:03PM +0400, Sergei Shtylyov wrote:
> > Hello.
> >>>> +	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
> >>>> +			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
> >
> >>>   The last 3 flags are going to be obsoleted too...
> >
> >> So if I remove them today, the command will still work?
> >
> >     s/obsoleted/renamed and moved to another other field/ -- I'm going to 
> > submit a patchset refactoring 'struct ide_cmd and 'struct ide-taskfile' 
> > at last...
> 
> Since I'm coding to today's kernel, not to a patch which doesn't exist
> yet, taking them out won't work very well.
> 
> I've not been paying much attention to drivers/ide, so I've no idea
> whether the following patch works.  It does at least compile:
> 
> +++ b/drivers/ide/ide-disk.c
> @@ -407,7 +407,7 @@ static void idedisk_prepare_flush(struct request_queue *q, s
>  static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
>                                                         struct bio *bio)
>  {
> -       ide_task_t *task;
> +       struct ide_cmd *task;
>         unsigned size;
>         struct page *page = alloc_page(GFP_KERNEL);
>         if (!page)
> @@ -432,8 +432,8 @@ static int idedisk_prepare_discard(struct request_queue *q, 
>  
>         task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
>                            IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
> -                          IDE_TFLAG_DYN;
> -       task->data_phase = TASKFILE_OUT_DMA;
> +                          IDE_TFLAG_DYN | IDE_TFLAG_WRITE;
> +       task->protocol = ATA_PROT_DMA;
>  
>         rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
>         rq->special = task;
> 
> If I've understood 0dfb991c6943c810175376b58d1c29cfe532541b correctly,
> this should be equivalent.  Bart?

Yep.  The final patch looks fine overall (thanks for adding TRIM support
also to drivers/ide), with the small exception for this chunk:

@@ -521,6 +567,9 @@ static int set_wcache(ide_drive_t *drive, int arg)
 
        update_ordered(drive);
 
+       if (ata_id_has_trim(drive->id))
+               blk_queue_set_discard(drive->queue, idedisk_prepare_discard);
+
        return err;
 }

as it would fit better somewhere in ide_disk_setup() ISO set_wcache()...

[ When it comes to CodingStyle issues I don't care that much though I think
  that applying Sergei's suggestions will make the patch more consistent with
  the rest of drivers/ide code... ]
