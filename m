Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYI2Uzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYI2Uzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYI2Uzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:55:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:43692 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYI2Uzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:55:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="341906981"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "akataria@vmware.com" <akataria@vmware.com>,
       Gerd Hoffmann <kraxel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Date: Mon, 29 Sep 2008 13:55:19 -0700
Subject: RE: Use CPUID to communicate with the hypervisor.
Thread-Topic: Use CPUID to communicate with the hypervisor.
Thread-Index: Ackiav0P/IqPiFqhRnO6hg0TbjhDtwAA6w9Q
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
In-Reply-To: <1222717085.30247.44.camel@alok-dev1>
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

On 9/29/2008 12:38:05 PM, Alok Kataria wrote:
> On Mon, 2008-09-29 at 11:46 -0700, Gerd Hoffmann wrote:
> > Alok Kataria wrote:
> > > Hi Gerd,
> > >
> > > > Shouldn't you check the hypervisor signature here?
> > >
> > > Nope the whole idea of not checking the hypervisor signature is
> > > that we should keep this interface generic.
> >
> > Nice idea.  Problem with that is that approach is that we don't have
> > full control here.  It probably isn't that a hard to have vmware,
> > xen and kvm agree here, given vmware proposes this and for xen+kvm
> > one can send patches.
>
> Yep.
> And please note that this does allow either Xen/KVM to propose a new
> leaf and the rest of the hypervisor players can decide to export that
> leaf or return a zero value.
>

For example, we can set the following ranges so that so that each VMM vender can define and implement features avoiding conflicts:
vmware to define 0x4000001X
xen to define 0x4000002X
kvm to define 0x4000003X
...

The point here is that all the features are generic because we don't make them exclusive. To that end, we don't check the signature. Whatever common features can be found in the above, and each hypervisor can choose to implement what was defined by other hypervisors.

Detection of the feature 0x400000XY is done by:
1.  Get EAX from Leaf 0x4000000000, Hypervisor CPUID information. EAX returns the maximum input value for hypervisor CPUID info.

    If EAX < 0x400000XY, then the feature is not available.

2.  Get EAX from the target Leaf 0x400000XY by doing cpuid_eax(0x400000XY).

    If (EAX == 0), the feature is not implemented.

If the hypervisor does not implement a particular feature specified by 0x400000XN and 0x400000XN < 0x400000XY, the hypervisor needs to return 0 in EAX with cpuid_eax(0x400000XN) (XN > 0).

             .
Jun Nakajima | Intel Open Source Technology Center
