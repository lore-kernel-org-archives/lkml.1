Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZJMNSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZJMNSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbZJMNSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:18:45 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:23648 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759839AbZJMNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:18:43 -0400
Date: Tue, 13 Oct 2009 15:17:51 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 0/5]: mtdoops: fixes and improvements
Message-ID: <20091013151751.59e217a7@marrow.netinsight.se>
In-Reply-To: <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Here are a couple of patches to mtdoops which I've been working on for
a while and which were recently discussed on the MTD list. They are
applied on top of Artems tree,

  http://git.infradead.org/users/dedekind/l2-mtd-2.6.git

which apart from the mainline tree contains a panic fix from Aaro and
Artems mtdoops style cleanup patch.


Now, I'd like to warn sensitive readers that patch 5 *does* contain work
queue elements. However, I believe there is a good reason for this: The
mtd->write call is not good to call while oopsing, and mtd->panic_write
is sort of a last resort. Now, if we panic anyhow, mtd->panic_write
will be called, so the oops will still be written and the scheduled
work won't run anyway.


The patches are:

1. Avoid erasing already empty areas (the area would be erased at each
   module load otherwise)

2. Keep track of mtdoops page cleanliness in an array. This allows
   mtdoops_inc_counter to be called during panic (which fails in my
   case with the current code in mtd->read, although I believe this is
   MTD-driver dependent).

3. Make page size configurable to support longer messages. Mainly
   needed for patch 3, but also allows longer messages to be stored
   during panics (when the next oops area cannot be erased).

4. (kernel/printk.c) Add a dump_device as per Linus suggestion which
   includes a dump_kmsg function which dumps the kernel log buffer to
   registered devices.

5. Refactor mtdoops as a dump_device device instead of a console device.

ChangeLog:

v2:
  * Patches have been reordered to keep the least controversial (?) first.
  * Implement Artems suggestion to keep cleanliness in an array
  * Use Aaros patch to fix the panic_on_oops problem

v3:
  * Correct checkpatch issues

v4: Review corrections
  * Rebase on top of "[PATCH] mtd: mtdoops: several minor cleanups"
  * Patch 1 has been added
  * Use 1 bit per oops page, and rename clean/dirty unused/used
  * Don't initialize oops_page_dirty (it's a global structure anyway so
    it will be cleared together with the rest of BSS)
  * Rename mtdoops_page_size record_size (although only for the page
    size setting)

v5: Corrections after panic_on_oops discussion
  * Add dump_device
  * Refactor mtdoops as a dump device.

