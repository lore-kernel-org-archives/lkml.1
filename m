Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZFXAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZFXAIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZFXAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:08:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZFXAII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:08:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 3)
Date: Wed, 24 Jun 2009 02:08:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906231303390.3209-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906231303390.3209-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906240208.23482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Alan Stern wrote:
> On Tue, 23 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > Below is a new revision of the patch introducing the run-time PM framework.
> > 
> > The most visible changes from the last version:
> > 
> > * I realized that if child_count is atomic, we can drop the parent locking from
> >   all of the functions, so I did that.
> > 
> > * Introduced pm_runtime_put() that decrements the resume counter and queues
> >   up an idle notification if the counter went down to 0 (and wasn't 0 previously).
> >   Using asynchronous notification makes it possible to call pm_runtime_put()
> >   from interrupt context, if necessary.
> > 
> > * Changed the meaning of the RPM_WAKE bit slightly (it is now also used for
> >   disabling run-time PM for a device along with the resume counter).
> > 
> > Please let me know if I've overlooked anything. :-)
> 
> This first thing to strike me was that you moved the idle notifications 
> into the workqueue.

Yes, I did.
 
> Is that really needed?  Would we be better off just make the idle
> callbacks directly from pm_runtime_put?  They would run in whatever
> context the driver happened to be in at the time.
> 
> It's not clear exactly how much work the idle callbacks will need to 
> do, but it seems likely that they won't have to do too much more than 
> call pm_request_suspend.  And of course, that can be done in_interrupt.

I just don't want to put any constraints on the implementation of
->runtime_idle().  The requirement that it be suitable for calling from
interrupt context may be quite inconvenient for some drivers and I'm afraid
they may have problems with meeting it.

Best,
Rafael
