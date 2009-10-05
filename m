Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZJEPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZJEPRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZJEPRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:17:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44126 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZJEPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:17:15 -0400
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
From: Andi Kleen <andi@firstfloor.org>
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
	<4AC990E1.7030708@jp.fujitsu.com>
	<c62985530910050151u78b46fa4l6ec0184f4f75be27@mail.gmail.com>
Date: Mon, 05 Oct 2009 17:16:37 +0200
In-Reply-To: <c62985530910050151u78b46fa4l6ec0184f4f75be27@mail.gmail.com>
 (=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker's message of "Mon, 5 Oct 2009
 10:51:46 +0200")
Message-ID: <87iqetyip6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker <fweisbec@gmail.com> writes:

> So the need is to have a more stable ring buffer. But this one is an ad-hoc one.

It was designed to do one job and does it well with minimal overhead.
That seems all positive to me.

> We already have a general purpose per-cpu/lockless ring buffer implementation in
> kernel/trace/ring_buffer.c
> And it's not only used by tracing, it's generally available.

That trace ring buffer is significantly larger than the all rest of the MCE 
code together:

andi@basil:~/lsrc/git/obj> size kernel/trace/ring_buffer.o 
   text    data     bss     dec     hex filename
  14241      21      12   14274    37c2 kernel/trace/ring_buffer.o
andi@basil:~/lsrc/git/obj> size arch/x86/kernel/cpu/mcheck/mce.o 
   text    data     bss     dec     hex filename
  11098    4480     224   15802    3dba arch/x86/kernel/cpu/mcheck/mce.o

Basically you're proposing to more than double the code footprint of the 
MCE handler for a small kernel configuration, just to avoid a few lines
of code.

It might be that all of its features are needed for tracing, but they
are definitely not needed for MCE handling and it would need 
to be put on a significant diet before core code like the MCE handler
could even think to start relying on it. In addition the ring-buffer.c
currently doesn't even directly do what mce needs and would need
significant glue code to fit into the existing interfaces and likely
modifications to the ring buffer itself too (e.g. to stop
trace_stop from messing with error handling)

Error handling code like the MCE handler has to be always compiled in
unlike tracing and other debugging options and I don't think it can
really afford to use such oversized code, especially since it doesn't
really need any of its fancy features.  Linux has enough problems with
code size growth recently, no need to make it worse with proposals
like this. Also the requirements of error handling are quite different
from other tracing and debugging and the ring-buffer doesn't even fit
well recently.

If the code should be converted to use a generic buffer kernel/kfifo.o
would be the right target and size:

andi@basil:~/lsrc/git/obj> size kernel/kfifo.o 
   text    data     bss     dec     hex filename
    734       0       0     734     2de kernel/kfifo.o

Unfortunately this needs Stefanie's lockless kfifo changes first to make 
happen and they didn't make it into 2.6.32-rc*

If they make it into 2.6.33 and there's really a strong desire to use
some generalized buffer I think that would be a suitable solution.
But frankly just keeping Ying's buffer around would also be quite reasonable

Short term Ying's simple alternative is the only good solution.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
