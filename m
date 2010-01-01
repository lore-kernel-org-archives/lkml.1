Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059Ab0AAPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0AAPKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990Ab0AAPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:10:37 -0500
Received: from www84.your-server.de ([213.133.104.84]:52845 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0AAPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:10:36 -0500
Subject: Re: [PATCH] proc: revert to show stack information in
 /proc/{pid}/status
From: Stefani Seibold <stefani@seibold.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jan 2010 16:10:16 +0100
Message-ID: <1262358616.11460.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 01.01.2010, 23:14 +0900 schrieb KOSAKI Motohiro:
> > Am Donnerstag, den 31.12.2009, 23:12 +0900 schrieb KOSAKI Motohiro:
> > > Commit d899bf7b (procfs: provide stack information for threads) introduced
> > > to show stack information in /proc/{pid}/status. But it cause large performance
> > > regression. Unfortunately /proc/{pid}/status is used ps command too and ps is
> > > one of most important component. Because both to take mmap_sem and page table walk
> > > are heavily operation.
> > > 
> > 
> > /proc/<pid>/status is IMHO not a performance relevant thing. The main
> > reason is to provide exact information about a running process.
> 
> No. You have to learn real world use case. if you think so, you should 
> change ps before submit this change. This patch obviously make harm than worth. 
> Nobody (except you) use it but everybody get regression.
> 

It is fascinating that every developer means that only his personal view
and requirements are the wisdom of the world.
   
> 
> > > Thus, this patch revert it. Fortunately /proc/{pid}/task/{tid}/smaps
> > > provide almost same information. we can use it.
> > 
> > Completely wrong. Where does smaps provides this kind of information?
> > Where is there the high water mark of the stack usage?
> 
> You have to see you patch itself. show_map_vma() isn't only used by /proc/pid/maps,
> but also be used by /proc/pid/smaps.
> 
> Now, /proc/{pid}/task/{tid}/smaps show following column.
> 
> 7fb97c181000-7fb97d1d1000 rw-p 00000000 00:00 0                          [threadstack:0084eff0]
> Size:              16704 kB
> Rss:                   8 kB
> Pss:                   8 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         8 kB
> Referenced:            8 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> 
> It descibe
>   - This vma is thread stack
>   - vma size is 16704kB
>   - stack vsz size in vma is 0x0084eff0 (~ 8508kB)
>   - and, physical memory is used 8kB.
> 

But it don't describe the usage high water mark. With the information
provided by proc/*/smaps this is not possible. It is very funny to get
complains without checking. Your assertion is completely WRONG.

> 
> Anyway, I revert the regresstion patch as other regression patches. if you really want
> this feature, you have three options.
> 
>   1. create new /proc file instead to use /proc/pid/status.

This was discarded by Andrew. He prefered the inclusion
in /proc/pid/status. 

>   2. improve performance until typical use-case don't notice regression.

Not possible.

>   3. change ps and other /proc related userland implementation and resubmit this patch.

ps works quiet well.

> 
> But even if you choose anything, You have to test both its functional and performance
> _before_ submitting kernel patch.

Teach me master! Do you think i don't know that is coast something?.
Walking through the pages coast some runtime. But ps is not a
performance critical application nor a cat /proc/*/status!

Stefani


