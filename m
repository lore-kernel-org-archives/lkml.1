Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZHMOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZHMOqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZHMOqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:46:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37332 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754109AbZHMOp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:45:59 -0400
Date: Thu, 13 Aug 2009 10:45:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908122343.20554.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908131031060.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:

> I have an idea.
> 
> Every such dependency involves two devices, one of which is a "master"
> and the second of which is a "slave", meaning that the "slave" have to be
> suspended before the "master" and cannot be resumed before it.  In principle
> we could give each device two lists of "dependency objects", one containing
> "dependency objects" where the device is the "master" and the other containing
> "dependency objects" where the device is the "slave".  Then, each "dependency
> object" could be represented as
> 
> struct pm_connection {
>     struct device *master;
>     struct list_head master_hook;
>     struct device *slave;
>     struct list_head slave_hook;
> };
> 
> Add some locking, helpers for adding / removing "dependency objects" etc.
> and it should work.  Instead of checking the parent, walk the list of
> "masters", instead of walking the list of children, walk the list of "slaves".

If the set of pm_connection objects is reasonably small then the
master_hook and slave_hook aren't needed; you can just read through the
entire list.  Leaving out parent-child connections, which we already
know, would help shrink the set.

The layout of the pm_connection objects could then be improved
slightly.  Each object could contain a variable-sized array of device
pointers together with two integers, M and S.  The first M pointers
would be masters and the remaining S pointers would be slaves.  This
could be useful when, for example, a large number of devices all depend
on one particular power device.

> The core could create those objects for parent-child relationships
> automatically, the other ones would have to be added by platforms / bus types /
> drivers etc.
> 
> This approach has a problem that it's prone to adding circular dependencies by
> mistake, but then I think it would apply to any other approach just as well.

Yes.  In theory we could detect such cycles at runtime, but it's 
probably not worth the effort.

Alan Stern

