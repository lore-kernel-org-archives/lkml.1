Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYFVJMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYFVJMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYFVJMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:12:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:13450 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYFVJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=OrhynjW3xeycRRGoVIC5q74dRxodFifWnzKSQjwB2sHneQk+K9BurdMLJxDtJkoXm2
         ycfGAogwBKniwIrs0PQj9ix0qBv7FacgVsNcNwLiC7XLZAmR/HFCU7j82Ma/8F6QRrzN
         SOXEmIFHm2KfPtffp6nCnybgJcg/O7WPRFW7E=
Date: Sun, 22 Jun 2008 11:11:40 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel =?utf-8?Q?Marjam=C3=A4ki?= <danielm77@spray.se>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: [PATCH] V4L/vivi: fix possible memory leak in vivi_fillbuff
Message-ID: <20080622091136.GB11823@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move allocation after first check and fix memory leak.
http://bugzilla.kernel.org/show_bug.cgi?id=10659

Noticed-by: Daniel Marjamäki <danielm77@spray.se>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/vivi.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 845be18..5ff9a58 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -327,13 +327,14 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	int hmax  = buf->vb.height;
 	int wmax  = buf->vb.width;
 	struct timeval ts;
-	char *tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
+	char *tmpbuf;
 	void *vbuf = videobuf_to_vmalloc(&buf->vb);
 
-	if (!tmpbuf)
+	if (!vbuf)
 		return;
 
-	if (!vbuf)
+	tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
+	if (!tmpbuf)
 		return;
 
 	for (h = 0; h < hmax; h++) {
-- 
1.5.4.5

