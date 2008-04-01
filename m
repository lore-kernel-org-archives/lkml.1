Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYDAI6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYDAI6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYDAI5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:57:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYDAI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:57:53 -0400
Date: Tue, 1 Apr 2008 01:55:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Message-Id: <20080401015555.f267d970.akpm@linux-foundation.org>
In-Reply-To: <20080401084214.GY7279@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
	<20080320130356.69ab65fe.akpm@linux-foundation.org>
	<20080325144400.GG8959@enneenne.com>
	<20080327202531.a924e5d9.akpm@linux-foundation.org>
	<20080401084214.GY7279@enneenne.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 10:42:14 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Thu, Mar 27, 2008 at 08:25:31PM -0700, Andrew Morton wrote:
> > On Tue, 25 Mar 2008 15:44:00 +0100 Rodolfo Giometti <giometti@enneenne.com> wrote:
> > > > 
> > > > As it stands, there might be deadlocks such as when a process which itself
> > > > holds a ref on the pps_device (with an open fd?) calls
> > > > pps_unregister_source.
> > > 
> > > I can add a wait_event_interruptible in order to allow userland to
> > > continue by receiving a signal. It could be acceptable?
> > 
> > There should be no need to "wait" for anything.  When the final reference
> > to an object is released, that object is cleaned up.  Just like we do for
> > inodes, dentries, pages, files, and 100 other kernel objects.
> > 
> > The need to wait for something else to go away is a big red flag with
> > "busted refcounting" written on it.
> > 
> > > > Also, we need to take care that all processes which were waiting in
> > > > pps_unregister_source() get to finish their cleanup before we permit rmmod
> > > > to proceed.  Is that handled somewhere?
> > > 
> > > I don't understand the problem... this code as been added in order to
> > > avoid the case where a pps_event() is called while a process executes
> > > the pps_unregister_source(). If more processes try to execute this
> > > code the first which enters will execute idr_remove() which prevents
> > > another process to reach the wait_event()... is that wrong? =:-o
> > 
> > I was asking you!
> > 
> > We should get the reference counting and object lifetimes sorted out first. 
> > There should be no "wait for <object> to be released" code.  Once that is
> > in place, things like rmmod will also sort themselves out: it just won't be
> > possible to remove the module while there are live references to objects.
> 
> The problem is related to serial and parallel clients.
> 
> The PPS source related to a serial port (or a parallel one) uses the
> serial (or parallel) IRQ to get PPS timestamps and it could be
> possible that a process tries to close the PPS source while another
> CPU is runnig the serial IRQ, so I cannot remove the PPS object until
> the IRQ handler is finished its job on the PPS object.
> 
> For clients (currently none :) which define their own IRQ handler for
> PPS timestamps managing the problem doesn't arise at all.

This can all be handled with suitable locking and refcounting.  The device
which is delivering PPS interrupts has a reference on the PPS data
structures.  If userspace has PPS open then it also has a reference.

The thread of control which releases the last reference to the PPS data
structures also frees them all up.  This may require a schedule_work() if
we need to support release-from-interrupt (as it appears that we do), but
that's OK - we just need to be able to make the PPS data structures
ineligible for new lookups while the schedule_work() is pending.

There should be no need for any thread of control to wait for any other thread
of control to do anything.  Get the refcounting right and everything
can be done synchronously.
