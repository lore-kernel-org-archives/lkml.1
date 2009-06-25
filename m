Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZFYXRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZFYXRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFYXQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:16:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54293 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZFYXQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 5)
Date: Fri, 26 Jun 2009 01:17:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906251144280.4836-100000@iolanthe.rowland.org> <200906252358.56909.rjw@sisk.pl>
In-Reply-To: <200906252358.56909.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906260117.12989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Rafael J. Wysocki wrote:
> On Thursday 25 June 2009, Alan Stern wrote:
> > On Wed, 24 Jun 2009, Alan Stern wrote:
> > > More comments to follow when I get time to review more of the code...
> > 
> > Here we go.  This isn't so detailed, because I wasn't able to do a 
> > detailed review.  Frankly, the code is kind of a mess.
> > 
> > The whole business about the runtime_notify and RPM_NOTIFY flags is 
> > impenetrable.  My suggestion: Rename runtime_notify to notify_pending 
> > and eliminate RPM_NOTIFY.  Then make sure that notify_pending is set 
> > whenever a notify work item is queued.
> 
> I was going to do exactly that, but I realized it wouldn't work in general,
> because ->runtime_idle() could run __pm_runtime_suspend() in theory.
> 
> The runtime_notify bit is only needed for pm_runtime_disable() so that it
> knows there's a work item to cancel.
> 
> > The pm_notify_or_cancel_work routine should just be pm_notify_work.  
> > It's silly to submit a workqueue item just to cancel a delayed
> > workqueue item!
> 
> Maybe, but how do you think we should cancel it?  cancel_delayed_work()
> doesn't guarantee that the work structure used for queuing the work will
> not be accessed after it's returned and we can't schedule the next suspend
> request until we know it's safe.  So, we have to use cancel_delayed_work_sync()
> for that, which can't be done from interrupt context, so we need to do it in a
> work function.

BTW, the problem is this.

Say we queue an idle notification, so power.work is used for this purpose.
Then, suspend is requested, but we cannot cancel the notification
asynchronously, so we can only queue the suspend.  power.suspend_work is used
for that.

Now, assume a resume is requested, so seemingly we need to queue a resume
(the suspend request is pending and we have to cancel it with
cancel_delayed_work_sync()), but power.work is already in use.  There are
two ways to handle this IMO: (1) use yet another 'struct work' variable
(suboptimal) and (2) make the idle notification work function cancel the
suspend instead of running the notification (that's what I did and I don't see
how I can avoid it without doing (1)).

Best,
Rafael
