Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYJZLIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYJZLIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYJZLIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:08:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47777 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYJZLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:08:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 26 Oct 2008 12:03:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [Bug 11823][PATCH] ieee1394: dv1394: fix possible deadlock in
 multithreaded clients
To: linux1394-devel@lists.sourceforge.net
cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@saeurebad.de>
In-Reply-To: <4902E80B.7090805@s5r6.in-berlin.de>
Message-ID: <tkrat.306c405611bf6756@s5r6.in-berlin.de>
References: <bug-11823-4803@http.bugzilla.kernel.org/>
 <4902E80B.7090805@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a possible though highly unlikely deadlock:

Thread A:                  Thread B:
 - acquire mmap_sem         - dv1394_ioctl/read/write()
 - dv1394_mmap()            - acquire video->mtx
 - acquire video->mtx       - copy_to/from_user(), possible page fault:
                              acquire mmap_sem

The simplest fix is to use mutex_trylock() instead of mutex_lock() in
dv1394_mmap().  This changes the behavior under contention in a way
which is visible to userspace clients.  However, my guess is that no
clients exist which use mmap vs. ioctl/read/write on the dv1394
character device file interface in concurrent threads.

Reported-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux/drivers/ieee1394/dv1394.c
===================================================================
--- linux.orig/drivers/ieee1394/dv1394.c
+++ linux/drivers/ieee1394/dv1394.c
@@ -1270,8 +1270,14 @@ static int dv1394_mmap(struct file *file
 	struct video_card *video = file_to_video_card(file);
 	int retval = -EINVAL;
 
-	/* serialize mmap */
-	mutex_lock(&video->mtx);
+	/*
+	 * We cannot use the blocking variant mutex_lock here because .mmap
+	 * is called with mmap_sem held, while .ioctl, .read, .write acquire
+	 * video->mtx and subsequently call copy_to/from_user which will
+	 * grab mmap_sem in case of a page fault.
+	 */
+	if (!mutex_trylock(&video->mtx))
+		return -EAGAIN;
 
 	if ( ! video_card_initialized(video) ) {
 		retval = do_dv1394_init_default(video);

-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/

