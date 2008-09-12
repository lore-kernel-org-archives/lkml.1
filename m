Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYILNOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYILNOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYILNOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:14:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41026 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYILNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:14:32 -0400
Date: Fri, 12 Sep 2008 14:13:51 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
Message-ID: <20080912131351.GA31545@flint.arm.linux.org.uk>
Mail-Followup-To: Roland McGrath <roland@redhat.com>,
	linux-arch@vger.kernel.org, utrace-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080912025733.E55F415420D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912025733.E55F415420D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, let's comment on each bit separately.

Regsets
-------

These don't appear to be a problem for ARM, and turn out to be relatively
clean.  The only thing I did do was invent some alternative simpler
helper functions rather than using the user_regset_copy* functions (to
avoid taking the address of function arguments, which needlessly forces
them onto the stack.)

However, in looking at other architectures, I notice that sparc does this
when initializing its regsets:

                .n = 38 * sizeof(u32),
                .size = sizeof(u32), .align = sizeof(u32),

and sparc64:

                .n = 36 * sizeof(u64),
                .size = sizeof(u64), .align = sizeof(u64),

which, given that fs/binfmt_elf.c does this:

                        size_t size = regset->n * regset->size;
                        void *data = kmalloc(size, GFP_KERNEL);
                        if (unlikely(!data))
                                return 0;

means sparc ends up allocating 38 * sizeof(u32) * sizeof(u32), and
sparc64 ends up with 36 * sizeof(u64) * sizeof(u64), which must surely
be wrong?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
