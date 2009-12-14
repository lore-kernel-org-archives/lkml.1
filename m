Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZLNWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZLNWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZLNWmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:42:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbZLNWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:42:13 -0500
Date: Mon, 14 Dec 2009 14:41:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912142311.31658.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912141416040.26135@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912122334.08367.rjw@sisk.pl> <alpine.LFD.2.00.0912141015240.26135@localhost.localdomain> <200912142311.31658.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Rafael J. Wysocki wrote:
>
> OK, what about a two-pass approach in which the first pass only inits the
> completions and starts async threads for leaf "async" devices?  I think leaf
> devices are most likely to take much time to suspend, so this will give us
> a chance to save quite some time.

Why?

Really.

Again, stop making it harder than it needs to be.

Why do you make up these crazy schemes that are way more complex than they 
need to be?

Here's an untested one-liner that has a 10-line comment.

I agree it is ugly, but it is ugly exactly because the generic device 
layer _forces_ us to wait for children even when we don't want to. With 
this, that unnecessary wait is now done asynchronously.

I'd rather do it some other way - perhaps having an explicit flag that 
says "don't wait for children because I'm not going to suspend myself 
until 'suspend_late' _anyway_". But at least this is _simple_.

		Linus

---
 drivers/pci/probe.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 98ffb2d..4e0ad7b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -437,6 +437,17 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	}
 	bridge->subordinate = child;
 
+	/*
+	 * We don't really suspend PCI buses asyncronously.
+	 *
+	 * However, since we don't actually suspend them at all until
+	 * the late phase, we might as well lie to the device layer
+	 * and it to do our no-op not-suspend asynchronously, so that
+	 * we end up not synchronizing with any of our child devices
+	 * that might want to be asynchronous.
+	 */
+	bridge->dev.power.async_suspend = 1;
+
 	return child;
 }
 
