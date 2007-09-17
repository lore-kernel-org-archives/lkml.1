Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbXIQSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbXIQSPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXIQSPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:15:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:29104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbXIQSPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="280877672"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Date: Mon, 17 Sep 2007 11:14:53 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46EC233B.5010209@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Thread-Index: Acf3xZhXbD1315MeTsSZyOw+9p4o8gBdgGzQ
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com> <46EB6556.5020506@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com> <46EC233B.5010209@us.ibm.com>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Anthony Liguori" <aliguori@us.ibm.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <kvm-devel@lists.sourceforge.net>,
       "Avi Kivity" <avi@qumranet.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Sep 2007 18:15:03.0715 (UTC) FILETIME=[AB248730:01C7F956]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Nakajima, Jun wrote:
<snip>
> > 
> > I'm suggesting that we use CPUID.0x4000000Y (Y: TBD, e.g. 6) for
Linux
> > paravirtualization.  The ebx, ecx and edx return the Linux
> > paravirtualization features available on that hypervisor. Those
features
> > are defined architecturally (not VMM specific).
> > 
> > Like CPUID.0, CPUID.0x40000000 is used to detect the hypervisor with
the
> > vendor identification string returned in ebx, edx, and ecx (as we
are
> > doing in Xen). The eax returns the max leaf (which is 0x40000002 on
Xen
> > today).
> 
> I don't understand the purpose of returning the max leaf.  Who is that
> information useful for?

Well, this is the key info to the user of CPUID. It tells which leaves
are valid to use. Otherwise, the user cannot tell whether the results of
CPUID.0x4000000N are valid or not (i.e. junk). BTW, this is what we are
doing on the native (for the leaf 0, 0x80000000, for example). The fact
that Xen returns 0x40000002 means it only uses 3 leaves today. 

> 
> I like Jeremy's suggesting of starting with 0x40001000 for KVM.  Xen
has
> an established hypercall interface and that isn't going to change.
> However, in the future, if other Operating Systems (like the BSDs)
> choose to implement the KVM paravirtualization interface, then that
> leaves open the possibility for Xen to also support this interface to
> get good performance for those OSes.  It's necessary to be able to
> support both at once if you wish to support these interfaces without
> user interaction.

Using CPUID.0x4000000N (N > 2) does not prevent Xen from doing that,
either. If you use 0x40001000, 1) you need to say the leaves from
0x40000000 through 0x40001000 are all valid, OR 2) you create/fork a
new/odd leaf (with 0x1000 offset) repeating the detection redundantly. 

> 
> There's no tangible benefit to us to use 0x40000000.  Therefore I'm
> inclined to lean toward making things easier for others.

Again, 0x40000000 is not Xen specific. If the leaf 0x40000000 is used
for any guest to detect any hypervisor, that would be compelling
benefit. For future Xen-specific features, it's safe for Xen to use
other bigger leaves (like 0x40001000) because the guest starts looking
at them after detection of Xen. 

Likewise if KVM paravirtualization interface (as kind of "open source
paravirtualization interface") is detected in the generic areas (not in
vender-specific), any guest can check the features available without
knowing which hypervisor uses which CPUID for that. 

> 
> Regards,
> 
> Anthony Liguori
> 
> >  And like CPUID.1, CPUID.0x40000001 returns the version number in
> > eax, and each VMM should be able to define a number of VMM-specific
> > features available in ebx, ecx, and edx returned (which are
reserved, i.e.
> > not used in Xen today). 
> > 
> > Suppose we knew (i.e. tested) Xen and KVM supported Linux
> > paravirtualization, the Linux code does:
> > 1. detect Xen or KVM <the list> using CPUID.0x40000000
> > 2. Check the version if necessary using CPUID.0x40000001
> > 3. Check the Linux paravirtualization features available using
> > CPUID.0x4000000Y. 
> > 
> > Jun
> > ---
> > Intel Open Source Technology Center

Jun
---
Intel Open Source Technology Center
