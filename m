Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbZAPF22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbZAPF22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZAPF2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:28:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:14199 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZAPF2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TRFmhvyzREVTxRPoqZpPMI84Q4q0aDyhRaQnFQQTtrYGUi884cJeePDPH4riOul36c
         GrvRfFtx1RGBFjsYlzwfgwVrKW4jWbjnikP8La4uFxquV3bpjm36uf/P76vxDQ+fkqbq
         8KcmGzmT9X/TM+UeRuhDsheSpkQFS2OLhwdGs=
Date: Fri, 16 Jan 2009 14:28:04 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Cc: npiggin@suse.de, akpm@linux-foundation.org
Subject: [PATCH] Remove needless flush_dcache_page call
Message-ID: <20090116052804.GA18737@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, Anyone don't maintain cramfs.
I don't know who is maintain romfs. so I send this patch to linux-mm, 
lkml, linux-dev. 

I am not sure my thought is right. 

When readpage is called, page with argument in readpage is just new 
allocated because kernel can't find that page in page cache. 

At this time, any user process can't map the page to their address space. 
so, I think D-cache aliasing probelm never occur. 

It make sense ?

---
diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
deleted file mode 100644
index e69de29..0000000
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a07338d..40c8b84 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -492,7 +492,6 @@ static int cramfs_readpage(struct file *file, struct page * page)
 		pgdata = kmap(page);
 	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
 	kunmap(page);
-	flush_dcache_page(page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 98a232f..d008262 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -454,7 +454,6 @@ romfs_readpage(struct file *file, struct page * page)
 
 	if (!result)
 		SetPageUptodate(page);
-	flush_dcache_page(page);
 
 	unlock_page(page);
