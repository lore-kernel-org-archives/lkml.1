Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYFBVWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYFBVWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYFBVW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:22:27 -0400
Received: from flusers.ccur.com ([12.192.68.2]:36570 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbYFBVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:22:26 -0400
Date: Mon, 2 Jun 2008 17:21:06 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Theodore Tso <tytso@mit.edu>,
       Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Fix for asm warning in head_32.S
Message-ID: <20080602212106.GA25959@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org> <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site> <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:10:02PM -0700, Linus Torvalds wrote:
> It also causes these warnings on 32-bit PAE:
> 
> 	  AS      arch/x86/kernel/head_32.o
> 	arch/x86/kernel/head_32.S: Assembler messages:
> 	arch/x86/kernel/head_32.S:225: Warning: left operand is a bignum; integer 0 assumed
> 	arch/x86/kernel/head_32.S:609: Warning: left operand is a bignum; integer 0 assumed
> 
> and I do not see why (the end result seems to be identical).



Fix head_32.S gcc bignum warnings when CONFIG_PAE=y.

    arch/x86/kernel/head_32.S: Assembler messages:
    arch/x86/kernel/head_32.S:225: Warning: left operand is a bignum; integer 0 assumed
    arch/x86/kernel/head_32.S:609: Warning: left operand is a bignum; integer 0 assumed

The assembler was stumbling over the 64-bit constant 0x100000000 in the
KPMDS #define.

Testing: a cmp(1) on head_32.o before and after shows the binary is unchanged.

Signed-off-by: Joe Korty <joe.korty@ccur.com

Index: a/arch/x86/kernel/head_32.S
===================================================================
--- a.orig/arch/x86/kernel/head_32.S	2008-06-02 16:51:20.000000000 -0400
+++ a/arch/x86/kernel/head_32.S	2008-06-02 16:54:05.000000000 -0400
@@ -189,7 +189,7 @@
 	 * this stage.
 	 */
 
-#define KPMDS ((0x100000000-__PAGE_OFFSET) >> 30) /* Number of kernel PMDs */
+#define KPMDS (((-__PAGE_OFFSET) >> 30) & 3) /* Number of kernel PMDs */
 
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
