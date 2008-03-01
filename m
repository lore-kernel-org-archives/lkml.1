Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbYCAJBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbYCAJBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYCAI7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:64846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYCAI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VJdnXRXXktaMnj59BHFcgv/hs9v0wJCnQNAcm8eSAFVQSmsK+POJDNmgKBlVWhGSoxPjoe8qg78MtEYlb1nbFOWttdfYjborPQwRhWweFozsGUW9XFixdL7oUIZG+Yjn48LzWTTRs9IfMaWIJeGSu4/Znp0GcuqLHzVD+KVsbN0=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 23/24] ide-tape: remove pipelined mode description from Documentation/ide/ide-tape.txt
Date: Sat,  1 Mar 2008 09:58:47 +0100
Message-Id: <1204361928-30229-24-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 Documentation/ide/ide-tape.txt |   79 ----------------------------------------
 1 files changed, 0 insertions(+), 79 deletions(-)

diff --git a/Documentation/ide/ide-tape.txt b/Documentation/ide/ide-tape.txt
index 658f271..51f596b 100644
--- a/Documentation/ide/ide-tape.txt
+++ b/Documentation/ide/ide-tape.txt
@@ -8,8 +8,6 @@
  * interface, on the other hand, creates new requests, adds them
  * to the request-list of the block device, and waits for their completion.
  *
- * Pipelined operation mode is now supported on both reads and writes.
- *
  * The block device major and minor numbers are determined from the
  * tape's relative position in the ide interfaces, as explained in ide.c.
  *
@@ -45,83 +43,6 @@
  *
  * | Special care is recommended.  Have Fun!
  *
- *
- * An overview of the pipelined operation mode.
- *
- * In the pipelined write mode, we will usually just add requests to our
- * pipeline and return immediately, before we even start to service them. The
- * user program will then have enough time to prepare the next request while
- * we are still busy servicing previous requests. In the pipelined read mode,
- * the situation is similar - we add read-ahead requests into the pipeline,
- * before the user even requested them.
- *
- * The pipeline can be viewed as a "safety net" which will be activated when
- * the system load is high and prevents the user backup program from keeping up
- * with the current tape speed. At this point, the pipeline will get
- * shorter and shorter but the tape will still be streaming at the same speed.
- * Assuming we have enough pipeline stages, the system load will hopefully
- * decrease before the pipeline is completely empty, and the backup program
- * will be able to "catch up" and refill the pipeline again.
- *
- * When using the pipelined mode, it would be best to disable any type of
- * buffering done by the user program, as ide-tape already provides all the
- * benefits in the kernel, where it can be done in a more efficient way.
- * As we will usually not block the user program on a request, the most
- * efficient user code will then be a simple read-write-read-... cycle.
- * Any additional logic will usually just slow down the backup process.
- *
- * Using the pipelined mode, I get a constant over 400 KBps throughput,
- * which seems to be the maximum throughput supported by my tape.
- *
- * However, there are some downfalls:
- *
- *	1.	We use memory (for data buffers) in proportional to the number
- *		of pipeline stages (each stage is about 26 KB with my tape).
- *	2.	In the pipelined write mode, we cheat and postpone error codes
- *		to the user task. In read mode, the actual tape position
- *		will be a bit further than the last requested block.
- *
- * Concerning (1):
- *
- *	1.	We allocate stages dynamically only when we need them. When
- *		we don't need them, we don't consume additional memory. In
- *		case we can't allocate stages, we just manage without them
- *		(at the expense of decreased throughput) so when Linux is
- *		tight in memory, we will not pose additional difficulties.
- *
- *	2.	The maximum number of stages (which is, in fact, the maximum
- *		amount of memory) which we allocate is limited by the compile
- *		time parameter IDETAPE_MAX_PIPELINE_STAGES.
- *
- *	3.	The maximum number of stages is a controlled parameter - We
- *		don't start from the user defined maximum number of stages
- *		but from the lower IDETAPE_MIN_PIPELINE_STAGES (again, we
- *		will not even allocate this amount of stages if the user
- *		program can't handle the speed). We then implement a feedback
- *		loop which checks if the pipeline is empty, and if it is, we
- *		increase the maximum number of stages as necessary until we
- *		reach the optimum value which just manages to keep the tape
- *		busy with minimum allocated memory or until we reach
- *		IDETAPE_MAX_PIPELINE_STAGES.
- *
- * Concerning (2):
- *
- *	In pipelined write mode, ide-tape can not return accurate error codes
- *	to the user program since we usually just add the request to the
- *      pipeline without waiting for it to be serviced. In case an error
- *      occurs, I will report it on the next user request.
- *
- *	In the pipelined read mode, subsequent read requests or forward
- *	filemark spacing will perform correctly, as we preserve all blocks
- *	and filemarks which we encountered during our excess read-ahead.
- *
- *	For accurate tape positioning and error reporting, disabling
- *	pipelined mode might be the best option.
- *
- * You can enable/disable/tune the pipelined operation mode by adjusting
- * the compile time parameters below.
- *
- *
  *	Possible improvements.
  *
  *	1.	Support for the ATAPI overlap protocol.
-- 
1.5.4.1

