Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYBQQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYBQQ1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYBQQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:27:08 -0500
Received: from webhosting.zipcon.net ([209.221.136.93]:60989 "EHLO
	webhosting.zipcon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYBQQ1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:27:07 -0500
X-Greylist: delayed 3310 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 11:27:07 EST
From: Bill Waddington <william.waddington@beezmo.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMA mapping API on 32-bit X86 with CONFIG_HIGHMEM64G
Date: Sun, 17 Feb 2008 07:31:53 -0800
Message-ID: <qakgr39onfg8q408qhpstffuf5lhpt7c20@4ax.com>
References: <fa.UILz1HxdpfM019FfTnX6mSuY9KE@ifi.uio.no>
In-Reply-To: <fa.UILz1HxdpfM019FfTnX6mSuY9KE@ifi.uio.no>
X-Mailer: Forte Agent 4.2/32.1118
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - webhosting.zipcon.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - beezmo.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 04:16:58 UTC, in fa.linux.kernel you wrote:

>I was looking at the out-of-tree driver for a PCI high-security module 
>(from a vendor who shall remain nameless) today, as we had a problem 
>reported where the device didn't work properly if the computer had more 
>than 4GB of RAM (this is x86 32-bit, with CONFIG_HIGHMEM64G enabled).
>
>Essentially what it was doing was taking some memory that the userspace 
>app was transferring to/from the device, doing get_user_pages on it, and 
>then using the old-style page_to_phys, etc. functions to DMA on that 
>memory instead of the modern DMA API.
>
>However, I'm not sure this strategy would have worked on this platform 
>even if it had been using the proper DMA API. This device has 32-bit DMA 
>limits and is transferring userspace buffers which with HIGHMEM64G 
>enabled could easily have physical addresses over 4GB. The strategy that 
>Linux Device Drivers, 3rd Edition (chapter 15) suggests is doing 
>get_user_pages, creating an SG list from the returned pages and then 
>using dma_map_sg on that list. However, essentially all dma_map_sg in 
>include/asm-x86/dma-mapping_32.h is:
>
>	for_each_sg(sglist, sg, nents, i) {
>		BUG_ON(!sg_page(sg));
>
>		sg->dma_address = sg_phys(sg);
>	}
>
>which does nothing to ensure that the returned physical address is 
>within the device's DMA mask. On 64-bit this triggers IOMMU mapping but 
>on 32-bit it doesn't seem like this case is handled at all. I believe 
>the block and networking layers have their own ways of ensuring that 
>they don't feed such buffers to their drivers if they can't handle it, 
>but a basic character device driver is kind of left out in the cold here 
>and the DMA API doesn't appear to work as documented in this case. Given 
>that x86-32 kernels don't implement any IOMMU support I'm not sure what 
>it actually could do, other than implementing some kind of software 
>bounce buffering of its own..
>
>Are there any in-tree drivers that use this DMA mapping on 
>get_user_pages strategy that could be affected by this?

No takers?  This got me worried about _my_ out-of-tree driver...

>I think the get_free_pages trick is actually pretty silly in this case, 
>the size of the data being transferred is likely such that it would be 
>just as fast or faster to copy to a kernel buffer and DMA to/from there..

That's what I do currently.  If HIGHMEM64G is defined I switch from
user space DMA to an in-driver copy/DMA buffer.

Is there a more elegant/simpler way to do this?  At one time I thought
there was a kernel bounce-buffer hidden behind the DMA API - at least
on some architectures and some memory configurations.

Just my imagination, or is this problem already taken care of in the
kernel?

Thanks,
Bill
-- 
William D Waddington
william.waddington@beezmo.com
"Even bugs...are unexpected signposts on
the long road of creativity..." - Ken Burtch
