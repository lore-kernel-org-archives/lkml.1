Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbXE1Qnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbXE1Qnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763176AbXE1Qnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:43:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763112AbXE1Qng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:43:36 -0400
Date: Mon, 28 May 2007 12:43:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
 hibernation/suspend
In-Reply-To: <20070528161242.GA1063@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0705281237200.22682-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Matthew Garrett wrote:

> On Mon, May 28, 2007 at 12:09:30PM -0400, Alan Stern wrote:
> 
> > I can't speak for the second example, but there's a good reason the
> > first example works this way.  It's not a matter of races; the problem
> > is that the kernel thread's job is to selectively suspend and resume
> > devices.  We don't want it doing this while a system sleep is in 
> > progress; it would (and in fact has, before the thread was made 
> > freezable) cause the sleep transition to abort.
> 
> How does this work on PPC or APM systems?

For hibernation it behaves the same as on other types of systems.

For STR it generally works okay.  There was one report of suspends
aborting, and it looked like this was caused by selective resumes
originating from userspace.  This seemed to be unrelated to the kernel
threads; apparently some program was running while the STR was in
progress, and causing the problem.  For example, the lsusb program will
do a selective resume on every USB device as it scans through them all.
However that's just a guess, we haven't fully resolved that bug report.

The theoretical answer is that it behaves the way we want.  The kernel 
thread does selective resumes in response to device requests.  If such 
a request comes in while the system is asleep it will awaken the 
system; so it's only logical that a request coming in while the system 
is in the process of going to sleep should abort the suspend.

Alan Stern

