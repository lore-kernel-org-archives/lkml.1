Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0BJLbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:31:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41082 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0BJLbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:31:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=yGKPAE7y1+vKv7ADKM0lcas3fq2wRFVdqhbXD9yUV83UYNEMqpP23hRLiXOvCsXmT
	FM52NXpxseQYAHgkBhuBA==
MIME-Version: 1.0
Date: Wed, 10 Feb 2010 12:31:16 +0100
Message-ID: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
Subject: [RFC] perf_events: how to add Intel LBR support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Intel Last Branch Record (LBR) is a cyclic taken branch buffer hosted
in registers. It is present in Core 2, Atom, and Nehalem processors. Each
one adding some nice improvements over its predecessor.

LBR is very useful to capture the path that leads to an event. Although
the number of recorded branches is limited (4 on Core2 but 16 in Nehalem)
it is very valuable information.

One nice feature of LBR, unlike BTS, is that it can be set to freeze on PMU
interrupt. This is the way one can capture a path that leads to an event or
more precisely to a PMU interrupt.

I started looking into how to add LBR support to perf_events. We have LBR
support in perfmon and it has proven very useful for some measurements.

The usage model is that you always couple LBR with sampling on an event.
You want the LBR state dumped into the sample on overflow. When you resume,
after an overflow, you clear LBR and you restart it.

One obvious implementation would be to add a new sample type such as
PERF_SAMPLE_TAKEN_BRANCHES. That would generate a sample with
a body containing an array of 4x2 up to 16x2 u64 addresses. Internally, the
hw_perf_event_structure would have to store the LBR state so it could be
saved and restored on context switch in per-thread mode.

There is one problem with this approach. On Nehalem, the LBR can be configured
to capture only certain types of branches + priv levels. That is about
8 config bits
+ priv levels. Where do we pass those config options?

One solution would have to provide as many PERF_SAMPLE bits as the hardware
OR provide some config field for it in perf_event_attr. All of this
would have to
remain very generic.

An alternative approach is to define a new type of (pseudo)-event, e.g.,
PERF_TYPE_HW_BRANCH and provide variations very much like this is
done for the generic cache events. That event would be associated with a
new fixed-purpose counter (similar to BTS). It would go through scheduling
via a specific constraint (similar to BTS). The hw_perf_event structure
would provide the storage area for dumping LBR state.

To sample on LBR with the event approach, the LBR event would have to
be in the same event group. The sampling event would then simply add
sample_type = PERF_SAMPLE_GROUP.

The second approach looks more extensible, flexible than the first one. But
it runs into a major problem with the current perf_event API/ABI and
implementation. The current assumption is that all events never return more
than 64-bit worth of data. In the case of LBR, we would need to return way
more than this.

A long time ago, I mentioned LBR as a key feature to support but we never
got to a solution as to how to support it with perf_events.

What's you take on this?
