Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYFPFiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYFPFiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYFPFiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:38:15 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:17284 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYFPFiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q3CqTC/DYdaA1lm+yelV0V4c9sX3jAZhPgxG2RzML818wFn90HeQRxJKFBzLSTa+l9
         n/b7D2JPASRa+LQS+JCxAXUKPeqOnx3lM/6iGc2D6I3kHcuytuT+jiGfEgzu1VpTNS0y
         AOkIliLKthan0YRGqG/KQbxdDRfgWQ37V2jmU=
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
From: Tom Zanussi <tzanussi@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       akpm@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
In-Reply-To: <84144f020806140916j7c39d3fr6ada38169ebc84c2@mail.gmail.com>
References: <20080613040958.4f52ee29@linux360.ro>
	 <1213417601.8237.37.camel@charm-linux>
	 <20080614181103.17617db1@linux360.ro>
	 <84144f020806140916j7c39d3fr6ada38169ebc84c2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 00:38:10 -0500
Message-Id: <1213594690.7744.49.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-14 at 19:16 +0300, Pekka Enberg wrote:
> On Fri, 13 Jun 2008 23:26:41 -0500
> Tom Zanussi <tzanussi@gmail.com> wrote:
> >> Alternatively, you could get rid of the problem by making sure CPU0
> >> never reads CPU1's data, by having the userspace reader use per-cpu
> >> threads and using sched_setaffinity() to pin each thread to a given
> >> cpu. See for example, the blktrace code, which does this.
> 
> On Sat, Jun 14, 2008 at 6:11 PM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > Yes, and performance-wise this is better. Though I'm not sure setting
> > affinity is 100% safe. Will the thread be migrated soon enough, so we
> > don't read cross-CPU? The point is I'm not sure how hard this is
> > enforced.
> >
> > However, I suggest this patch should go in, for two reasons:
> > 1. It provides expected behavior in any such situation.
> > 2. It adds (almost) no overhead when used in conjuction with setting CPU
> > affinity. When the writer acquires the spinlock, it does not busy-wait,
> > so the spinlock just disables IRQs (relay_write()).
> 
> Agreed. Tom, any objections to merging this patch?

Well, I suppose anyone who had a problem with it would make their own
local copy of relay_write() without it, or more likely they'd be using
relay_reserve() anyway.  It does add some code to read() which can't be
gotten around, but since it adds (almost) no overhead, it shouldn't be a
problem.

So I guess I don't have strong feelings about it if it's solving a real
usability problem and doesn't cause any performance (or other)
regressions.

Tom

