Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbXIQUwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbXIQUwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXIQUwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:52:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:56848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXIQUw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="141789807"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Date: Mon, 17 Sep 2007 13:52:25 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE1037F85F8@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46EED250.5080207@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Thread-Index: Acf5XxwQzGa/iyKpQTuv9G2v4tsUxgAB6/WA
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com> <46EB6556.5020506@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com> <46EC233B.5010209@us.ibm.com> <97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com> <46EED250.5080207@goop.org>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Anthony Liguori" <aliguori@us.ibm.com>, <kvm-devel@lists.sourceforge.net>,
       "Avi Kivity" <avi@qumranet.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Sep 2007 20:52:26.0245 (UTC) FILETIME=[A7544350:01C7F96C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Nakajima, Jun wrote:
> 
> > Again, 0x40000000 is not Xen specific. If the leaf 0x40000000 is
used
> > for any guest to detect any hypervisor, that would be compelling
> > benefit. For future Xen-specific features, it's safe for Xen to use
> > other bigger leaves (like 0x40001000) because the guest starts
looking
> > at them after detection of Xen.
> > 
> > Likewise if KVM paravirtualization interface (as kind of "open
source
> > paravirtualization interface") is detected in the generic areas (not
in
> > vender-specific), any guest can check the features available without
> > knowing which hypervisor uses which CPUID for that.
> > 
> 
> This just seems a bit grotty.  You're relying on the fact that you can
> overlay Xen's current use of 0x4000000x for the generic interface by
> freezing Xen's current use of 40000000-2.  0x40000000 becomes a more
or
> less useless hypervisor-identification signature (useless because you
> need to assume that leaves 4000000x, x>2 implement the generic
interface
> anyway, where x=1,2 are reserved for Xen (=hypervisor-specific) uses).

No, really. Xen just _implemented_ the generic interface from the
beginning, at least for 0 and 1 (version). The 0x40000002 (hypercall
page) looks specific to Xen, but it can be used for KVM as well, thus
can be generic (or a hypervisor can tell it's not supported by returning
0 pages for hypercall pages). If Xen implements the new generic feature
(defined by 0x40000003, for example), then it returns 40000003 or large
for the max leaf upon CPUID.0x40000000.

> 
> In other words, what mechanism can a guest use to explicitly identify
> the existence of the generic interface?  There needs to be a signature
> for that somewhere.
> 
>     J
So you don't need a signature for that. 

As I wrote before:
1. detect Xen or KVM <the list> using CPUID.0x40000000 
2. Check the version if necessary using CPUID.0x40000001
3. Check the generic features available using CPUID.0x4000000Y, if the
max leaf returned >= 0x4000000Y.

A guest wants to want to know who the hypervior is for practical
purposes (e.g. debuggging) anyway. This is equivalent to what a native
OS would do to detect a generic CPU feature.

Jun
---
Intel Open Source Technology Center
