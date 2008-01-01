Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAAVJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAAVJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYAAVJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:09:24 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40507 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbYAAVJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:09:23 -0500
Date: Tue, 1 Jan 2008 22:09:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/media/common: Add missing video_device_release
Message-ID: <Pine.LNX.4.64.0801012208150.19803@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Video_device_alloc returns the result of a kzalloc.  In this case, the
value is stored in a local variable which is not copied elsewhere before
the point of the error return (video_register_device does not save its
first argument anywhere if it returns a negative value).  Thus, a
video_device_release it needed before the error return.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* E = video_device_alloc(...);
  if (E == NULL) S
  ... when != video_device_release(...,(T1)E,...)
      when != if (E != NULL) { ... video_device_release(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != video_device_release(...,(T2)E,...)
        when != if (E != NULL) { ... video_device_release(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
--- a/drivers/media/common/saa7146_fops.c	2007-10-22 11:25:10.000000000 +0200
+++ b/drivers/media/common/saa7146_fops.c	2008-01-01 14:20:33.000000000 +0100
@@ -538,6 +538,7 @@ int saa7146_register_device(struct video
 	// fixme: -1 should be an insmod parameter *for the extension* (like "video_nr");
 	if (video_register_device(vfd, type, -1) < 0) {
 		ERR(("cannot register v4l2 device. skipping.\n"));
+		video_device_release(vfd);
 		return -1;
 	}
 
