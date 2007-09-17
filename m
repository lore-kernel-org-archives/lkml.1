Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXIQV52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXIQV52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbXIQV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:56:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:36179 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760635AbXIQV4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,266,1186383600"; 
   d="scan'208";a="297124676"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 2/3] Refactor hypercall infrastructure (v3)
Date: Mon, 17 Sep 2007 14:56:50 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE1037F8705@scsmsx412.amr.corp.intel.com>
In-Reply-To: <11900590723438-git-send-email-aliguori@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 2/3] Refactor hypercall infrastructure (v3)
Thread-Index: Acf5ZR80K8jsx6R3QUqjCIa/CMT/jAADsd5w
References: <1190059071649-git-send-email-aliguori@us.ibm.com> <11900590723438-git-send-email-aliguori@us.ibm.com>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Anthony Liguori" <aliguori@us.ibm.com>, <kvm-devel@lists.sourceforge.net>
Cc: "Zachary Amsden" <zach@vmware.com>, <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
X-OriginalArrivalTime: 17 Sep 2007 21:56:50.0846 (UTC) FILETIME=[A6CF93E0:01C7F975]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This patch refactors the current hypercall infrastructure to better
support
> live 
> migration and SMP.  It eliminates the hypercall page by trapping the
UD
> exception that would occur if you used the wrong hypercall instruction
for the
> underlying architecture and replacing it with the right one lazily.
> 
> It also introduces the infrastructure to probe for hypercall available
via
> CPUID leaves 0x40000000.  CPUID leaf 0x40000001 should be filled out
by
> userspace.
> 
> A fall-out of this patch is that the unhandled hypercalls no longer
trap to
> userspace.  There is very little reason though to use a hypercall to
> communicate 
> with userspace as PIO or MMIO can be used.  There is no code in tree
that uses
> userspace hypercalls.
> 
> Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
> 
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index 3b29256..cc5dfb4 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -1,73 +1,110 @@
>  #ifndef __LINUX_KVM_PARA_H
>  #define __LINUX_KVM_PARA_H
> 
> -/*
> - * Guest OS interface for KVM paravirtualization
> - *
> - * Note: this interface is totally experimental, and is certain to
change
> - *       as we make progress.
> +/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.
It
> + * should be used to determine that a VM is running under KVM.

<snip>

> +
> +static inline int kvm_para_available(void)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
> +	memcpy(signature + 0, &ebx, 4);
> +	memcpy(signature + 4, &ecx, 4);
> +	memcpy(signature + 8, &edx, 4);
> +	signature[12] = 0;
> +
> +	if (strcmp(signature, "KVMKVMKVM") == 0)

> +		return 1;
> +
> +	return 0;
> +}

I think we should compare 12 characters (not just 9, as far as my eyes
tell), and can we use some cute one, like "FantasticKVM"? ;-)

Jun
---
Intel Open Source Technology Center
