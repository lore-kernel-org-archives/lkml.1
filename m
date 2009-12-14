Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbZLNXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbZLNXRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbZLNXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:17:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbZLNXRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:17:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Tue, 15 Dec 2009 00:18:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912142311.31658.rjw@sisk.pl> <alpine.LFD.2.00.0912141416040.26135@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912141416040.26135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912150018.11837.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Linus Torvalds wrote:
> 
> On Mon, 14 Dec 2009, Rafael J. Wysocki wrote:
> >
> > OK, what about a two-pass approach in which the first pass only inits the
> > completions and starts async threads for leaf "async" devices?  I think leaf
> > devices are most likely to take much time to suspend, so this will give us
> > a chance to save quite some time.
> 
> Why?
> 
> Really.

Because the PCI bridges are not the only case where it matters (I'd say they
are really a corner case).  Basically, any two async devices separeted by a
series of sync ones are likely not to be suspended (or resumed) in parallel
with each other, because the parent is usually next to its children in dpm_list.
So, if the first device suspends, its "synchronous" parent waits for it and the
suspend of the second async device won't be started until the first one's
suspend has returned.  And it doesn't matter at what level we do the async
thing, because dpm_list is there anyway.

As Alan said, the real problem is that we generally can't change the ordering
of dpm_list arbitrarily, because we don't know what's going to happen as a
result.  The async_suspend flag tells us, basically, what devices can be safely
moved to different positions in dpm_list without breaking things, as long as
they are not moved behind their parents or in front of their children.

Starting the async suspends upfront would effectively work in the same way as
moving those devices to the beginning of dpm_list without breaking the
parent-child chains, which in turn is likely to allow us to save some extra
time.

That's not only about the PCI bridges, it's more general.  As far as your
one-liner is concerned, I'm going to test it, because I think we could use it
anyway.

Rafael
