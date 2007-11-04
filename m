Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXKDV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXKDV7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 16:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXKDV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 16:59:25 -0500
Received: from aun.it.uu.se ([130.238.12.36]:54821 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbXKDV7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 16:59:25 -0500
Date: Sun, 4 Nov 2007 22:58:57 +0100 (MET)
Message-Id: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2007 11:41:58 -0800, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> > 
> > First patch didn't build. Second patch builds and boots Ok.
> > 
> > So this means the 486 DX4 has a buggy mov to %cr0?
> > 
> 
> Apparently.

Maybe not. I had a look in Intel's SDM Vol3, and the
section "switching to protected mode" specifies that
a move to %cr0 that sets PE should immediately be
followed by a far jmp or call. They write that "random
failures can occur if other instructions exist between
[the move to %cr0] and [the far jmp/call]". The current
version of pmjump.S does exactly that: it executes
a bunch of moves to segment registers in that window.

(Section 9.9.1 in the Sept. 2005 revision I have in
front of me.)

Similarly, section "serializing instructions" writes
that a move to %cr0 that enables or disables paging
should be followed by a jump. They write that this isn't
required in P4 or P6 family processors, but is required
for compatibility with other ia32 processors. Reading
between the lines, they imply that older ia32 processors
don't treat %cr0 writes as completely serializing.

(Section 7.4 in the Sept. 2005 revision.)

/Mikael
