Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXLDQID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXLDQID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXLDQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:07:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXLDQHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:07:49 -0500
Subject: [PATCH] VM/Security: add security hook to do_brk
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, alan@redhat.com, chrisw@redhat.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       solar@openwall.com, wtarreau@hera.kernel.org
Content-Type: text/plain
Date: Tue, 04 Dec 2007 11:06:55 -0500
Message-Id: <1196784415.2912.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a specifically crafted binary do_brk() can be used to get low
pages available in userspace virtually memory and can thus be used to
circumvent the mmap_min_addr low memory protection.  Add security checks
in do_brk().

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index f4cfc6a..15678aa 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1941,6 +1941,10 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
+	error = security_file_mmap(0, 0, 0, 0, addr, 1);
+	if (error)
+		return error;
+
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = arch_mmap_check(addr, len, flags);


