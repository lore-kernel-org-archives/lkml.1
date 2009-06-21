Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZFUVPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZFUVPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFUVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:14:51 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42335 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZFUVOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rGxsagOlP6rbfDLg3MOMx0syxSN9Z0fWWhhxJaAJTR2Qpmxry/Xt40u4y/jntTWZVs
         KvHMsOFsjdRpXGPq/DZPoSNfeKCYN8L4wPQewAXrmk6USi/T5IJM+In6QsG3rkfEBuFo
         2g1nMuOmbo4AEbkojPRkZwYIJtFj/hswTIRSk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
Date: Sun, 21 Jun 2009 17:14:52 -0400
X-Google-Sender-Auth: a895e56961c506b8
Message-ID: <cb0375e10906211414j390fc590y4331896bddda9c0d@mail.gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
From: Andrew Lutomirski <luto@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 3:47 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>
>
> What *has* changed is that we have a newradeon driver, and it looks like
> that new radeon driver is crap, and does this:
>
>        info->fix.smem_start = (unsigned long)fbptr;
>
> which is totally screwed up. It assigns a _virtual_ address to that
> "smem_start" thing, even though it should be a physical one.
>
> I don't know the radeon driver, so I don't know where to find the physical
> address.  It's also possible that there is no good single physical
> address, and the radeon driver should implement a "fb_mmap" function.
>
> Does this patch make the warning and the oops at least go away? Obviously
> it won't result in a working frame buffer, but that's a separate issue
>

I haven't tried your patch, but I hacked up the one below instead,
which also fixes the oops.  It still doesn't boot, though -- plymouth
hangs (or otherwise dies), preventing my initramfs from finishing.
The same kernel image boots fine with radeon.modeset=0.

I wouldn't apply this without someone more familiar with the code's
ack -- I have no idea if the lifetime of the framebuffer object is
right, and there may be any number of other bugs lurking in here.  Not
to mention a missing "static."

Signed-off-by: Andy Lutomirski <luto@mit.edu>

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c
b/drivers/gpu/drm/radeon/radeon_fb.c
index fa86d39..cbb330d 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -380,6 +380,12 @@ int radeonfb_blank(int blank, struct fb_info *info)
 	return 0;
 }

+int radeonfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct radeon_fb_device *rfbdev = info->par;
+	return radeon_object_fbdev_mmap(rfbdev->rdev->fbdev_robj, vma);
+}
+
 static struct fb_ops radeonfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = radeonfb_check_var,
@@ -390,6 +396,7 @@ static struct fb_ops radeonfb_ops = {
 	.fb_imageblit = cfb_imageblit,
 	.fb_pan_display = radeonfb_pan_display,
 	.fb_blank = radeonfb_blank,
+	.fb_mmap = radeonfb_mmap,
 };

 /**
@@ -499,7 +506,7 @@ int radeonfb_create(struct radeon_device *rdev,

 	ret = radeon_gem_object_create(rdev, aligned_size, 0,
 				       RADEON_GEM_DOMAIN_VRAM,
-				       false, ttm_bo_type_kernel,
+				       false, ttm_bo_type_device,
 				       false, &gobj);
 	if (ret) {
 		printk(KERN_ERR "failed to allocate framebuffer\n");
@@ -547,8 +554,6 @@ int radeonfb_create(struct radeon_device *rdev,
 	info->fbops = &radeonfb_ops;
 	info->fix.line_length = fb->pitch;
 	info->screen_base = fbptr;
-	info->fix.smem_start = (unsigned long)fbptr;
-	info->fix.smem_len = size;
 	info->screen_base = fbptr;
 	info->screen_size = size;
 	info->pseudo_palette = fb->pseudo_palette;
diff --git a/drivers/gpu/drm/radeon/radeon_object.c
b/drivers/gpu/drm/radeon/radeon_object.c
index 983e8df..433e52e 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -267,7 +267,6 @@ int radeon_object_pin(struct radeon_object *robj,
uint32_t domain,
 		}
 		if (!r) {
 			robj->rdev->fbdev_info->screen_base = fbptr;
-			robj->rdev->fbdev_info->fix.smem_start = (unsigned long)fbptr;
 		}
 		mutex_unlock(&robj->rdev->fbdev_info->lock);
 	}
@@ -316,7 +315,6 @@ void radeon_object_unpin(struct radeon_object *robj)
 		}
 		if (!r) {
 			robj->rdev->fbdev_info->screen_base = fbptr;
-			robj->rdev->fbdev_info->fix.smem_start = (unsigned long)fbptr;
 		}
 		mutex_unlock(&robj->rdev->fbdev_info->lock);
 	}
