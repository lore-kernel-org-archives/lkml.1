Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0BJNFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:05:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0BJNFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:05:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HldODmZLzVWS07UKNnhLFLLml6KRvj4671mEebJrUo+bDqXj9BEof5skDcW4HqxS5
	3Xb7RZQrXxp68HpBxCiHw==
MIME-Version: 1.0
In-Reply-To: <1265803166.11509.286.camel@laptop>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
	 <1265803166.11509.286.camel@laptop>
Date: Wed, 10 Feb 2010 14:04:54 +0100
Message-ID: <bd4cb8901002100504i8e716e8ob845f692e031726f@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 12:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-08 at 17:17 +0200, Stephane Eranian wrote:
>>         This patch adds correct AMD Northbridge event scheduling.
>>         It must be applied on top tip-x86 + hw_perf_enable() fix.
>>
>>         NB events are events measuring L3 cache, Hypertransport
>>         traffic. They are identified by an event code  >= 0xe0.
>>         They measure events on the Northbride which is shared
>>         by all cores on a package. NB events are counted on a
>>         shared set of counters. When a NB event is programmed
>>         in a counter, the data actually comes from a shared
>>         counter. Thus, access to those counters needs to be
>>         synchronized.
>>
>>         We implement the synchronization such that no two cores
>>         can be measuring NB events using the same counters. Thus,
>>         we maintain a per-NB * allocation table. The available slot
>>         is propagated using the event_constraint structure.
>>
>>         The 2nd version takes into account the changes on how
>>         constraints are stored by the scheduling code.
>>
>>         The 3rd version fixes formatting issues, code readability
>>         and one bug in amd_put_event_constraints().
>>
>>         Signed-off-by: Stephane Eranian <eranian@google.com>
>
> OK, took this with the below merged in.
>
> ---
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -81,7 +81,7 @@ struct event_constraint {
>  };
>
>  struct amd_nb {
> -       int nb_id;  /* Northbridge id */
> +       int nb_id;  /* NorthBridge id */
>        int refcnt; /* reference count */
>        struct perf_event *owners[X86_PMC_IDX_MAX];
>        struct event_constraint event_constraints[X86_PMC_IDX_MAX];
> @@ -2268,7 +2268,7 @@ static inline int amd_is_nb_event(struct
>        u64 val = hwc->config & K7_EVNTSEL_EVENT_MASK;
>        /* event code : bits [35-32] | [7-0] */
>        val = (val >> 24) | (val & 0xff);
> -       return val >= 0x0e0;
> +       return val >= 0xe00;
>  }
>
I don't understand the change from 0xe0 to 0xe00.
That's not the same thing at all.
Event select is bits 0-7 + 32-35.
