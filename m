Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZFUCaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZFUCaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 22:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZFUC36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 22:29:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51943 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751896AbZFUC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 22:29:58 -0400
Date: Sat, 20 Jun 2009 22:30:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework
 for run-time PM of I/O devices
In-Reply-To: <200906210148.57199.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906202223080.20502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:

> On Saturday 20 June 2009, Alan Stern wrote:
> > Some more thoughts...
> > 
> > Magnus, you might have some insights here.  It occurred to me that some 
> > devices can switch power levels very quickly, and the drivers might 
> > therefore want the runtime suspend and resume methods to be called as 
> > soon as possible, even in interrupt context.
> 
> Then, we'll need special suspend and resume calls for them.

Good idea.  pm_runtime_resume_atomic() and pm_runtime_suspend_atomic().  
No need for _request variants since the status should never be 
RPM_SUSPENDING or RPM_RESUMING while the lock is released.


> > Similarly, we should insure that runtime PM calls made before the
> > device is registered don't do anything.  So when the device structure
> > is first created and the contents are all 0, this should also be
> > interpreted as an exceptional state.  We could call it RPM_UNREGISTERED
> > and use it for both purposes.
> 
> Hmm.  How do you think is possible that the pm_runtime_* functions will be
> called in such a situation?

By mistake.  :-)

Seriously, there _are_ places where drivers get bound to device before
those devices are registered.  This happens for example in USB when a
bunch of related interfaces are present in the same physical device.  
When the first interface is registered, its driver binds itself to all
the others even though they haven't been registered yet.

Alan Stern

