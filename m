Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbXDML0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbXDML0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXDML0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:26:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:40364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXDML0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:26:07 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Christopher S. Aker" <caker@theshore.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
	<p73ps697agf.fsf@bingen.suse.de> <461EE95A.3090600@theshore.net>
	<20070412193838.ea98238b.randy.dunlap@oracle.com>
	<461EF1A1.3070102@theshore.net>
	<20070413115526.69e61016@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Apr 2007 14:23:51 +0200
In-Reply-To: <20070413115526.69e61016@the-village.bc.nu>
Message-ID: <p73d528799k.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> > I saw that too, and unfortunately I don't know what what that condition 
> > represents, either.  It's the only other element in that if statement 
> > that could make it take that path, so I'm assuming that's part of the 
> > problem.
> 
> Multiple mm's mean multiple threads with a different set of mappings,
> which would fit for UML. Either way there should be a check for !pipe
> before appending the pid

Here's a patch. It just doesn't do any formatting for the pipe case.

-Andi

Fix core to pipe for multithreaded processes

I also removed the BKL around format_corename because it seems unneeded.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.21-rc3-test/fs/exec.c
===================================================================
--- linux-2.6.21-rc3-test.orig/fs/exec.c
+++ linux-2.6.21-rc3-test/fs/exec.c
@@ -1501,9 +1501,6 @@ int do_coredump(long signr, int exit_cod
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
 	 */
- 	lock_kernel();
-	format_corename(corename, core_pattern, signr);
-	unlock_kernel();
  	if (corename[0] == '|') {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
@@ -1512,10 +1509,12 @@ int do_coredump(long signr, int exit_cod
  			goto fail_unlock;
  		}
 		ispipe = 1;
- 	} else
+ 	} else {
+		format_corename(corename, core_pattern, signr);
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
+	}
 	if (IS_ERR(file))
 		goto fail_unlock;
 	inode = file->f_path.dentry->d_inode;
