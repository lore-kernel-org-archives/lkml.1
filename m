Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZKCU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZKCU0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZKCU0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:26:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:35373 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZKCU0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:26:19 -0500
Date: Tue, 3 Nov 2009 15:26:11 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: [PATCH] drm: check return values in drm_version
Message-ID: <20091103152611.194a4501@mycelium.queued.net>
In-Reply-To: <20091103150954.68f4a285@mycelium.queued.net>
References: <20091019013708.6ca3c7df@mycelium.queued.net>
	<20091102234124.2655e61d.akpm@linux-foundation.org>
	<20091103150954.68f4a285@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 15:09:54 -0500
Andres Salomon <dilinger@collabora.co.uk> wrote:

> On Mon, 2 Nov 2009 23:41:24 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 19 Oct 2009 01:37:08 -0400 Andres Salomon
> > <dilinger@collabora.co.uk> wrote:
> > 
> > > There are a few more macros in drmP.h that are unused;
> > > DRM_GET_PRIV_SAREA, DRM_ARRAY_SIZE, and DRM_WAITCOUNT can go away
> > > completely.
> > > 
> > > Unfortunately, DRM_COPY is still used in one place, but we can at
> > > least move it to where it's used.  It's an awful looking macro..
> > 
> > It would have been nice to fix the (valid) checkpatch warnings while
> > you were there.
> > 
> 
> How about I do one better and replace the macro w/ a function?
> 
> 
> 
> From 535091717408e4ec4974e8f309212f61aabd1880 Mon Sep 17 00:00:00 2001
> From: Andres Salomon <dilinger@collabora.co.uk>
> Date: Tue, 3 Nov 2009 15:03:52 -0500
> Subject: [PATCH] drm: replace DRM_COPY macro w/ a function
> 
> Don't inline it; the compiler can figure it out.  Comments added that
> are based upon my interpretation of the code.  Hopefully they're
> correct. :)
> 

And here's one that actually checks the return values from
drm_copy_field.  This is separate from the pure cleanup patch(es)
as it changes behavior that userspace
sees, so it can be bisected and reverted apart from the others if
needed.



>From 041636a0e2b6d7ec5c4fdb8f495682d6928b73bf Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@collabora.co.uk>
Date: Tue, 3 Nov 2009 15:15:51 -0500
Subject: [PATCH] drm: check return values in drm_version

In drm_version, actually check the results from function calls so that
we're not potentially passing garbage back to userspace.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/gpu/drm/drm_drv.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index ec0e3ae..5bd3f94 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -403,15 +403,21 @@ static int drm_version(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
 {
 	struct drm_version *version = data;
+	int err;
 
 	version->version_major = dev->driver->major;
 	version->version_minor = dev->driver->minor;
 	version->version_patchlevel = dev->driver->patchlevel;
-	drm_copy_field(version->name, &version->name_len, dev->driver->name);
-	drm_copy_field(version->date, &version->date_len, dev->driver->date);
-	drm_copy_field(version->desc, &version->desc_len, dev->driver->desc);
-
-	return 0;
+	err = drm_copy_field(version->name, &version->name_len,
+			dev->driver->name);
+	if (!err)
+		err = drm_copy_field(version->date, &version->date_len,
+				dev->driver->date);
+	if (!err)
+		err = drm_copy_field(version->desc, &version->desc_len,
+				dev->driver->desc);
+
+	return err;
 }
 
 /**
-- 
1.5.6.5

