Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYHNIUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYHNIUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYHNIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:20:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60086
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYHNIUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:20:05 -0400
Date: Thu, 14 Aug 2008 01:20:04 -0700 (PDT)
Message-Id: <20080814.012004.193702132.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org, michael@ellerman.id.au
Subject: bug in lmb_enforce_memory_limit()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just mentioned this to Ben H. on IRC and promised I would report it
here. :-)

The first loop over lmb.memory in this function interprets the
memory_limit as a raw size limit, and that's fine so far.

But the second loop over lmb.reserved interprets this value
instead as an "address limit."

I haven't cobbled together a fix myself, but probably the way to do
this is, when we're about break out of the first loop over lmb.memory,
walk through the now-trimmed memory blobs and trim those from
lmb.reserved, one by one.

This bug got introduced by:

   commit 2babf5c2ec2f2d5de3e38d20f7df7fd815fd10c9
   Author: Michael Ellerman <michael@ellerman.id.au>
   Date:   Wed May 17 18:00:46 2006 +1000

       [PATCH] powerpc: Unify mem= handling

back when LMB was still a powerpc local item. :-)

This led me to another bug which probably a lot of platforms are
effected by.

If you do this command line memory limiting, and the kernel was placed
by the boot loader into physical ram (say at the end of the available
physical memory) that gets trimmed out by the command line option, we
hang or crash right as we boot into userspace because freeing up
initmem ends up freeing invalid page structs.

I think, on sparc64, instead of adding all kinds of complicated logic
to free_initmem() I'm simply going to only poison the pages and
not free them at all if cmdline_memory_size has been set.
