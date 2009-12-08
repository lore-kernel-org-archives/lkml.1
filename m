Return-Path: <linux-kernel-owner+w=401wt.eu-S966556AbZLHWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966556AbZLHWCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966447AbZLHWCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:02:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966382AbZLHWCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:02:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 23:03:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <alpine.LFD.2.00.0912081256310.3560@localhost.localdomain> <200912082240.42773.rjw@sisk.pl>
In-Reply-To: <200912082240.42773.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082303.12758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Rafael J. Wysocki wrote:
> On Tuesday 08 December 2009, Linus Torvalds wrote:
> > 
> > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > > 
> > > Anyway, if we use an rwsem, it won't be checkable from interrupt context just
> > > as well.
> > 
> > You can't do a lock() from an interrupt, but the unlocks should be 
> > irq-safe. 
> > 
> > > Suppose we use rwsem and during suspend each child uses a down_read() on a
> > > parent and then the parent uses down_write() on itself.  What if, whatever the
> > > reason, the parent is a bit early and does the down_write() before one of the
> > > children has a chance to do the down_read()?  Aren't we toast?
> > 
> > We're toast, but we're toast for a totally unrealted reason: it means that 
> > you tried to resume a child before a parent, which would be a major bug to 
> > begin with.
> > 
> > Look, I even wrote out the comments, so let me repeat the code one more 
> > time.
> > 
> >  - suspend time calling:
> >         // This won't block, because we suspend nodes before parents
> >         down_read(node->parent->lock);
> >         // Do the part that may block asynchronously
> >         async_schedule(do_usb_node_suspend, node);
> > 
> >  - resume time calling:
> >         // This won't block, because we resume parents before children,
> >         // and the children will take the read lock. 
> >         down_write(leaf->lock);
> >         // Do the blocking part asynchronously
> >         async_schedule(usb_node_resume, leaf);
> > 
> > See? So when we take the parent lock for suspend, we are guaranteed to do 
> > so _before_ the parent node itself suspends. And conversely, when we take 
> > the parent lock (asynchronously) for resume, we're guaranteed to do that 
> > _after_ the parent node has done its own down_write.
> > 
> > And that all depends on just one trivial thing; that the suspend and 
> > resume is called in the right order (children first vs parent first 
> > respectively). And that is such a _major_ correctness issue that if that 
> > isn't correct, your suspend isn't going to work _anyway_.
> 
> Understood (I think).
> 
> Let's try it, then.  Below is the resume patch based on my previous one in this
> thread (I have only verified that it builds).

Ah, I need to check if dev->parent is not NULL before trying to lock it, but
apart from this it doesn't break things at least.

Rafael
