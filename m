Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZHSVRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZHSVRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZHSVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:17:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZHSVRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:17:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Wed, 19 Aug 2009 23:17:41 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0908191004560.3001-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908191004560.3001-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908192317.41253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 August 2009, Alan Stern wrote:
> On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:
> 
> > There's a problem that for safety reasons I maintain the ordering of dpm_list
> > and the callbacks are scheduled for async execution in the same order in
> > which they would have been executed synchronously.  If were to change this,
> > we'd have to be _very_ careful.
> 
> Why?  The order in which jobs are scheduled for async execution doesn't 
> bear any particular relation to the order in which they get run.

Yes, it does, if all of the async threads are busy and we add more async jobs
to the queue.  We must ensure that none of the jobs being executed will wait
for any jobs in the queue.

Also, if any devices are handled synchronously, they must not wait for any
"async" devices that haven't been scheduled yet.

With a master thread that would do all the waiting that wouldn't be a problem
any more, but I'm not sure how to implement such a thread efficiently.  The
problem is that each device may depend on multiple other devices, so even
if one callback finishes, there's no guarantee there will be any device with
satisfied dependencies, so it looks like the master thread would have to
browse dpm_list continuously searching it for devices that are ready for
suspending.

Also I don't think we can change the ordering of dpm_list as a result of
asynchronous execution.

Thanks,
Rafael
