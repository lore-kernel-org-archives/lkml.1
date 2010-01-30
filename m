Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279Ab0A3Sqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0A3Sqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0A3Sqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:46:31 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:47500 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0A3Sqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:46:30 -0500
Date: Sat, 30 Jan 2010 19:46:24 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 stalls as guest in virtualbox
Message-ID: <1264877041@msgid.manchmal.in-ulm.de>
References: <1264788823@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264788823@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Biedl wrote...

(...)

Christian Ehrhard gave me a lot of help understanding the kernel sides
of that issue, thanks for this.  Appearently virtualbox cannot
properly deal with the result of alternative_io in
arch/x86/include/asm/cmpxchg_32.h since this klugdy patch

--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -317,7 +317,7 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
        __typeof__(*(ptr)) __ret;                               \
        __typeof__(*(ptr)) __old = (o);                         \
        __typeof__(*(ptr)) __new = (n);                         \
-       alternative_io("call cmpxchg8b_emu",                    \
+       alternative_io("lock; cmpxchg8b (%%esi)",               \
                        "lock; cmpxchg8b (%%esi)" ,             \
                       X86_FEATURE_CX8,                         \
                       "=A" (__ret),                            \

fixes the problem, 

Unlike his findings described in
<http://marc.info/?l=linux-kernel&m=121545190107704&w=2>, the guest
does not crash but seems to run into a busy loop instead.

A acceptable workaround is selecting CONFIG_M686 (but not CONFIG_M586).

Now I guess this is rather something to virtualbox guys should take
care of, therefore I've opened a ticket there:
http://www.virtualbox.org/ticket/6100

    Christoph
