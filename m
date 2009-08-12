Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZHLVmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZHLVmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZHLVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:42:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZHLVms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:42:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Wed, 12 Aug 2009 23:43:20 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121702520.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122343.20554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Alan Stern wrote:
> On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The following patches introduce a mechanism allowing us to execute device
> > drivers' suspend and resume callbacks asynchronously during system sleep
> > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > message.
> > 
> > Comments welcome.
> 
> I get the idea.  Not bad.

Thanks!

> Have you tried it in a serious way?  For example, turning on the
> async_suspend flag for every device?

No, I've only tested it with a few selected drivers.  I'm going to try the
"async everyone" scenario, though.

> In one way it isn't as efficient as it could be.  You fire off a bunch
> of async threads and then make many of them wait for parent or child
> devices.  They could be doing useful work instead.

I kind of agree, but then the patches would be more complicated.

> It would be interesting to invent a way of representing explicitly the 
> non-tree dependencies -- assuming there aren't too many of them!  (I 
> can just hear the TI guys hollering about power and timer domains...)

I have an idea.

Every such dependency involves two devices, one of which is a "master"
and the second of which is a "slave", meaning that the "slave" have to be
suspended before the "master" and cannot be resumed before it.  In principle
we could give each device two lists of "dependency objects", one containing
"dependency objects" where the device is the "master" and the other containing
"dependency objects" where the device is the "slave".  Then, each "dependency
object" could be represented as

struct pm_connection {
    struct device *master;
    struct list_head master_hook;
    struct device *slave;
    struct list_head slave_hook;
};

Add some locking, helpers for adding / removing "dependency objects" etc.
and it should work.  Instead of checking the parent, walk the list of
"masters", instead of walking the list of children, walk the list of "slaves".

The core could create those objects for parent-child relationships
automatically, the other ones would have to be added by platforms / bus types /
drivers etc.

This approach has a problem that it's prone to adding circular dependencies by
mistake, but then I think it would apply to any other approach just as well.

Best,
Rafael
