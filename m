Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbXGFJqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbXGFJqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXGFJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:46:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbXGFJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:45:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 11:53:03 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org> <1183712354.3388.126.camel@localhost.localdomain> <200707061131.08475.oliver@neukum.org>
In-Reply-To: <200707061131.08475.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061153.05091.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 11:31, Oliver Neukum wrote:
> Am Freitag, 6. Juli 2007 schrieb Benjamin Herrenschmidt:
> > On Fri, 2007-07-06 at 09:13 +0200, Rafael J. Wysocki wrote:
> > > 
> > > The only reason (I know of) why we don't handle uninterruptible tasks in the
> > > freezer is that we're afraid of the suspend process deadlocking with an
> > > uninterruptible task holding a lock, but AFAICS the probability of such an
> > > event is extremely small.
> > 
> > What would deadlock specifically ? One of the drivers trying to acquire
> > that lock ? It would be a driver bug then.
> 
> Your driver's write method looks like:
> 
> mutex_lock();
> poke_some_hardware();
> wait_event_uninterruptible(); //for result
> res = evaluate_result();
> mutex_unlock();
> return res;
> 
> If you put a task into the refrigerator at wait_event_interruptible()
> you will deadlock if you need this lock for the driver to go to suspend.
> The suspend method then must not take the lock _and_ it must be
> aware that there may be an ongoing operation.

s/interruptible/uninterruptible/

> you will deadlock if you need this lock for the driver to go to suspend.
> The suspend method then must not take the lock _and_ it must be
> aware that there may be an ongoing operation.

Well, is there any driver in the tree that works like that _and_ has a
.suspend() method requiring the same lock?

Besides, I'm not going to put the task into the refrigerator at that point.

Please read http://lkml.org/lkml/2007/7/6/71

Moreover, I claim that, in the context of your example, _if_ the task is stuck
at the wait_event_uninterruptible(), _then_ the freezerless suspend will
deadlock with the task.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
