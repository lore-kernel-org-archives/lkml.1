Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXFDWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXFDWI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXFDWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:08:21 -0400
Received: from gw.goop.org ([64.81.55.164]:39169 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbXFDWIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:08:21 -0400
Message-ID: <46648D4A.3070603@goop.org>
Date: Mon, 04 Jun 2007 15:08:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: use iret directly where possible
References: <46646662.9020707@goop.org> <200706042305.05340.ak@suse.de> <4664841A.8040802@goop.org> <200706042346.55049.ak@suse.de>
In-Reply-To: <200706042346.55049.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Ah I assumed the hypervisor would just check IF in ring 1 too.
> It would certainly make this easier, but then the additional trap
> of setting it would be also somewhat expensive agreed.
>   

Xen doesn't do that because, while it could track sti/cli (expensively),
iret and popf quietly ignore the IF state in ring 1, and so there's lots
of scope for interrupt state getting lost.

> I must say I still hate the patch; it has all the signs of something that
> will be very nasty to maintain later.
>   

Well, the corresponding xen-unstable code has been a bit of a trial to
maintain.  I made this as simple and self-contained as possible (with
very little non-locality) to try and keep it maintainable.

I agree its all a bit subtle, but in its favour:

   1. It's internal to the implementation of the iret pvop, which does
      have a fairly well-defined and stable interface (same as iret
      instruction, essentially)
   2. Comments!
   3. Relatively simple implementation (only one register to deal with
      in the slow-path handler, for example)

The annoying non-local thing is the test in the xen upcall handler, but
that's unavoidable.

    J
