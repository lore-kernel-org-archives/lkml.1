Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbYLXPXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbYLXPXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXPXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:23:40 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38423 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYLXPXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:23:39 -0500
Date: Wed, 24 Dec 2008 16:23:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, mail@davidkiliani.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/staging/meilhaus: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0812241623120.5475@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING and ME_IO_STREAM_CONFIG_WRAPAROUND both
hanve 0 as the rightmost bit, and thus eg
!flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING is always 0.
I assume that !(flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING) and
!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND) were intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/meilhaus/me1600_ao.c |    4 +++-
 drivers/staging/meilhaus/me4600_ao.c |    2 +-
 drivers/staging/meilhaus/me6000_ao.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -u -p a/drivers/staging/meilhaus/me1600_ao.c b/drivers/staging/meilhaus/me1600_ao.c
--- a/drivers/staging/meilhaus/me1600_ao.c
+++ b/drivers/staging/meilhaus/me1600_ao.c
@@ -756,7 +756,9 @@ static int me1600_ao_io_single_write(me_
 	queue_delayed_work(instance->me1600_workqueue,
 			   &instance->ao_control_task, 1);
 
-	if ((!flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING) && ((instance->ao_regs_shadows)->trigger & instance->ao_idx)) {	//Blocking mode. Wait for software trigger.
+	if ((!(flags & ME_IO_SINGLE_TYPE_WRITE_NONBLOCKING)) &&
+	    ((instance->ao_regs_shadows)->trigger & instance->ao_idx)) {
+		/* Blocking mode. Wait for software trigger. */
 		if (time_out) {
 			delay = (time_out * HZ) / 1000;
 			if (delay == 0)
diff -u -p a/drivers/staging/meilhaus/me4600_ao.c b/drivers/staging/meilhaus/me4600_ao.c
--- a/drivers/staging/meilhaus/me4600_ao.c
+++ b/drivers/staging/meilhaus/me4600_ao.c
@@ -1025,7 +1025,7 @@ static int me4600_ao_io_stream_config(me
 	}
 
 	if (flags & ME_IO_STREAM_CONFIG_HARDWARE_ONLY) {
-		if (!flags & ME_IO_STREAM_CONFIG_WRAPAROUND) {
+		if (!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND)) {
 			PERROR
 			    ("Hardware ME_IO_STREAM_CONFIG_HARDWARE_ONLY has to be with ME_IO_STREAM_CONFIG_WRAPAROUND.\n");
 			return ME_ERRNO_INVALID_FLAGS;
diff -u -p a/drivers/staging/meilhaus/me6000_ao.c b/drivers/staging/meilhaus/me6000_ao.c
--- a/drivers/staging/meilhaus/me6000_ao.c
+++ b/drivers/staging/meilhaus/me6000_ao.c
@@ -1063,7 +1063,7 @@ static int me6000_ao_io_stream_config(me
 	}
 
 	if (flags & ME_IO_STREAM_CONFIG_HARDWARE_ONLY) {
-		if (!flags & ME_IO_STREAM_CONFIG_WRAPAROUND) {
+		if (!(flags & ME_IO_STREAM_CONFIG_WRAPAROUND)) {
 			PERROR
 			    ("Hardware ME_IO_STREAM_CONFIG_HARDWARE_ONLY has to be with ME_IO_STREAM_CONFIG_WRAPAROUND.\n");
 			return ME_ERRNO_INVALID_FLAGS;
