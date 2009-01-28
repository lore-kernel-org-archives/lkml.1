Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZA1XI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZA1XI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA1XIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:08:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:64901 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZA1XIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Do4R+WwooWCpEXJMS5jg30JX3KkfhLRYnqOHMqQs5xUVVOpyc4Qz/7LQtMNtCzIdGO
         ST5YaD+3A09X8kv3P3UEnY4CGeVmS0YR0nEaumXc2ohDF1kEm9lnow4wkcliu8Zhbb8X
         QUalFTVJ5klwlb4ICZOBUj1zXee9yN34YWpSc=
Date: Thu, 29 Jan 2009 00:08:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-input@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] psmouse: run kpsmoused only while needed
Message-ID: <20090128230837.GA7631@nowhere>
References: <496fd1d3.0d135e0a.171b.43ea@mx.google.com> <20090126143210.ce6a4503.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126143210.ce6a4503.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 02:32:10PM -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2009 16:16:19 -0800 (PST)
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > While looking at the workqueue tracer, I noticed that kpsmoused receives
> > rarely (if not never) events.
> > 
> > Currently, when a mouse has to resync, it uses the kpsmoused singlethreaded
> > workqueue. But recync are rare. While reading an old discussion, it seems
> > that usual workqueue events can't be used for that purpose because resync
> > can take too much time and could delay the other works in queue.
> > 
> > But if you have built psmouse driver, this workqueue will always be present
> > whether you have a ps/2 port or not. And its events are rare.
> > 
> > To avoid this pointless task, this patch makes the kpsmoused a kernel
> > thread only created on the fly when a recync is needed. Once the recync is done,
> > this thread will die. So you will almost never see it, and it will not be
> > an inactive task anymore.
> > 
> > This thread is created through a usual workqueue event (because we can't create
> > it from interrupt).
> > 
> 
> Seems like a reasonable objective.
> 
> >
> > ...
> >
> >  /*
> >   * __psmouse_set_state() sets new psmouse state and resets all flags.
> > @@ -313,7 +307,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
> >  		       psmouse->name, psmouse->phys, psmouse->pktcnt);
> >  		psmouse->badbyte = psmouse->packet[0];
> >  		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
> > -		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
> > +		atomic_inc(&psmouse->nb_recync_pending);
> 
> The patch and the changelog consistently misspell "sync".
> 
> A code comment (in psmouse.h) which clearly spells out the role of
> nb_recync_pending would be useful.
> 
> > +		schedule_work(&psmouse->resync_work);
> >  		goto out;
> >  	}
> >  
> >
> > ...
> >
> > @@ -1131,7 +1155,13 @@ static void psmouse_disconnect(struct serio *serio)
> >  
> >  	/* make sure we don't have a resync in progress */
> >  	mutex_unlock(&psmouse_mutex);
> > -	flush_workqueue(kpsmoused_wq);
> > +
> > +	prepare_to_wait(&psmouse->recync_pending_queue, &wait,
> > +				TASK_UNINTERRUPTIBLE);
> > +	if (atomic_read(&psmouse->nb_recync_pending))
> > +		schedule();
> > +	finish_wait(&psmouse->recync_pending_queue, &wait);
> 
> So... we're requiring that nb_recync_pending is zero at this stage?
> 
> I wonder if the code manages to do that.  A little WARN_ON(), maybe?
> 
> >  	mutex_lock(&psmouse_mutex);
> >  
> 

After reading how work the async jobs (kernel/async.c), I think it would be better
to actually use it instead of creating a thread through a workqueue and wait for a
counter to be zero to be sure all is flushed.

The async functions provide local execution and synchronisation domains through special cookies,
which means long tasks of mouse resync will not starve other works.

What do you think about it?

