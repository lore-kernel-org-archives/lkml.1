Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYAJDaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYAJDaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYAJDaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:30:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:23753 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYAJD37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:29:59 -0500
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080109233044.777564395@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.777564395@goodmis.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 19:28:20 -0800
Message-Id: <1199935701.18203.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:29 -0500, Steven Rostedt wrote:
> +cycle_t notrace get_monotonic_cycles(void)
> +{
> +       cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> +
> +       do {
> +               /*
> +                * cycle_raw and cycle_last can change on
> +                * another CPU and we need the delta calculation
> +                * of cycle_now and cycle_last happen atomic, as well
> +                * as the adding to cycle_raw. We don't need to grab
> +                * any locks, we just keep trying until get all the
> +                * calculations together in one state.
> +                *
> +                * In fact, we __cant__ grab any locks. This
> +                * function is called from the latency_tracer which can
> +                * be called anywhere. To grab any locks (including
> +                * seq_locks) we risk putting ourselves into a deadlock.
> +                */
> +               cycle_raw = clock->cycle_raw;
> +               cycle_last = clock->cycle_last;
> +
> +               /* read clocksource: */
> +               cycle_now = clocksource_read(clock);
> +
> +               /* calculate the delta since the last update_wall_time: */
> +               cycle_delta = (cycle_now - cycle_last) & clock->mask;
> +
> +       } while (cycle_raw != clock->cycle_raw ||
> +                cycle_last != clock->cycle_last);
> +
> +       return cycle_raw + cycle_delta;
> +}

The last I check this changed caused problems for me with the -rt
latency tracer.. I haven't tested this tree , but all things being equal
I would imagine the exists here also..

Daniel

