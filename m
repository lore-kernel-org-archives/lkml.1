Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbXF1N3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbXF1N3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXF1N3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:29:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbXF1N3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:29:05 -0400
Subject: [PATCH] SELinux: make mmap hint addresses greater than
	mmap_min_addr
From: Eric Paris <eparis@redhat.com>
To: sds@tycho.nsa.gov, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Thu, 28 Jun 2007 09:28:52 -0400
Message-Id: <1183037332.3905.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new protection to keep users from writing to the first couple of
pages of virtual memory also is stopping mmap operations which are only
giving a hint address greater than 0 but less than mmap_min_addr.  This
patch should take the address given to mmap and move it up to
mmap_min_addr thus eliminating the security denial.

--

Testing on this patch resulted in expected results.  With my
mmap_min_addr set to 40960

About to MAP_FIXED addr:40960
Works.
About to MAP_FIXED addr:32768
mmap: Permission denied

So MAP_FXIED operations were getting denied.

About to mmap with hint addr:40960
Works.
About to mmap with hint addr:32768
Requested addr:32768 but got addr:40960

So given a low hint address we just got 40960

About to mmap with hint addr:4096
Requested addr:4096 but got addr:40960
About to mmap with hint addr:8192
Requested addr:8192 but got addr:3086798848

Here I didn't munmap between each mmap call.  In this case 4096 hint got
bumped to 40960 (mmap_min_addr) and worked fine.  A new hint, 8192 also
got bumped to 40960 but the kernel found it couldn't use that and
instead found a whole new open memory area.  Appears to be working as
expected.

 mm/mmap.c  |    7 +++++++
 mm/nommu.c |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index bce4995..ecd1dcc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -916,6 +916,13 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 	if (!len)
 		return -EINVAL;
 
+	/*
+	 * If a hint addr is less than mmap_min_addr change addr to be as
+	 * low as possible but still greater than mmap_min_addr
+	 */
+	if (!(flags & MAP_FIXED) && (addr != NULL) && (addr < mmap_min_addr))
+		addr = (mmap_min_addr + ~PAGE_MASK) & PAGE_MASK;
+
 	error = arch_mmap_check(addr, len, flags);
 	if (error)
 		return error;
diff --git a/mm/nommu.c b/mm/nommu.c
index 989e2e9..6c13728 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -805,6 +805,13 @@ unsigned long do_mmap_pgoff(struct file *file,
 	void *result;
 	int ret;
 
+	/*
+ 	* If a hint addr is less than mmap_min_addr change addr to be as
+ 	* low as possible, but still greater than mmap_min_addr
+ 	*/
+	if (!(flags & MAP_FIXED) && (addr != NULL) && (addr < mmap_min_addr))
+		addr = (mmap_min_addr + ~PAGE_MASK) & PAGE_MASK;
+
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,


