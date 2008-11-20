Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYKTLen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYKTLen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYKTLbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:41 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62589 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYKTLbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:40 -0500
X-BigFish: VPS-54(z21eW5edJz1418M1432R98dR936eQ1805M936fO873fnzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KAMQOH-04-BP3-01
Date: Thu, 20 Nov 2008 12:31:29 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081120113129.GZ13394@amd.com>
References: <20081118154322.GX13394@amd.com> <20081119150504G.fujita.tomonori@lab.ntt.co.jp> <20081119092544.GD29705@8bytes.org> <20081120131951H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081120131951H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 20 Nov 2008 11:31:29.0310 (UTC) FILETIME=[87DC0BE0:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:25:15PM +0900, FUJITA Tomonori wrote:
> On Wed, 19 Nov 2008 10:25:44 +0100
> Joerg Roedel <joro@8bytes.org> wrote:
> > I found issues in network drivers only for now. The two drivers where I
> > found issues are the in-kernel ixgbe driver (I see IO_PAGE_FAULTS
> > there), the ixgbe version from the Intel website has a double-free bug
> > when unloading the driver or changing the device mtu. The same problem
> > was found with the Broadcom NetXtreme II driver.
> 
> I see, thanks. You already reported the bugs to netdev?
> 

Not yet, but I will do so when I can prove the bug is not in my driver
;) (== when my debug code is ready)

> > We can't test all drivers for those bugs until 2.6.28 will be released.
> > And these bugs can corrupt data, for example when a driver frees dma
> > addresses allocated by another driver and these addresses are then
> > reallocated.
> > The only way to protect the drivers from each other is to isolate them
> > in different protection domains. The AMD IOMMU driver prints a WARN_ON()
> > if a driver frees dma addresses not yet mapped. This triggered with the
> > bnx2 and the ixgbe driver.
> 
> It would be better to add such WARN_ON to VT-d. VT-d is everywhere
> nowadays. I think that there are some developers who can test these
> drivers with VT-d.

Yes, I agree.

> > And the data corruption is real, it eat the root-fs of my testbox one
> > time.
> > I agree that we need to fix the drivers. I plan to implement some debug
> > code which allows driver developers to detect those bugs even if they
> > have no IOMMU in the system.
> 
> It's not so hard to add such debug feature to swiotlb, I guess.
> 

Yes, but I prefer to have it outside of any dma_ops implementation. This
way it can also be used to find out if a bug originated from the device
driver or the dma_ops implementation.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

