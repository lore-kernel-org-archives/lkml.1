Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXDLXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXDLXQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXDLXQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:16:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42317
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932386AbXDLXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:16:22 -0400
Date: Thu, 12 Apr 2007 16:16:23 -0700 (PDT)
Message-Id: <20070412.161623.71575524.davem@davemloft.net>
To: paulus@samba.org
Cc: torvalds@linux-foundation.org, jeremy@goop.org, zach@vmware.com,
       rusty@rustcorp.com.au, ebiederm@xmission.com, ak@muc.de, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
From: David Miller <davem@davemloft.net>
In-Reply-To: <17920.30274.608018.34484@cargo.ozlabs.ibm.com>
References: <45FF770C.7050301@goop.org>
	<Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org>
	<17920.30274.608018.34484@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Wed, 21 Mar 2007 11:03:14 +1100

> Linus Torvalds writes:
> 
> > We should just do this natively. There's been several tests over the years 
> > saying that it's much more efficient to do sti/cli as a simple store, and 
> > handling the "oops, we got an interrupt while interrupts were disabled" as 
> > a special case.
> > 
> > I have this dim memory that ARM has done it that way for a long time 
> > because it's so expensive to do a "real" cli/sti.
> > 
> > And I think -rt does it for other reasons. It's just more flexible.
> 
> 64-bit powerpc does this now as well.

I was curious about this so I had a look.

There appears to be three pieces of state used to manage this
on powerpc, PACASOFTIRQEN(r13), PACAHARDIRQEN(r13) and the
SOFTE() in the stackframe.

Plus there is all of this complicated logic on trap entry and
exit to manage these three values properly.

local_irq_restore() doesn't look like a simple piece of code
either.  Logically it should be simple, update the software
binary state, and if enabling see if any interrupts came in
while we were disable so we can run them.

Given all of that, is it really cheaper than just flipping the
bit in the cpu control register? :-/
