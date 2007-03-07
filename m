Return-Path: <linux-kernel-owner+w=401wt.eu-S965555AbXCGRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555AbXCGRlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965563AbXCGRlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:41:00 -0500
Received: from mail.suse.de ([195.135.220.2]:43918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422833AbXCGRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:43 -0500
Message-Id: <20070307171405.434874206@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 051/101] V4L: fix cx25840 firmware loading
Content-Disposition: inline; filename=v4l-fix-cx25840-firmware-loading.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 15 Feb 2007 03:40:34 -0300
Subject: [patch 051/101] [PATCH] V4L: fix cx25840 firmware loading

Due to changes in the i2c handling in 2.6.20 this cx25840 bug surfaced,
causing the firmware load to fail for the ivtv driver. The correct
sequence is to first attach the i2c client, then use the client's
device to load the firmware.

(cherry picked from commit d55c7aec666658495e5b57a6b194c8c2a1ac255f)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx25840/cx25840-core.c     |    4 ++--
 drivers/media/video/cx25840/cx25840-firmware.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/drivers/media/video/cx25840/cx25840-core.c
+++ linux-2.6.20.1/drivers/media/video/cx25840/cx25840-core.c
@@ -907,13 +907,13 @@ static int cx25840_detect_client(struct 
 	state->vbi_line_offset = 8;
 	state->id = id;
 
+	i2c_attach_client(client);
+
 	if (state->is_cx25836)
 		cx25836_initialize(client);
 	else
 		cx25840_initialize(client, 1);
 
-	i2c_attach_client(client);
-
 	return 0;
 }
 
--- linux-2.6.20.1.orig/drivers/media/video/cx25840/cx25840-firmware.c
+++ linux-2.6.20.1/drivers/media/video/cx25840/cx25840-firmware.c
@@ -37,7 +37,7 @@
  */
 #define FWSEND 48
 
-#define FWDEV(x) &((x)->adapter->dev)
+#define FWDEV(x) &((x)->dev)
 
 static char *firmware = FWFILE;
 

--
