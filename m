Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZHMS2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZHMS2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZHMS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:28:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZHMS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:28:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Thu, 13 Aug 2009 20:28:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908131031060.2940-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908131031060.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132028.53094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Alan Stern wrote:
> On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> 
> > I have an idea.
> > 
> > Every such dependency involves two devices, one of which is a "master"
> > and the second of which is a "slave", meaning that the "slave" have to be
> > suspended before the "master" and cannot be resumed before it.  In principle
> > we could give each device two lists of "dependency objects", one containing
> > "dependency objects" where the device is the "master" and the other containing
> > "dependency objects" where the device is the "slave".  Then, each "dependency
> > object" could be represented as
> > 
> > struct pm_connection {
> >     struct device *master;
> >     struct list_head master_hook;
> >     struct device *slave;
> >     struct list_head slave_hook;
> > };
> > 
> > Add some locking, helpers for adding / removing "dependency objects" etc.
> > and it should work.  Instead of checking the parent, walk the list of
> > "masters", instead of walking the list of children, walk the list of "slaves".
> 
> If the set of pm_connection objects is reasonably small then the
> master_hook and slave_hook aren't needed; you can just read through the
> entire list.  Leaving out parent-child connections, which we already
> know, would help shrink the set.

Do you mean a global list for the entire system?  I'm not sure if that wouldn't
hurt performance (please note that it also affects runtime PM).

We could use counters of "suspended slaves" and "active masters" to optimize
things, but still updating these counters could take time (one has to find all
devices dependent on given one and update a counter for each of them).

> The layout of the pm_connection objects could then be improved
> slightly.  Each object could contain a variable-sized array of device
> pointers together with two integers, M and S.  The first M pointers
> would be masters and the remaining S pointers would be slaves.  This
> could be useful when, for example, a large number of devices all depend
> on one particular power device.

I'm not sure.  If we use the coutners, this case will be quite easy to handle.

Thanks,
Rafael
