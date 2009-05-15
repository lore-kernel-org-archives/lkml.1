Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZEORiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZEORiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZEORiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:38:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZEORiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:38:15 -0400
Subject: Re: perf counter issue -
 WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@in.ibm.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1242404001.32543.100.camel@laptop>
References: <20090513165433.GD16373@in.ibm.com>
	 <20090513165724.GA32707@in.ibm.com> <20090515135604.GC16389@elte.hu>
	 <20090515145144.GD13664@ghostprotocols.net>
	 <20090515155807.GA25957@in.ibm.com>  <1242404001.32543.100.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 May 2009 19:37:53 +0200
Message-Id: <1242409073.32543.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 18:13 +0200, Peter Zijlstra wrote:
> On Fri, 2009-05-15 at 21:28 +0530, Srivatsa Vaddagiri wrote:
> > On Fri, May 15, 2009 at 11:51:44AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > hm, is there a reproducer perhaps? Is there some class file i could 
> > > > run with specific parameters to reproduce it?
> > > 
> > > I'll try this with some java benchmarks we have, AMQP related, lets see
> > > if I can reproduce it.
> > 
> > I tried this with SPECJbb - which I am not at liberty to distribute
> > unfortunately. I will try and recreate it with volanomark or other open
> > source benchmarks.
> 
> I could indeed reproduce with vmark. Am poking at it.. still clueless
> though ;-)

[root@opteron tmp]# cat foo.c
#include <pthread.h>
#include <unistd.h>

void *thread(void *arg)
{
        sleep(5);
        return NULL;
}

void main(void)
{
        pthread_t thr;
        pthread_create(&thr, NULL, thread, NULL);
}

The above instantly triggers it. It appears we fail to cleanup on the
reparent path. I'll go root around in exit.c.

