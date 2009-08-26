Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZHZVOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZHZVOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZHZVOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbZHZVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:14:08 -0400
Date: Wed, 26 Aug 2009 23:14:00 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
Message-ID: <20090826211400.GE14722@random.random>
References: <20090825145832.GP14722@random.random>
 <20090825152217.GQ14722@random.random>
 <Pine.LNX.4.64.0908251836050.30372@sister.anvils>
 <20090825181019.GT14722@random.random>
 <Pine.LNX.4.64.0908251958170.5871@sister.anvils>
 <20090825194530.GU14722@random.random>
 <Pine.LNX.4.64.0908261910530.15622@sister.anvils>
 <20090826194444.GB14722@random.random>
 <Pine.LNX.4.64.0908262048270.21188@sister.anvils>
 <4A95A10C.5040008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A95A10C.5040008@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 11:54:36PM +0300, Izik Eidus wrote:
> But before getting into this, why is it so important to break the ksm 
> pages when madvise(UNMERGEABLE) get called?

The moment ksm pages are swappable, there's no apparent reason why
anybody should ask the kernel to break any ksm page if the application
themselfs aren't writing to them in the first place (triggering
copy-on-write in app context which already handles TIF_MEMDIE just
fine).

In oom deadlock terms madvise(UNMERGEABLE) is the only place that is
100% fine at breaking KSM pages, because it runs with right tsk->mm
and page allocation will notice TIF_MEMDIE set on tsk.

If we remove "echo 2" only remaining "unsafe" spot is the break_cow in
kksmd context when memcmp fails and similar during the scan.

> When thinking about it, lets say I want to use ksm to scan 2 
> applications and merged their STATIC identical data, and then i want to 
> stop scanning them after i know ksm merged the pages, as soon as i will 
> try to unregister this 2 applications ksm will unmerge the pages, so we 
> dont allow such thing for the user (we can tell him ofcurse for such 
> case to use normal way of sharing, so this isnt a really strong case for 
> this)

For the app it will be tricky to know when the pages are merged
though, right now it could only wait a "while"... so I don't really
see madvise(UNMERGEABLE) as useful regardless how we implement
it... but then this goes beyond the scope of this bug because as said
madvise(UNMERGEABLE) is the only place that breaks ksm pages as safe
as regular write fault in oom context because of it running in the
process context (not echo 2 or kksmd context).
