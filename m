Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYAVSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYAVSZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYAVSZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:25:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:8672 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYAVSZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:25:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,234,1199692800"; 
   d="scan'208";a="506535676"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] X86: fix typo PAT to X86_PAT
Date: Tue, 22 Jan 2008 10:26:10 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE62C219@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080119032849.GA16757@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] X86: fix typo PAT to X86_PAT
Thread-Index: AchaS3SGSlrKixobSbeiKiRF9TOa3QC1sLhg
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com> <20080118210210.GB10717@elte.hu> <20080119032849.GA16757@redhat.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <Yinghai.Lu@Sun.COM>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Jan 2008 18:25:09.0148 (UTC) FILETIME=[1E7885C0:01C85D24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Dave Jones [mailto:davej@redhat.com] 
>Sent: Friday, January 18, 2008 7:29 PM
>To: Ingo Molnar
>Cc: Yinghai Lu; Pallipadi, Venkatesh; LKML
>Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
>
>On Fri, Jan 18, 2008 at 10:02:10PM +0100, Ingo Molnar wrote:
> > 
> > * Dave Jones <davej@redhat.com> wrote:
> > 
> > >  > you mean modifies MTRRs? Which code is that? (besides the 
> > >  > /proc/mtrr userspace API)
> > > 
> > > This exclusion is going to be a real pain in the ass for distro 
> > > kernels. It's impossible for example to build a kernel 
>that will now 
> > > support the MTRR-alike registers on the AMD K6/early 
>Cyrix etc and 
> > > also support PAT.
> > > 
> > > Additionally, given people tend to update their kernels a 
>lot more 
> > > often than they update to a whole new version of X, it 
>means until 
> > > userspace has caught up, we can't ship a kernel with PAT 
>supported, or 
> > > else X gets a lot slower due to the missing mtrr support.
> > 
> > there's no exclusion enforced right now, and if a CPU is 
>PAT-incapable 
> > (or if the kernel is booted nopat) then the MTRR bits 
>should be usable. 
> > But if we boot with PAT enabled, and Xorg gets /proc/mtrr 
>wrong, we'll 
> > see nasty crashes. If it gets them right, it should all 
>still work just 
> > fine. Is this ok? Then, in a year or two, distros can disable write 
> > support to /proc/mtrr. Hm?
>
>A crazy idea just occured to me..  We could make /proc/mtrr an 
>interface
>to set PAT on a range of memory.  This would make it transparently work
>without any changes in X or anything else that sets them in userspace.
>

Yes. We actually used this earlier while we were testing PAT
functionality internally :).

There are some issues though. 
1) Current X does /dev/mem mapping of the region followed by MTRR
setting for this region. For this to work with PAT based MTRR, either
the order has to change (so that there wont be any conflict due to WB
devmem mapping when we try to simulate mtrr) or we need a mechanism to
go and change devmem mapping to reflect the later PAT attribute changes.
2) We will have to fail mtrr setting when there are hard conflicts with
PAT requests.

We will look at this as a possible optimization for next round of PAT
patches. But, to work with existing X, we will have to have mechanism to
go and change existing mappings which is slightly more complicated than
what we already have with current PAT changes.

Thanks,
Venki
