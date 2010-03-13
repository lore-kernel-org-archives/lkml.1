Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500Ab0CMBa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:30:59 -0500
Received: from kroah.org ([198.145.64.141]:60649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934872Ab0CMATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:53 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.796828453@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 030/123] PM / Hibernate: Fix preallocating of memory
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit a9c9b4429df437982d2fbfab1f4b46b01329e9ed upstream.

The hibernate memory preallocation code allocates memory to push some
user space data out of physical RAM, so that the hibernation image is
not too large.  It allocates more memory than necessary for creating
the image, so it has to release some pages to make room for
allocations made while suspending devices and disabling nonboot CPUs,
or the system will hang due to the lack of free pages to allocate
from.  Unfortunately, the function used for freeing these pages,
free_unnecessary_pages(), contains a bug that prevents it from doing
the job on all systems without highmem.

Fix this problem, which is a regression from the 2.6.30 kernel, by
using the right condition for the termination of the loop in
free_unnecessary_pages().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1181,7 +1181,7 @@ static void free_unnecessary_pages(void)
 
 	memory_bm_position_reset(&copy_bm);
 
-	while (to_free_normal > 0 && to_free_highmem > 0) {
+	while (to_free_normal > 0 || to_free_highmem > 0) {
 		unsigned long pfn = memory_bm_next_pfn(&copy_bm);
 		struct page *page = pfn_to_page(pfn);
 


