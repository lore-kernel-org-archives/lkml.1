Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYGJNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYGJNuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYGJNt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:49:59 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58459 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbYGJNt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:49:58 -0400
Subject: Re: [RFC] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 08:49:54 -0500
Message-Id: <1215697794.3353.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 22:29 -0400, Frank Ch. Eigler wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > I've been looking at using the existing in kernel markers for dtrace
> > named probing in systemtap.  What I find is that they're a bit
> > heavyweight when compared to what dtrace does (because of the way
> > they drop stubbable calling points).
> 
> > This patch adds incredibly simple markers which are designed to be used
> > via kprobes [+ dwarf].  [...]
> 
> > [...]  The disadvantage is that it's really unusable for rolling
> > your own marker probes because it relies on the dwarf2 information
> > to locate the probe point for kprobes and unravel the local
> > variables of interest, so you need an external tool like systemtap
> > to help you. [...]
> 
> Another disadvantage is one that came up earlier when markers were
> initially thought up: that something so invisible to the compiler (no
> code being generated in the instruction stream, after optimization,
> may be impossible to locate: not just the statement but also the
> putative parameters.

Actually, I listed that one as an advantage.  But, in order to be
completely zero impact, the probe cannot interfere with optimisation,
and so you run the risk of having the probe point do strange things
(like it's in the middle of a loop that gets unrolled) or that the
variables you want to advertise get optimised away.

All of this is mitigated by correct selection of the probe points and
the variables.

> Long ago, someone proposed inserting an asm("nop") mini-markers into
> the instruction stream, which could then be used as an anchor to tie a
> kprobe to, so that would solve the statement-location problem.

But you don't need a nop ... you just need a line number.

> But it doesn't help assure that the parameters will be available in
> dwarf, so someone else proposed adding another asm that just asks the
> parameters to be evaluated and placed *somewhere*.  Each asm input
> constraint was to be the loosest possible, so as to not force the
> compiler to put the values into registers (and evict their normal
> tracing-ignorant tenants).

Actually, it does.  Assuming the probe is placed in the code by someone
who knows what they're doing and is using it, you can ensure that what
you're advertising actually exists.  If you look at the SCSI example I
gave, both the probe points and the variables actually exist, and will
continue to exist because of what they are and where they're placed.

> I believe this combination was never actually built/tested, partly
> because people realized that then the compiler would always have to
> evaluate parameters unconditionally, whether or not a kprobe is
> present.  (To do it otherwise would IIRC require the asm code to
> include control-flow-modification instructions, which would surprise
> gcc.)
> 
> So that's roughly how we arrived at recent markers.  They expose to
> the compiler the parameters, but arrange not to evaluate them unless
> necessary.  The most recent markers code patches nops over most or all
> the hot path instructions, so there is no tangible performance impact.

Yes there are.  There are actually two performance impacts:

     1. The nops themselves take cycles to execute ... small, granted,
        but it adds up with lots of probe points
     2. The probes interfere with optimisation since to replace them
        with a function call, they must be barriers.

I didn't say use simple probes to replace markers ... I just said it's
an alternative for things like I/O subsystems that don't want the
perturbation.

James


