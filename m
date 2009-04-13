Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZDMW71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZDMW71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDMW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:59:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbZDMW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:59:07 -0400
Date: Tue, 14 Apr 2009 00:58:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090413225846.GA817@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090413224219.GK5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413224219.GK5977@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Apr 14, 2009 at 12:36:06AM +0200, Frederic Weisbecker wrote:
> > Impact: allow filtering by lock name / fix module tracing
> > 
> > Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> > But we can't use the char * type for the name without risking to
> > dereference a freed pointer. A lock name can come from a module
> > towards lockdep and it is risky to only store its address because we
> > defer its name printing.
> > 
> > That's why this patch uses a fixed array size and copy the name.
> > Also it lets us filter the lock name because the event filtering
> > doesn't handle the char pointers. Such support is not needed yet since
> > the events don't use it for now because it is rarely easy to keep track
> > of a string while we defer its output.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/trace/lockdep_event_types.h |   13 +++++++++++--
> >  1 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
> > index 863f1e4..68f84f4 100644
> > --- a/include/trace/lockdep_event_types.h
> > +++ b/include/trace/lockdep_event_types.h
> > @@ -32,18 +32,27 @@ TRACE_FORMAT(lock_contended,
> >  	TP_FMT("%s", lock->name)
> >  	);
> >  
> > +#define LOCK_NAME_SIZE	25
> 
> 
> 
> This constant may look a bit weird.
> I just started with the assumption that a full lock name
> will rarely exceed this length.
> 
> If you agree with it, I will expand the conversion of lockdep
> TRACE_FORMAT to TRACE_EVENTS with the same assumption.
> So that we will be able to use filters with locks events.

Sure.

But 25 might be on the narrow side. The names come from macros and 
we do have a few cases of particularly long sequences of: 
spin_lock(&my_subsys->my_bus->my_driver->my_hw->my_object->my_lock) 
easily spanning 25 characters. And stripping will strip away the 
most useful (final) bits of the word.

	Ingo
