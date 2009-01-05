Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbZAEXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbZAEXjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZAEXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:39:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZAEXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:39:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=eKh3a4EnWcDbc5bTy/fhRztyZMfy/g+r2qfvqHq/LYhuc45RpZqH2bdH+Cn9DMsLO
	kCBmRDVki1wXb1H6fV0qQ==
MIME-Version: 1.0
Date: Mon, 5 Jan 2009 15:39:07 -0800
Message-ID: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com>
Subject: [PATCH]Fix: 32bit binary has 64bit address of stack vma
From: Ying Han <yinghan@google.com>
To: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Waychison <mikew@google.com>, Rohit Seth <rohitseth@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.36
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Han <yinghan@google.com>

Fix 32bit binary get 64bit stack vma offset.

32bit binary running on 64bit system, the /proc/pid/maps shows for the
vma represents stack get a 64bit adress:
ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]

Signed-off-by:	Ying Han <yinghan@google.com>

fs/exec.c                     |    5 +-

diff --git a/fs/exec.c b/fs/exec.c
index 4e834f1..8c3eff4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -517,6 +517,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
+	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
 	struct mmu_gather *tlb;

 	BUG_ON(new_start > new_end);
@@ -531,7 +532,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
+	vma_adjust(vma, new_start, old_end, new_pgoff, NULL);

 	/*
 	 * move the page tables downwards, on failure we rely on
@@ -564,7 +565,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
 	/*
 	 * shrink the vma to just the new range.
 	 */
-	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
+	vma_adjust(vma, new_start, new_end, new_pgoff, NULL);

 	return 0;
 }
