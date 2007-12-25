Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXLYNXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXLYNXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXLYNWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:22:51 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:10133 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXLYNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=VC76voXvIahD9pdoTYCMDAPubJxY5N1HckeHxmbaK+hud0oVK9FYs8rdDZhoMTqKn7aISSvFKBxYkDKbI61daADpUF8tCWTRicBN7xVP0XGzSFMov/wqBJ2tDN3QvjRBKQQcaj6c2ogFK46NQK7vID1Y5GxwvHo76Az5/N7cLL4=
Date: Tue, 25 Dec 2007 22:21:26 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH] xip: fix get_zeroed_page with __GFP_HIGHMEM
Message-ID: <20071225132126.GA4800@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of get_zeroed_page() with __GFP_HIGHMEM is invalid.
Use alloc_page() with __GFP_ZERO instead of invalid get_zeroed_page().

(This patch is only compile tested)

Cc: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/filemap_xip.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: 2.6-git/mm/filemap_xip.c
===================================================================
--- 2.6-git.orig/mm/filemap_xip.c
+++ 2.6-git/mm/filemap_xip.c
@@ -25,14 +25,15 @@ static struct page *__xip_sparse_page;
 static struct page *xip_sparse_page(void)
 {
 	if (!__xip_sparse_page) {
-		unsigned long zeroes = get_zeroed_page(GFP_HIGHUSER);
-		if (zeroes) {
+		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+
+		if (page) {
 			static DEFINE_SPINLOCK(xip_alloc_lock);
 			spin_lock(&xip_alloc_lock);
 			if (!__xip_sparse_page)
-				__xip_sparse_page = virt_to_page(zeroes);
+				__xip_sparse_page = page;
 			else
-				free_page(zeroes);
+				__free_page(page);
 			spin_unlock(&xip_alloc_lock);
 		}
 	}
