Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYIPVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYIPVY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYIPVYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:24:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:43333 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIPVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=ZOce1Aj0QQY8vlzVeCBVlt2ToIGde2/qum1LgUkjJTFRlFGS7hoN+ytwvqplvCvq4b
         81DhcEpWUjZC4/qTVAsu996WLK97D8jTfcm8CWYM4J0xxdEadUio6a1VveTC7cEeoEvT
         Bk2zv0oxN/1w6inkIdNf2h9QfYMZ1C+Z7ijbQ=
Date: Wed, 17 Sep 2008 00:24:44 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 5/7] mmiotrace: handle TRACE_PRINT entries.
Message-ID: <20080917002444.4dd5a49f@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0809161609520.7650@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
	<20080916220227.4db173f5@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809161609520.7650@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 16:11:20 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 16 Sep 2008, Pekka Paalanen wrote:
> 
> > From 6a458e250857907e16cb16799392fccbfd5f0f4a Mon Sep 17 00:00:00 2001
> > From: Pekka Paalanen <pq@iki.fi>
> > Date: Sun, 17 Aug 2008 18:15:13 +0300
> > Subject: [PATCH] mmiotrace: handle TRACE_PRINT entries.
> > 
> > Also make trace_seq_print_cont() non-static, and add a newline if the
> > seq buffer can't hold all data.
> > 
> > Signed-off-by: Pekka Paalanen <pq@iki.fi>
> > ---
> >  kernel/trace/trace.c           |   31 +++++++++++--------------------
> >  kernel/trace/trace.h           |   19 +++++++++++++++++++
> >  kernel/trace/trace_mmiotrace.c |   23 +++++++++++++++++++++++
> >  3 files changed, 53 insertions(+), 20 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 406de9c..7e7154f 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
...
> > @@ -1517,12 +1500,16 @@ lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
> >  
> >  static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
> >  
> > -static void
> > -trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> > +/*
> > + * The message is supposed to contain an ending newline.
> > + * If the printing stops prematurely, try to add a newline of our own.
> > + */
> > +void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> >  {
> >  	struct trace_array *tr = iter->tr;
> >  	struct trace_array_cpu *data = tr->data[iter->cpu];
> >  	struct trace_entry *ent;
> > +	bool ok = true;
> 
> hmm, since when did the kernel have type bool?

Good question. It seems to be used a lot. :-)

commit 6e21828743247270d09a86756a0c11702500dbfb
Author: Richard Knutsson <ricknu-0@student.ltu.se>
Date:   Sat Sep 30 23:27:11 2006 -0700

    [PATCH] Generic boolean
    
    This patch defines:
    * a generic boolean-type, named 'bool'
    * aliases to 0 and 1, named 'false' and 'true'
    
    Removing colliding definitions of 'bool', 'false' and 'true'.
    
    Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

-- 
Pekka Paalanen
http://www.iki.fi/pq/
