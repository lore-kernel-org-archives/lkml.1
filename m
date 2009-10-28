Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZJ1WX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZJ1WX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZJ1WX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:23:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:54310 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZJ1WX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,641,1249282800"; 
   d="scan'208";a="508626201"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Date: Wed, 28 Oct 2009 15:23:30 -0700
Subject: RE: [PATCH -next] ia64/sn: fix percpu warnings
Thread-Topic: [PATCH -next] ia64/sn: fix percpu warnings
Thread-Index: AcpX7OZRI6sGjgDuQdmbaILQAqdA8QAATHwQAAsyx9A=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E34C0629@orsmsx505.amr.corp.intel.com>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
	 <20091014151003.0ef42973.randy.dunlap@oracle.com>
	 <4AD67C05.2030201@kernel.org>
 <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com>
 <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com>
 <4AE85D28.90809@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E34C0108@orsmsx505.amr.corp.intel.com>
 <4AE87344.6030708@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E34C018B@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E34C018B@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just tried an x86_64 build with a module also modified to access
> softirq_work_list.  It did NOT get a CRC error.  So the x86_64
> toolchain doesn't seem to have the same issue as ia64.

Ok.  x86 doesn't see this because the defconfig has
  CONFIG_MODVERSIONS is not set

If I turn MODVERSION off, then the problem disappears for me.

If I turn MODVERSIONS on for x86 (and fudge a driver to make use of
softirq_work_list), then x86 gets the CRC warning too.


So this isn't a tool chain problem. Neither x86 nor ia64
can handle exported per-cpu array objects when CONFIG_MODVERSIONS
is set.

Looking at the __crc symbols in the vmlinux for x86 with
CONFIG_MODVERSIONS=y I see:

000000006dcaeb88 A __crc_per_cpu__kernel_stack
00000000b3994c7a A __crc_per_cpu__kstat
00000000d917c158 A __crc_per_cpu__node_number
                 w __crc_per_cpu__softirq_work_list
0000000036a1f502 A __crc_per_cpu__softnet_data
0000000057adf756 A __crc_per_cpu__this_cpu_off

which explains why "modpost" is unable to find a CRC.

Maybe the comments in <linux/module.h> are supposed to be a
clue? :

#ifdef CONFIG_MODVERSIONS
/* Mark the CRC weak since genksyms apparently decides not to
 * generate a checksums for some symbols */
#define __CRC_SYMBOL(sym, sec)                                  \
        extern void *__crc_##sym __attribute__((weak));         \
        static const unsigned long __kcrctab_##sym              \
        __used                                                  \
        __attribute__((section("__kcrctab" sec), unused))       \
        = (unsigned long) &__crc_##sym;

But not enough of a clue for me :-(


-Tony
