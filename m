Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXEDPAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXEDPAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXEDPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:00:46 -0400
Received: from ozlabs.org ([203.10.76.45]:48350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbXEDPAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:00:45 -0400
Subject: [PATCH 3/3] lguest: fix obscure but nasty cow bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1178290730.23670.117.camel@localhost.localdomain>
References: <1178290638.23670.114.camel@localhost.localdomain>
	 <1178290730.23670.117.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 05 May 2007 01:00:31 +1000
Message-Id: <1178290831.23670.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nasty bug where the host is the first to write a MAP_PRIVATE page: the
guest still references the old one and won't see the write.  This can
happen with just the wrong data layouts for the initial setup
hypercall (the other places in the code are always written
guest-first).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 drivers/lguest/hypercalls.c |    6 ++++++
 1 file changed, 6 insertions(+)

===================================================================
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -144,6 +144,12 @@ static void initialize(struct lguest *lg
 	/* We reserve the top pgd entry. */
 	put_user(4U*1024*1024, &lg->lguest_data->reserve_mem);
 	put_user(lg->guestid, &lg->lguest_data->guestid);
+
+	/* This is the one case where the above accesses might have
+	 * been the first write to a Guest page.  This may have caused
+	 * a copy-on-write fault, but the Guest might be referring to
+	 * the old (read-only) page. */
+	guest_pagetable_clear_all(lg);
 }
 
 /* Even if we go out to userspace and come back, we don't want to do


