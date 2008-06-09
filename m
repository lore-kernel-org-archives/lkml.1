Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYFITJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYFITJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYFITJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:09:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30255 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbYFITJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FUbZiCtY3VgalEYk5BzmOSvCYI5UmZZ7stF92qCiyKiRgxz7+rkmJKxuh2Pnu+vys2
         Or/1jlyAgRaSdNHi3VDhNFMI04bugBJQoQ6AIDQqetFH5qnRvkmI3NZ4BrAX82iE4co7
         xjuPL1PmInprDal4XHLqO2wNW/a70lZYUIUUM=
Date: Mon, 9 Jun 2008 21:08:57 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: saa7134: fix race between opening and closing the
	device
Message-ID: <20080609190854.GA5855@joi>
References: <20080607224835.GA25025@joi> <20080608063104.GA5608@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608063104.GA5608@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 08:31:04AM +0200, Marcin Slusarz wrote:
> On Sun, Jun 08, 2008 at 12:48:35AM +0200, Marcin Slusarz wrote:
> > (...)
> 
> This patch is stupid. Please ignore.

Ok, I think this one should be considered for inclusion.
I don't think it has anything to do with oops in empress_querycap,
but who knows ;)
Compile tested only.
---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] v4l: saa7134: fix race between opening and closing the device

decrementing dev->empress_users should be done as last action of ts_release,
because it sleeps and write access to dev->empress_started is not protected
in any way
(additionally closing thread could mute audio after opening thread unmuted it)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com
---
 drivers/media/video/saa7134/saa7134-empress.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 81431ee..0da683a 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -112,7 +112,6 @@ static int ts_release(struct inode *inode, struct file *file)
 
 	videobuf_stop(&dev->empress_tsq);
 	videobuf_mmap_free(&dev->empress_tsq);
-	dev->empress_users--;
 
 	/* stop the encoder */
 	ts_reset_encoder(dev);
@@ -121,6 +120,8 @@ static int ts_release(struct inode *inode, struct file *file)
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
 
+	dev->empress_users--;
+
 	return 0;
 }
 
-- 
1.5.4.5

