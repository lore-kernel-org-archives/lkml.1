Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYLKACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYLKACQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYLKABk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:01:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbYLKABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:01:37 -0500
Date: Wed, 10 Dec 2008 17:01:06 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Gilad Ben-Yossef <gilad@codefidence.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       zaitcev@redhat.com
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Message-Id: <20081210170106.d19e568d.zaitcev@redhat.com>
In-Reply-To: <20081210142301.GA11490@localhost>
References: <20081210073247.GA18630@localhost>
	<200812101040.09886.laurent.pinchart@skynet.be>
	<20081210124308.GB6772@localhost>
	<493FCD12.30000@codefidence.com>
	<20081210142301.GA11490@localhost>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 22:23:01 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:

> For 64bit systems, we can easily go beyond 4GB physical memory.
> So at least we should add GFP_DMA32 in addition to GFP_NOIO?

I am afraid the situation is that we really screwed the pooch while
creating the USB API. I may be wrong about this, but my understanding
is that if we get an address above 4GB from kmalloc and then send
it down to usb_submit_urb(), a random memory corruption is likely
(this is because we forget to check the result of dma_map_single()).

The code worked until now because most systems out in the field
either a) had IOMMU, or b) had 4GB or RAM or less, but not both.
The case (a) includes all AMD CPUs, all Itanium CPUs, and the
Intel-based enterprise systems from big vendors, e.g. IBM Calgary,
HP ZX-1, etc. Also, (a) covers Intel P4 class systems with swiotlb.
So, we only blow up if a kernel with swiotlb disabled boots on an
Intel box with more than 4GB of RAM. This is still far from ideal,
but we kinda pretend not to notice. I heard that Intel has seen
the error in their ways and is going to come out with IOMMU for
all their chipsets, so in a few years this is going to be moot.

-- Pete
