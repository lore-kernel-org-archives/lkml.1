Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYJRTQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYJRTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYJRTFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:47739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYJRTFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:23 -0400
Date: Sat, 18 Oct 2008 11:48:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 18/26] V4L/DVB (9053): fix buffer overflow in uvc-video
Message-ID: <20081018184811.GU301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-fix-buffer-overflow-in-uvc-video.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Ralph Loader <suckfish@ihug.co.nz>

Commit fe6c700ff34e68e1eb7991e9c5d18986d0005ac1 upstream

V4L/DVB (9053): fix buffer overflow in uvc-video

There is a buffer overflow in drivers/media/video/uvc/uvc_ctrl.c:

INFO: 0xf2c5ce08-0xf2c5ce0b. First byte 0xa1 instead of 0xcc
INFO: Allocated in uvc_query_v4l2_ctrl+0x3c/0x239 [uvcvideo] age=13 cpu=1 pid=4975
...

A fixed size 8-byte buffer is allocated, and a variable size field is read
into it; there is no particular bound on the size of the field (it is
dependent on hardware and configuration) and it can overflow [also
verified by inserting printk's.]

The patch attempts to size the buffer to the correctly.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -592,7 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	if (ctrl == NULL)
 		return -EINVAL;
 
-	data = kmalloc(8, GFP_KERNEL);
+	data = kmalloc(ctrl->info->size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 

-- 
