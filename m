Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab0CDTgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:36:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756213Ab0CDTgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:36:10 -0500
Date: Thu, 4 Mar 2010 14:36:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <201003042026.30303.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003041432320.1305-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:

> On Thursday 04 March 2010, Alan Stern wrote:
> > On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:
> > 
> > > > Very well.  Then we still need a solution to the original problem:  
> > > > Devices sometimes need to be unregistered during resume, but
> > > > del_gendisk() blocks on the writeback thread, which is frozen until
> > > > after the resume finishes.  How do you suggest this be fixed?
> > > 
> > > I thought about thawing the writeback thread earlier in such cases.
> > > 
> > > Would that makes sense / is it doable at all?
> > 
> > My thought exactly.  This is the only approach that also solves the 
> > following race:
> > 
> > 	A driver is unloaded at the same time as a suspend starts.
> > 
> > 	The writeback thread gets frozen.
> > 
> > 	Then before the rmmod thread is frozen, it calls del_gendisk.
> > 
> > Delaying things by means of a workqueue (or the equivalent) might also 
> > work, but it doesn't seem as safe.  For example, some important 
> > writebacks might end up getting delayed until too late.
> 
> OK, so what exactly should trigger the thawing of the writeback thread?
> 
> Should we do that unconditionally at one point or wait for a specific situation
> to happen, and how to recognize that situation in the latter case?

My thought was that del_gendisk would do this unconditionally.  It
would make the task unfreezable and then thaw it, to prevent a race.

This assumes that del_gendisk never gets called in the middle of a
sleep transition unless the device is really gone.  If that's not the
case, Pavel's suggestion (make the resume routine do the device removal
asynchronously) might be better.

Alan Stern

