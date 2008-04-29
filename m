Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbYD2UNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbYD2UNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYD2UNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:13:37 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21797 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYD2UNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:13:36 -0400
Message-ID: <48178143.2000308@hp.com>
Date: Tue, 29 Apr 2008 16:12:51 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-driver@qlogic.com,
       linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com
Subject: Re: Issue with qla2xxx_probe_one
References: <48175C3F.3000002@hp.com> <20080429174447.GL67096@plap4.qlogic.org>
In-Reply-To: <20080429174447.GL67096@plap4.qlogic.org>
Content-Type: multipart/mixed;
 boundary="------------050404010600090601000605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050404010600090601000605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Vasquez wrote:
> On Tue, 29 Apr 2008, Alan D. Brunelle wrote:
>
>> I /think/ that there is an issue with this routine /if/ the firmware
>> images are not loaded properly - on a 16-way ia64 box I am starting to
>> see this with an up-stream kernel (Jens Axboe's origin/io-cpu-affinity
>> branch). In any event, it looks to me that :
>>
>>         if (qla2x00_initialize_adapter(ha)) {
>>                 qla_printk(KERN_WARNING, ha,
>>                     "Failed to initialize adapter\n");
>>
>>                 DEBUG2(printk("scsi(%ld): Failed to initialize
adapter - "
>>                     "Adapter flags %x.\n",
>>                     ha->host_no, ha->device_flags));
>>
>>                 ret = -ENODEV;
>>                 goto probe_failed;
>>         }
>>
>> skips around:
>>
>>         ret = scsi_add_host(host, &pdev->dev);
>>
>> which is needed to properly initialize the freelist (via:
>> scsi_setup_command_freelist).
>
> Wasn't something like this posted recently to linux-scsi:
>
> http://lkml.org/lkml/2008/4/27/333
>
> this is sitting in scsi-misc-2.6.git:
>
> [SCSI] bug fix for free list handling
>
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a79cbe1aa5dd695f0ee012ecde1ff88b1192e326
>
> which I gather will be pushed soon...

My apologies for not having seeing that.

But after looking at it, doesn't it still have a hole?

o  scsi_setup_command_freelist initializes the free_list list.

o  It then invokes scsi_get_host_cmd_pool, if this fails there is no
need to invoke scsi_put_host_cmd_pool (it wasn't gotten).

o  If scsi_get_host_cmd_pool succeeds but scsi_pool_alloc_command fails,
it will (correctly) invoke scsi_put_host_cmd_pool.

However, if either of scsi_get_host_cmd_pool or scsi_put_host_cmd_pool
happens to fail, we'll end up in scsi_destroy_command_freelist - and
since the free_list was initialized, the while loop will be bypassed,
but scsi_put_host_cmd_pool will be invoked an extra time. And this is
badness, right?

Wouldn't the attached patch [boot tested on my previously failing
system] be correct (and perhaps cleaner - you're not looking at the
innards of the list data structure to determine things)?

Alan

--------------050404010600090601000605
Content-Type: text/x-diff;
 name="0001-Ensure-proper-handling-of-the-scsi-free_list-handlin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Ensure-proper-handling-of-the-scsi-free_list-handlin.pa";
 filename*1="tch"

>From 344f31749fe26fe8b56fcd6ff3f3902cedb8144c Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Tue, 29 Apr 2008 15:46:36 -0400
Subject: [PATCH] Ensure proper handling of the scsi free_list handling upon errors

Only release resources in scsi_destroy_command_freelist that have been
correctly initialized.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 drivers/scsi/scsi.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 12d69d7..749c9c7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -469,6 +469,7 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
 	if (!cmd) {
 		scsi_put_host_cmd_pool(gfp_mask);
+		shost->cmd_pool = NULL;
 		return -ENOMEM;
 	}
 	list_add(&cmd->list, &shost->free_list);
@@ -481,6 +482,13 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
+	/*
+	 * If cmd_pool is NULL the free list was not initialized, so
+	 * do not attempt to release resources.
+	 */
+	if (!shost->cmd_pool)
+		return;
+
 	while (!list_empty(&shost->free_list)) {
 		struct scsi_cmnd *cmd;
 
-- 
1.5.4.3


--------------050404010600090601000605--
