Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYJMSJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYJMSJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYJMSIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:08:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:46105 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbYJMSIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,404,1220252400"; 
   d="scan'208";a="390994358"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc selectsCONFIG_INTEL_IOATDMA=y
Date: Mon, 13 Oct 2008 11:05:43 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52066E2EAE@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20081013112631.GD29938@cs181140183.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUILD_FAILURE] 2.6.27-git2 - allyesconfig on powerpc selectsCONFIG_INTEL_IOATDMA=y
Thread-Index: AcktJrbZk9gyLeuJTkeM2yO8vA5KgQANdvcg
References: <20081013101559.GA14372@linux.vnet.ibm.com> <20081013112631.GD29938@cs181140183.pp.htv.fi>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Brice Goglin" <brice@myri.com>, "Jeff Garzik" <jgarzik@redhat.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <apw@shadowen.org>,
       <linuxppc-dev@ozlabs.org>, <sam@ravnborg.org>,
       <e1000-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
X-OriginalArrivalTime: 13 Oct 2008 18:05:44.0809 (UTC) FILETIME=[4FF03D90:01C92D5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Oct 13, 2008 at 03:45:59PM +0530, Kamalesh Babulal wrote:
>> Hi,
>> 
>>    2.6.27-git2 kernel build fails, while building the kernel with

from subject, on PPC.

>> allyesconfig option. The allyesconfig selects CONFIG_INTEL_IOATDMA=y
>> 
>> CC   drivers/dma/ioat_dca.o
>> drivers/dma/ioat_dca.c: In function ‘dca_enabled_in_bios’:
>> drivers/dma/ioat_dca.c:81: error: implicit declaration of function
>> ‘cpuid_eax’ drivers/dma/ioat_dca.c: In function
>> ‘system_has_dca_enabled’: 
>> drivers/dma/ioat_dca.c:91: error: implicit declaration of function
>> ‘boot_cpu_has’ drivers/dma/ioat_dca.c:91: error:
>> ‘X86_FEATURE_DCA’ undeclared (first use in this function)
>> drivers/dma/ioat_dca.c:91: error: (Each undeclared identifier is
>> reported only once drivers/dma/ioat_dca.c:91: error: for each
>> function it appears in.)  
>> drivers/dma/ioat_dca.c: In function ‘ioat_dca_get_tag’:
>> drivers/dma/ioat_dca.c:190: error: implicit declaration of function
>> ‘cpu_physical_id’ make[2]: *** [drivers/dma/ioat_dca.o] Error 1
>> make[1]: *** [drivers/dma] Error 2
>> make: *** [drivers] Error 2
>> ...
> 
> Thanks for the report, the MYRI10GE and IXGBE commits that introduced
> the select's are really broken.

it fixed an obvious bug with CONFIG_IXGBE=y and CONFIG_INTEL_IOATDMA=m, unfortunate that it is so difficult to use Kconfig for the uninitiated.
 
> For fixing it I need to know the intended semantics.
> 
> Brian, Jesse, is it OK to limit the drivers to m with
> CONFIG_INTEL_IOATDMA=m ?

why is the IOATDMA driver not depending on x86?  x86 hardware (32 and 64 bit) are the only machines that will have ioatdma support, since the ioatdma (and dca) device is only in Intel server chipsets since S5000 (aka S5000, S5400, S7400 and derivatives/followons)

What we want, is myri10ge and ixgbe drivers that can build whether or not CONFIG_INTEL_IOATDMA is enabled.  IF CONFIG_INTEL_IOATDMA *is* enabled (which it should not be on PPC) then there are several cases we want to work:
CONFIG_INTEL_IOATDMA=m  ---> CONFIG_IXGBE=[m|n]
CONFIG_INTEL_IOATDMA=y  ---> CONFIG_IXGBE=[m|y|n]
CONFIG_INTEL_IOATDMA=n  ---> CONFIG_IXGBE=[m|y|n]
CONFIG_INTEL_IOATDMA depends on X86

same for myri10ge I think.  I hope that cleared something up, we can seriously use some help from the experts to get Kconfig correct for this.
