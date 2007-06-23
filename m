Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbXFWSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbXFWSEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXFWSEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:04:43 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:62793 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXFWSEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:04:43 -0400
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, hch@infradead.org, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070623095359.4667514e.akpm@linux-foundation.org>
References: <20070622182051.859570787@goodmis.org>
	 <20070622182315.571740041@goodmis.org>
	 <20070623095359.4667514e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 14:00:17 -0400
Message-Id: <1182621617.5493.136.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 09:53 -0700, Andrew Morton wrote:
> > On Fri, 22 Jun 2007 14:20:56 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > This patch replaces the tasklet implementation with a work
> > queue implementation while keeping the tasklet API.
> > The API is still the same, and the drivers don't know that a
> > work queue is being used.
> 
> I still think this sucks: we end up with a fairly pointless-looking wrapper
> API which we wouldn't have put in the kernel except for messy legacy
> editing-is-too-hard reasons.  In an ideal world, it'd be better just to get
> in and do the hard work.

If I had all the hardware that tasklets touch, I'd start doing it. (look
for more patches from me that do this for the hardware I do have :-)

> 
> Anyway.  Please fix the many correct warnings which checkpatch.pl

I'll have to add a clean up patch. A lot of the output from that came
from me moving existing code.  So I'll have to clean up the existing
code first so that checkpatch.pl doesn't complain about it.  I prefer a
patch that moves code to do nothing but that, move code and not even add
clean ups to it.  So the simple solution is, add patch to clean up (will
do).

Also this:

   void tasklet_schedule(struct tasklet_struct *t)
   {
           WARN_ON_ONCE(!ktaskletd_wq);
           queue_work(ktaskletd_wq, &t->work);
   }

   EXPORT_SYMBOL(tasklet_schedule);


produces

   PATCH: tasklets-to-workqueues.patch:259:
   FILE: linux-2.6-test/kernel/tasklet_work.c:30:
   +EXPORT_SYMBOL(tasklet_schedule);


So I guess that blank line is not acceptable?
and should be:

   void tasklet_schedule(struct tasklet_struct *t)
   {
           WARN_ON_ONCE(!ktaskletd_wq);
           queue_work(ktaskletd_wq, &t->work);
   }
   EXPORT_SYMBOL(tasklet_schedule);

I'll fix that up.

> generates, reissue the patches with a decent overall changelog (this series
> had no rationale for the changes at all) and we'll see what happens.

Should I just put in the prologue from the first series, or slim it down
a bit so people don't need to read the whole thing every time? I can
just put in the stuff that's relevant and leave out the "history".

Thanks,

-- Steve


