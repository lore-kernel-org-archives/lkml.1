Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZLMRao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZLMRao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZLMRam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:30:42 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52088 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751339AbZLMRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:30:40 -0500
Date: Sun, 13 Dec 2009 12:30:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912131221210.1111-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Linus Torvalds wrote:

> This version still has a major problem, which is not related to 
> completions vs rwsems, but simply to the fact that you wanted to do this 
> at the generic device layer level rather than do it at the actual 
> low-level suspend/resume level.
> 
> Namely that there's no apparent sane way to say "don't wait for children".
> 
> PCI bridges that don't suspend at all - or any other device that only 
> suspends in the 'suspend_late()' thing, for that matter - don't have any 
> reason what-so-ever to wait for children, since they aren't actually 
> suspending in the first place. But you make them wait regardless, which 
> then serializes things unnecessarily (for example, two unrelated USB 
> controllers).

In reality this should never be a problem.

Consider that ultimately we want to achieve the following two goals:

	Implement a two-pass algorithm, so that synchronous devices
	can't cause spurious dependencies between two async devices.
	(This will fix the issue of an intermediate PCI bridge
	serializing two unrelated USB controllers.)

	Convert all lengthy suspend/resume operations to async.

Obviously we don't want to do this all at once.  But until the goals
are achieved, there's no point worrying about devices being forced to
wait for their children or parents.  And after the goals are achieved,
it won't matter.

Why not?  Consider the devices which would be delayed.  If they use
synchronous suspend/resume then they won't take much time, so delaying
them won't matter.  Indeed, based on Arjan's preliminary measurements
it's fair to say that the total time taken by all the synchronous
suspends/resumes put together should be negligible.  Even if all of
them were somehow delayed until all the async activities were complete,
nobody would notice or care.  (And conversely, if all the async
activities could somehow be forced to wait until all the synchronous
suspends/resumes were done, nobody would notice or care.)

Okay, so consider a case where A comes before B in dpm_list and B is 
the parent of C.  Suppose B doesn't need to wait for C to suspend, but 
we force it to wait anyhow.

If A or C is synchronous then we're okay, by the considerations above.  
Suppose A is async.  Then it wouldn't be delayed unless it was one of
B's ancestors, so suppose it is.  Now we are potentially delaying A
more than necessary.

Or are we?  Even though B might not need to wait for C to suspend,
there's an excellent chance that A _does_ need to wait for C.  If we
allow B to suspend before C then there would be nothing to prevent A
from suspending too quickly.  A's driver would need to wait explicitly 
for C -- which is unreasonable since C isn't one of A's children.  
(Rafael made a similar point.)

In short, allowing devices to suspend before their children would be 
dangerous and probably would not save a significant amount of time.

Alan Stern

