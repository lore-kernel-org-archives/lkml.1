Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZA1IZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZA1IZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZA1IZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:25:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZA1IZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:25:09 -0500
Subject: Re: [PATCH v4] softlockup: remove hung_task_check_count
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Singh Baines <msb@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090127184851.GD22298@google.com>
References: <1232991701.4863.222.camel@laptop>
	 <20090127003055.GA21269@google.com> <20090127132626.GH23121@elte.hu>
	 <20090127184851.GD22298@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jan 2009 09:25:00 +0100
Message-Id: <1233131100.10992.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 10:48 -0800, Mandeep Singh Baines wrote:
> Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mandeep Singh Baines <msb@google.com> wrote:
> > 
> > > The design was proposed by Frédéric Weisbecker. Peter Zijlstra suggested 
> > > the use of RCU.
> > 
> > ok, this looks _much_ cleaner.
> > 
> > One question:
> > 
> > > -	read_lock(&tasklist_lock);
> > > +	rcu_read_lock();
> > >  	do_each_thread(g, t) {
> > > -		if (!--max_count)
> > > +		if (need_resched())
> > >  			goto unlock;
> > 
> > Isnt it dangerous to skip a check just because we got marked for 
> > reschedule? Since it runs so rarely it could by accident be preempted and 
> > we'd not get any checking done for a long time.
> > 
> 
> Yeah, the checking could be deferred indefinitely. So you could have a system
> where tasks are hung but it takes a really long time to detect this and
> finally panic the system. Not so good for high-availability.

Why break out at all? Are you that worried about khungtaskd introducing
latencies? Is using preemptible RCU an option for you?

