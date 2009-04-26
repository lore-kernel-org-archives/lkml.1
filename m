Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZDZMU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZDZMU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZDZMUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:20:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54948 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZDZMUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=uybNpkgbcf4ZFWhE91kL/tjskBgwWxRhtI8bhKqE96YKzHqndni1xMKQIxvkci9FvH
         4BPpLZ6tjQJZu9YReukSDkRx+aeQ8U6/JhNN1Z5vR3vFTjPBmwIC/4vRcnA2gx5VdmR1
         FLbkxQpJViCv7Xy7klS/rU8TDuJiD4wbeYcCM=
Message-ID: <49F4519F.4090003@gmail.com>
Date: Sun, 26 Apr 2009 14:20:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] fbcmap: non working tests on unsigned	cmap->start
References: <49EDD799.8060607@gmail.com> <20090423134110.51ea8df2.akpm@linux-foundation.org> <20090423214738.GF7134@sci.fi>
In-Reply-To: <20090423214738.GF7134@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmap->start is unsigned, A negative start could result in incorrect
colors. `start' is used as the starting index for the hardware palette,
'start+len-1' is the last index.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>>> vi include/linux/fb.h +478
>>>
>>> Note that struct fb_cmap_user cmap->start in fb_set_user_cmap() is unsigned.
>>> Should there maybe be a test:
>>>
>>> if (cmap->start > MAX || ...)
>>>
>>> (and what should MAX be then?)
>>>

> On Thu, Apr 23, 2009 at 01:41:10PM -0700, Andrew Morton wrote:
>> argh.
>>
>> - Perhaps userspace can kill the kernel by sending a "negative"
>>   `start'.  Removing the test will make it even less likely that we'll
>>   fix this bug.
> 
> Shouldn't happen. 'start' is used as the starting index for the hardware
> palette, 'start+len-1' is the last index. All drivers should already check
> the passed values since the maximum index depends on the display mode.
> And I suppose the worst thing that could happen if the driver fails to
> check the values would be incorrect colors.

Thanks for your explanation, I think this should fix it?

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..ea62d87 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -266,7 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
+	if (cmap->start >= cmap->len || (!info->fbops->fb_setcolreg &&
 				!info->fbops->fb_setcmap)) {
 		rc = -EINVAL;
 		goto out1;

