Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYFZKkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYFZKkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYFZKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:40:01 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46810 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYFZKkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:40:00 -0400
Date: Thu, 26 Jun 2008 13:37:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [2.6.26 patch] #error for gcc 4.1.{0,1}
Message-ID: <20080626103751.GA30359@cs181140183.pp.htv.fi>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:27:26PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Andrew Morton wrote:
> > > 
> > > I see only the following choices:
> > > - remove __weak and replace all current usages
> > > - move all __weak functions into own files, and ensure that also happens
> > >   for future usages
> > > - #error for gcc 4.1.{0,1}
> > 
> > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> 
> It's __GNUC_PATCHLEVEL__, I believe.
> 
> So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> (bad, and rather uncommon).
> 
> And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> begin with, I think it's better to just not support it.

Some talk and one and a half months later we still don't abort the build 
for these gcc version.

If anyone has a better patch please step forward - otherwise I'd propose 
the patch below.

> 			Linus

cu
Adrian


<--  snip  -->


gcc 4.1.0 and 4.1.1 are known to miscompile the kernel:
  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781

Usage of weak functions has become a common pattern in the kernel, and 
usages get added in each kernel version increasing the probability of 
bugs with each kernel release.

This miscompilation of weak functions can result in subtle runtime 
errors.

#error for gcc 4.1.0 and 4.1.1 to prevent users from running into
this bug.

Note:
We already printed a #warning for gcc 4.1.0 due to a different bug.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ee78871a1d85fe60958748c208389adb4031fefe diff --git a/init/main.c b/init/main.c
index f7fb200..bede344 100644
--- a/init/main.c
+++ b/init/main.c
@@ -76,8 +76,9 @@
  * trouble.
  */
 
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
-#warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
+/*  due to http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781  */
+#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && (__GNUC_PATCHLEVEL__ == 0 || __GNUC_PATCHLEVEL__ == 1)
+#error gcc 4.1.0 and 4.1.1 are known to miscompile the kernel.
 #endif
 
 static int kernel_init(void *);

