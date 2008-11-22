Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYKVLTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYKVLTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYKVLTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:19:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:10644 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYKVLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=jJpmJLOqIGsu9YOq5jJ7eNcApuxXL9YUNu20aL+zz/DSYC1njBbJIWoN4jkQ2BDGkk
         q2qdl/XtkAUcGmII8zRGGLTJXy6ouPXjTQLm571MIzh/KiQ77AdOlgrW0bFBYvtMeDkc
         X6OlYsrLq94h+TjaWpXkMQOMxH5y72mmPjM+Q=
Date: Sat, 22 Nov 2008 12:20:45 +0100
To: Brian Phelps <lm317t@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Gerd Knorr <kraxel@bytesex.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Alexander Shaduri <ashaduri@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Julia Lawall <julia@diku.dk>
Subject: [PATCH] bttv: don't compare list_head's .next with NULL
Message-ID: <20081122112045.GA6890@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811211750l7edc8037ue813341779917b0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

Can you see if this patch helps your problem?


Vegard


>From 84396b14b9059de4a697df4ea4e036a22513436e Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 22 Nov 2008 12:12:11 +0100
Subject: [PATCH] bttv: don't compare list_head's .next with NULL

The list implementation doesn't store NULLs in .next/.prev, but
uses poison values (for-sure invalid pointers). I assume that this
code wanted to test whether an entry was the last in a list.

This function is only ever called for the video capture list, so
we know which list to check (it could have been vcapture as well).

Patch is untested!

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/media/video/bt8xx/bttv-risc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/video/bt8xx/bttv-risc.c
index 5b1b8e4..7a54c99 100644
--- a/drivers/media/video/bt8xx/bttv-risc.c
+++ b/drivers/media/video/bt8xx/bttv-risc.c
@@ -649,14 +649,14 @@ bttv_buffer_activate_video(struct bttv *btv,
 	if (NULL != set->top  &&  NULL != set->bottom) {
 		if (set->top == set->bottom) {
 			set->top->vb.state    = VIDEOBUF_ACTIVE;
-			if (set->top->vb.queue.next)
+			if (list_is_last(&set->top->vb.queue, &btv->capture))
 				list_del(&set->top->vb.queue);
 		} else {
 			set->top->vb.state    = VIDEOBUF_ACTIVE;
 			set->bottom->vb.state = VIDEOBUF_ACTIVE;
-			if (set->top->vb.queue.next)
+			if (list_is_last(&set->top->vb.queue, &btv->capture))
 				list_del(&set->top->vb.queue);
-			if (set->bottom->vb.queue.next)
+			if (list_is_last(&set->bottom->vb.queue, &btv->capture))
 				list_del(&set->bottom->vb.queue);
 		}
 		bttv_apply_geo(btv, &set->top->geo, 1);
@@ -671,7 +671,7 @@ bttv_buffer_activate_video(struct bttv *btv,
 		      ~0x0f, BT848_COLOR_CTL);
 	} else if (NULL != set->top) {
 		set->top->vb.state  = VIDEOBUF_ACTIVE;
-		if (set->top->vb.queue.next)
+		if (list_is_last(&set->top->vb.queue, &btv->capture))
 			list_del(&set->top->vb.queue);
 		bttv_apply_geo(btv, &set->top->geo,1);
 		bttv_apply_geo(btv, &set->top->geo,0);
@@ -682,7 +682,7 @@ bttv_buffer_activate_video(struct bttv *btv,
 		btaor(set->top->btswap & 0x0f,   ~0x0f, BT848_COLOR_CTL);
 	} else if (NULL != set->bottom) {
 		set->bottom->vb.state = VIDEOBUF_ACTIVE;
-		if (set->bottom->vb.queue.next)
+		if (list_is_last(&set->bottom->vb.queue, &btv->capture))
 			list_del(&set->bottom->vb.queue);
 		bttv_apply_geo(btv, &set->bottom->geo,1);
 		bttv_apply_geo(btv, &set->bottom->geo,0);
-- 
1.5.6.5

