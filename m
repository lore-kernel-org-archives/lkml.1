Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZF0Ovl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZF0Ovl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZF0Ovb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:51:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47859 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765AbZF0Ovb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:51:31 -0400
Date: Sat, 27 Jun 2009 10:51:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906270032.45290.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906271042450.12287-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009, Rafael J. Wysocki wrote:

> > Speaking of races, have you noticed that the way power.work_done gets 
> > used is racy?
> 
> Not really. :-)
> 
> > You can't wait for the completion before releasing the 
> > lock, but then anything could happen.
> > 
> > A safer approach would be to use a wait_queue.
> 
> I'm not sure what you mean exactly.  What's the race?

Come to think of it, there really is a problem here.  Because the
wait_for_completion call occurs outside the spinlock, it can race with
the init_completion call.  It's not good for both of them to run at the
same time; the completion's internal spinlock and list pointers could 
get corrupted.

Therefore I stand by my original assertion: The struct completion 
should be replaced with a wait_queue.  Set the runtime_error field to 
-EINPROGRESS initially, and make other threads wait until the value 
changes.

Alan Stern

