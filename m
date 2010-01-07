Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886Ab0AGKB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0AGKB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434Ab0AGKBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:01:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0AGKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:01:54 -0500
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <bd4cb8901001070154x84a569t71ac317c95eb4683@mail.gmail.com>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop> <20091222010238.GB31264@drongo>
	 <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
	 <20100107041340.GA30718@drongo> <1262854826.4049.91.camel@laptop>
	 <bd4cb8901001070154x84a569t71ac317c95eb4683@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 11:01:06 +0100
Message-ID: <1262858466.4049.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 10:54 +0100, Stephane Eranian wrote:
> 
> Ok, so I made some progress yesterday on all of this.
> 
> The key elements are:
>   -  pmu->enable() is always called from generic with PMU disabled
>   -  pmu->disable() is called with PMU possibly enabled
>   - hw_perf_group_sched_in() is always called with PMU disabled
> 
> I got the n_added logic working now on X86.
> 
> I noticed the difference in pmu->enabled() between Power and X86.
> On PPC, you disable the whole PMU. On X86, that's not the case.
> 
> Now, I do the scheduling in hw_perf_enable(). Just like on PPC, I also
> move events around if their register assignment has changed. It is not
> quite working yet. I must have something wrong with the read and rewrite
> code.
> 
> I will experiment with pmu->enable(). Given the key elements above, I think
> Paul is right, all scheduling can be deferred until hw_perf_enable().
> 
> But there is a catch. I noticed that hw_perf_enable() is void. In
> other words, it
> means that if scheduling fails, you won't notice. This is not a problem on PPC
> but will be on AMD64. That's because the scheduling depends on what goes on
> on the other cores on the socket. In other words, things can change between
> pmu->enable()/hw_perf_group_sched_in() and hw_perf_enable(). Unless we lock
> something down in between. 

You have to lock stuff, you can't fail hw_perf_enable() because at that
point we've lost all track of what failed.



