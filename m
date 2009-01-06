Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZAFR2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZAFR2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZAFR2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:28:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZAFR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:28:35 -0500
Date: Tue, 6 Jan 2009 12:28:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing/ftrace: handle more than one stat file per
 tracer
In-Reply-To: <20090106003035.GD6531@nowhere>
Message-ID: <alpine.DEB.1.10.0901061227280.10871@gandalf.stny.rr.com>
References: <495b9305.0405560a.0ec4.29c0@mx.google.com> <alpine.DEB.1.10.0901051546450.25066@gandalf.stny.rr.com> <20090106003035.GD6531@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Frederic Weisbecker wrote:
> > > +
> > > +	if (all_stat_sessions) {
> > > +		for (i = 0; i < nb_sessions; i++) {
> > > +			session = all_stat_sessions[i];
> > > +			reset_stat_session(session);
> > > +			mutex_destroy(&session->stat_mutex);
> > > +			kfree(session);
> > > +		}
> > > +	}
> > > +	all_stat_sessions = kmalloc(sizeof(struct tracer_stat_session *) * nb,
> > > +				    GFP_KERNEL);
> > 
> > You want this to be kzalloc.
> > 
> > > +	if (!all_stat_sessions)
> > > +		return -ENOMEM;
> > > +
> > > +	for (i = 0; i < nb; i++) {
> > > +		session = kmalloc(sizeof(struct tracer_stat_session) * nb,
> > > +				  GFP_KERNEL);
> > 
> > Not so important, but you probably want to do it here too.
> > 
> > > +		if (!session)
> > > +			goto free_sessions;
> > > +
> > > +		INIT_LIST_HEAD(&session->stat_list.list);
> > > +		mutex_init(&session->stat_mutex);
> > > +		session->ts = &ts[i];
> > > +		all_stat_sessions[i] = session;
> > > +	}
> > > +	nb_sessions = nb;
> > > +	return 0;
> > > +
> > > +free_sessions:
> > > +
> > > +	for (j = 0; j < i; j++)
> > > +		kfree(all_stat_sessions[i]);
> > 
> > With out the kzalloc above, this may crash the kernel, because
> > all_stat_sessions[i] might not be NULL when they were not initialized.
> 
> 
> I'm not sure. j will not go through indexes of rooms that weren't allocated.

Ah, OK, my eyes confused i's and j's so I did not notice the loop to last 
failed. Which is strange because I write similar code :-/.

-- Steve
