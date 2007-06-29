Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXF2FhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXF2FhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXF2FhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:37:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40814
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbXF2FhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:37:15 -0400
Date: Thu, 28 Jun 2007 22:37:34 -0700 (PDT)
Message-Id: <20070628.223734.21928089.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clameter@sgi.com, hugh@veritas.com, James.Bottomley@steeleye.com,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter
 gather lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070628222424.4cbae90c.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<20070628222424.4cbae90c.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 28 Jun 2007 22:24:24 -0700

> So what happens when two quite different threads of control are doing
> IO against two hunks of kmalloced memory which happen to come from the same
> page?  Either some (kernel-wide) locking is needed, or that pageframe needs
> to be treated as readonly?

Or you put an atomic_t at the beginning or tail of every SLAB
object.  It's a space cost not a runtime cost for the common
case which is:

	smp_rmb();
	if (atomic_read(&slab_obj->count) == 1)
		really_free_it();
	else if (atomic_dec_and_test(...))

Note I don't like this variant either. :)

