Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYE2Wux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYE2Wux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYE2Wup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:50:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYE2Wuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:50:44 -0400
Date: Thu, 29 May 2008 15:50:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: youquan_song@linux.intel.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 2.6.26-rc3 : schedule] remove unlikely macros in 
 workqueue.c/queue_delayed_work_on
Message-ID: <20080529155036.2b37958b@infradead.org>
In-Reply-To: <20080529132915.8caeb501.akpm@linux-foundation.org>
References: <1740.172.16.180.81.1212044570.squirrel@linux.intel.com>
	<20080529132915.8caeb501.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 13:29:15 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 29 May 2008 00:02:50 -0700 (PDT)
> youquan_song@linux.intel.com wrote:
> 
> > cpufreq_ondemand governor call queue_delayed_work_on with entry
> > parameter "cpu" every sample rate(every logical cpu during
> > 20ms).check the value of "cpu","cpu>=0" condition meeting rate is
> > over than 90%.
> > 
> > This patch remove the unlikely macros to benefit kernel schedule and
> > reader comprehension.
> > 
> > Signed-off-by: Youquan Song <youquan.song@intel.com>
> > ---
> >  workqueue.c    |    2++++++
> >  1 file changed,     1 insertions(+), 1 deletions(-)
> > 
> > --- linux-2.6/kernel/workqueue.c	2008-05-13
> > 10:10:11.000000000 -0400 +++
> > linux-2.6-new/kernel/workqueue.c	2008-05-29
> > 09:46:16.000000000 -0400 @@ -230,7 +230,7 @@ timer->data =
> > (unsigned long)dwork; timer->function = delayed_work_timer_fn;
> > 
> > -		if (unlikely(cpu >= 0))
> > +		if (cpu >= 0)
> > 			add_timer_on(timer, cpu);
> > 		else
> > 			add_timer(timer);
> > 
> 
> This is very much dependent on what workload the machine is running.
> 
> There are 189 queue_delayed_work() callsites and they all want the
> unlikely() to be there.
> 
> There are six queue_delayed_work_on() callsites and they don't want
> the unlikely().
> 
> Don't know what to do here.  Fortunately it doesn't matter much ;)
> 
> -mm has profile-likely-unlikely-macros.patch which can be used to
> instrument these things (that feature seems to get broken regularly
> though).
> 
> But the instrumentation should be performed across a broad range of
> workloads.


and on x86 it barely makes any difference at all, at best you can
handwave a little about icache footprint. 

/me ponders checking if we get a code size reduction by defining these
animals to be empty passthrough
