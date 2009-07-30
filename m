Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZG3KEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZG3KEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZG3KEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:04:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39366 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZG3KEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:04:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Jul 2009 19:02:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Message-Id: <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
	<20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 02:31:04 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 30 Jul 2009, KAMEZAWA Hiroyuki wrote:
> 
> > 1. IIUC, the name is strange.
> > 
> > At job scheduler, which does this.
> > 
> > if (vfork() == 0) {
> > 	/* do some job */
> > 	execve(.....)
> > }
> > 
> > Then, when oom_adj_child can be effective is after execve().
> > IIUC, the _child_ means a process created by vfork().
> > 
> 
> It's certainly a difficult thing to name and I don't claim that "child" is 
> completely accurate since, as you said, vfork'd tasks are also children 
> of the parent yet they share the same oom_adj value since it's an 
> attribute of the shared mm.
> 
> If you have suggestions for a better name, I'd happily ack it.
> 

Simply, reset_oom_adj_at_new_mm_context or some.

> > 2. More simple plan is like this, IIUC.
> > 
> >   fix oom-killer's select_bad_process() not to be in deadlock.
> > 
> 
> Alternate ideas?
> 
At brief thiking.

1. move oom_adj from mm_struct to signal struct. or somewhere.
   (see copy_signal())
   Then,
    - all threads in a process will have the same oom_adj.
    - vfork()'ed thread will inherit its parent's oom_adj.   
    - vfork()'ed thread can override oom_adj of its own.

    In other words, oom_adj is shared when CLONE_PARENT is not set.

2. rename  mm_struct's oom_adj as shadow_oom_adj.

   update this shadow_oom_adj as the highest oom_adj among
   the values all threads share this mm_struct have.
   This update is done when
   - mm_init()
   - oom_adj is written.

   User's 
   # echo XXXX > /proc/<x>/oom_adj
   is not necessary to be very very fast.

   I don't think a process which calls vfork() is multi-threaded.

3. use shadow_oom_adj in select_bad_process().



> > rather than this new stupid interface.
> > 
> 
> Well, thank you.  Regardless of whether you think it's stupid or not, it 
> doesn't allow you to livelock the kernel in a very trivial way when the 
> oom killer gets invoked prior to execve() and the parent is OOM_DISABLE.
> 


just plz consider more.

Thanks,
-Kame

