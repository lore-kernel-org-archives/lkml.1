Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbYBXPRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbYBXPRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYBXPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:17:40 -0500
Received: from aun.it.uu.se ([130.238.12.36]:35062 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYBXPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:17:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18369.35401.678391.183329@harpo.it.uu.se>
Date: Sun, 24 Feb 2008 16:16:25 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
In-Reply-To: <20080224135720.GA5323@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
	<20080224135720.GA5323@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Mikael Pettersson <mikpe@it.uu.se> wrote:
 > 
 > > The kernel for this 486 has CONFIG_M486=y and CONFIG_M586TSC=n, but 
 > > the 2.6.25 kernels still try to access the TSC. Here's the oops from 
 > > 2.6.25-rc2-git8:
 > 
 > hm, could you send me the full .config you used?

I've put it here:
<http://user.it.uu.se/~mikpe/linux/tmp/config-2.6.24-git8>

Meanwhile, I've traced the breakage to 2.6.24-git8.

2.6.24-git8 changed include/asm-x86/tsc.h:get_cycles() to call
rdtscll() even if CONFIG_X86_TSC isn't set. The call is protected
by a cpu_has_tsc test, but starting with 2.6.24-git8 cpu_has_tsc
is non-zero on this machine, which is very very wrong.

Diffing dmesg between git7 and git8 doesn't sched any light since
git8 also removed the printouts of the x86 caps as they were being
initialised and updated. I'm currently adding those printouts back
in the hope of seeing where and when the caps get broken.
