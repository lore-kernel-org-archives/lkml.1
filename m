Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZHRWcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZHRWcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZHRWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:32:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZHRWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:32:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Wed, 19 Aug 2009 00:33:23 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0908181606520.2653-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908181606520.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908190033.23502.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Alan Stern wrote:
> On Tue, 18 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > Also, I think a better approach to the async execution would not
> > > require adding a struct completion to each device and making each async
> > > thread wait for the completion to be signalled.  Instead, have a single
> > > master thread (i.e., the thread doing the suspend) monitor the
> > > dependencies and have it farm the devices out to async threads as they
> > > become ready to be suspended or resumed.
> > 
> > Do you mean that the master thread should check the dependencies
> > _before_ executing, for example, __device_resume() and execute it
> > asynchronously only if they are already satisfied?  In that case we might lose
> > the opportunity to save some time.
> 
> That's almost what I mean.  The master thread should keep track of the 
> state of all the devices.  Each time a suspend or resume completes, the 
> master thread should determine which devices now have all their 
> dependencies satisfied as a result, and should asynchronously execute 
> __device_resume() for each one of them.
> 
> > For example, assume devices A and B depend on C. Say that normally, A would be
> > handled before B, so if C hasn't finished yet, the A's callback will be
> > executed synchronously.  Now, if both A and B take time T to complete the
> > callback and C finishes dT after we've called A synchronously, we'll lose the
> > chance to save T - dT by handling A and B in parallel.
> 
> No, that's not what I mean.  Until C is finished, the master thread
> will sleep.  When C finishes the master thread will wake up, note that
> A and B can now be resumed, fire off two async threads to resume them, 
> and go back to sleep.

There's a problem that for safety reasons I maintain the ordering of dpm_list
and the callbacks are scheduled for async execution in the same order in
which they would have been executed synchronously.  If were to change this,
we'd have to be _very_ careful.

Thanks,
Rafael
