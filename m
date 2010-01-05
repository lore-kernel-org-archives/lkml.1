Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130Ab0AEMhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0AEMhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0AEMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:37:20 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:27411 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab0AEMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:37:19 -0500
X-Trace: 321166455/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4BAL3BQktPRRyw/2dsb2JhbAAI0zmEMAQ
X-IronPort-AV: E=Sophos;i="4.47,505,1257120000"; 
   d="scan'208";a="321166455"
Date: Tue, 5 Jan 2010 12:37:19 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric B Munson <ebmunson@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] nommu: reject MAP_HUGETLB
In-Reply-To: <20100104123858.GA5045@us.ibm.com>
Message-ID: <alpine.LSU.2.00.1001051232530.1055@sister.anvils>
References: <alpine.LSU.2.00.0912302009040.30390@sister.anvils> <20100104123858.GA5045@us.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've agreed to restore the rejection of MAP_HUGETLB to nommu.
Mimic what happens with mmu when hugetlb is not configured in:
say -ENOSYS, but -EINVAL if MAP_ANONYMOUS was not given too.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/nommu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- 2.6.33-rc2-git/mm/nommu.c	2009-12-31 08:08:16.000000000 +0000
+++ linux/mm/nommu.c	2010-01-05 12:08:01.000000000 +0000
@@ -1405,6 +1405,14 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 	struct file *file = NULL;
 	unsigned long retval = -EBADF;
 
+	if (unlikely(flags & MAP_HUGETLB)) {
+		if (flags & MAP_ANONYMOUS)
+			retval = -ENOSYS;	/* like hugetlb_file_setup */
+		else
+			retval = -EINVAL;
+		goto out;
+	}
+
 	if (!(flags & MAP_ANONYMOUS)) {
 		file = fget(fd);
 		if (!file)
