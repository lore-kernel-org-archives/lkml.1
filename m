Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZDGD3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZDGD3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGD3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:29:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:31164 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbZDGD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:29:04 -0400
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
In-Reply-To: <alpine.LFD.2.00.0904060835530.3863@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <20090406130414.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0904060835530.3863@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 23:28:00 -0400
Message-Id: <1239074880.17426.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49DAC84D.00C4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 08:37 -0700, Linus Torvalds wrote:
> 
>
> One thing that I find intriguing is how the fsync time seems so 
> _consistent_ across a wild variety of drives. It's interesting how you see 
> delays that are roughly the same order of magnitude, even though you are 
> using an old SATA drive, and I'm using the Intel SSD. And when you turn 
> off TCQ, your numbers go down even more.
> 

It may help if we rule out the ext3/jbd transaction growing code.  I'd
be pretty surprised if it made for long pauses, but its worth checking:

-chris

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index e6a1174..a7c4f79 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1417,7 +1417,7 @@ int journal_stop(handle_t *handle)
 	 * for joiners in that case.
 	 */
 	pid = current->pid;
-	if (handle->h_sync && journal->j_last_sync_writer != pid) {
+	if (0 && handle->h_sync && journal->j_last_sync_writer != pid) {
 		u64 commit_time, trans_time;
 
 		journal->j_last_sync_writer = pid;


