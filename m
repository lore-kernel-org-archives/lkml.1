Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZDXMiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZDXMiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZDXMh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:37:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59431 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZDXMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:37:55 -0400
Date: Fri, 24 Apr 2009 13:23:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
 synchronization logic
In-Reply-To: <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
  <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu> 
 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com> 
 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
 <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Dmitry Adamushko wrote:
> 2009/4/23 Hugh Dickins <hugh@veritas.com>:
> >
> > I guess your mutex Synchronization works out, but are interrupts
> > still disabled around the critical wrmsr()s, wherever they're getting
> > called from?
> 
> Yes, *msr() calls are only done from functions that are now being
> called via smp_call_function_single(). The later seems to always do it
> with disabled interrupts. The only exception is mc_sysdev_resume()
> calling  ->apply_microcode() directly but this one in turn is always
> called with disabled interrupts.
> 
> But now that you mentioned it I wonder if we may actually need a
> spinlock there... can we have multi-threaded cpus/cores with (all |
> some) shared msr registers?

Good thinking, yes we can and do, unless I'm misinterpreting the
evidence.  Though P4 Xeon and Atom startup messages give the opposite
impression, claiming to update all cpus from lower revision, more
careful tests starting from "maxcpus=1" and then "echo 1 >online"
(which, unless you've fiddled around putting the microcode_ctl'ed
microcode.dat into /lib/firmware/intel-ucode/wherever, isn't able
to update at online time on Intel) shows that the later onlined
siblings already have the updated microcode applied to their
previously onlined siblings.  Which isn't surprising, but I'd
been lulled into thinking the opposite by the startup sequence.

Please add "HT versus not" to my earlier list of confusions.

microcode_mutex still covers most cases: is it the case of onlining
two threads at the same time that slips through?  Is that permitted
at the outer level?  Though even if it is, I'd feel safest to have
the spin_lock_irqsaves back (or if not, comment to say why not needed).

Hugh
