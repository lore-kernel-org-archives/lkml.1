Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0BOWYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:24:48 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52457 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0BOWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SrU45HGhaa9ML+1owRKLUbZeDOKWHIL/H5NIqkkjlZEXg/TLKFatGexbUNsNo8VDW4
         wO0+PM+M26V2QCxHGrIRKabvnDfvQPct+o5Pn3uUOMbQj3pfjuFC29fcAb+xf3Le/3je
         vos11VJNVM0CTzaN3ukB5mRgLNkANdh5jBPPA=
Date: Mon, 15 Feb 2010 23:22:40 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: nouveau@lists.freedesktop.org
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau: fix nouveau_i2c_find bounds checking
Message-ID: <20100215222240.GB2823@joi.lan>
References: <20100215124046.GB18821@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215124046.GB18821@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:40:56PM +0300, Dan Carpenter wrote:
> This is the results from:
>     make C=1 CHECK="/path/to/smatch -p=kernel" bzImage modules | tee warns.txt
>     grep -w overflow warns.txt | uniq -f 3 | tee err-list
> 
> I hacked on the buffer overflow check last weekend and these are the 
> results.  It has way more false positives than the other bug lists 
> I've posted, but it's still kinda neat.
> 
> It works like this:
> 
> lib/zlib_inflate/inftrees.c
>    112      for (min = 1; min <= MAXBITS; min++)
>    113          if (count[min] != 0) break;
>    114      if (root < min) root = min;
> smatch thinks "min" can be MAXBITS here.
> 
> One bad thing is that if you have code like:
>         if (foo == 42)
> 		frob();
> Smatch thinks that "foo" can be 43 after the if statement.
> 
> The format is:
> file.c +<line> function(<lines into function>) warning 'array_name' <array size> <= <offset>
> 
> regards,
> dan carpenter
> 
> Previous bug lists:
> * Putting too much data on the stack
>   http://lkml.indiana.edu/hypermail/linux/kernel/1002.1/01252.html
> 
> * Assigning negative values to unsigned variables
>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01222.html
> 
> * Doing dma on the stack
>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01231.html
> 
> * Dereferencing variables before verifying they are not null
>   http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01980.html
> 
> (...)
> drivers/gpu/drm/nouveau/nouveau_i2c.c +262 nouveau_i2c_find(9) error: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
> drivers/gpu/drm/nouveau/nouveau_i2c.c +263 nouveau_i2c_find(10) warn: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
> drivers/gpu/drm/nouveau/nouveau_i2c.c +267 nouveau_i2c_find(14) error: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
> (...)


---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] drm/nouveau: fix nouveau_i2c_find bounds checking

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_i2c.c b/drivers/gpu/drm/nouveau/nouveau_i2c.c
index 70e994d..f0162c4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_i2c.c
+++ b/drivers/gpu/drm/nouveau/nouveau_i2c.c
@@ -256,7 +256,7 @@ nouveau_i2c_find(struct drm_device *dev, int index)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nvbios *bios = &dev_priv->VBIOS;
 
-	if (index > DCB_MAX_NUM_I2C_ENTRIES)
+	if (index >= DCB_MAX_NUM_I2C_ENTRIES)
 		return NULL;
 
 	if (!bios->bdcb.dcb.i2c[index].chan) {
-- 
1.6.6.1


