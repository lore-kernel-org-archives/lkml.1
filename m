Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZLFXl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZLFXl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZLFXlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:41:23 -0500
Received: from kroah.org ([198.145.64.141]:33803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbZLFXio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:09 2009
Message-Id: <20091206233209.565626658@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [10/20] V4L/DVB (13230): s2255drv: Dont conditionalize video buffer completion on waiting processes
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13230-s2255drv-don-t-conditionalize-video-buffer-completion-on-waiting-processes.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike Isely <isely@pobox.com>

commit 1f95725755ab67f3198df3b5bf7517f926f310ca upstream.

The s2255 driver had logic which aborted processing of a video frame
if there was no process waiting on the video buffer in question.  That
simply doesn't work when the application is doing things in an
asynchronous manner.  If the application went to the trouble to queue
the buffer in the first place, then the driver should always attempt
to complete it - even if the application at that moment has its
attention turned elsewhere.  Applications which always blocked waiting
for I/O on the capture device would not have been affected by this.
Applications which *mostly* blocked waiting for I/O on the capture
device probably only would have been somewhat affected (frame lossage,
at a rate which goes up as the application blocks less).  Applications
which never blocked on the capture device (e.g. polling only) however
would never have been able to receive any video frames, since in that
case this "is anyone waiting on this?" check on the buffer never would
have evalutated true.  This patch just deletes that harmful check
against the buffer's wait queue.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/s2255drv.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -578,11 +578,6 @@ static int s2255_got_frame(struct s2255_
 	buf = list_entry(dma_q->active.next,
 			 struct s2255_buffer, vb.queue);
 
-	if (!waitqueue_active(&buf->vb.done)) {
-		/* no one active */
-		rc = -1;
-		goto unlock;
-	}
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
 	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);


