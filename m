Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526Ab0AEErU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0AEErU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306Ab0AEErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:47:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39739 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0AEErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:47:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Jan 2010 13:43:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 13:29:40 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi, Kame.
> 
> On Tue, Jan 5, 2010 at 9:25 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 04 Jan 2010 19:24:35 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >> Generic speculative fault handler, tries to service a pagefault
> >> without holding mmap_sem.
> >>
> >> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> >
> > I'm sorry if I miss something...how does this patch series avoid
> > that vma is removed while __do_fault()->vma->vm_ops->fault() is called ?
> > ("vma is removed" means all other things as freeing file struct etc..)
> 
> Isn't it protected by get_file and iget?
> Am I miss something?
> 
Only kmem_cache_free() part of following code is modified by the patch.

==
 229 static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 230 {
 231         struct vm_area_struct *next = vma->vm_next;
 232 
 233         might_sleep();
 234         if (vma->vm_ops && vma->vm_ops->close)
 235                 vma->vm_ops->close(vma);
 236         if (vma->vm_file) {
 237                 fput(vma->vm_file);
 238                 if (vma->vm_flags & VM_EXECUTABLE)
 239                         removed_exe_file_vma(vma->vm_mm);
 240         }
 241         mpol_put(vma_policy(vma));
 242         kmem_cache_free(vm_area_cachep, vma);
 243         return next;
 244 }
==

Then, fput() can be called. The whole above code should be delayd until RCU
glace period if we use RCU here.

Then, my patch dropped speculative trial of page fault and did synchronous
job here. I'm still considering how to insert some barrier to delay calling
remove_vma() until all page fault goes. One idea was reference count but
it was said not-enough crazy.


Thanks,
-Kame

