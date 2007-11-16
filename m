Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbXKPU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbXKPU4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbXKPUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:55:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012AbXKPUz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:55:58 -0500
Subject: [PATCH 3/3] security: allow capable check to permit mmap or low vm
	space
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 16 Nov 2007 15:55:45 -0500
Message-Id: <1195246545.2924.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a kernel with CONFIG_SECURITY but without an LSM which implements
security_file_mmap it is impossible for an application to mmap addresses
lower than mmap_min_addr.  Based on a suggestion from a developer in the
openwall community this patch adds a check for CAP_SYS_RAWIO.  It is
assumed that any process with this capability can harm the system a lot
more easily than writing some stuff on the zero page and then trying to
get the kernel to trip over itself.  It also means that programs like X
on i686 which use vm86 emulation can work even with mmap_min_addr set.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 security/dummy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/dummy.c b/security/dummy.c
index 6d895ad..3ccfbbe 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -426,7 +426,7 @@ static int dummy_file_mmap (struct file *file, unsigned long reqprot,
 			    unsigned long addr,
 			    unsigned long addr_only)
 {
-	if (addr < mmap_min_addr)
+	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 	return 0;
 }


