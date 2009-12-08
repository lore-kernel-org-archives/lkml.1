Return-Path: <linux-kernel-owner+w=401wt.eu-S965881AbZLHToe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881AbZLHToe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965879AbZLHToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:44:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbZLHTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:44:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 20:44:52 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <200912081323.50606.rjw@sisk.pl> <alpine.LFD.2.00.0912080728590.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912080728590.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082044.52098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Linus Torvalds wrote:
> 
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > The wait queue plus the op_complete flag combo plays the role of the locking
> > in the Linus' picture
> 
> Please just use the lock. Don't make up your own locking crap. Really. 
> 
> Your patch is horrible. Exactly because your locking is horribly 
> mis-designed. You can't say things are complete from an interrupt, for 
> example, since you made it some random bitfield, which has unknown 
> characteristics (ie non-atomic read-modify-write etc).

I didn't assume anyone would check it from an interrupt, because I didn't see
a point.  In fact I didn't assume anyone except for the PM core would check it.
In case this assumption is wrong, it can be easily put under the dev->sem
that we take anyway before calling the bus type (etc.) callbacks.

Anyway, if we use an rwsem, it won't be checkable from interrupt context just
as well.

> The fact is, any time anybody makes up a new locking mechanism, THEY 
> ALWAYS GET IT WRONG. Don't do it.
>
> I suggested using the rwsem locking for a good reason. It made sense. It 
> was simpler. Just do it that way, stop making up crap.

Suppose we use rwsem and during suspend each child uses a down_read() on a
parent and then the parent uses down_write() on itself.  What if, whatever the
reason, the parent is a bit early and does the down_write() before one of the
children has a chance to do the down_read()?  Aren't we toast?

Do we need any direct protection against that or does it just work itself out
in a way I just don't see right now?

Rafael
