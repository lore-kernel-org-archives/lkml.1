Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYJUL57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYJUL57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJUL5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:57:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:51885 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYJUL5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Kpt9aBoueh152vD7lilSkX9ny7NjaxWT3kdr+txnj4U1o+tReAWW5UT3Pbusvs01qv
         03bkFWE4sMqQ0zpRDiPsmE5h1cN0DvqOyNp5wP7E+vVybL1O38zV3DX0NoJDlDF/BOV0
         dB63776kQDEKCifzJcPfUZWemT3hzZVR9x/x4=
From: Magnus Damm <magnus.damm@gmail.com>
To: kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, Magnus Damm <magnus.damm@gmail.com>,
       horms@verge.net.au, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Date: Tue, 21 Oct 2008 20:56:38 +0900
Message-Id: <20081021115638.27749.59642.sendpatchset@rx1.opensource.se>
Subject: [PATCH] vmcore: Remove saved_max_pfn check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch removes the saved_max_pfn check from the /proc/vmcore
function read_from_oldmem(). No need to verify, we should be able
to just trust that "elfcorehdr=" is correctly passed to the crash
kernel on the kernel command line like we do with other parameters.

The read_from_oldmem() function in fs/proc/vmcore.c is quite similar
to read_from_oldmem() in drivers/char/mem.c, but only in the latter
it makes sense to use saved_max_pfn. For oldmem it is used to determine
when to stop reading. For vmcore we already have the elf header info
pointing out the physical memory regions, no need to pass the end-of-
old-memory twice.

Removing the saved_max_pfn check from vmcore makes it possible for
architectures to skip oldmem but still support crash dump through
vmcore - without the need for the old saved_max_pfn cruft.

Architectures that want to play safe can do the saved_max_pfn check
in copy_oldmem_page(). Not sure why anyone would want to do that,
but that's even safer than today - the saved_max_pfn check in vmcore
removed by this patch only checks the first page.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Simon Horman <horms@verge.net.au>
---

 Andrew, can you please pick up this one?

 fs/proc/vmcore.c |    2 --
 1 file changed, 2 deletions(-)

--- 0001/fs/proc/vmcore.c
+++ work/fs/proc/vmcore.c	2008-10-21 20:45:15.000000000 +0900
@@ -47,8 +47,6 @@ static ssize_t read_from_oldmem(char *bu
 
 	offset = (unsigned long)(*ppos % PAGE_SIZE);
 	pfn = (unsigned long)(*ppos / PAGE_SIZE);
-	if (pfn > saved_max_pfn)
-		return -EINVAL;
 
 	do {
 		if (count > (PAGE_SIZE - offset))
