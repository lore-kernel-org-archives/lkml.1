Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYFEWcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYFEWcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYFEWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:32:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:13068 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYFEWce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:32:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,597,1204531200"; 
   d="scan'208";a="257052793"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Eliminate double kfree
Date: Thu, 5 Jun 2008 15:32:31 -0700
Message-ID: <5389061B65D50446B1783B97DFDB392D0A275662@orsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0805291504030.26229@ask.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Eliminate double kfree
Thread-Index: AcjHXArOURWSVMjsTBafHUqu/W/YSw==
References: <Pine.LNX.4.64.0805291504030.26229@ask.diku.dk>
From: "Gross, Mark" <mark.gross@intel.com>
To: "Julia Lawall" <julia@diku.dk>, <jbarnes@virtuousgeek.org>,
       <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 05 Jun 2008 22:32:32.0212 (UTC) FILETIME=[0B649940:01C8C75C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Julia Lawall [mailto:julia@diku.dk]
>Sent: Thursday, May 29, 2008 6:05 AM
>To: jbarnes@virtuousgeek.org; linux-pci@vger.kernel.org; linux-
>kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
>Subject: [PATCH 1/2] Eliminate double kfree
>
>From: Julia Lawall <julia@diku.dk>
>
>The destination of goto error also does a kfree(g_iommus), so it is not
>correct to do one here.
>
>This was found using the following semantic match.
>(http://www.emn.fr/x-info/coccinelle/)
>
>// <smpl>
>@r1@
>expression E;
>position p1,p2;
>@@
>
>kfree@p1(E);
>...
>kfree@p2(E);
>
>@subexps@
>expression E1;
>position r1.p1,p;
>@@
>
>kfree@p1(<+... E1@p ...+>);
>
>@recollect@
>position subexps.p;
>expression E1;
>@@
>
>E1@p
>
>@doublekfree@
>position r1.p1,r1.p2;
>expression recollect.E1,E2,E;
>position p;
>statement S;
>@@
>
>kfree@p1(E);
><+... E1@p=E2 ...+> // the actual semantic match contains other
assignments
>kfree@p2(E);
>
>@notdoublekfree@
>position r1.p1,r1.p2;
>position any doublekfree.p;
>expression E,E1,E2;
>@@
>
>* kfree@p1(E);
>... when != E1@p
>    when != E1@p = E2 // needed to match a variable decl
>* kfree@p2(E);
>// </smpl>
>
>Signed-off-by: Julia Lawall <julia@diku.dk>
>---
>
>diff -u -p a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>--- a/drivers/pci/intel-iommu.c	2008-05-15 18:11:35.000000000
+0200
>+++ b/drivers/pci/intel-iommu.c	2008-05-24 21:20:24.000000000
+0200
>@@ -1725,7 +1725,6 @@ int __init init_dmars(void)
> 	deferred_flush = kzalloc(g_num_of_iommus *
> 		sizeof(struct deferred_flush_tables), GFP_KERNEL);
> 	if (!deferred_flush) {
>-		kfree(g_iommus);
> 		ret = -ENOMEM;
> 		goto error;
> 	}
ACK.

Thanks,

--mgross
