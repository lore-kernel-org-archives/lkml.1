Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbXJRGmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbXJRGmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXJRGmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:42:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:25819 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXJRGmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:42:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,293,1188802800"; 
   d="scan'208";a="349325697"
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p73k5pmxfdw.fsf@crumb.suse.de>
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
	 <1192586376.17856.26.camel@caritas-dev.intel.com>
	 <p73odeyxi3u.fsf@crumb.suse.de>
	 <1192611948.17856.39.camel@caritas-dev.intel.com>
	 <p73k5pmxfdw.fsf@crumb.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Oct 2007 14:44:35 +0800
Message-Id: <1192689875.21509.24.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Oct 2007 06:42:05.0749 (UTC) FILETIME=[FF8CA650:01C81151]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 11:24 +0200, Andi Kleen wrote:
> > Can you tell me what that early reservation interface is? What I find in
> > x86_64 that does early memory allocation is alloc_low_page, which gets
> > non-conflict memory area through e820 map.
> 
> It's a new interface I only recently wrote:
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> 
> Then you can use early_reserve() and the e820 allocator will not touch
> it.
> 
> > Because setup data is allocated by bootloader or kernel 16-bit setup
> > code, and the e820 map is created there too, the memory area used by
> > setup data can be made reserved memory area in e820 map by bootloader or
> > kernel 16-bit setup code. This way, they will not be overwritten by
> > kernel. Do you think this works.
> 
> It has a little of a chicken'n'egg problem because the e820 map will
> be actually in the area you want to reserve. But it might work too.
> Boot data is normally copied before other allocations in head64.c
> If you do variable size boot data that might not work though.  And might
> be a little fragile overall.

Although variable size boot data (such as setup data) can be reserved
via early_reserve or e820 map, they may conflict with hard-coded memory
area used by kernel. This means boot loader must know the hard-coded
memory area used by kernel.

Another possible solution is as follow:
1. Bootloader allocates memory for setup data. Just avoid the memory
area after kernel loaded address.
2. In the very early stage of kernel boot (head64.c). Copy all the setup
data to the memory area after _end. And reserve that memory area with
early_reserve (or bad_addr for old code).

In this solution, the only unsafe memory area for setup data from
bootloader is memory area after _end. And kernel can use hard coded
memory area without the risk of conflicting with setup data from
bootloader.

Do you think this solution is better?

Best Regards,
Huang Ying
