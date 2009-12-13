Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZLMTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZLMTC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZLMTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:02:24 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60650 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753865AbZLMTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:02:18 -0500
Date: Sun, 13 Dec 2009 14:02:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Async suspend-resume patch w/ completions (was: Re:
 Async suspend-resume patch w/ rwsems)
In-Reply-To: <Pine.LNX.4.44L0.0912131221210.1111-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0912131349400.2857-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009, Alan Stern wrote:

> > Namely that there's no apparent sane way to say "don't wait for children".
> > 
> > PCI bridges that don't suspend at all - or any other device that only 
> > suspends in the 'suspend_late()' thing, for that matter - don't have any 
> > reason what-so-ever to wait for children, since they aren't actually 
> > suspending in the first place. But you make them wait regardless, which 
> > then serializes things unnecessarily (for example, two unrelated USB 
> > controllers).

> In short, allowing devices to suspend before their children would be 
> dangerous and probably would not save a significant amount of time.

There's more to be said.  Even without this "don't wait for children"  
thing, there can be bad interactions causing unnecessary delays.  For
example, suppose A (async) is the parent of B (sync), B comes before C
(sync) in dpm_list, and C is the parent of D (async).  Even if A & B
are unrelated to C & D, they will be forced to wait for them.  It 
doesn't matter that A and D are unrelated and so could suspend 
concurrently.

In essence, every synchonrous device is treated as though it depends on 
all the synchronous devices preceding it in dpm_list.  That's a lot of 
unnecessary constraints.  At the moment we have no choice, because we 
have to assume that some of those constraints actually are necessary -- 
and we don't know which ones.

It's an inescapable fact: If there are unnecessary ordering constraints
then you generally can't be 100% efficient in carrying out parallel
operations.  Compared with all these extra "synchronous" constraints,
the relatively small number of "don't need to wait for children"  
constraints is harmless.  I bet that if we got rid of all unnecessary
constraints except for making parents always wait for their children,
we'd attain more than 95% of the ideal speedup.

Alan Stern

