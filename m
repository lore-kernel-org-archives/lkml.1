Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYAVAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYAVAVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYAVAVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:21:12 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35204 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752994AbYAVAVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:21:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sQ4U4dmP8Tbb7ATwacub1KUWXkoYHN5qT9kzQhki73z1qycBXMmHfMbA4JntQ48xEC+C2Joox4OXvRo+JTulUlX3SqBLjjYZfkzcyXJxYDeMyICLSH4uUu8W7dNlg7S9wzEelXBi/QUmgG07ehaZR2DPuwUX4CFNuyp6byrdapw=  ;
X-YMail-OSG: XsJ39ZQVM1l3hhkkUCu2TqRkK65EjOWKn4wldZaqEeHytYVuz2YXylY.Oq2KSV3fxVezljqXBA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 12/23 -v4] Use RCU algorithm for monotonic cycles.
Date: Tue, 22 Jan 2008 11:20:58 +1100
User-Agent: KMail/1.9.5
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       John Stultz <johstul@us.ibm.com>, Steven Rostedt <srostedt@redhat.com>
References: <20080121152231.579118762@goodmis.org> <20080121152352.789802471@goodmis.org>
In-Reply-To: <20080121152352.789802471@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221120.59792.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 02:22, Steven Rostedt wrote:
> From: john stultz <johnstul@us.ibm.com>

>  static inline cycle_t
> -clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> +clocksource_get_basecycles(struct clocksource *cs)
>  {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> -	offset += cs->cycle_accumulated;
> +	int num;
> +	cycle_t now, offset;
> +
> +	preempt_disable();
> +	num = cs->base_num;
> +	smp_read_barrier_depends();

All barriers need comments in the code. eg. with read barriers, the
comment should contain a list of the loads being ordered, and a
reference to the places where stores come from.

I know it isn't too hard to follow _now_, but it makes the code more
maintainable.


> +	now = clocksource_read(cs);
> +	offset = (now - cs->base[num].cycle_base_last);
> +	offset &= cs->mask;
> +	offset += cs->base[num].cycle_base;
> +	preempt_enable();
> +
>  	return offset;
>  }
>
> @@ -197,14 +215,26 @@ clocksource_get_cycles(struct clocksourc
>   * @now:	current cycle value
>   *
>   * Used to avoids clocksource hardware overflow by periodically
> - * accumulating the current cycle delta. Must hold xtime write lock!
> + * accumulating the current cycle delta. Uses RCU-like update, but
> + * ***still requires the xtime_lock is held for writing!***
>   */
>  static inline void clocksource_accumulate(struct clocksource *cs, cycle_t
> now) {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> +	/* First update the monotonic base portion.
> +	 * The dual array update method allows for lock-free reading.
> +	 */
> +	int num = 1 - cs->base_num;
> +	cycle_t offset = (now - cs->base[1-num].cycle_base_last);
> +	offset &= cs->mask;
> +	cs->base[num].cycle_base = cs->base[1-num].cycle_base + offset;
> +	cs->base[num].cycle_base_last = now;
> +	wmb();
> +	cs->base_num = num;

Ditto for the wmb. Also, I think the wmb() can probably just be
smp_wmb().
