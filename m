Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXLSXKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXLSXKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXLSXKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:10:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXLSXKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:10:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-hardirq-W} -> {hardirq-on-W} usage -- pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1]
Date: Thu, 20 Dec 2007 00:29:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Daniel Walker <dwalker@mvista.com>, Miles Lane <miles.lane@gmail.com>,
       Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com> <1198092200.2716.49.camel@imap.mvista.com> <Pine.LNX.4.64.0712191158140.28180@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0712191158140.28180@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200029.31709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of December 2007, Christoph Lameter wrote:
> On Wed, 19 Dec 2007, Daniel Walker wrote:
> 
> > > It looks like the swsusp_save() calls drain_all_pages() , which calls
> > > on_each_cpu() .. On return on_each_cpu() unconditionally enables
> > > interrupts so the rest of the resume process has interrupt enable
> > > (which , it looks like, shouldn't happen) and then you get the lockdep()
> > > warning due to the above..
> > > 
> > > Not sure if this has been found already, or not?
> 
> Hmmm... It will unconditionally enable interrupts regardless how we call 
> this. We could explicity save and restore interrrupts in 
> swsusp_save() I guess. Why is swsusp_save() disabling interrupts?

Actually, it's called with interrupts disabled, because it's job is to create
the hibernation image.  At this point everything is off except for the CPU
running swsusp_save().
 
> > > Should drain_all_pages() really be drain_local_pages() ?
> > 
> > It looks like it was drain_local_pages, but the following patch
> > 
> > page-allocator-clean-up-pcp-draining-functions.patch
> > 
> > Changes that in -mm .. I added Christoph Lameter to the CC since it's
> > his patch ..
> 
> We could reexport drain_local_pages() again but then I do not understand 
> why we would only drain the pages of this processor and not of all other
> processors as well. It seems that software suspend intend was to flush 
> them all right?

Well, not exactly.  We are on one CPU at this point, the others have been
disabled.
