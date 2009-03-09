Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZCIEgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZCIEgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 00:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZCIEfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 00:35:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:26678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZCIEfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 00:35:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,327,1233561600"; 
   d="scan'208";a="496143713"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Date: Mon, 9 Mar 2009 12:35:42 +0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49B3D678.4050004@redhat.com> <200903091142.06628.sheng.yang@intel.com>
In-Reply-To: <200903091142.06628.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903091235.43083.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009 11:42:05 Yang, Sheng wrote:
> On Sunday 08 March 2009 22:30:16 Avi Kivity wrote:
> > Matthew Wilcox wrote:
> > > On Tue, Feb 24, 2009 at 12:47:38PM +0200, Avi Kivity wrote:
> > >> Do those patches allow using a VF on the host (in other words, does
> > >> the kernel emulate config space accesses)?
> > >
> > > SR-IOV hardware handles config space accesses to virtual functions.  No
> > > kernel changes needed for that aspect of it.
> >
> > Patches 2 and 3 of the patchset that enables SR/IOV in kvm [1] suggest
> > that at the config space is only partially implemented.
> >
> > [1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/29034
>
> Hi Avi
>
> For kernel side, patch 2 is not necessary. Because kernel would read
> VID/DID directly from pci_dev rather than configuration space, which have
> been set properly already.
>
> And very sorry, for the patch 3. We haven't known exactly what's happened.
> I think the problem is caused by guest driver, but didn't confirm(and I
> have some misunderstandings with ZhaoYu for I thought we are agree on the
> reason, but after confirm with him, he didn't agree). I am doing more
> investigations to find the real cause.

Found the reason of patch 3.

After insert guest driver module(vf driver), the driver would do a RMW to the 
command register to enable Bus Master bit(bit 2). And before that, MMIO bit 
have been set in the register. But without the patch 3, guest driver won't see 
the MMIO bit(bit 1), then just set 0x4 to the command register, with the side 
effect to unmap MMIO in QEmu. So patch 3 is needed(and what I thought before 
is right).

Unset the bit only affect the QEmu, which would unmap the mapping for MMIO. 
Kernel side don't need this, so it's OK.

-- 
regards
Yang, Sheng
