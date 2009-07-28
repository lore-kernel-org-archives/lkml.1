Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZG1QOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZG1QOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZG1QOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:14:42 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:29964 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZG1QOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:14:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOTAbkqrR7PD/2dsb2JhbAC9U4gnj3oFhAyCLw
X-IronPort-AV: E=Sophos;i="4.43,284,1246838400"; 
   d="scan'208";a="190378576"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jsquyres@cisco.com, rostedt@goodmis.org
Subject: Re: [PATCH v2] ummunotify: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
	<adad47smsb5.fsf@cisco.com>
	<20090722124208.97d7d9d7.akpm@linux-foundation.org>
	<adaeis53d2m.fsf_-_@cisco.com>
	<20090727165329.4acfda1c.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Jul 2009 09:14:40 -0700
In-Reply-To: <20090727165329.4acfda1c.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 27 Jul 2009 16:53:29 -0700")
Message-ID: <adaws5szswf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jul 2009 16:14:41.0080 (UTC) FILETIME=[8303E380:01CA0F9E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > +config UMMUNOTIFY
 > > +       tristate "Userspace MMU notifications"
 > > +       select MMU_NOTIFIER

 > Does `select' dtrt here if UMMUNOTIFY=m?  I never trust it...

Yes, it appears to when I test... and all the other users (KVM, SGI_GRU)
of MMU_NOTIFIER are tristates that select it, so in practice it seems to
work as well.

 > <searches in vain for ummunotify.txt>
 > 
 > Oh well :(
 > 
 > A little test app would be nice - I assume you have one.  We could toss
 > in in the tree as a how-to-use example, and people could perhaps turn
 > it into a regression test - perhaps the LTP people would take it.

I'll write up a bit of doc and stick it in Documentation/ummunotify.txt,
and create samples/ummunotify/ as well for the next iteration.

 > > +			if (test_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags)) {
 > > +				clear_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
 > > +			} else {
 > > +				set_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);

 > It's a shame that change_bit() didn't return the old (or new) value.

Heh, I didn't know about change_bit().  <looks> ... seems like
test_and_change_bit() is exactly what would fit here.  Will update.

 > The overall userspace interface seems a bit klunky, but I can't really
 > suggest anything better.  Netlink delivery?

I took a quick look at netlink but discarded the idea when I saw that
netlink sockets don't support mmap() ... seems that plumbing in mmap
support (to handle the kernel exported generation count) is probably
more trouble than it's worth, and I'm not sure that all the netlink
encapsulation is that much of a win here anyway.  I'd prefer to proceed
with the "virtual character device" interface -- another option would be
sys_ummunotify_create and sys_ummunotify_ctl but I can't really imagine
this being worth another couple syscalls.

 - R.
