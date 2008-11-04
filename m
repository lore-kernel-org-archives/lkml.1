Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYKDTeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYKDTeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYKDTeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:34:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYKDTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:34:14 -0500
Message-ID: <4910A390.409@zytor.com>
Date: Tue, 04 Nov 2008 11:33:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <491090F3.5020701@zytor.com> <1225824256.28612.1282966677@webmail.messagingengine.com>
In-Reply-To: <1225824256.28612.1282966677@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, looking at this some more, the current interrupt stubs are just
plain braindead.

We have a large number of push instructions which save a negative
number, even when that means using the full 5-byte form; then we use:

	unsigned vector = ~regs->orig_ax;

in do_IRQ.  This is utterly moronic; if we use the short form push at
all times, then we can set the upper bits (which distinguish us from a
system call entry) at leisure (via a simple orl in common code), rather
than in each stub, which to boot bloats it above the 8-byte mark.

That way, each stub has the simple form:

	6A xx E9 yy yy yy yy 90

Down to 8 bytes, including one byte of padding.  Already better - we are
down to 2K total, and each stub is aligned.

Now, we can do better than that at the cost of an extra branch.  The
extra branch, however, is a direct unconditional branch and so is not
subject to misprediction (good), although it may end up taking an extra
icache miss (bad):

we can group our vectors in 8 groups of 32 vectors each.  Each contain a
stub of the form:

	6A xx EB yy

... which jump to a common jump instruction at the end of each group.
Thus, each group takes 32*4+5 bytes+3 bytes for alignment = 136 bytes,
for a total of 1088 bytes.

This has two disadvantages:
- an extra jump.
- we can no longer redirect a stub away from common code by
  changing the branch in that slot.  We have to instead modify
  the IDT.  This means "dedicated" interrupts don't get the
  vector number at all, which is probably fine -- to be honest,
  I'm not sure if they do at the moment either.

Fixing the first of these I think is a no-brainer.  That will cut the
size of the existing stub pool by almost half.  The second is more of a
judgement call, and I'd like to see performance numbers for it.  Either
which way, I think it's worthwhile to consider this as an alternative to
  playing segmentation tricks, which I think could have really nasty
side effects.

	-hpa

