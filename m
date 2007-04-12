Return-Path: <linux-kernel-owner+w=401wt.eu-S1161537AbXDLCyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537AbXDLCyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXDLCxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:53:55 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161531AbXDLCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=rWyeRUY/auGcRDN1QfKWVTqoX9h4RcSGxNpnKeM3T8BOOSloBmcR7wuMCK/kDtSviyhYld5L8k1KOHyVd06yct1xiUqwah1+TLyWlYGNiAaoe+OKfOsnkro2VlwIvui8jalqV8PyFw5fn0Wp2f/Z9Ju1hvv6+ibonn/jDZ5tq7Y=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.55983.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 12/17] partition: remove redundant read_mapping_page error checks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded PageError checking in read_dev_sector(), and clean up the
code a bit.

Can anyone point out why it's OK to use page_address() here on a page which
has not been kmapped?  If it's not OK, then a good number of callers need to
be fixed.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/partitions/check.c linux-2.6.21-rc6-mm1-test/fs/partitions/check.c
--- linux-2.6.21-rc6-mm1/fs/partitions/check.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/partitions/check.c	2007-04-10 21:59:01.000000000 -0700
@@ -568,16 +568,12 @@ unsigned char *read_dev_sector(struct bl
 
 	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
 				 NULL);
-	if (!IS_ERR(page)) {
-		if (PageError(page))
-			goto fail;
-		p->v = page;
-		return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_CACHE_SHIFT - 9)) - 1)) << 9);
-fail:
-		page_cache_release(page);
+	if (IS_ERR(page)) {
+		p->v = NULL;
+		return NULL;
 	}
-	p->v = NULL;
-	return NULL;
+	p->v = page;
+	return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_CACHE_SHIFT - 9)) - 1)) << 9);
 }
 
 EXPORT_SYMBOL(read_dev_sector);
