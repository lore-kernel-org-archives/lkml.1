Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYDJJlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYDJJlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYDJJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:40:56 -0400
Received: from igraine.blacknight.ie ([81.17.252.25]:43564 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYDJJk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:40:56 -0400
Date: Thu, 10 Apr 2008 10:40:31 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] bttv: Fix memory leak in radio_release
Message-ID: <20080410094031.GA2532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1JjtGe-0007uo-Ap
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=1.608, required 7,
	autolearn=disabled, HELO_LOCALHOST 4.50, RCVD_IN_NERDS_IE -3.50,
	RCVD_IN_PBL 0.51, RDNS_NONE 0.10)
X-blacknight-igraine-MailScanner-SpamScore: s
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the leak of the bttv_fh structure allocated in radio_open which
was introduced by commit 5cd3955cb8adfc1edf481e9e1cb2289db50ccacb.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


Seeing as commit 'V4L/DVB (7277): bttv: Re-enabling radio support
requires the use of struct bttv_fh' made it into mainline I better fix
the memory leak I introduced.

Robert


diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index fcf8f2d..59a8847 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3457,6 +3457,9 @@ static int radio_release(struct inode *inode, struct file *file)
 	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 
+	file->private_data = NULL;
+	kfree(fh);
+
 	btv->radio_user--;
 
 	bttv_call_i2c_clients(btv, RDS_CMD_CLOSE, &cmd);
-- 
1.5.4.3.484.g60e3

