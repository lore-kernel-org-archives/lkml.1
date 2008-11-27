Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYK0V5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYK0V5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYK0V5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:57:16 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51440 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYK0V5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:57:15 -0500
Date: Thu, 27 Nov 2008 21:56:20 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
In-Reply-To: <492F0FEB.50805@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0811272136260.1747@blonde.site>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com> 
 <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
  <Pine.LNX.4.64.0811271349040.21910@blonde.site>
 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
 <Pine.LNX.4.64.0811271643250.9618@blonde.site> <492F0FEB.50805@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Pekka Enberg wrote:
> Hugh Dickins wrote:
> > Reverting my patch for now: that's certainly a reasonable possibility,
> > but leaves us with several other such bugs.  Suggested patch below,
> > but the ftrace part of it worries me a little, since it's within a
> > structure and maybe it's a bad idea to enlarge that at this point;
> > I've also not _really_ done the arithmetic needed for the slub one.
> 
> For SLUB, I think you can just replace the 100 with KSYM_NAME_LEN and it will
> work fine. The 100 constant is already supposed to be big enough to fit the
> symbol and the rest.

That would fix the bug that my sprint_symbol patch has exposed
(or introduced, according to your perspective!); but that 100 can only
be big enough to fit symbol and all the rest if you assume that maximum
symbol length is ... I'm not sure exactly ... somewhere around 20 bytes?

If we assume that, then why does KSYM_NAME_LEN allow 128?  I'll agree
that 128 seems rather on the high side (I'd abhor symbols of anywhere
near that length in any code I came near), but that's what's allowed,
so shouldn't SLUB be going along with that?

> 
> Hugh Dickins wrote:
> > An alternative quick just-for-now fix might be to remove that
> > 	namebuf[KSYM_NAME_LEN - 1] = 0;
> > from kallsyms_lookup(): as I understand it (please check), that
> > could only make sense in cases where the symbol is KSYM_NAME_LEN
> > long or longer - in which case, all of the places fixed in the
> > patch below would be causing corruption already, even without my
> > patch.  I think.  Maybe that "= 0" even serves no purpose at all?
> 
> I like this approach the best but I worry it's a can of worms especially this
> late in the cycle.
> 
> As a stop-gap measure, I'm fine with your proposed patch either as-is or with
> the suggestions I had for the SLUB case.

I'd be _much_ happier with my proposed patch if we get an Ack from
Steven on the ftrace.h part of it.

Hugh
