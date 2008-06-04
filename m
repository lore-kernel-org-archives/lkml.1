Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYFDRuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYFDRuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYFDRub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:50:31 -0400
Received: from main.gmane.org ([80.91.229.2]:49807 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbYFDRua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:50:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [X86][BISECTED] WARNING: at kernel/lockdep.c:2680
Date: Wed, 04 Jun 2008 18:50:21 +0100
Message-ID: <g26kkr$4qc$1@ger.gmane.org>
References: <4844868F.20104@gmail.com> <1212483192.6304.8.camel@twins> <d1af83620806030522i4b8120dgda19d3196f0838f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:

>> On Mon, 2008-06-02 at 20:47 -0300, Kevin Winchester wrote:
>>> In next-20080530 and next-20080602 (and possibly earlier - I can't
>>> remember the linux-next tree before that I tried) I get the following:
>>>
>>> [   12.885153] ------------[ cut here ]------------
>>> [   12.885203] WARNING: at kernel/lockdep.c:2680
>>> [   check_flags+0x98/0x151() 12.885248] Pid: 4, comm: watchdog/0 Not

OK I've managed to bisect this down to commit
[c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4] (sched: do not trace
sched_clock):

commit c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon May 12 21:21:14 2008 +0200

    sched: do not trace sched_clock

    The tracer uses sched_clock, so do not trace it.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reverting this made the lockdep warning go away. Here is the bisection log:
# bad: [cb689015ce306647ea9e00c2412b852b1dd1580d] Add linux-next specific
files
# good: [5ffeee1785c30303007b3d2dce85402b0bbf9b00] Add linux-next specific
files
git-bisect start 'next-20080527' 'next-20080526'
# bad: [357e7b54308101878f7e93e04fa8d7f06eea57a8] Merge
commit 'avr32/avr32-arch'
git-bisect bad 357e7b54308101878f7e93e04fa8d7f06eea57a8
# bad: [048f32bfd577d3c0c2c5f2e4b03690a2902be1c2] Merge
branch 'tracing/mmiotrace' into auto-ftrace-next
git-bisect bad 048f32bfd577d3c0c2c5f2e4b03690a2902be1c2
# good: [4d9493c90f8e6e1b164aede3814010a290161abb] ftrace: remove add-hoc
code
git-bisect good 4d9493c90f8e6e1b164aede3814010a290161abb
# good: [37135677e653537ffc6e7def679443272a1c03c3] ftrace: fix mcount export
bug
git-bisect good 37135677e653537ffc6e7def679443272a1c03c3
# good: [801a175bf601f9a9d5e86e92dee9adeeb6625da8] mmiotrace: ftrace fix
git-bisect good 801a175bf601f9a9d5e86e92dee9adeeb6625da8
# good: [e0fd5c2fa188311667267c02a702ae699a9fc2bd] mmiotrace: do not print
bogus pid for maps either
git-bisect good e0fd5c2fa188311667267c02a702ae699a9fc2bd
# good: [790e2a290b499b0400254e6870ec27969065d122] x86 mmiotrace: page level
is unsigned
git-bisect good 790e2a290b499b0400254e6870ec27969065d122
# good: [7b3ce4a410ccdc8ca0be361d4d4fd61c3830f52a] sched: clean up scheduler
markers
git-bisect good 7b3ce4a410ccdc8ca0be361d4d4fd61c3830f52a
# bad: [7fa13a1e8501b96ff11d4a19a5401f61ccd3d98c] Merge
branch 'tracing/ftrace' into auto-ftrace-next
git-bisect bad 7fa13a1e8501b96ff11d4a19a5401f61ccd3d98c
# bad: [c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4] sched: do not trace
sched_clock
git-bisect bad c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4

-- 
Sitsofe | http://sucs.org/~sits/

