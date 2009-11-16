Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZKPCG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZKPCG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZKPCG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:06:27 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:64670 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZKPCG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:06:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hjixPs+Cy7ROOTKHvtLWZ275S6dtu4KKNT4bIs0qo8XWtq+AyV8kz41eKm9VahL1IA
         eR6bZp3uYJQKQ5VZoh8XcEwj7CBpeaAXDdKV5VZDxaSX2xwPuy/D9IIBDW3qVqi6ZZca
         Jlulg3DVcTTsgyFUnwj/99KaqcD5hQJCZ0aTg=
MIME-Version: 1.0
Date: Mon, 16 Nov 2009 08:06:32 +0600
Message-ID: <b9df5fa10911151806y24cce0b9pe1162fb07a0d7e9@mail.gmail.com>
Subject: [PATCH] mm: Fix section mismatch in memory_hotplug.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 __free_pages_bootmem() is a __meminit function - which has been called
from put_pages_bootmem thus causes a section mismatch warning.

 We were warned by the following warning:

  LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x26b22): Section mismatch in reference
from the function put_page_bootmem() to the function
.meminit.text:__free_pages_bootmem()
The function put_page_bootmem() references
the function __meminit __free_pages_bootmem().
This is often because put_page_bootmem lacks a __meminit
annotation or the annotation of __free_pages_bootmem is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/mm/memory_hotplug.c	2009-11-13 13:17:06.000000000 +0600
+++ rakib/mm/memory_hotplug.c	2009-11-15 08:30:31.000000000 +0600
@@ -70,7 +70,9 @@ static void get_page_bootmem(unsigned lo
 	atomic_inc(&page->_count);
 }

-void put_page_bootmem(struct page *page)
+/* reference to __meminit __free_pages_bootmem is valid
+ * so use __ref to tell modpost not to generate a warning */
+void __ref put_page_bootmem(struct page *page)
 {
 	int type;
