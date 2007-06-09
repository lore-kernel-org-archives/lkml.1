Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbXFINVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbXFINVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbXFINVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:21:13 -0400
Received: from lazybastard.de ([212.112.238.170]:48750 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbXFINVM (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:21:12 -0400
Date: Sat, 9 Jun 2007 12:37:07 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070609103706.GA29193@lazybastard.org>
References: <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com> <20070608161526.GA3729@infradead.org> <20070608175152.GG20718@lazybastard.org> <4669A831.3040105@de.ibm.com> <20070608193606.GH20718@lazybastard.org> <466A5CE3.7060307@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466A5CE3.7060307@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 June 2007 09:55:15 +0200, Carsten Otte wrote:
> Jörn Engel wrote:
> 
> >Either that or using standard mtd->read() and mtd->write() calls.  I see
> >some advantages to mtd->write() in particular, as the device driver
> >needs some notification to trigger unmap_page_range() before the actual
> >write and chip state transitions happen.  mtd->write() seems much easier
> >than something like
> >
> >mtd->pre_write()
> >get_xip_page()
> >...
> >put_page()
> >mtd->post_write()
> >
> >If get_xip_page() only has userland consumers all the locking can be
> >kept inside device drivers.
> Hmmh. We won't need mtd->pre_write(), because the file system's 
> get_xip_page aop will have to ask mtd for the address anyway similar 
> to the way ext2_get_xip_page does call bdev_ops->direct_access.
> 
> If that call would pass the information whether the future access is 
> read-only or read+write, the device driver could do its housekeeping.
> 
> I think we should also cover put_page() plus mtd->post_write() inside 
> a put_xip_page() address space operation provided by the fs. This way 
> calls are balanced, and we have stuff in a single place rather then 
> duplicating code. The fs could rely on a generic implementation in 
> filemap_xip in case it does'nt need to do its own magic here.

That sounds like an awefully long critical section.  Remember, while the
write is going on (the chip isn't in read_array mode) the cannot be any
xip pages used anywhere in the system.  All existing mapping have to be
revoked and no new mappings created handed out while this goes on.

If we use a single call like mtd->write(), this critical section is
limited to one call and the device driver can keep it as short as
possible.  Having two calls and allowing crappy filesystems to spend a
long time between them... ugh.

Another thing that just dawned upon me is that the device driver must be
in control of xip.  You can partition a single chip and use two
filesystems on it.  If one fs is xip-aware and the other is, say, jffs2,
only the device driver can revoke mapping when jffs2 writes to the chip.

> >>- the device driver can access page->count via a helper function 
> >>provided by mm. This way, it can identify which pages are in use.
> >
> >One of us is confused here.  The driver would have to check page->count
> >for a large range of pages, usually the whole chip.  And it would have
> >to tear down every single mapping before starting to write.  Is that
> >possible and desirable to do with page->count?  Unsure.
> That point was indeed confusing. Let my try again:

You obviously have more experience with xip and quickly go into details
I don't understand yet.  So before I try to decipher your explanation
again, let me give you a very high level picture.  Something simple
enough for me to understand. :)

Fundamentally four kinds of functionality are required:
1 Handing out new xip pages for userspace.
2 Destroying xip pages for userspace.
3 Temporarily revoking any pages given out for current writes.
4 Handling page faults on revoked pages.
5 Reenabling revoked pages.

AFAICS, 1 and 2 are required for dcss xip as well.  3 is new and only
necessary for flash.  4 should be mostly old, 5 again is new.

Most likely 3 will require a TLB flush on most architectures plus some
provisions that page faults on the xip pages are handled by putting the
processes on a wait queue, done in 4.  5 will remove those provisions
again, wake everything on the waitqueue and allow userspace to proceed
accessing xip pages.

Roughly sane?

Jörn

-- 
To announce that there must be no criticism of the President, or that we
are to stand by the President, right or wrong, is not only unpatriotic
and servile, but is morally treasonable to the American public.
-- Theodore Roosevelt, Kansas City Star, 1918
