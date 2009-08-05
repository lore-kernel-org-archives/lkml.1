Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZHEXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZHEXkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZHEXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:40:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbZHEXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:40:37 -0400
Date: Wed, 5 Aug 2009 16:39:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH for 2.6.31 0/4] fix oom_adj regression v2
Message-Id: <20090805163945.056c463c.akpm@linux-foundation.org>
In-Reply-To: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Aug 2009 19:25:08 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> The commit 2ff05b2b (oom: move oom_adj value) move oom_adj value to mm_struct.
> It is very good first step for sanitize OOM.
> 
> However Paul Menage reported the commit makes regression to his job scheduler.
> Current OOM logic can kill OOM_DISABLED process.
> 
> Why? His program has the code of similar to the following.
> 
> 	...
> 	set_oom_adj(OOM_DISABLE); /* The job scheduler never killed by oom */
> 	...
> 	if (vfork() == 0) {
> 		set_oom_adj(0); /* Invoked child can be killed */
> 		execve("foo-bar-cmd")
> 	}
> 	....
> 
> vfork() parent and child are shared the same mm_struct. then above set_oom_adj(0) doesn't
> only change oom_adj for vfork() child, it's also change oom_adj for vfork() parent.
> Then, vfork() parent (job scheduler) lost OOM immune and it was killed.
> 
> Actually, fork-setting-exec idiom is very frequently used in userland program. We must
> not break this assumption.
> 
> This patch series are slightly big, but we must fix any regression soon.
> 

So I merged these but I have a feeling that this isn't the last I'll be
hearing on the topic ;)

Given the amount of churn, the amount of discussion and the size of the
patches, this doesn't look like something we should push into 2.6.31.  

If we think that the 2ff05b2b regression is sufficiently serious to be
a must-fix for 2.6.31 then can we please find something safer and
smaller?  Like reverting 2ff05b2b?


These patches clash with the controversial
mm-introduce-proc-pid-oom_adj_child.patch, so I've disabled that patch
now.

