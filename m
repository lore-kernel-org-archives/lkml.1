Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbZD0UGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbZD0UGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZD0UGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:06:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55397 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbZD0UGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:06:40 -0400
Subject: Re: [PATCH] Display 0 in meminfo for Committed_AS when value
	underflows
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebmunson@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, cl@linux-foundation.org
In-Reply-To: <20090427125208.94730dd8.akpm@linux-foundation.org>
References: <1240848620-16751-1-git-send-email-ebmunson@us.ibm.com>
	 <1240848914.29485.52.camel@nimitz>
	 <20090427125208.94730dd8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 13:06:35 -0700
Message-Id: <1240862795.29485.64.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 12:52 -0700, Andrew Morton wrote:
> On Mon, 27 Apr 2009 09:15:14 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > On Mon, 2009-04-27 at 17:10 +0100, Eric B Munson wrote:
> > > Splitting this patch from the chunk that addresses the cause of the underflow
> > > because the solution still requires some discussion.
> > > 
> > > Dave Hansen reported that under certain cirumstances the Committed_AS value
> > > can underflow which causes extremely large numbers to be displayed in
> > > meminfo.  This patch adds an underflow check to meminfo_proc_show() for the
> > > Committed_AS value.  Most fields in /proc/meminfo already have an underflow
> > > check, this brings Committed_AS into line.
> > 
> > Yeah, this is the right fix for now until we can iron out the base
> > issues.  Eric, I think this may also be a candidate for -stable.
> > 
> > Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> I cannot find Eric's original patch anywhere.  Did some demented MTA munch it?

Here's the version that I got.  My guess would be that your copy is
sitting in some IBM mail server's queue right now.  It might show up in
a couple of days. :)

---

Andrew,

Please merge the following patch.

Splitting this patch from the chunk that addresses the cause of the underflow
because the solution still requires some discussion.

Dave Hansen reported that under certain cirumstances the Committed_AS value
can underflow which causes extremely large numbers to be displayed in
meminfo.  This patch adds an underflow check to meminfo_proc_show() for the
Committed_AS value.  Most fields in /proc/meminfo already have an underflow
check, this brings Committed_AS into line.

Reported-by: Dave Hansen <dave@linux.vnet.ibm.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 fs/proc/meminfo.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 74ea974..facb9fb 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -22,7 +22,7 @@ void __attribute__((weak)) arch_report_meminfo(struct seq_file *m)
 static int meminfo_proc_show(struct seq_file *m, void *v)
 {
 	struct sysinfo i;
-	unsigned long committed;
+	long committed;
 	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
@@ -36,6 +36,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = atomic_long_read(&vm_committed_space);
+	if (committed < 0)
+		committed = 0;
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;

-- 
1.6.1.2


-- Dave

