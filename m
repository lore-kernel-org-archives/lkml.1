Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYLKAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYLKAeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLKAeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:34:04 -0500
Received: from www.tglx.de ([62.245.132.106]:48832 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYLKAeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:34:01 -0500
Date: Thu, 11 Dec 2008 01:33:41 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Edward Estabrook <edward.estabrook.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hjk@linutronix.de,
       gregkh@suse.de, edward.estabrook@gmail.com,
       edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Message-ID: <20081211003340.GB3078@local>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> From: Edward Estabrook <Edward_Estabrook@agilent.com>
> 
> Here is a patch that adds the ability to dynamically allocate and use
> coherent DMA
> from userspace by extending the Userspace IO driver.  This patch applies against
> 2.6.28-rc6.

Hi Edward,
sorry I didn't answer sooner. It was not lack of interest in your work, I
just had to think about it (and had quite a lot of other work, too).
I consider your idea of having DMA coherent memory allocatable from userspace
a valid demand. However, the interface should be implemented differently.

As a general requirement, all information you need to pass to userspace has
to go through sysfs. This is a UIO design decision and should not be changed
lightly. Please don't fill information into the allocated memory.

We shouldn't mix dynamically allocated DMA regions with the already existing
static memory mappings. There should be an extra directory, maybe called
/sys/class/uio/uioN/dyn_dma_mem/ containing information about this kind of
DMA memory. This directory would not exist by default, it's only created if
some user actually allocates such memory.

In the UIO core, these mappings should be handled with a dynamic list, not
a static array. The number of possible mappings has to be limited to a
sensible maximum, maybe 50 or 100. The code handling the existing static
mappings could mostly stay as-is.

Userspace can allocate new DMA memory by using some magic number as the offset
parameter of mmap() like you suggested. However, this magic should be just one
of the bits 16..31 (e.g. 0x00010000) to have other bits available for future
extensions.

I think you should also reconsider the way you unmap the memory. It's certainly
right to unmap everything when the device is unregistered, but I think there's
more to think about:
- Should the memory be freed as soon as all users have the device closed?
- What happens if a user calls munmap() on such a mapping?

I'm looking forward to your next version.

Thanks,
Hans

