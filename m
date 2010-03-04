Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0CDP7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:59:04 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18732 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0CDP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:59:00 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz146fK1418M1432R98dN10d1Izz1202hzzz32i6bh2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRLPD-01-IXE-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 16:58:20 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka
 NPT-Virtualization)
Message-ID: <20100304155820.GA6019@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <20100304144255.GA26657@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100304144255.GA26657@amt.cnet>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 15:58:20.0757 (UTC) FILETIME=[8329B850:01CABBB3]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:42:55AM -0300, Marcelo Tosatti wrote:
> On Wed, Mar 03, 2010 at 08:12:03PM +0100, Joerg Roedel wrote:
> > Hi,
> > 
> > here are the patches that implement nested paging support for nested
> > svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> > in the first round to get feedback about the general direction of the
> > changes.  Nevertheless I am proud to report that with these patches the
> > famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> > in the l1 guest when l2 is single-processor. With SMP guests the
> > situation is very different. The more vcpus the guest has the more is
> > the performance drop from l1 to l2. 
> > Anyway, this post is to get feedback about the overall concept of these
> > patches.  Please review and give feedback :-)
> 
> Joerg,
> 
> What perf gain does this bring ? (i'm not aware of the current
> overhead).

The benchmark was an allnoconfig kernel compile in tmpfs which took with
the same guest image:

as l1-guest with npt:
		
		2m23s

as l2-guest with l1(nested)-l2(shadow):
	
		around 8-9 minutes

as l2-guest with l1(nested)-l2(shadow) without the recent msrpm
optimization:

		around 19 minutes

as l2-guest with l1(nested)-l2(nested) [this patchset]:

		2m25s-2m30s

> Overall comments:
> 
> Can't you translate l2_gpa -> l1_gpa walking the current l1 nested
> pagetable, and pass that to the kvm tdp fault path (with the correct
> context setup)?

If I understand your suggestion correctly, I think thats exactly whats
done in the patches. Some words about the design:

For nested-nested we need to shadow the l1-nested-ptable on the host.
This is done using the vcpu->arch.mmu context which holds the l1 paging
modes while the l2 is running. On a npt-fault from the l2 we just
instrument the shadow-ptable code. This is the common case. because it
happens all the time while the l2 is running.

The other thing is that vcpu->arch.mmu.gva_to_gpa is expected to still
work and translate virtual addresses of the l2 into physical addresses
of the l1 (so it can be accessed with kvm functions).

To do this we need to be aware of the L2 paging mode. It is stored in
vcpu->arch.nested_mmu context. This context is only used for gva_to_gpa
translations. It is not used to build shadow page tables or anything
else. Thats the reason only the parts necessary for gva_to_gpa
translations of the nested_mmu context are initialized.

Since we can not use mmu.gva_to_gpa to translate only between l2_gpa and
l1_gpa because this function is required to translate l2_gva to l1_gpa
by other parts of kvm, the function which does this translation is moved
to nested_mmu.gva_to_gpa. So basically the gva_to_gpa function pointers
are swapped between mmu and nested_mmu.

The nested_mmu.gva_to_gpa function is used in translate_gpa_nested which
is assigned to the newly introduced translate_gpa callback of nested_mmu
context.

This callback is used in the walk_addr function to translate every
l2_gpa address we read from cr3 or the guest ptes into l1_gpa to read
the next step from the guest memory.

In the old unnested case the translate_gpa callback would point to a
function which just returns the gpa it is passed to it unmodified. The
walk_addr function is generalized and now there are basically two
versions of it:

	* walk_addr which translates using vcpu->arch.mmu context
	* walk_addr_nested which translates using vcpu->arch.nested_mmu
	  context

Thats pretty much how these patches work.

> You probably need to include a flag in base_role to differentiate
> between l1 / l2 shadow tables (say if they use the same cr3 value).

Not sure if this is necessary. It may be necessary when large pages come
into play. Otherwise the host npt pages are distinguished by the shadow
npt pages by the direct-flag.

	Joerg


