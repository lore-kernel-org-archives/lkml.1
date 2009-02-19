Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZBSKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZBSKeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZBSKeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:34:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:50242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZBSKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:33:59 -0500
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order
 violations.
From: Peter Zijlstra <peterz@infradead.org>
To: krh@bitplanet.net
Cc: eric@anholt.net, Wang Chen <wangchen@cn.fujitsu.com>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1235035145.4612.38.camel@laptop>
References: <499BC08C.5000603@cn.fujitsu.com>
	 <1234975113-4941-1-git-send-email-krh@bitplanet.net>
	 <1235035145.4612.38.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Feb 2009 11:33:21 +0100
Message-Id: <1235039601.4612.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 10:19 +0100, Peter Zijlstra wrote:
> On Wed, 2009-02-18 at 11:38 -0500, krh@bitplanet.net wrote:
> > From: Kristian Høgsberg <krh@redhat.com>
> > 
> > A number of GEM operations (and legacy drm ones) want to copy data to
> > or from userspace while holding the struct_mutex lock.  However, the
> > fault handler calls us with the mmap_sem held and thus enforces the
> > opposite locking order.  This patch downs the mmap_sem up front for
> > those operations that access userspace data under the struct_mutex
> > lock to ensure the locking order is consistent.
> > 
> > Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> > ---
> > 
> > Here's a different and simpler attempt to fix the locking order
> > problem.  We can just down_read() the mmap_sem pre-emptively up-front,
> > and the locking order is respected.  It's simpler than the
> > mutex_trylock() game, avoids introducing a new mutex.
> > 

OK let me try that again -- my initial response was a tad curt :/

While I appreciate your efforts in fixing GEM (I too have an interest in
seeing it done), I cannot support your patch.

Firstly, you're using mmap_sem well outside its problem domain, this is
bad form. Furthermore, holding it for extended durations for no good
reason affects all other users.

Secondly, mmap_sem is not a recursive lock (very few kernel locks are,
and we generally frown upon recursive locking schemes), this means that
the fault handler still cannot function properly.




