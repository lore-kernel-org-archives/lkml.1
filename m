Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZJXLBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZJXLBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 07:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZJXLBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 07:01:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:8922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZJXLBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 07:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,616,1249282800"; 
   d="scan'208";a="739968604"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Chris Wright'" <chrisw@sous-sol.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Sat, 24 Oct 2009 19:01:28 +0800
Subject: RE: [PATCH] intr-remap: allow disabling source id checking
Thread-Topic: [PATCH] intr-remap: allow disabling source id checking
Thread-Index: AcpUSQurx4A0vgWJQH2uxySCcYs1iwATrfCA
Message-ID: <715D42877B251141A38726ABF5CABF2C05509A7677@pdsmsx503.ccr.corp.intel.com>
References: <20091024012606.GB14926@sequoia.sous-sol.org>
In-Reply-To: <20091024012606.GB14926@sequoia.sous-sol.org>
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

Hi Chris,

How about get rid of the 'nointremap' option? Therefore keep only one option for interrupt remapping.

Regards,
Weidong 


Chris Wright wrote:
> Allow users to disable source id checking.  This is really a
> debugging aid 
> for broken BIOS setups.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  Documentation/kernel-parameters.txt |    7 +++++++
>  drivers/pci/intr_remapping.c        |   20 ++++++++++++++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt index 6fa7292..344256c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -982,6 +982,12 @@ and is between 256 and 4096 characters. It is
>  			defined in the file result in a hardware IOTLB flush operation as
>  			opposed to batching them for performance.
> 
> +	intremap=	[X86-64, Intel-IOMMU]
> +			Format: { on (default) | off | nosid }
> +			on	enable Interrupt Remapping (default)
> +			off	disable Interrupt Remapping
> +			nosid	disable Source ID checking
> +
>  	inttest=	[IA64]
> 
>  	iomem=		Disable strict checking of access to MMIO memory
> @@ -1691,6 +1697,7 @@ and is between 256 and 4096 characters. It is
> defined in the file 
> 
>  	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
>  			remapping.
> +			[Deprecated - use intremap=off]
> 
>  	nointroute	[IA-64]
> 
> diff --git a/drivers/pci/intr_remapping.c
> b/drivers/pci/intr_remapping.c 
> index 0ed78a7..136bb6e 100644
> --- a/drivers/pci/intr_remapping.c
> +++ b/drivers/pci/intr_remapping.c
> @@ -18,6 +18,8 @@ static int ir_ioapic_num;
>  int intr_remapping_enabled;
> 
>  static int disable_intremap;
> +static int disable_sourceid_checking;
> +
>  static __init int setup_nointremap(char *str)
>  {
>  	disable_intremap = 1;
> @@ -25,6 +27,22 @@ static __init int setup_nointremap(char *str)
>  }
>  early_param("nointremap", setup_nointremap);
> 
> +static __init int setup_intremap(char *str)
> +{
> +	if (!str)
> +		return -EINVAL;
> +
> +	if (!strncmp(str, "on", 2))
> +		disable_intremap = 0;
> +	else if (!strncmp(str, "off", 3))
> +		disable_intremap = 1;
> +	else if (!strncmp(str, "nosid", 5))
> +		disable_sourceid_checking = 1;
> +
> +	return 0;
> +}
> +early_param("intremap", setup_intremap);
> +
>  struct irq_2_iommu {
>  	struct intel_iommu *iommu;
>  	u16 irte_index;
> @@ -440,6 +458,8 @@ int free_irte(int irq)
>  static void set_irte_sid(struct irte *irte, unsigned int svt,
>  			 unsigned int sq, unsigned int sid)
>  {
> +	if (disable_sourceid_checking)
> +		svt = SVT_NO_VERIFY;
>  	irte->svt = svt;
>  	irte->sq = sq;
>  	irte->sid = sid;

