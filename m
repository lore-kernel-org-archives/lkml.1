Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXLQPri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXLQPri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbXLQPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:47:26 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:56046 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbXLQPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:47:25 -0500
Message-ID: <47669A16.3010604@BitWagon.com>
Date: Mon, 17 Dec 2007 07:47:34 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: slab quirks in DEBUG, ctor, and initialization
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mm/slab.c, the DEBUG variant of cache_alloc_debugcheck_after
might call  cachep->ctor(objp, cachep, 0);  but the non-DEBUG
variant does absolutely nothing.  idr_pre_get is a routine
which notices the difference.

Even when cache_alloc_debugcheck_after does invoke the ctor,
then it is conditional upon  cachep->flags & SLAB_POISON .  This
assumes that the only two states are poisoned and all-zero
(from .bss static, or via a cleared new page frame.)
So if SLAB_POISON is not specified, then a ctor which
does anything other than memset(,0,) is out of luck.
Instead: if a ctor is specified then it should be called
for each successful allocation.

Invoking the ctor from within cache_alloc_debugcheck_after makes it
awkward for a dynamic checker of allocations and  initializations.
Valgrind would be happier if allocation and initialization were
invoked at the same subroutine nesting level, such as in __cache_alloc:

        cache_alloc_debugcheck_before(cachep, flags);
        local_irq_save(save_flags);
        objp = __do_cache_alloc(cachep, flags);
	/* checker marks the space as allocated */
        local_irq_restore(save_flags);
        objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
	if (objp && cachep->ctor)
		cachep->ctor(objp, cachep, 0);
	/* checker notes initializations during ctor [above] */

-- 
John Reiser, jreiser@BitWagon.com
