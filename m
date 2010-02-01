Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0BAAFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:05:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58939 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0BAAFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:05:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 1 Feb 2010 09:01:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, vedran.furac@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100201090140.116cc704.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
	<20100129162137.79b2a6d4@lxorguk.ukuu.org.uk>
	<c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
	<20100129163030.1109ce78@lxorguk.ukuu.org.uk>
	<5a0e6098f900aa36993b2b7f2320f927.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 13:07:01 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Sat, 30 Jan 2010, KAMEZAWA Hiroyuki wrote:
> 
> > okay...I guess the cause of the problem Vedran met came from
> > this calculation.
> > ==
> >  109         /*
> >  110          * Processes which fork a lot of child processes are likely
> >  111          * a good choice. We add half the vmsize of the children if they
> >  112          * have an own mm. This prevents forking servers to flood the
> >  113          * machine with an endless amount of children. In case a single
> >  114          * child is eating the vast majority of memory, adding only half
> >  115          * to the parents will make the child our kill candidate of
> > choice.
> >  116          */
> >  117         list_for_each_entry(child, &p->children, sibling) {
> >  118                 task_lock(child);
> >  119                 if (child->mm != mm && child->mm)
> >  120                         points += child->mm->total_vm/2 + 1;
> >  121                 task_unlock(child);
> >  122         }
> >  123
> > ==
> > This makes task launcher(the fist child of some daemon.) first victim.
> 
> That "victim", p, is passed to oom_kill_process() which does this:
> 
> 	/* Try to kill a child first */
> 	list_for_each_entry(c, &p->children, sibling) {
> 		if (c->mm == p->mm)
> 			continue;
> 		if (!oom_kill_task(c))
> 			return 0;
> 	}
> 	return oom_kill_task(p);
> 

Then, finally, per-process oom_adj(!=OOM_DISABLE) control is ignored ?
Seems broken.

I think all this children-parent logic is bad.

Thanks,
-Kame



