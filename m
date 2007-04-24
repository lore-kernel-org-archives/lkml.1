Return-Path: <linux-kernel-owner+w=401wt.eu-S1030876AbXDXVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbXDXVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031081AbXDXVXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:23:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54335
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030876AbXDXVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:23:44 -0400
Date: Tue, 24 Apr 2007 14:23:51 -0700 (PDT)
Message-Id: <20070424.142351.62664098.davem@davemloft.net>
To: ak@suse.de
Cc: ashok.raj@intel.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com, shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when
 devices cannot address entire range.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200704242312.54738.ak@suse.de>
References: <200704242133.16219.ak@suse.de>
	<20070424203304.GB27911@linux-os.sc.intel.com>
	<200704242312.54738.ak@suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Tue, 24 Apr 2007 23:12:54 +0200

> We already have a couple of other IOMMU architectures who essentially have the same
> problem. Have you checked how they solve this?

Sparc64, for one, only uses 32-bit IOMMU addresses.  And we simply
don't try to handle the funny devices at all, in fact we can't
handle the ones that want mappings only in the low 16MB for
example since the hardware IOMMU window usually starts in the
middle of the 32-bit PCI address space.

We do it both because that's faster due to Single Address Cycles, as
mentioned, and also because that's simply is where the hardware's
IOMMU window is.  You can't use 64-bit IOMMU addresses even if you
wanted to on sparc64.

My suggestion would be to allocate top-down in the 32-bit IOMMU space.

That might work, but my gut feeling is that this won't be sufficient
and we'll need some kind of device driver initiated reservation
mechanism for the <16MB et al. weird stuff.
