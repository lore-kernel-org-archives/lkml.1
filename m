Return-Path: <linux-kernel-owner+w=401wt.eu-S934281AbYD1Nq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbYD1Nq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbYD1Nqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:46:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:37957 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764816AbYD1Nqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,716,1199692800"; 
   d="scan'208";a="322134744"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Date: Mon, 28 Apr 2008 21:46:44 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Thread-Index: Acio9QEo2iZQZAT0QImmEfDePhks1QAQD4cQ
References: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk>
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "Al Viro" <viro@ftp.linux.org.uk>, <torvalds@linux-foundation.org>
Cc: <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
       <kvm-ia64-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 28 Apr 2008 13:46:45.0503 (UTC) FILETIME=[4C6450F0:01C8A936]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> * EXTRA_CFLAGS do not apply for *.S
> * don't bother with symlinks to ../lib/mem*.S, just add ../lib/mem*.o
>   to object list
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/ia64/kvm/Makefile |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
> index 41b034f..5235339 100644
> --- a/arch/ia64/kvm/Makefile
> +++ b/arch/ia64/kvm/Makefile
> @@ -42,10 +42,7 @@ $(obj)/$(offsets-file): arch/ia64/kvm/asm-offsets.s
>  #
> 
>  EXTRA_CFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
> -
> -$(addprefix $(objtree)/,$(obj)/memcpy.S $(obj)/memset.S):
> -	$(shell ln -snf ../lib/memcpy.S $(src)/memcpy.S)
> -	$(shell ln -snf ../lib/memset.S $(src)/memset.S)
> +EXTRA_AFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
> 
>  common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
> 
> @@ -57,5 +54,5 @@ EXTRA_CFLAGS_vcpu.o += -mfixed-range=f2-f5,f12-f127
>  kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o
>  	mmio.o \ vtlb.o process.o
>  #Add link memcpy and memset to avoid possible structure assignment
> error -kvm-intel-objs += memset.o memcpy.o
> +kvm-intel-objs += ../lib/memset.o ../lib/memcpy.o
>  obj-$(CONFIG_KVM_INTEL) += kvm-intel.o

I don't think it is workable for kvm-ia64.  Currently,  kvm-intel module
needs to be relocated at insertion time, so the code is
position-indenpent. Howerver, lib/*.memset.o(memcoy.o) are not compiled
as position independent code, they can't be linked into the module
correctly in your way. That is why we use symbol link instead of linking
the objects under /lib. 

Xiantao
