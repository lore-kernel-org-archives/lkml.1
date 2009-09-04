Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbZIDI0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbZIDI0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZIDI0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:26:13 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52243 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127AbZIDI0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:26:11 -0400
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak
	reports
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1252040671.9336.10.camel@johannes.local>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
	 <1251962791.3336.3.camel@johannes.local>
	 <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
	 <1252001837.9336.2.camel@johannes.local>  <20090903204319.GC3701@mosca>
	 <1252040671.9336.10.camel@johannes.local>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 04 Sep 2009 09:25:57 +0100
Message-Id: <1252052757.26413.9.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2009 08:25:58.0234 (UTC) FILETIME=[5430A3A0:01CA2D39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 07:04 +0200, Johannes Berg wrote:
> On Thu, 2009-09-03 at 13:43 -0700, Luis R. Rodriguez wrote:
> > On Thu, Sep 03, 2009 at 11:17:17AM -0700, Johannes Berg wrote:
> > > On Thu, 2009-09-03 at 11:13 -0700, Luis R. Rodriguez wrote:
> > > 
> > > > What I meant is it gobbles it up and spits another thing out. When it
> > > > gobbles it up the routine then uses kref_put().
> > > > 
> > > > > Why can it not track this?
> > > > 
> > > > It probably can, just not sure if it follows kref_put(), I was under
> > > > the impression here it doesn't and because of it we were getting false
> > > > positives. Catalin, can you confirm?
> > > 
> > > Ah I'd think that if it can't track it then that's because we use a
> > > pointer to the middle of the struct to keep track of it much of the
> > > time.
> > 
> > So you agree with the patch but not the commit log entry?
> 
> I'm not sure -- I think kmemleak should be able to figure it out, and if
> you were using IBSS then we actually have a leak that we need to plug,
> but otherwise I'd prefer to get some more input from Catalin first.

First of all, kmemleak_ignore() is not the right function to mark a
false positive as it completely ignores an object even though it may
have pointers to others. The kmemleak_not_leak() function should be
used. However, there are only two places in the kernel where this was
actually needed (one of them is a real leak but we ignore it as it makes
the code more complicated).

So, I think we should try to figure out why kmemleak reports it. There
are a few common cases:
     1. transient false positive - this should disappear after a few
        scans
     2. a pointer leading to the reported object is stored in an area of
        memory not scanned by kmemleak - most commonly pages allocated
        explicitly (alloc_pages etc.) as kmemleak doesn't track these.
        The preferred solution is to inform kmemleak about such page
        (kmemleak_alloc/kmemleak_free) rather than marking the false
        positive
     3. a pointer leading to the reported object isn't actually pointing
        to anywhere inside the structure (i.e. using the physical
        address). Here we would use kmemleak_not_leak()

> Catalin, is it conceivable that kmemleak reports false positives if we
> use a struct like
> 
> struct pubbss {
> ...
> };
> 
> struct bss {
> ...
> struct pubbss pub;
> };
> 
> and then keep track of &bss->pub; pointers instead of bss directly?

It should not report  false positive here. That's a pretty common case
with struct list_head, struct device etc. and kmemleak handles them
properly - if there is a memory location pointing to *anywhere* inside a
structure, the object is considered referenced and not reported.

-- 
Catalin

