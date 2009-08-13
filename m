Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbZHMUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbZHMUAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZHMUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:00:19 -0400
Received: from kroah.org ([198.145.64.141]:42006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbZHMUAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:35 2009
Message-Id: <20090813195135.602994150@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Maxime Bizon <mbizon@freebox.fr>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Simon Kirby <sim@netnation.com>
Subject: [patch 74/74] ide: fix memory leak when flush command is issued
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ide-fix-memory-leak-when-flush-command-is-issued.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit bc146d23d1358af43f03793c3ad8c9f16bbcffcb upstream.

I'm using ide on 2.6.30.1 with xfs filesystem. I noticed a kernel memory
leak after writing lots of data, the kmalloc-96 slab cache keeps
growing. It seems the struct ide_cmd kmalloced by idedisk_prepare_flush
is never kfreed.

Commit a09485df9cda49fbde2766c86eb18a9cae585162 ("ide: move request
type specific code from ide_end_drive_cmd() to callers (v3)") and
f505d49ffd25ed062e76ffd17568d3937fcd338c ("ide: fix barriers support")
cause this regression, cmd->rq must now be set for ide_complete_cmd to
honor the IDE_TFLAG_DYN flag.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Simon Kirby <sim@netnation.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-disk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -413,6 +413,7 @@ static void idedisk_prepare_flush(struct
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->special = cmd;
+	cmd->rq = rq;
 }
 
 ide_devset_get(multcount, mult_count);


