Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXCTEU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXCTEU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXCTEU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:20:58 -0400
Received: from ozlabs.org ([203.10.76.45]:48479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975AbXCTEU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:20:56 -0400
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
	callsites to make them patchable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
In-Reply-To: <45FF4043.4000805@vmware.com>
References: <20070316.023331.59468179.davem@davemloft.net>
	 <45FB005D.9060809@goop.org>
	 <1174127638.8897.75.camel@localhost.localdomain>
	 <20070318.003309.71088169.davem@davemloft.net>
	 <20070318120814.GA45869@muc.de>
	 <1174272469.11680.23.camel@localhost.localdomain>
	 <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
	 <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
	 <1174348905.11680.54.camel@localhost.localdomain>
	 <45FF4043.4000805@vmware.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 15:20:23 +1100
Message-Id: <1174364423.11680.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 18:00 -0800, Zachary Amsden wrote:
> Rusty Russell wrote:
> > *This* was the reason that the current hand-coded calls only clobber %
> > eax.  It was a compromise between native (no clobbers) and others (might
> > need a reg).
> 
> I still don't think this was a good trade.
...
> Xen no longer needs such a register

Hmm, well, if VMI is happy, Xen is happy, and lguest is happy, then
perhaps we're better off with a cc-only clobber rule?  Certainly makes
life simpler.

> > Now, since we decided to allow paravirt_ops operations to be normal C
> > (ie. the patching is optional and done late), we actually push and pop %
> > ecx and %edx.  This makes the call site 10 bytes long, which is a nice
> > size for patching anyway (enough for a movl $0, <addr>, a-la lguest's
> > cli, or movw $0, %gs:<addr> if we supported SMP).
> 
> You can do it in 11 bytes with no clobbers and normal C semantics by 
> linking to a direct address instead of calling to an indirect, but then 
> you need some gross fixup technology in paravirt_patch:
> 
> if (call_addr == (void*)native_sti) {
>   ...
> }

Well, I don't think we need such hacks: since we have to use handcoded
asm and mark the callsites anyway, marking what they're calling is
trivial.

The other idea from "btfixup" is that we can do the patching *much*
earlier, so we don't need the initial code to be valid at all if we
wanted to: we just need room to patch in a call insn.  We could then
generate trampolines which do the necessary pushes & pops automatically
for backends which want to use C calling conventions.

Perhaps it's time for code and benchmarks?

Rusty.

