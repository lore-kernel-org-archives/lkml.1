Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYABE3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYABE3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYABE3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:29:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbYABE3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:29:02 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost Tracing
References: <20071231060911.GB6461@in.ibm.com>
	<20071231102045.GB30380@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 01 Jan 2008 22:31:21 -0500
In-Reply-To: <20071231102045.GB30380@elte.hu> (Ingo Molnar's message of "Mon, 31 Dec 2007 11:20:46 +0100")
Message-ID: <y0modc4vr7a.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]  Firstly, why on earth does a full format string have to be
> passed in for something as simple as a CPU id? This way we basically
> codify it forever that tracing _has_ to be expensive when
> enabled. [...]

FWIW, I'm not keen about the format strings either, but they don't
constitute a performance hit beyond an additional parameter.  It does
not need to actually get parsed at run time.


>[...]
> Secondly, the inlined overhead of trace_mark() is still WAY too large:
>
>                 if (unlikely(__mark_##name.state)) {                    \
> [...]
>                 }                                                       \

Note that this is for the unoptimized case.  The immediate-value code
is better.  I have still yet to see some good measurements of how much
the overheads of the various variants are, however.  It's only fair to
gather these numbers and continue the debate with them in hand.


> Whatever became of the obvious suggestion that i outlined years ago,
> to have a _single_ trace call instruction and to _patch out_ the
> damn marker calls by default?  [...]  only leaving a ~5-byte NOP
> sequence behind them (and some minimal disturbance to the variables
> the tracepoint accesses). [...]

This has been answered several times before.  It's because the marker
parameters have to be (conditionally) evaluated and pushed onto a call
frame.  It's not just a call that would need being nop'd, but a whole
function call setup/teardown sequence, which itself can be interleaved
with adjacent code.


- FChE
