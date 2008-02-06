Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbYBFXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbYBFXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763228AbYBFXHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:07:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25856 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763249AbYBFXHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xFpOdjvEHegeTTKvwa6BkwAJG7B18EnCqBi2rPR7LDQ4KdrIC1t0MDX7X2JnCXB+1O4iQOvoVrOki8UKdp4BfHGSyx2V9nTF/hLYyv21qBdwAJ8P6z6nd37kHAgUVqXsG3yy1bjfr54GXjaDnOf/0Zj8nuelQPcOnhM6MPz8OHE=
Message-ID: <6101e8c40802061507y109776d0o790ebefcf71baf1@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:07:28 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {05/17} - cciss-fix_memory_leak - series for stable kernel #2
In-Reply-To: <6101e8c40802011733g504c1cd7ubaceee5df9a51a66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011733g504c1cd7ubaceee5df9a51a66@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f2912a1223c0917a7b4e054f18086209137891ea Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Tue, 31 Jul 2007 00:39:39 -0700
Subject: [PATCH] cciss: fix memory leak

There's a memory leak in the cciss driver.

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

Spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1be82d5..a11b2bd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3227,12 +3227,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: f2912a1223c0917a7b4e054f18086209137891ea
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
