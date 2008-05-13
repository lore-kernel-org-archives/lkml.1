Return-Path: <linux-kernel-owner+w=401wt.eu-S1761873AbYEMUmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873AbYEMUmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYEMUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:42:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13996 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbYEMUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=Q4AP5Cr4WAOR9pJnuHxqJLKjf6oCKGHW2hG5U+jV0DEaQWbSnNjjJ2olP81NXhK/r/Ip20IMiLvhFat3by+Cv8JqAHBuBIxPHnxp5sUOrm4TECO7jjVZn6mCK8pNwvAhbUK8CSI0vfAOoowo3X/v0G+EVhHEE+kP4cXiEmwHaGs=
Date: Tue, 13 May 2008 22:42:06 +0200
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080513204206.GA17781@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recap: powertop shows between 200-400 wakeups/second with the description
"<kernel IPI>: Rescheduling interrupts" when all processors have load (e.g.
I need to run two busy-loops on my 2-CPU system for this to show up).

The bisect resulted in this commit:

commit 0c07ee38c9d4eb081758f5ad14bbffa7197e1aec
Author: Andi Kleen <ak@suse.de>
Date:   Wed Jan 30 13:33:16 2008 +0100

    x86: use the correct cpuid method to detect MWAIT support for C states

    Previously there was a AMD specific quirk to handle the case of
    AMD Fam10h MWAIT not supporting any C states. But it turns out
    that CPUID already has ways to detectly detect that without
    using special quirks.

    The new code simply checks if MWAIT supports at least C1 and doesn't
    use it if it doesn't. No more vendor specific code.

    Note this is does not simply clear MWAIT because MWAIT can be still
    useful even without C states.

    Credit goes to Ben Serebrin for pointing out the (nearly) obvious.

    Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I was not able to revert this without conflicts, so I will leave that part
to you. Here is the bisect log in case it is useful:

git-bisect start 'v2.6.26-rc1' 'v2.6.24'
git-bisect bad 3f85d63ea4ff922f6abdb509f4aaf6993b3273a3
git-bisect bad f77bc6a420eba845605ff1d53cadf55f94c5e8b7
git-bisect good c76c04758b8fd24a1c38b19742e3437e954e945b
git-bisect good 0ba6c33bcddc64a54b5f1c25a696c4767dc76292
git-bisect good fde1b3fa947c2512e3715962ebb1d3a6a9b9bb7d
git-bisect bad d690b2afd5a7a02816386aa704c8c0b1aca8d2de
git-bisect good 773221f46f82dc2f277dacc331d9d2ef2c690cb6
git-bisect bad f8f76481bc2803aea03ff213c7e1405b53f7e488
git-bisect bad 9042219cd8d43b81322b826d463dd6e52acae6cf
git-bisect bad ca74a6f84e68b44867022f4a4f3ec17c087c864e
git-bisect good 064954761254ef17fae2b84fb5a034d48a769143
git-bisect good 30d432dfab2bcfd021d352e2058fae6b9405caeb
git-bisect bad 27cc2a812eb504f4aadff5baa862da715fb0f886
git-bisect bad 0c07ee38c9d4eb081758f5ad14bbffa7197e1aec

This initially showed up on my 2.6.24.5-85.fc8 (Fedora) kernel.

I have two different systems (one laptop, one desktop) which both show the
same symptoms, please do tell me if you need any more info.


Vegard
