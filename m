Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024Ab0ALFvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0ALFvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277Ab0ALFvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:51:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60112 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0ALFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=frrUP04LaMdnLjGAizApZpskroYIFZHXd55QUWrnhDCtFJIOl5S3D2/XdE0ycLIqKF
         rz38xvpmV0dwqALW6KXmMIFyWsto6jp1aPmro8vyuHVan1Tny3G76xbYcaQI+BL5tc5M
         arEd4HDs7u/QQ3EAJaIgwkMVne7ONP5BUPVug=
Subject: Re: [PATCH] Fix reset of ramzswap
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <d760cf2d1001112130p8489b93uccd6a4650ff4a4a8@mail.gmail.com>
References: <1263271018.23507.8.camel@barrios-desktop>
	 <d760cf2d1001112130p8489b93uccd6a4650ff4a4a8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 14:48:28 +0900
Message-Id: <1263275308.23507.18.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 11:00 +0530, Nitin Gupta wrote:
> On Tue, Jan 12, 2010 at 10:06 AM, minchan.kim <minchan.kim@gmail.com> wrote:
> > ioctl(cmd=reset)
> >        -> bd_holder check (if whoever hold bdev, return -EBUSY)
> >        -> ramzswap_ioctl_reset_device
> >                -> reset_device
> >                        -> bd_release
> >
> > bd_release is called by reset_device.
> > but ramzswap_ioctl always checks bd_holder before
> > reset_device. it means reset ioctl always fails.
> 
> Are you sure you checked this patch?

> This check makes sure that you cannot reset an active swap device.
> When device in swapoff'ed the ioctl works as expected.
> 
It seems my test was wrong. 
Maybe my test case don't swapoff swap device. 
Sorry. Ignore this patch, pz.
Thanks for the reivew, Nitin. 

I have one more patch. But I don't want to conflict your pending
patches. If it is right, pz, merge this patch with your pending series.

>From bf810ec09761b0f37eca7ba22d72fb2b1f2cba50 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Tue, 12 Jan 2010 14:46:46 +0900
Subject: [PATCH] Remove unnecessary check of ramzswap_write

Nitin already implement swap slot free callback.
So, we don't need this test any more.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 drivers/staging/ramzswap/ramzswap_drv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c
b/drivers/staging/ramzswap/ramzswap_drv.c
index 18196f3..575a147 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -784,14 +784,6 @@ static int ramzswap_write(struct ramzswap *rzs,
struct bio *bio)
 	src = rzs->compress_buffer;
 
 	/*
-	 * System swaps to same sector again when the stored page
-	 * is no longer referenced by any process. So, its now safe
-	 * to free the memory that was allocated for this page.
-	 */
-	if (rzs->table[index].page)
-		ramzswap_free_page(rzs, index);
-
-	/*
 	 * No memory ia allocated for zero filled pages.
 	 * Simply clear zero page flag.
 	 */
-- 
1.5.6.3




-- 
Kind regards,
Minchan Kim

