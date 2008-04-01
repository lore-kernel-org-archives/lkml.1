Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYDALMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYDALMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbYDALMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:12:16 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:13931 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbYDALMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:12:15 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
	<Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz>
	<20080401083359.GB32272@elte.hu>
	<Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Apr 2008 13:12:09 +0200
In-Reply-To: <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz>
Message-ID: <874pal25iu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Apr 2008 11:05:32.0400 (UTC) FILETIME=[4D9EAF00:01C893E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:
> 
> In fact we have received report from one of our users that he is seeing 
> approximately 15% performance degradation of mmap() when spinlocks are not 
> inlined. I am going to do some performance measurements myself shortly, as 
> it seems quite strange, but while at it, I have noticed the aforementioned 
> asymetry in spinlock.h, so I just wanted to know if there is any 
> particular reason behind that.

At some point -- but that was before queued locks -- I noticed that
for i386 spin unlocks the call sequence for the sub function is
actually larger in code than the actual spin unlock operation and for
x86-64 it was about the same. That was not even counting any negative
register allocation effects the call has on the caller. Spinlocks
don't clobber a lot of registers, but the compiler doesn't know that
when calling the function so it has to assume all ABI callee clobbered
are gone.

I didn't do anything back then because at this point Ingo was
reorganizing the spinlock code hourly[1] for his lockdep etc. merge and
wanted to wait for it to settle down and then it dropped from 
the radar.

Anyways without queued spinlocks that has probably changed again,
might be still worth rechecking.

-Andi

[1] ok I'm exaggerating...
