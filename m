Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYGJCay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYGJCay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYGJCaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:30:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYGJCap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:30:45 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] simple dprobe like markers for the kernel
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 09 Jul 2008 22:29:16 -0400
In-Reply-To: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain> (James Bottomley's message of "Wed, 09 Jul 2008 16:22:31 -0500")
Message-ID: <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> I've been looking at using the existing in kernel markers for dtrace
> named probing in systemtap.  What I find is that they're a bit
> heavyweight when compared to what dtrace does (because of the way
> they drop stubbable calling points).

> This patch adds incredibly simple markers which are designed to be used
> via kprobes [+ dwarf].  [...]

> [...]  The disadvantage is that it's really unusable for rolling
> your own marker probes because it relies on the dwarf2 information
> to locate the probe point for kprobes and unravel the local
> variables of interest, so you need an external tool like systemtap
> to help you. [...]

Another disadvantage is one that came up earlier when markers were
initially thought up: that something so invisible to the compiler (no
code being generated in the instruction stream, after optimization,
may be impossible to locate: not just the statement but also the
putative parameters.

Long ago, someone proposed inserting an asm("nop") mini-markers into
the instruction stream, which could then be used as an anchor to tie a
kprobe to, so that would solve the statement-location problem.

But it doesn't help assure that the parameters will be available in
dwarf, so someone else proposed adding another asm that just asks the
parameters to be evaluated and placed *somewhere*.  Each asm input
constraint was to be the loosest possible, so as to not force the
compiler to put the values into registers (and evict their normal
tracing-ignorant tenants).

I believe this combination was never actually built/tested, partly
because people realized that then the compiler would always have to
evaluate parameters unconditionally, whether or not a kprobe is
present.  (To do it otherwise would IIRC require the asm code to
include control-flow-modification instructions, which would surprise
gcc.)

So that's roughly how we arrived at recent markers.  They expose to
the compiler the parameters, but arrange not to evaluate them unless
necessary.  The most recent markers code patches nops over most or all
the hot path instructions, so there is no tangible performance impact.


- FChE
