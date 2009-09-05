Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbZIEAYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbZIEAYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964790AbZIEAYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:24:18 -0400
Received: from kroah.org ([198.145.64.141]:42327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964807AbZIEAV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:57 2009
Message-Id: <20090905001457.204965346@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Schmidt <mschmidt@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [patch 64/71] xenfb: connect to backend before registering fb
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=xenfb-connect-to-backend-before-registering-fb.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Schmidt <mschmidt@redhat.com>

commit 0a80fb10239b04c45e5e80aad8d4b2ca5ac407b2 upstream.

As soon as the framebuffer is registered, our methods may be called by the
kernel. This leads to a crash as xenfb_refresh() gets called before we have
the irq.

Connect to the backend before registering our framebuffer with the kernel.

[ Fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14059 ]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/xen-fbfront.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -454,6 +454,10 @@ static int __devinit xenfb_probe(struct 
 
 	xenfb_init_shared_page(info, fb_info);
 
+	ret = xenfb_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
 	ret = register_framebuffer(fb_info);
 	if (ret) {
 		fb_deferred_io_cleanup(fb_info);
@@ -464,10 +468,6 @@ static int __devinit xenfb_probe(struct 
 	}
 	info->fb_info = fb_info;
 
-	ret = xenfb_connect_backend(dev, info);
-	if (ret < 0)
-		goto error;
-
 	xenfb_make_preferred_console();
 	return 0;
 


