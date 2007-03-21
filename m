Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbXCUCrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbXCUCrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXCUCrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:47:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42449 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXCUCrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:47:06 -0400
Date: Tue, 20 Mar 2007 19:47:01 -0700
From: sukadev@us.ibm.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-ID: <20070321024701.GC13436@us.ibm.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <46004B02.7020407@gmail.com> <200703202206.38168.rjw@sisk.pl> <200703210149.33240.rjw@sisk.pl> <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| "Rafael J. Wysocki" <rjw@sisk.pl> writes:
| 
| > On Tuesday, 20 March 2007 22:06, Rafael J. Wysocki wrote:
| >> On Tuesday, 20 March 2007 21:58, Jiri Slaby wrote:
| >> > Rafael J. Wysocki napsal(a):
| >> > > Actually, the problem is 100% reproducible on my system too and I doubt
| > it's
| >> > > caused by the recent freezer patches.
| >> > 
| >> > I don't know what exactly do you mean by recent, but 2.6.21-rc3-mm2 works
| >> > for me.
| >> 
| >> Thanks for the confirmation.
| >> 
| >> The patches I was talking about had already been in 2.6.21-rc3-mm2, so the
| >> reason of this failure must be different.
| >
| > Bisection shows that the freezing of processes has been broken by one of the
| > patches:
| >
| > remove-the-likelypid-check-in-copy_process.patch
| 
| Grr.  Oleg's review of remove-the-likelypid-check-in-copy-process
| showed it to be questionable (and it was just an optimization)
| so we can get rid of that one easily. 
| 
| Although all it did that was really questionable was add
| the idle process to the global process list and bump a process
| count when we forked the idle process.  Not dramatically dangerous
| things.
| 
| > use-task_pgrp-task_session-in-copy_process.patch
| 
| As I recall that patch was pretty trivial, and shouldn't have
| anything to do with the freezer.   The process freezer doesn't care
| about pids does it?

Yes. I think this one is trivial too. Here is the effective change in
copy_process():

-               attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-               attach_pid(p, PIDTYPE_SID, find_pid(sid));
+               attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
+               attach_pid(p, PIDTYPE_SID, task_session(current));


| 
| Eric
