Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXJHP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXJHP2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXJHP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:28:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:60929 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbXJHP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=miEXoorhK/y1PgLuAPlG5dNAzuHLCTsZmeBGLl6g/WrwDqezYq4rB4Tn4UeHNetI8v+eRlv1Z89t2ueNRjtNWwGTPYMcA9u/KxLh40WTyX3RKgRPrpG7ZjaVN+qEt9PCtjtSHmf64VBQyUIhr00GWRFVHysNc4lDvqKYuLei9Ac=
Message-ID: <3d0408630710080828h7ad160dbxf6cbd8513c1ad3e8@mail.gmail.com>
Date: Mon, 8 Oct 2007 23:28:07 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH]fix page release issue in filemap_fault
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e0224d950fba045a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

find_lock_page increases page's usage count, we should decrease it
before return VM_FAULT_SIGBUS

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
----
diff -ur linux-2.6.23-rc9/mm/filemap.c linux/mm/filemap.c
--- linux-2.6.23-rc9/mm/filemap.c	2007-10-07 15:03:33.000000000 +0800
+++ linux/mm/filemap.c	2007-10-08 23:14:39.000000000 +0800
@@ -1388,6 +1388,7 @@
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
+		page_cache_release(page);
 		goto outside_data_content;
 	}
