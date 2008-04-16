Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYDPWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYDPWVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYDPWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:21:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:60359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYDPWVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,666,1199692800"; 
   d="scan'208";a="373335458"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Mapping PCI BAR through /sys/devices/pci* sets cache-disable andwrite-through
Date: Wed, 16 Apr 2008 15:23:25 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEE5CEA9@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1208367626.5245.5.camel@koto.keithp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mapping PCI BAR through /sys/devices/pci* sets cache-disable andwrite-through
Thread-Index: Acif7PKL4pIW/qjVROW4LKzgE+b+4wAIpSFA
References: <1208367626.5245.5.camel@koto.keithp.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Keith Packard" <keithp@keithp.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 16 Apr 2008 22:21:03.0083 (UTC) FILETIME=[27FC5BB0:01C8A010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Keith Packard
>Sent: Wednesday, April 16, 2008 10:40 AM
>To: linux-kernel
>Subject: Mapping PCI BAR through /sys/devices/pci* sets 
>cache-disable andwrite-through
>
>The X server recently (within the last year) switched from mapping the
>frame buffer from /dev/mem to using /sys/devices/pci*. This caused a
>significant memory bandwidth reduction for writes, similar to 
>the effect
>caused when the associated MTRR is set to UC instead of WC.
>
>Looking at the code path, we find, in i386:pci_mmap_page_range:
>
>        prot = pgprot_val(vma->vm_page_prot);
>        if (boot_cpu_data.x86 > 3)
>                prot |= _PAGE_PCD | _PAGE_PWT;
>        vma->vm_page_prot = __pgprot(prot);
>
>Which is to say, on any CPU which supports it, force the cache-disable
>and write-through bits on.
>
>Is there some reason this is there? Surely applications should be
>expected to set these attributes correctly, currently using MTRR and in
>the future, using PAT directly.
>

Setting flags "_PAGE_PCD | _PAGE_PWT" maps to PAT_3 which is "UC". So,
the mapping X server will get is UC and if X sets MTRR to WC, it will
not have any effect on this mapping, which will be still UC. There may
be apps which depend on this /sys/ interface giving UC mapping always...

With PAT patches, we now have /sys/devices/pci*resource_wc (in addition
to resource) for any PREFETCHABLE region. So, X has to change to use
that new interface to get WC mapping.

Thanks,
Venki
