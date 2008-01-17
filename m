Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYAQS3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYAQS3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAQS3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:29:45 -0500
Received: from gw.goop.org ([64.81.55.164]:53742 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbYAQS3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:29:44 -0500
Message-ID: <478F9E91.7050009@goop.org>
Date: Thu, 17 Jan 2008 10:29:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: link error in today's x86.git
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this with the current x86.git:

arch/x86/mm/built-in.o: In function `fix_to_virt': /home/jeremy/hg/xen/paravirt/linux-i386/include2/asm/fixmap_32.h:157: undefined reference to `__this_fixmap_does_not_exist'

It appears to be coming from ioremap_32.c.

I can't see any particular change which would have caused this, but this 
loop in early_ioremap_reset:

	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
		addr = fix_to_virt(idx);
		pte = early_ioremap_pte(addr);
		if (!*pte & _PAGE_PRESENT) {
			phys = *pte & PAGE_MASK;
			set_fixmap(idx, phys);
		}
	}

seems incompatible with the test in fix_to_virt:

	/*
	 * this branch gets completely eliminated after inlining,
	 * except when someone tries to use fixaddr indices in an
	 * illegal way. (such as mixing up address types or using
	 * out-of-range indices).
	 *
	 * If it doesn't get removed, the linker will complain
	 * loudly with a reasonably clear error message..
	 */
	if (idx >= __end_of_fixed_addresses)
		__this_fixmap_does_not_exist();

While the compiler could prove that idx is within range here, it seems a 
bit much to require it to.

    J
