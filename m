Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXKZXro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXKZXro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbXKZXrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:47:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbXKZXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:47:37 -0500
Subject: [PATCH 1/3] mmap: protect from stack expantion into low vm
	addresses
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Content-Type: text/plain
Date: Mon, 26 Nov 2007 18:47:26 -0500
Message-Id: <1196120846.16779.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add security checks to make sure we are not attempting to expand the
stack into memory protected by mmap_min_addr

Signed-off-by: Eric Paris <eparis@redhat.com>

---

** Be very careful applying/rediffing this patch.  Standard 3 lines of
context from git diff will misapply the first hunk to expand_upwards
instead of properly in expand_downwards.  This patch was generated using
-U 4 to make sure it applies in the correct place.  **

 mm/mmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- kernel-1/mm/mmap.c
+++ kernel-2/mm/mmap.c
@@ -1614,17 +1614,21 @@ static inline int expand_downwards(struc
 	 * so that the anon_vma locking is not a noop.
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
+
+	address &= PAGE_MASK;
+	error = security_file_mmap(0, 0, 0, 0, address, 1);
+	if (error)
+		return error;
+
 	anon_vma_lock(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
 	 */
-	address &= PAGE_MASK;
-	error = 0;
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
 		unsigned long size, grow;


