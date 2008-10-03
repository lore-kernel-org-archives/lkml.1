Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYJCWdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYJCWdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYJCWdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:33:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:1217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYJCWdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:33:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,358,1220252400"; 
   d="scan'208";a="446805159"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Fri, 3 Oct 2008 15:33:30 -0700
Subject: RE: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
Thread-Topic: [RFC] CPUID usage for interaction between Hypervisors	and
	Linux.
Thread-Index: AckkLhziLeYuJCEWS1ShRsuooRGAywBWPDLg
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1>
 <48E3FDD5.7040106@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
 <48E422CA.2010606@zytor.com>
In-Reply-To: <48E422CA.2010606@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m93MXpdq021302

On 10/1/2008 6:24:26 PM, H. Peter Anvin wrote:
> Nakajima, Jun wrote:
> > >
> > > All I have seen out of Microsoft only covers CPUID levels
> > > 0x40000000 as an vendor identification leaf and 0x40000001 as a
> > > "hypervisor identification leaf", but you might have access to other information.
> >
> > No, it says "Leaf 0x40000001 as hypervisor vendor-neutral interface
> > identification, which determines the semantics of leaves from
> > 0x40000002 through 0x400000FF." The Leaf 0x40000000 returns vendor
> > identifier signature (i.e. hypervisor identification) and the
> > hypervisor CPUID leaf range, as in the proposal.
> >
>

Resuming the thread :-)

> In other words, 0x40000002+ is vendor-specific space, based on the
> hypervisor specified in 0x40000001 (in theory); in practice both
> 0x40000000:0x40000001 since M$ seem to use clever identifiers as
> "Hypervisor 1".

What it means their hypervisor returns the interface signature (i.e. "Hv#1"), and that defines the interface. If we use "Lv_1", for example, we can define the interface 0x40000002 through 0x400000FF for Linux. Since leaf 0x40000000 and 0x40000001 are separate, we can decouple the hypervisor vender from the interface it supports. This also allows a hypervisor to support multiple interfaces.

And whether a guest wants to use the interface without checking the vender id is a different thing. For Linux, we don't want to hardcode the vender ids in the upstream code at least for such a generic interface.

So I think we need to modify the proposal:

Hypervisor interface identification Leaf:
        Leaf 0x40000001.

        This leaf returns the interface signature that the hypervisor implements.
        # EAX: "Lv_1" (or something)
        # EBX, ECX, EDX: Reserved.

Lv_1 interface Leaves:
        Leaf range 0x40000002 - 0x4000000FF.

In fact, both Xen and KVM are using the leaf 0x40000001 for different purposes today (Xen: Xen version number, KVM: KVM para-virtualization features). But I don't think this would break their existing binaries mainly because they would need to expose the interface explicitly now.

>
> > > This further underscores my belief that using 0x400000xx for
> > > anything "standards-based" at all is utterly futile, and that this
> > > space should be treated as vendor identification and the rest as
> > > vendor-specific. Any hope of creating a standard that's actually
> > > usable needs to be outside this space, e.g. in the 0x40SSSSxx
> > > space I proposed earlier.
> >
> > Actually I'm not sure I'm following your logic. Are you saying using
> > that 0x400000xx for anything "standards-based" is utterly futile
> > because Microsoft said "the range is hypervisor vendor-neutral"? Or
> > you were not sure what they meant there. If we are not clear, we can
> > ask them.
> >
>
> What I'm saying is that Microsoft is effectively squatting on the
> 0x400000xx space with their definition.  As written, it's not even
> clear that it will remain consistent between *their own* hypervisors,
> even less anyone else's.

I hope the above clarified your concern. You can google-search a more detailed public spec. Let me know if you want to know a specific URL.

>
>         -hpa
>
             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
