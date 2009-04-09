Return-Path: <linux-kernel-owner+w=401wt.eu-S934771AbZDIPPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbZDIPPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933910AbZDIPPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:15:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbZDIPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:15:15 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
From: Andi Kleen <andi@firstfloor.org>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 09 Apr 2009 17:15:09 +0200
In-Reply-To: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> (Frederic Weisbecker's message of "Tue,  7 Apr 2009 04:19:49 +0200")
Message-ID: <87tz4x97uq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:
>
> So the new lock that replaces the bkl here is a per superblock mutex 

You have to be very careful with this. Mutexes can be slower than
spinlocks (and the new BKL is a spinlock) in some situations, they
typically schedule much more etc., which can be costly. So this might
have actually made it slower if you're unlucky.  There were some
experimental changes recently to make mutexes more behave like
spinlocks, but I don't think they're fully performance equivalent.

Better would be to use spinlocks if possible. I guess you just would
need to find all sleep points and wrap them with lock dropping?

> After this patch, reiserfs suffers from a slight performance regression (for now).

That might be related to the scheduling  behaviour. Watch the reschedule
counters in vmstat 1

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
