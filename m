Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXKNSb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXKNSb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbXKNSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:31:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:5092 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbXKNSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=AUepX9R/bLM5aJcTfoG40oUs5Fw32m0b24aL6V3jnLCqiRV7Wf8fN2SrGFi7c3XsG+bHb2CgvQZ8HkR0ZI5D0eM8OnTcNHpsH/GK9GNghieeNyJzaKoZwddrm/+X87ZQX+1mdUu5N2vBJ1NONF9TdQDrB5k7GMK/2MoVGgXA/10=
Message-ID: <e04d66f60711141031waeb9f1bu34a8fa4cadd5d6c3@mail.gmail.com>
Date: Wed, 14 Nov 2007 18:31:15 +0000
From: "Robert Bragg" <robert@sixbynine.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] mm: Don't allow ioremapping of ranges larger than vmalloc space
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c3973b7d4dd53d29
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When running with a 16M IOREMAP_MAX_ORDER (on armv7) we found that the vmlist
search routine in __get_vm_area_node can mistakenly allow a driver to ioremap
a range larger than vmalloc space.

If at the time of the ioremap all existing vmlist areas sit below the determined
alignment then the search routine continues past all entries and exits the for
loop - straight into the found: label - without ever testing for integer
wrapping or that the requested size fits.

We were seeing a driver successfully ioremap 128M of flash even though there was
only 120M of vmalloc space. From that point the system was left with
the remainder
of the first 16M of space to vmalloc/ioremap within.

Signed-off-by: Robert Bragg <robert@sixbynine.org>

---

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index af77e17..06a7f3a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -216,6 +216,10 @@ static struct vm_struct *__get_vm_area_node
 		if (addr > end - size)
 			goto out;
 	}
+	if ((size + addr) < addr)
+		goto out;
+	if (addr > end - size)
+		goto out;

 found:
 	area->next = *p;
