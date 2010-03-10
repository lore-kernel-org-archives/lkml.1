Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0CJP1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:27:00 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36166 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0CJP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:26:58 -0500
X-SpamScore: -34
X-BigFish: VPS-34(zz1432R98dN936eM179dN9371Pab9bhzz1202hzzz32i2a8h87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ2O8L-01-263-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 16:26:43 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] KVM: MMU: Make tdp_enabled a mmu-context
 parameter
Message-ID: <20100310152643.GO5619@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
 <4B94C0B5.7080507@redhat.com>
 <20100310144426.GK5619@amd.com>
 <4B97B269.3010502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B97B269.3010502@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 15:26:43.0802 (UTC) FILETIME=[16F7DBA0:01CAC066]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 04:53:29PM +0200, Avi Kivity wrote:
> On 03/10/2010 04:44 PM, Joerg Roedel wrote:
> >On Mon, Mar 08, 2010 at 11:17:41AM +0200, Avi Kivity wrote:
> >>On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> >>>This patch changes the tdp_enabled flag from its global
> >>>meaning to the mmu-context. This is necessary for Nested SVM
> >>>with emulation of Nested Paging where we need an extra MMU
> >>>context to shadow the Nested Nested Page Table.
> >>>
> >>>
> >>>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>index ec891a2..e7bef19 100644
> >>>--- a/arch/x86/include/asm/kvm_host.h
> >>>+++ b/arch/x86/include/asm/kvm_host.h
> >>>@@ -254,6 +254,7 @@ struct kvm_mmu {
> >>>  	int root_level;
> >>>  	int shadow_root_level;
> >>>  	union kvm_mmu_page_role base_role;
> >>>+	bool tdp_enabled;
> >>>
> >>This needs a different name, since the old one is still around.
> >>Perhaps we could call it parent_mmu and make it a kvm_mmu pointer.
> >Hmm, how about renaming the global tdp_enabled variable to tdp_usable?
> >The global variable indicates if tdp is _usable_ and we can _enable_ it
> >for a mmu context.
> 
> I think of the global flags as host tdp, and the mmu as guest tdp
> (but maybe this is wrong?).  If that makes sense, the naming should
> reflect that.

The basic flow of the mmu state with npt-npt is:

	1. As long as the L1 is running the arch.mmu context is in tdp
	   mode and builds a direct-mapped page table.
	
	2. When vmrun is emulated and the nested vmcb enables nested
	   paging, arch.mmu is switched to a shadow-mmu mode which now
	   shadows the l1 nested page table.
	   So when the l2-guest runs with nested paging the
	   arch.mmu.tdp_enabled variable on the host is false.
	
	3. On a vmexit emulation the mmu is switched back to tdp
	   handling state.

So the mmu.tdp_enabled parameter is about tdp being enabled for the
mmu context (so mmu.tdp_enabled means that we build a l1-direct-mapped
page table when true or shadow a l1-page-table when false). Thats why I
think the 'tdp_enabled' name makes sense in the mmu-context.
The global flag only shows if an mmu-context could be in tdp-state. So
tdp_usable may be a good name for it.

	Joerg


