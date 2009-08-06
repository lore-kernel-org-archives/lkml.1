Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZHFSTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZHFSTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZHFSTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:19:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZHFSTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:19:00 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
       "mmorley@hcl.in" <mmorley@hcl.in>
In-Reply-To: <20090806135800.7ccb7787@lxorguk.ukuu.org.uk>
References: <1248466429.3567.82.camel@localhost>
	 <200908061159.45550.tvrtko.ursulin@sophos.com>
	 <1249557831.32113.234.camel@twins>
	 <200908061348.43625.tvrtko.ursulin@sophos.com>
	 <20090806135800.7ccb7787@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:18:10 -0400
Message-Id: <1249582690.20644.33.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 13:58 +0100, Alan Cox wrote:
> > > We are taking about the kind of fanotify client that says: No you cannot
> > > open/read/write/mmap/etc.. this file until I say you can, right?
> > 
> > Yes and no, it would be more accurate to say "this open takes long while we do 
> > something else in the background".
> 
> There are two or three ways to handle this
> 
> 1.	Block the open until the daemon dies or responds
> 2.	Have a timeout (which would need to be connection configurable)
> 3.	Require the daemon responds with "in progress" now and then.

I've taken option #3.  I don't see options #2 as viable, although off
list discussion from clamav people has said they believe they are
interested in #2 rather than #3.

> For a superuser managed service its no different to an NFS mount which
> can go wonky so the only real question is what should fanotify allow non
> privileged users to do. The answer would appear anyway to be: not use
> this aspect of such a facility.

That's the approach taken thus far.  Although non-blocking/access
notification will be opened up to normal users (currently even
notification is root only)

> For the superuser case the fact the daemon can be killed thus releasing
> anything stuff is analogous to umount -f of a stuck NFS mount which seems
> perfectly good for NFS.

It does work for NFS (which I would call case #1.)  I claim that it
doesn't work for this case since a global listener stuck would stop you
from running kill() since it owuldn't be able to get permission to open
it....

