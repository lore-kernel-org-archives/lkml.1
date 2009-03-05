Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZCEQle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZCEQle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZCEQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:22 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37749 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZCEQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:21 -0500
Subject: [RFC][PATCH 11/11] optimize c/r check in dup_fd()
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:13 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163913.E59C59BB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__scan_files_for_cr() should compile down to nothing
if checkpoint/restart is disabled.

But, I think the spinlocks in fcheck_files() keep
the compiler from figuring this out.  So, instead
if putting in some #ifdefs, use our new cr_enabled()
helper.

I've verified that this puts .text size back to
where it was without the __scan_files_for_cr() call.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/file.c~optimize-cr-checkk fs/file.c
--- linux-2.6.git/fs/file.c~optimize-cr-checkk	2009-03-05 08:37:05.000000000 -0800
+++ linux-2.6.git-dave/fs/file.c	2009-03-05 08:37:05.000000000 -0800
@@ -290,6 +290,9 @@ static void __scan_files_for_cr(struct f
 {
 	int i;
 
+	if (!cr_enabled())
+		return;
+
 	for (i = 0; i < files->fdtab.max_fds; i++) {
 		struct file *f = fcheck_files(files, i);
 		if (!f)
_
