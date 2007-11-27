Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbXK0Eyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbXK0Eyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXK0Eyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:54:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbXK0Eyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:54:39 -0500
Date: Mon, 26 Nov 2007 20:54:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: [PATCH 1/1] mm: add dirty_highmem option
Message-Id: <20071126205428.c264ccff.akpm@linux-foundation.org>
In-Reply-To: <20071122034204.GA14079@brong.net>
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	<20071115052538.GA21522@brong.net>
	<alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	<20071115115049.GA8297@brong.net>
	<alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	<1195155601.22457.25.camel@lappy>
	<1195159457.22457.35.camel@lappy>
	<alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
	<20071122034204.GA14079@brong.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 14:42:04 +1100 Bron Gondwana <brong@fastmail.fm> wrote:

>  /*
> + * free highmem will not be subtracted from the total free memory
> + * for calculating free ratios if vm_dirty_highmem is true
> + */
> +int vm_dirty_highmem;

One would expect that setting dirty_highmem to true would cause highmem to
be accounted in dirty-memory calculations.  However with this change
reality is in fact the inverse of that.

So how about this?

 Documentation/filesystems/proc.txt |    4 ++--
 mm/page-writeback.c                |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1265,8 +1265,8 @@ Contains, as a boolean, a switch to allo
 part of the "available" memory against which the dirty ratios will be
 applied.
 
-Setting this to 1 can be useful on 32 bit machines where you want to make
-random changes within an MMAPed file that is larger than your available
+Setting this to 0 (false) can be useful on 32 bit machines where you wish to
+make random changes within an MMAPed file that is larger than your available
 lowmem, however it is potentially dangerous and has serious bounce-buffer
 issues.
 
diff -puN mm/page-writeback.c~mm-add-dirty_highmem-option-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-add-dirty_highmem-option-fix
+++ a/mm/page-writeback.c
@@ -69,10 +69,10 @@ static inline long sync_writeback_pages(
 int dirty_background_ratio = 5;
 
 /*
- * free highmem will not be subtracted from the total free memory
- * for calculating free ratios if vm_dirty_highmem is true
+ * free highmem will be subtracted from the total free memory for calculating
+ * free ratios if vm_dirty_highmem is true
  */
-int vm_dirty_highmem;
+int vm_dirty_highmem = 1;
 
 /*
  * The generator of dirty data starts writeback at this percentage
@@ -293,7 +293,7 @@ static unsigned long determine_dirtyable
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	if (!vm_dirty_highmem)
+	if (vm_dirty_highmem)
 		x -= highmem_dirtyable_memory(x);
 	return x + 1;	/* Ensure that we never return 0 */
 }
_




(I dropped the already-merged part of your patch)

(I fixed a build error in kernel/sysctl.c: "one" was defined twice when
suitable config options were set).

(It's an unpleasing patch, btw.  But it's an unpleasant problem and at least
this way people can tell us "hey, I did <this> and it started to work")
