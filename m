Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZDMTS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZDMTS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZDMTSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:18:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZDMTSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:18:48 -0400
Date: Mon, 13 Apr 2009 21:14:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090413191406.GA12759@redhat.com>
References: <20090413181733.GA10424@redhat.com> <1239649429.16771.9.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239649429.16771.9.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Trond Myklebust wrote:
>
> On Mon, 2009-04-13 at 20:17 +0200, Oleg Nesterov wrote:
> > slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
> > this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
> > all kslowd threads. Afaics this is not what we want, change slow_work_thread()
> > to use prepare_to_wait_exclusive().
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > 
> > --- 6.30/kernel/slow-work.c~1_SW_EXCLUSIVE	2009-04-06 00:03:42.000000000 +0200
> > +++ 6.30/kernel/slow-work.c	2009-04-13 19:40:20.000000000 +0200
> > @@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
> >  		vsmax *= atomic_read(&slow_work_thread_count);
> >  		vsmax /= 100;
> >  
> > -		prepare_to_wait(&slow_work_thread_wq, &wait,
> > -				TASK_INTERRUPTIBLE);
> > +		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
> > +						TASK_INTERRUPTIBLE);
> >  		if (!freezing(current) &&
> >  		    !slow_work_threads_should_exit &&
> >  		    !slow_work_available(vsmax) &&
> > 
> 
> Should that really be TASK_INTERRUPTIBLE? I don't see anything obvious
> in the enclosing for(;;) loop that checks for or handles signals...

I guess TASK_INTERRUPTIBLE was chosen to not contribute to calc_load(),
nr_active() returns nr_running + nr_uninterruptible.

Oleg.

