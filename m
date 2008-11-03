Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYKCX4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYKCX4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKCXzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:55:53 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:63953 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYKCXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:55:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uBMeL3isVrO135LjdFH8IsD/DssiW8csfmpusKTxXaVHddqzWCUgx1lKF0KozK7DKY
         YS4MRpO72uOI47slJEW0/z5SUyTWE6Ke0msd74kZFncaFX/329j1z/EjrIFBQ3NW87IX
         QJ8XFjiUJ9V9jcKgjvCw5lE6Bg5+WArRLwVXA=
Message-ID: <21d7e9970811031555y2e8187c5q5b8768800e176bd4@mail.gmail.com>
Date: Tue, 4 Nov 2008 09:55:51 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: bob.montgomery@hp.com
Subject: Re: [PATCH] disable CPU side GART accesses
Cc: "Dave Jones" <davej@redhat.com>, "Yinghai Lu" <yinghai@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <1225755379.3428.39.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>
	 <1225147341.2215.401.camel@amd.troyhebe> <4906495B.1060506@kernel.org>
	 <1225313564.3428.14.camel@amd.troyhebe>
	 <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
	 <20081029213244.GD24794@redhat.com>
	 <21d7e9970810291440w50d15c30o961dad801cf71548@mail.gmail.com>
	 <1225755379.3428.39.camel@amd.troyhebe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 9:36 AM, Bob Montgomery <bob.montgomery@hp.com> wrote:
> On Wed, 2008-10-29 at 21:40 +0000, Dave Airlie wrote:
>> On Thu, Oct 30, 2008 at 7:32 AM, Dave Jones <davej@redhat.com> wrote:
>> > On Thu, Oct 30, 2008 at 07:24:34AM +1000, Dave Airlie wrote:
>> >
>> >  > This stops the CPU from using the aperture for most DRI things. I
>> >  > can't confirm this won't regress working systems
>> >  > though. The whole AMD GART thing scares me, esp if some of the host
>> >  > chipsets also have an AGP GART.
>> >
>> > The easy cop-out for those in the past has been 'dont support them'.
>> > It's why we removed some K8 chipset PCI IDs from the via driver for eg.
>> > iirc, if we leave them unprogrammed, they're essentially irrelevant.
>> >
>>
>> I was more going the other way, why use the IOMMU for AGP when it has
>> other tasks to
>> do, and we have a host chipset GART.
>>
>> Granted I've never had an AMD + AGP system to ever care about this.
>
> We're specifically talking about AMD64, and we're not using an IOMMU for
> AGP, we're using the AMD64 implementation of the GART for an IOMMU.
> The (possible) danger is that some old AMD64 system could also (or
> instead) try using the GART for AGP and run into a problem since my
> patch wants to disable CPU side access to the aperture, which is fine
> when we're using it as an IOMMU.
>
> In drivers/gpu/drm/drm_memory.c:agp_remap(), there are these comments
> about the part of the code that deals with "cant_use_aperture":
>
> /*
>  * OK, we're mapping AGP space on a chipset/platform on which
>  * memory accesses by the CPU do not get remapped by the GART.
>  * We fix this by using the kernel's page-table instead (that's
>  * probably faster anyhow...).
>  */
>
> So that's encouraging.  Now the question is this:  Can I just go into
> amd64-agp.c and add ".cant_use_aperture=true" to the agp_bridge_driver
> struct?  Who's brave enough to say that will just work? :-)

I have serious doubts about including such a patch without testing on
a large range of AMD64 systems
with a large range of distro/X servers.

Dave.

>
> static const struct agp_bridge_driver amd_8151_driver = {
> ...
>
> The "cant_use_aperture" paths have possibly
> never been tested on amd64 agp systems, but
> are in use on these systems:
>
> alpha-agp.c:    .cant_use_aperture      = true,
> hp-agp.c:       .cant_use_aperture      = true,
> i460-agp.c:     .cant_use_aperture      = true,
> parisc-agp.c:   .cant_use_aperture      = true,
> sgi-agp.c:      .cant_use_aperture = true,
> uninorth-agp.c: .cant_use_aperture      = true,
> uninorth-agp.c: .cant_use_aperture      = true,
>
> Thanks for any more enlightenment,
> Bob Montgomery
>
>
>
>
>
>
>
>
