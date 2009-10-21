Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZJUO7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZJUO7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZJUO7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:59:52 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39862 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZJUO7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DXaOO96jShmQ8gNGkjd/mzgFoxIGvRBoFwEtTVUliTPKe5QdTRpbYMTQp6iuQ1KnNy
         wtVfH55CryIKWvAXLjia/YUEDJ29glKqHrcMR1UTNJw3ea2OUTIaBnn/O105n75NOydr
         Cdi/nlJ4elA7CPGv5reZ3+3IlzZ2DdVDU0JsE=
Message-ID: <4ADF2449.7090902@gmail.com>
Date: Wed, 21 Oct 2009 17:10:01 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: krzysztof.h1@poczta.fm
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: Wrong test on unsigned in
 fb_set_user_cmap()?
References: <20091021065018.7625046CCF3@f46.poczta.interia.pl>
In-Reply-To: <20091021065018.7625046CCF3@f46.poczta.interia.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct fb_cmap_user member start is unsigned. The same condition
is already checked in fb_set_cmap(), so this should be safe.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> Is this required?
> 
> Drop the whole if() as exactly the same condition is checked in the
> fb_set_cmap() again.

Ok

> Anyway, the check of the cmap->start < 0 does
> not make any sense as the start is u32 value (most userspace
> addresses will be lower then 2GB on 32 bit system so the error cannot
> be caught by the check). I vote for removing the (cmap->start < 0) in
> the fb_set_cmap as well as most drivers check the start value already
> in driver's fb_setcolreg() function.

In fb_set_cmap() this is not `cmap->start' but `start' which has type
int. Therefore I think the test makes some sense there, so I left it.

> 
> Best regards,
> Krzysztof

Thanks, here:

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..f46d617 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -266,11 +266,6 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-				!info->fbops->fb_setcmap)) {
-		rc = -EINVAL;
-		goto out1;
-	}
 	rc = fb_set_cmap(&umap, info);
 out1:
 	unlock_fb_info(info);
