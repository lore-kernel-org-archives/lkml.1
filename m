Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZFTXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZFTXsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZFTXsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:48:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFTXsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:48:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework for run-time PM of I/O devices
Date: Sun, 21 Jun 2009 01:48:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906210148.57199.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009, Alan Stern wrote:
> Some more thoughts...
> 
> Magnus, you might have some insights here.  It occurred to me that some 
> devices can switch power levels very quickly, and the drivers might 
> therefore want the runtime suspend and resume methods to be called as 
> soon as possible, even in interrupt context.

Then, we'll need special suspend and resume calls for them.

> In terms of the current framework, this probably means holding the
> runtime PM lock (i.e., not releasing it) across the calls to
> ->runtime_suspend and ->runtime_resume.  It also means that
> pm_request_suspend and pm_request_resume should carry out their jobs
> immediately instead of queuing a work item.  (Unless the current status 
> is RPM_SUSPENDING or RPM_RESUMING, which should never happen.)
> 
> Should there be a flag in dev_pm_info to select this behavior?

I don't think we should complicate pm_request_suspend() and pm_request_resume()
further to handle this particular case.  IMO it's better to provide separate
core calls for that.

> When a device structure is unregistered and deallocated, we have to
> insure that there aren't any pending runtime PM workqueue items.  
> Hence device_del should call a routine that changes the status to an
> exceptional state (not RPM_ERROR but something else) to prevent new
> requests from being queued, and then calls cancel_work_sync or
> cancel_delayed_work_sync as required.

This is done in the patch I've just sent.
 
> Similarly, we should insure that runtime PM calls made before the
> device is registered don't do anything.  So when the device structure
> is first created and the contents are all 0, this should also be
> interpreted as an exceptional state.  We could call it RPM_UNREGISTERED
> and use it for both purposes.

Hmm.  How do you think is possible that the pm_runtime_* functions will be
called in such a situation?

Best,
Rafael
