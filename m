Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZKSS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZKSS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZKSS4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:56:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZKSS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:56:33 -0500
Date: Thu, 19 Nov 2009 10:54:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Haley <aph@redhat.com>
cc: Richard Guenther <richard.guenther@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>   <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>   <20091119072040.GA23579@elte.hu>   <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>  
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>   <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>   <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>   <1258653562.22249.682.camel@gandalf.stny.rr.com>
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Nov 2009, Linus Torvalds wrote:
> 
> I bet other people than just the kernel use the mcount hook for subtler 
> things than just doing profiles. And even if they don't, the quoted code 
> generation is just crazy _crap_.

For the kernel, if the only case is that timer_stat.c thing that Thomas 
pointed at, I guess we can at least work around it with something like the 
appended. The kernel code is certainly ugly too, no question about that. 

It's just that we'd like to be able to depend on mcount code generation 
not being insane even in the presense of ugly code..

The alternative would be to have some warning when this happens, so that 
we can at least see it. "mcount won't work reliably"

		Linus

---
 kernel/time/timer_stats.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index ee5681f..488c7b8 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -76,7 +76,7 @@ struct entry {
 	 */
 	char			comm[TASK_COMM_LEN + 1];
 
-} ____cacheline_aligned_in_smp;
+};
 
 /*
  * Spinlock protecting the tables - not taken during lookup:
@@ -114,7 +114,7 @@ static ktime_t time_start, time_stop;
 #define MAX_ENTRIES		(1UL << MAX_ENTRIES_BITS)
 
 static unsigned long nr_entries;
-static struct entry entries[MAX_ENTRIES];
+static struct entry entries[MAX_ENTRIES] ____cacheline_aligned_in_smp;
 
 static atomic_t overflow_count;
 
