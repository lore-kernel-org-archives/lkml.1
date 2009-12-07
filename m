Return-Path: <linux-kernel-owner+w=401wt.eu-S935295AbZLGX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295AbZLGX2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935229AbZLGX2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:28:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53536 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709AbZLGX2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:28:37 -0500
Date: Mon, 7 Dec 2009 23:28:38 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jiri Slaby <jirislaby@gmail.com>
cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: DRM/ttm: Unreachable code in ttm_bo_add_ttm
In-Reply-To: <4B1D68AD.2090409@gmail.com>
Message-ID: <alpine.DEB.2.00.0912072328050.14943@skynet.skynet.ie>
References: <4B1D68AD.2090409@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Jiri Slaby wrote:

> Hi,
> 
> Stanse found unreachable code in ttm_bo_add_ttm:
> http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=32&id=714#l238
> 
> Excerpt from there:
>   230| case ttm_bo_type_user:
>   231|  bo->ttm = ttm_tt_create(bdev, bo->num_pages << 12,
>   232|     page_flags | (1 << 1),
>   233|     glob->dummy_read_page);
>   234|  if (bo->ttm == ((void *)0))
>   235|   ret = -12;
>   236|  break;
>   237|
>   238|  ret = ttm_tt_set_user(bo->ttm, get_current(),
>      |This node is unreachable prev next
>   239|          bo->buffer_start, bo->num_pages);
>   240|  if (ret != 0)
>   241|   ttm_tt_destroy(bo->ttm);
>   242|  break;
> 
> 

Thanks,
I've pushed this patch.

>From 447aeb907e417e0e837b4a4026d5081c88b6e8ca Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Tue, 8 Dec 2009 09:25:45 +1000
Subject: [PATCH] drm/ttm: fix unreachable code.

None of the in-tree drivers use user objects yet so this wasn't hitting
us.

Stanse found unreachable code in ttm_bo_add_ttm:
http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=32&id=714#l238

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 87c0625..e13fd23 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -275,9 +275,10 @@ static int ttm_bo_add_ttm(struct ttm_buffer_object *bo, bool zero_alloc)
 		bo->ttm = ttm_tt_create(bdev, bo->num_pages << PAGE_SHIFT,
 					page_flags | TTM_PAGE_FLAG_USER,
 					glob->dummy_read_page);
-		if (unlikely(bo->ttm == NULL))
+		if (unlikely(bo->ttm == NULL)) {
 			ret = -ENOMEM;
-		break;
+			break;
+		}
 
 		ret = ttm_tt_set_user(bo->ttm, current,
 				      bo->buffer_start, bo->num_pages);
-- 
1.6.5.2

