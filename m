Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbXLBUF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbXLBUF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXLBUFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:05:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39960 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXLBUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:05:49 -0500
Date: Sun, 2 Dec 2007 12:04:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Need lockdep help
Message-ID: <20071202120411.2aac7720@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.44L0.0712021430140.4185-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0712021430140.4185-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 14:45:32 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Ingo:
> 
> I ran into a lockdep reporting issue just now with some new code
> under development.  I think it's a false positive; the question is
> how best to deal with it.
> 
> Here's the situation.  The new code runs during a system sleep (i.e., 
> suspend or hibernation).  Certain activities have to be deferred
> during a system sleep, so I defined an rwsem:
> system_sleep_in_progress_rwsem.
> 
> Subroutines carrying out these activities acquire a read lock on the
> rwsem, so normally they proceed with no hindrance.  During a sleep
> transition, I acquire a write lock -- this is done via a PM-notifier
> callout routine.  That is, during a PM_HIBERNATION_PREPARE or
> PM_SUSPEND_PREPARE notification the routine does down_write(), and
> during a PM_POST_HIBERNATION or PM_POST_SUSPEND notification the
> routine does up_write().
> 
> The problem is that the notifier chain itself is under the control of 
> an rwsem (to prevent the chain from being modified while it is in
> use). The resulting actions look like this:
> 
> System sleep start:
> 		down_read(notifier-chain rwsem);
> 		call the notifier routine
> 			down_write(&system_sleep_in_progress_rwsem);
> 		up_read(notifier-chain rwsem);
> 
> System sleep end:
> 		down_read(notifier-chain rwsem);
> 		call the notifier routine
> 			up_write(&system_sleep_in_progress_rwsem);
> 		up_read(notifier-chain rwsem);
> 
> This creates a lockdep violation; each rwsem in turn is locked while 
> the other is being held.  However the only way this could lead to 
> deadlock would be if there was already a bug in the system Power 
> Management code (overlapping notifications).

or.. modifications to the notifier chain while all this is happening
(remember: rwsems are fair, once a writer shows up, all readers wait)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
