Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZBCHEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZBCHEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 02:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZBCHEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 02:04:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbZBCHEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 02:04:15 -0500
Date: Mon, 2 Feb 2009 23:03:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-input@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] psmouse: run kpsmoused only while needed
Message-Id: <20090202230335.9e31c97f.akpm@linux-foundation.org>
In-Reply-To: <20090128230837.GA7631@nowhere>
References: <496fd1d3.0d135e0a.171b.43ea@mx.google.com>
	<20090126143210.ce6a4503.akpm@linux-foundation.org>
	<20090128230837.GA7631@nowhere>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 00:08:39 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > @@ -1131,7 +1155,13 @@ static void psmouse_disconnect(struct serio *serio)
> > >  
> > >  	/* make sure we don't have a resync in progress */
> > >  	mutex_unlock(&psmouse_mutex);
> > > -	flush_workqueue(kpsmoused_wq);
> > > +
> > > +	prepare_to_wait(&psmouse->recync_pending_queue, &wait,
> > > +				TASK_UNINTERRUPTIBLE);
> > > +	if (atomic_read(&psmouse->nb_recync_pending))
> > > +		schedule();
> > > +	finish_wait(&psmouse->recync_pending_queue, &wait);
> > 
> > So... we're requiring that nb_recync_pending is zero at this stage?
> > 
> > I wonder if the code manages to do that.  A little WARN_ON(), maybe?
> > 
> > >  	mutex_lock(&psmouse_mutex);
> > >  
> > 
> 
> After reading how work the async jobs (kernel/async.c), I think it would be better
> to actually use it instead of creating a thread through a workqueue and wait for a
> counter to be zero to be sure all is flushed.
> 
> The async functions provide local execution and synchronisation domains through special cookies,
> which means long tasks of mouse resync will not starve other works.
> 
> What do you think about it?

Yes, it would be better to use the async infrastructure.

If only to see how the code ends up looking - it _should_ be simpler/cleaner
than the open-coded implementation.  If it isn't, we should ask the async code
"why not?".
