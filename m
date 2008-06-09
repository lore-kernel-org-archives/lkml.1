Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYFILBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYFILBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbYFILBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:01:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47596 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901AbYFILBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:01:36 -0400
From: Alexey Dobriyan <adobriyan@parallels.com>
To: akpm@osdl.org
Subject: [PATCH] seq_file: make seq_lseek accept SEEK_END
Date: Mon, 9 Jun 2008 15:01:12 +0400
User-Agent: KMail/1.9.9
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       Joakim Tjernlund <joakim.tjernlund@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091501.13170.adobriyan@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for delay, such simple thing should have been sent long ago.
Joakim, please, confirm.
-------------------------------------------
[PATCH] seq_file: make seq_lseek accept SEEK_END

and pretend seq_files have zero length. This should be enough
to fix busybox start-stop-daemon:
http://marc.info/?t=120836691600002&r=1&w=2

It does xlseek(fd, 0, SEEK_END) to estimate amount of memory to malloc
but satisfied with 0. Sudden -EINVAL from lseek(2) breaks it.

X-Introduced-By: f16278c679aa72e28288435b313ba2d4494d6be5
Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
---

 fs/seq_file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -254,6 +254,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int origin)
 	switch (origin) {
 		case 1:
 			offset += file->f_pos;
+		case 2:
+			/* pretend it's zero length */
 		case 0:
 			if (offset < 0)
 				break;
