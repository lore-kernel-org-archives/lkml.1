Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYKDWNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYKDWNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYKDWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:13:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:33431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYKDWNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:13:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="459281018"
From: "Luck, Tony" <tony.luck@intel.com>
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
       "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Tue, 4 Nov 2008 14:13:39 -0800
Subject: RE: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
Thread-Topic: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
Thread-Index: Ack+DEP3w74SxMCKTfO+ptOehbf/wgAufUEg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35BE05F00@orsmsx505.amr.corp.intel.com>
References: <490F880E.4000801@cse.unsw.edu.au>
In-Reply-To: <490F880E.4000801@cse.unsw.edu.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Cc: linux-ia64 ... more likely to attract attention of HP
ia64 experts there.

> arch/ia64/hp/common/sba_iommu.c: I/O MMU is out of mapping resources

Odd ... the code (back to the dawn of git time in 2.6.12-rc1) looks like

        panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n"
                ioc->ioc_hpa);

I wonder why you don't see the "@ HEXADDRESS"?

> Using git-bisect, I've zeroed in on the commit that introduced this.
> Please see the attached file for the commit.

Did you confirm that reverting this commit on a recent kernel
fixes the problem (once in a while git bisect can point to
the wrong commit ... it seems very likely that it got the
right one here, but it is always good to check).  When I
tried to use "patch -R" to revert this it got confused on
the Kconfig file because the lines that were added were
subsequently changed ... so you may need to revert that
by hand ... the sba_iommu.c apparently reverted ok).

> Other info:
> System is HP RX6600(16Gb RAM, 16 processors w/ dual cores and HT)
> 20 SATA disks under software RAID0 with 6 TB capacity.
> Silicon Image 3124 controller.
> File system is XFS.

My HP test system is way too small to attempt to recreate
this (just 2 cpus & 1 disk).  How long does each of your
tests take to hit the problems ... a few minutes? Or hours?

> I'd much appreciate some help in fixing this because this panic has
> basically stalled my own work. I'd be willing to run more tests on my
> setup to test any patches that possibly fix this issue.

Adding some printk() before the panic might give a clue as to what
is going wrong.  Either a bogus call is trying to allocate far
too much space, or the bitmap is leaking, or we have a totally
messed up "ioc" structure.

Printing "pages_needed" the address of "ioc" and some interesting
fields from ioc (at least ioc->res_size) would help.  I assume
the the return value from sba_search_bitmap() is ~0x0 ... but
you should print "pide" just to be sure.

-Tony
