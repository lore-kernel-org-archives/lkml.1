Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZBSOuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZBSOuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZBSOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:49:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZBSOt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:49:59 -0500
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order
 violations.
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: krh@bitplanet.net, eric@anholt.net, Wang Chen <wangchen@cn.fujitsu.com>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1235039601.4612.45.camel@laptop>
References: <499BC08C.5000603@cn.fujitsu.com>
	 <1234975113-4941-1-git-send-email-krh@bitplanet.net>
	 <1235035145.4612.38.camel@laptop>  <1235039601.4612.45.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Feb 2009 09:49:40 -0500
Message-Id: <1235054980.31384.16.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 11:33 +0100, Peter Zijlstra wrote:
> On Thu, 2009-02-19 at 10:19 +0100, Peter Zijlstra wrote:
> > On Wed, 2009-02-18 at 11:38 -0500, krh@bitplanet.net wrote:
> > > From: Kristian Høgsberg <krh@redhat.com>
> > > 
> > > A number of GEM operations (and legacy drm ones) want to copy data to
> > > or from userspace while holding the struct_mutex lock.  However, the
> > > fault handler calls us with the mmap_sem held and thus enforces the
> > > opposite locking order.  This patch downs the mmap_sem up front for
> > > those operations that access userspace data under the struct_mutex
> > > lock to ensure the locking order is consistent.
> > > 
> > > Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> > > ---
> > > 
> > > Here's a different and simpler attempt to fix the locking order
> > > problem.  We can just down_read() the mmap_sem pre-emptively up-front,
> > > and the locking order is respected.  It's simpler than the
> > > mutex_trylock() game, avoids introducing a new mutex.
> > > 
> 
> OK let me try that again -- my initial response was a tad curt :/

No that's fair, I was aware that the patch was probably borderline and
got the feedback I was looking for ;)

> While I appreciate your efforts in fixing GEM (I too have an interest in
> seeing it done), I cannot support your patch.
> 
> Firstly, you're using mmap_sem well outside its problem domain, this is
> bad form. Furthermore, holding it for extended durations for no good
> reason affects all other users.

Yup, agree.

> Secondly, mmap_sem is not a recursive lock (very few kernel locks are,
> and we generally frown upon recursive locking schemes), this means that
> the fault handler still cannot function properly.

I understand, but we take it twice only as a read lock, so that should
work, right?  We prevent the deadlock the lockdep validator warned about
and as far as I can see, the patch doesn't introduce a new one.  But
other than that I agree with the frowning on recursive locking, it's too
often used to paper over badly thought out locking.

cheers,
Kristian


