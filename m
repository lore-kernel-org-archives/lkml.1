Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZHFSTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZHFSTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHFSTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:19:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZHFSTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:19:00 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Douglas Leeder <douglas.leeder@sophos.com>, Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
In-Reply-To: <1249557831.32113.234.camel@twins>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com>
	 <1249554548.32113.137.camel@twins>
	 <200908061159.45550.tvrtko.ursulin@sophos.com>
	 <1249557831.32113.234.camel@twins>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:18:15 -0400
Message-Id: <1249582695.20644.35.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 13:23 +0200, Peter Zijlstra wrote:

> But yes, if its so invasive to the filesystem as to make it unusable I'd
> argue it to be part of the filesystem, we do filesystem encryption in
> the filesystem, so why should we do such invasive scanning outside of
> it?

In kernel?  yes.  In filesystem?  No.  This isn't fileystem specific,
it's system wide.  Didn't we have the discussion about fuse not being as
all encompassing as a number of people wanted?  Think nfsd.  Dazuko is I
believe working on generic stackable filesystems which might eventually
be able to implement a better set of hooks, but that is a LONG way from
a solved problem last I heard.

> 
> We are taking about the kind of fanotify client that says: No you cannot
> open/read/write/mmap/etc.. this file until I say you can, right?

Only open and read (or first mmap for read).  Nothing available for
write.  Noone purports this to be an LSM.

> By the above you're hosed anyway since starting a new one will fail due
> to there being no daemon, right? Might as well forfeit all security
> measures once the daemon dies. That is let security depend on there
> being a daemon connected.

Nope.  You should stop calling and thinking of it as a security system.
As I've said multiple times it is at best an indexing and integrity
checking system.  We fail open.  We don't prevent or care about
malicious local attacks.  When a group is evicted everything is going to
just work.  The whole reason for the timeout is because I don't trust
userspace not to get it wrong and I'd rather not lose my box because of
it.  Yes, the reset I'm proposing allows userspace to screw the system
forever, but at least that is an active operation, not an accidental
segfault bringing down the whole system.

> Seems like a weird thing to me, suppose you DoS the system on purpose
> and all clients start getting wonky, you kill them all, and are left
> with non, then you cannot access any of your files anymore and
> everything grinds to a halt?

Nope, you DoS the system on purpose all the listeners get evicted, now
everything else will be able to open/read data without those listeners
paying attention.  When a group is evicted it's evicted.  It no longer
needs to say yes or no.

> Like said, having the filesystem block actions based on external
> processes seems just asking for trouble.

Or it seems like exactly what hierarchical storage management systems
want....

-Eric

