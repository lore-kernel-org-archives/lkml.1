Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYEDBCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYEDBCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 21:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYEDBCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 21:02:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:40236 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYEDBCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 21:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,432,1204531200"; 
   d="scan'208";a="277597032"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Date: Sun, 4 May 2008 09:01:54 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC011CAECD@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20080428182416.GE5882@ZenIV.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Thread-Index: AcipXRsxqpHt1seZTI634mx9HKNdkQEJR3dQ
References: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk> <42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com> <20080428141402.GD5882@ZenIV.linux.org.uk> <20080428182416.GE5882@ZenIV.linux.org.uk>
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: "Al Viro" <viro@ftp.linux.org.uk>, <torvalds@linux-foundation.org>,
       <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
       <kvm-ia64-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 04 May 2008 01:01:58.0513 (UTC) FILETIME=[7417CE10:01C8AD82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Airo
    Currenlty,  We only allow CONFIG_KVM_INTEL = m , since it needs to
be relocated at insertion time. 
Xiantao
Al Viro wrote:
> On Mon, Apr 28, 2008 at 03:14:02PM +0100, Al Viro wrote:
>> On Mon, Apr 28, 2008 at 09:46:44PM +0800, Zhang, Xiantao wrote:
>>>>  kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o 
>>>>  mmio.o \ vtlb.o process.o #Add link memcpy and memset to avoid
>>>> possible structure assignment error -kvm-intel-objs += memset.o
>>>> memcpy.o +kvm-intel-objs += ../lib/memset.o ../lib/memcpy.o
>>>>  obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
>>> 
>>> I don't think it is workable for kvm-ia64.  Currently,  kvm-intel
>>> module needs to be relocated at insertion time, so the code is
>>> position-indenpent. Howerver, lib/*.memset.o(memcoy.o) are not
>>> compiled as position independent code, they can't be linked into
>>> the module correctly in your way. That is why we use symbol link
>>> instead of linking the objects under /lib.
>> 
>> symlinks won't work as you use them.  If you really need separately
>> compiled, use file with a couple of #include "../lib/......S" and
>> be done with that.
> 
> ... like this, perhaps?  I still wonder what will happen with either
> this or the original tree if you make CONFIG_KVM_INTEL=y, though -
> won't either variant give you duplicate symbols?
> 
> diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
> index 5235339..e7b9432 100644
> --- a/arch/ia64/kvm/Makefile
> +++ b/arch/ia64/kvm/Makefile
> @@ -54,5 +54,5 @@ EXTRA_CFLAGS_vcpu.o += -mfixed-range=f2-f5,f12-f127
>  kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o
>  	mmio.o \ vtlb.o process.o
>  #Add link memcpy and memset to avoid possible structure assignment
> error -kvm-intel-objs += ../lib/memset.o ../lib/memcpy.o
> +kvm-intel-objs += memset.o memcpy.o
>  obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
> diff --git a/arch/ia64/kvm/memcpy.S b/arch/ia64/kvm/memcpy.S
> new file mode 100644
> index 0000000..c04cdbe
> --- /dev/null
> +++ b/arch/ia64/kvm/memcpy.S
> @@ -0,0 +1 @@
> +#include "../lib/memcpy.S"
> diff --git a/arch/ia64/kvm/memset.S b/arch/ia64/kvm/memset.S
> new file mode 100644
> index 0000000..83c3066
> --- /dev/null
> +++ b/arch/ia64/kvm/memset.S
> @@ -0,0 +1 @@
> +#include "../lib/memset.S"

