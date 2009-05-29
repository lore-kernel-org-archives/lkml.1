Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbZE2Nt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbZE2Nt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZE2NtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:49:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36863 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZE2NtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:49:21 -0400
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090529123504.GA32299@elte.hu>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	 <1243584388.23657.156.camel@twins> <1243584793.23657.168.camel@twins>
	 <1243585721.23657.177.camel@twins> <20090529085916.GA21461@elte.hu>
	 <20090529091608.GA15278@elte.hu>  <20090529123504.GA32299@elte.hu>
Date: Fri, 29 May 2009 16:49:21 +0300
Message-Id: <1243604961.28651.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, 2009-05-29 at 14:35 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > try the latest Git repo (i tried 95110d7) and do this:
> > 
> >   make clean
> >   perf stat -- make -j
> > 
> > that locks up for me, very quickly, with permanently stuck tasks:
> > 
> >    PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM   TIME    COMMAND        
> >  10748 mingo     20   0     0    0    0 R 100.4  0.0   0:06.44 chmod         
> >  10756 mingo     20   0     0    0    0 R 100.4  0.0   0:06.43 touch         
> > 
> > looping in the remove-context retry loop.
> 
> ok, after muchos debugging and tracing this turned out to be the 
> perf_counter_task_exit() in kernel/fork.c, in the fork() failure 
> path. That zapped the task ctx in cpuctx and caused the next 
> schedule (which is rare) to not schedule the real context out. Then, 
> when the task was scheduled back in again later, we scheduled in 
> already active counters. Much mayhem followed and the lockup was a 
> common incarnation of that. I pushed out a couple of fixes for this.
> 
> Pekka, the symptoms appear to match your 'stuck Xorg while make -j' 
> symptoms pretty accurately - so if you try latest perfcounters/core 
> it might solve some of those problems as well.

Yup, works much better here. Thanks!

Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka

