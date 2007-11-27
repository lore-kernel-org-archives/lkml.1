Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbXK0Pdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbXK0Pdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXK0PdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:33:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44475 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbXK0PdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:33:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Chinner <dgc@sgi.com>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Tue, 27 Nov 2007 16:51:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20071112064706.GA23595@dose.home.local> <20071126210844.GB119954183@sgi.com> <200711262307.56742.rjw@sisk.pl>
In-Reply-To: <200711262307.56742.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271651.39180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 of November 2007, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, David Chinner wrote:
> > On Mon, Nov 26, 2007 at 02:12:10PM +0100, Tino Keitel wrote:
> > > On Wed, Nov 14, 2007 at 10:04:45 +1100, David Chinner wrote:
> > > > On Tue, Nov 13, 2007 at 11:51:19AM +0100, Tino Keitel wrote:
> > > > > On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > No. I'd say something got screwed up during suspend/resume. Is it
> > > > > > reproducable?
> > > > > 
> > > > > No. I often use suspend to RAM, and usually it works without such
> > > > > failures. I restart squid during the resume prosecure, and the above
> > > > > Oops lead to a squid in D state.
> > > > 
> > > > Ok. Sounds like there's not much we can debug at this point. Thanks
> > > > for the report, though.
> > > 
> > > I got a similar Oops again:
> > > 
> > > xfs_iget_core: ambiguous vns: vp/0xc00700c0, invp/0xcb5a1680
> > 
> > Now there's a message that I haven't seen in about 3 years.
> > 
> > It indicates that the linux inode connected to the xfs_inode is not
> > the correct one. i.e. that the linux inode cache is out of step with
> > the XFS inode cache.
> > 
> > Basically, that is not supposed to happen. I suspect that the way
> > threads are frozen is resulting in an inode lookup racing with
> > a reclaim. The reclaim thread gets stopped after any use threads,
> > and so we could have the situation that a process blocked in lookup
> > has the XFS inode reclaimed and reused before it gets unblocked.
> > 
> > The question is why is it happening now when none of that code in
> > XFS has changed?
> > 
> > Rafael, when are threads frozen? Only when they schedule or call
> > try_to_freeze()?
> 
> Kernel threads freeze only when they call try_to_freeze().  User space tasks
> freeze while executing the signals handling code.
> 
> > Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?
> 
> Yes.  Kernel threads are not sent fake signals by the freezer any more.

Ah, sorry, this change has been merged after 2.6.23.  However, before 2.6.23
we had another important change that caused all kernel threads to have
PF_NOFREEZE set by default, unless they call set_freezable() explicitly.

Greetings,
Rafael
