Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYBIHvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYBIHvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYBIHvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:51:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYBIHv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:51:29 -0500
Date: Fri, 8 Feb 2008 23:46:19 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, "James Morris" <jmorris@namei.org>,
       linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Message-Id: <20080208234619.385bcab9.zaitcev@redhat.com>
In-Reply-To: <20080205140506.c6354490.akpm@linux-foundation.org>
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
	<20080204213911.1bcbaf66.akpm@linux-foundation.org>
	<1202219216.27371.24.camel@moss-spartans.epoch.ncsc.mil>
	<20080205104028.190192b1.akpm@linux-foundation.org>
	<6101e8c40802051115v12d3c02br24873ef1014dbea9@mail.gmail.com>
	<6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
	<6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
	<20080205140506.c6354490.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 14:05:06 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> > > http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/

> I think ub.c is basically abandoned in favour of usb-storage.
> If so, perhaps we should remove or disble ub.c?

Looks like it's just Tomo or Jens made a mistake when converting to
the new s/g API. Nothing to be too concerned about. I know I should've
reviewed their patch closer, but it seemed too simple...

-- Pete

Fix up the conversion to sg_init_table().

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -657,7 +657,6 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
-	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -668,6 +667,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	/*
 	 * get scatterlist from block layer
 	 */
+	sg_init_table(&urq->sgv[0], UB_MAX_REQ_SG);
 	n_elem = blk_rq_map_sg(lun->disk->queue, rq, &urq->sgv[0]);
 	if (n_elem < 0) {
 		/* Impossible, because blk_rq_map_sg should not hit ENOMEM. */
