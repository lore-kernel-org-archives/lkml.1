Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0BINEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:04:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0BINEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:04:46 -0500
Subject: Re: [RFC][PATCH] perf_events: added new start/stop PMU callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901002080921p311e29fbmcdf0841b0af558a@mail.gmail.com>
References: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
	 <1265646612.11509.13.camel@laptop>
	 <bd4cb8901002080921p311e29fbmcdf0841b0af558a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 14:04:21 +0100
Message-ID: <1265720661.11509.245.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 18:21 +0100, Stephane Eranian wrote:
> 
> > But before we do that, I think we need to look at the /* hardware */
> > part of struct hw_perf_event, and make that arch specific, we've been
> > growing that a lot lately and I don't think !x86 uses any of that.

I looked at the pahole output:

$ pahole -C hw_perf_event build/arch/x86/kernel/cpu/perf_event.o
struct hw_perf_event {
        union {
                struct {
                        u64        config;               /*     0     8 */
                        u64        last_tag;             /*     8     8 */
                        long unsigned int config_base;   /*    16     8 */
                        long unsigned int event_base;    /*    24     8 */
                        int        idx;                  /*    32     4 */
                        int        last_cpu;             /*    36     4 */
                };                                       /*          40 */
                struct {
                        s64        remaining;            /*     0     8 */
                        struct hrtimer hrtimer;          /*     8    96 */
                        /* --- cacheline 1 boundary (64 bytes) was 40 bytes ago --- */
                };                                       /*         104 */
                union {
                        struct arch_hw_breakpoint info;  /*          24 */
                };                                       /*          24 */
        };                                               /*     0   104 */
        /* --- cacheline 1 boundary (64 bytes) was 40 bytes ago --- */
        atomic64_t                 prev_count;           /*   104     8 */
        u64                        sample_period;        /*   112     8 */
        u64                        last_period;          /*   120     8 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        atomic64_t                 period_left;          /*   128     8 */
        u64                        interrupts;           /*   136     8 */
        u64                        freq_time_stamp;      /*   144     8 */
        u64                        freq_count_stamp;     /*   152     8 */

        /* size: 160, cachelines: 3 */
        /* last cacheline: 32 bytes */
};

which suggests we still have plenty of room to grow without adding undue
overhead on other architectures, that struct hrtimer is the largest
thing in there.

> It is clear it will need to grow much more to host non-counting features.
> I have played with that myself a few weeks back. So, yes the saved state
> needs to be arch specific.

What do you mean by non-counting features?

