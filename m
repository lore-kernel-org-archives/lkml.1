Return-Path: <linux-kernel-owner+w=401wt.eu-S935256AbZLGPNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935256AbZLGPNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935228AbZLGPN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:13:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51019 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935223AbZLGPN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:13:28 -0500
Date: Mon, 7 Dec 2009 10:13:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071003270.3064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Linus Torvalds wrote:

> 	# Phase one: walk the tree synchronously, starting any
> 	# async work on the leaves
> 	suspend_prepare(root)
> 	{
> 		for_each_child(root) {
> 			// This may take the parent lock for
> 			// reading if it does something async
> 			suspend_prepare(child);
> 		}
> 		suspend_prepare_one_node(root);
> 	}
> 
> 	# Phase two: walk the tree synchronously, waiting for
> 	# and finishing the suspend
> 	suspend(root)
> 	{
> 		for_each_child(root) {
> 			suspend(child);
> 		}
> 		// This serializes with any async children started in phase 1
> 		write_lock(root->lock);
> 		suspend_one_node(root);
> 		write_unlock(root->lock);
> 	}
> 
> and I really think this should work.

> No complex concepts. No change to existing tested drivers. No callbacks, 
> no flags, no nothing. And a pretty simple way for a driver to decide: I'll 
> do my suspends asynchronously (without parent drivers really ever even 
> having to know about it).
> 
> I dunno. Maybe I'm overlooking something, but the above is much closer to 
> what I think would be worth doing.

You're overlooking resume.  It's more difficult than suspend.  The
issue is that a child can't start its async part until the parent's
synchronous part is finished.

So for example, suppose the device listing contains P, C, Q, where C is
a child of P, Q is unrelated, and P has a long-lasting asynchronous
requirement.  The resume process will stall upon reaching C, waiting
for P to finish.  Thus even though P and Q might be able to resume in
parallel, they won't get the chance.

An approach that handles resume well can probably be adapted to handle 
suspend too.  The reverse isn't true, as this example shows.

Alan Stern

