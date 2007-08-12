Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXHLF3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXHLF3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXHLF3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:29:23 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38061 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751059AbXHLF3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:29:22 -0400
Message-ID: <386896556.06040@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 12 Aug 2007 13:29:15 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812052915.GA6769@mail.ustc.edu.cn>
Mail-Followup-To: Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070811132131.GA13775@mail.ustc.edu.cn> <20070811141714.GA7232@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811141714.GA7232@cvg>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 06:17:14PM +0400, Cyrill Gorcunov wrote:
> [Fengguang Wu - Sat, Aug 11, 2007 at 09:21:31PM +0800]
> | Andrew,
> | 
> | I'm not sure if this patch is the right fix for the bug.  But it do
> | stops the oops message. The bug also happens in 2.6.23-rc1-mm2/2.6.23-rc2-mm2.
> | I'm running debian/sid. The .config is attached.
> | 
> |
> 
> [...snip...]
> 
> Even if you're right you have to make the same patch for
> mm/nommu.c but I've an anticipation the problem is growing
> up from another point (and I'm really hoping that I'm wrong ;)

Thank you, the patch is updated to:
===

Fix possible NULL pointer deference on __vm_enough_memory().

Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/mmap.c  |    3 ++-
 mm/nommu.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/mm/mmap.c
+++ linux-2.6.23-rc2-mm2/mm/mmap.c
@@ -166,7 +166,8 @@ int __vm_enough_memory(long pages, int c
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (current->mm)
+		allowed -= current->mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
--- linux-2.6.23-rc2-mm2.orig/mm/nommu.c
+++ linux-2.6.23-rc2-mm2/mm/nommu.c
@@ -1342,7 +1342,8 @@ int __vm_enough_memory(long pages, int c
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (current->mm)
+		allowed -= current->mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space

