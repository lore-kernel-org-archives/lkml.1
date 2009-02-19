Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZBSPRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZBSPRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbZBSPRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:17:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:52557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115AbZBSPRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:17:04 -0500
Date: Thu, 19 Feb 2009 16:17:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, krh@bitplanet.net, eric@anholt.net,
       Wang Chen <wangchen@cn.fujitsu.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order violations.
Message-ID: <20090219151701.GG1747@wotan.suse.de>
References: <499BC08C.5000603@cn.fujitsu.com> <1234975113-4941-1-git-send-email-krh@bitplanet.net> <1235035145.4612.38.camel@laptop> <1235039601.4612.45.camel@laptop> <1235054980.31384.16.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235054980.31384.16.camel@gaara.bos.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 09:49:40AM -0500, Kristian Høgsberg wrote:
> 
> > Secondly, mmap_sem is not a recursive lock (very few kernel locks are,
> > and we generally frown upon recursive locking schemes), this means that
> > the fault handler still cannot function properly.
> 
> I understand, but we take it twice only as a read lock, so that should
> work, right?  We prevent the deadlock the lockdep validator warned about
> and as far as I can see, the patch doesn't introduce a new one.  But
> other than that I agree with the frowning on recursive locking, it's too
> often used to paper over badly thought out locking.

It doesn't work. rwsems are fair (otherwise there is terrible starvation
properties), so if another process does an interleaved down_write, then
the 2nd down_read will block until the down_write is serviced.
