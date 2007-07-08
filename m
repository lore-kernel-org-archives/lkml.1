Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXGHVh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXGHVh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXGHVhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:37:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbXGHVht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:37:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 23:45:26 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <200707082115.27363.rjw@sisk.pl> <1183928612.3388.289.camel@localhost.localdomain>
In-Reply-To: <1183928612.3388.289.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082345.27859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 23:03, Benjamin Herrenschmidt wrote:
> On Sun, 2007-07-08 at 21:15 +0200, Rafael J. Wysocki wrote:
> > On Sunday, 8 July 2007 07:14, Benjamin Herrenschmidt wrote:
> > [--snip--]
> > > 
> > > I just think that the freezer approach, as it is, is backward. We can't
> > > have a 3rd party try to discriminate what to freeze and what not, it
> > > will always get something wrong, and in some cases with the wrong timing
> > > or ordering.
> > 
> > Nice discussion, except for one thing: the freezer doesn't decide what to
> > freeze.  For example, even right now kernel threads decide if they want to be
> > frozen.
> 
> Somewhat... userspace doesn't and workqueues are a gray area.

Workqueues are kernel threads and the creator decides if they are going to
freeze.  There are only two freezable worqueues in the entire tree right now.

> Also, I've been thinking this "icebox" idea a bit more and it seems in
> fact a bit racy in some areas, at least for use by things like drivers,
> unless we end up doing something aking to an RCU on suspend, waiting for
> all tasks to reach userland once, but that has the same annoyances as
> the current freezer.
> 
> Thus I'm tempted to go back to saying that driver can handle things
> locally :-)

Actaully, I'm perfectly fine with that, as long as each task blocked by the
driver due to suspend has PF_FROZEN (or something similar) set.  Then, at
least theoretically, we'll be able to drop the freezer from the suspend code
path and move it after device_suspend() (or the hibernation-specific
equivalent) for hibernation (in that case there shouldn't be a problem with
any task waiting on I/O while the freezer is running ;-)).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
