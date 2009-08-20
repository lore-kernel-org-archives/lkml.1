Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZHTPzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZHTPzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZHTPzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:55:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZHTPzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:55:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Thu, 20 Aug 2009 17:56:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0908191829510.26174-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908191829510.26174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201756.36801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Alan Stern wrote:
> On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:
> 
> > On Wednesday 19 August 2009, Alan Stern wrote:
> > > On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:
> > > 
> > > > There's a problem that for safety reasons I maintain the ordering of dpm_list
> > > > and the callbacks are scheduled for async execution in the same order in
> > > > which they would have been executed synchronously.  If were to change this,
> > > > we'd have to be _very_ careful.
> > > 
> > > Why?  The order in which jobs are scheduled for async execution doesn't 
> > > bear any particular relation to the order in which they get run.
> > 
> > Yes, it does, if all of the async threads are busy and we add more async jobs
> > to the queue.  We must ensure that none of the jobs being executed will wait
> > for any jobs in the queue.
> 
> That's part of the reason for the dependencies: to make sure that where
> it matters, things don't run in the wrong order.
> 
> > Also, if any devices are handled synchronously, they must not wait for any
> > "async" devices that haven't been scheduled yet.
> 
> I'm not sure what you mean.  If a device is handled synchronously, it 
> must wait for all the devices preceding it on the list, regardless of 
> whether those devices are handled asynchronously.

Not really, IMO.  Namely, setting async_suspend for a device is a declaration
that all of its dependencies are known, whether they are on "async" or on
"sync" devices.  Hence, "sync" devices don't need to wait for the "async"
devices they don't depend on in a known way, because otherwise it would be
invalid to set async_suspend for those "async" devices.

Nevertheless, "sync" devices have to wait for all of the other "sync" devices
that are "in front" of them in dpm_list, because dependencies between different
"sync" devices need not be known (the direct dependencies betwee them are
known, but there may be other unknown dependencies satisfied only because the
the ordering of dpm_list is preserved).

Obviously "sync" devices have to wait for the "async" devices they depend on
in a known way.  In turn, "async" devices have to wait for all of the devices
they depend on in a known way, "sync" as well as "async".

Thanks,
Rafael
