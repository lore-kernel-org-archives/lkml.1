Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZDGInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZDGInR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZDGInD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:43:03 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:52354 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZDGInB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:43:01 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [linux-pm] pm-hibernate : possible circular locking dependency
 detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Gautham R Shenoy <ego@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200904062158.11245.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0904061439230.4571-100000@iolanthe.rowland.org>
	 <200904062158.11245.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 10:43:50 +0200
Message-Id: <1239093831.798.5717.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 21:58 +0200, Rafael J. Wysocki wrote:
> On Monday 06 April 2009, Alan Stern wrote:
> > On Mon, 6 Apr 2009, Gautham R Shenoy wrote:
> > 
> > > > If I understand correctly it isn't really a deadlock scenario, but it
> > > > is a lockdep violation.  The violation is:
> > > > 
> > > > 	The pci_device_probe() path 2) proves that dpm_list_mtx [4] can
> > > > 	be acquired while cpu_hotplug.lock [3] is held;
> > > > 
> > > > 	The hibernate() path 3) proves that cpu_hotplug.lock [3] can be
> > > > 	acquired while dpm_list_mtx [4] is held.
> > > > 
> > > > The two pathways cannot run simultaneously (and hence cannot deadlock) 
> > > > because the prepare() stage of hibernation is supposed to stop all 
> > > > device probing.  But lockdep will still report a problem.
> > > 
> > > Thanks for clarifying this Alan. I guess it boils down to teaching
> > > lockdep about this false-positive.
> > 
> > Or else changing the code somehow to avoid the violation completely.  
> > But I have no idea how...  And AFAIK, teaching lockdep about special 
> > cases like this is not so easy to do.
> 
> Yeah, I've just wanted to ask about that.  Peter, how can we do it?

I think it would come down to modeling that blocking of probes as a lock
or something -- because that's basically what it is.

So on the regular probe path, take a read lock of this lock, and on the
suspend path take it as write or something.

