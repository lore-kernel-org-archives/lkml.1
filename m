Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbXJQJY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbXJQJY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764693AbXJQJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:24:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:47599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbXJQJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:24:44 -0400
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
	<1192586376.17856.26.camel@caritas-dev.intel.com>
	<p73odeyxi3u.fsf@crumb.suse.de>
	<1192611948.17856.39.camel@caritas-dev.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Oct 2007 11:24:43 +0200
In-Reply-To: <1192611948.17856.39.camel@caritas-dev.intel.com>
Message-ID: <p73k5pmxfdw.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Wed, 2007-10-17 at 10:25 +0200, Andi Kleen wrote:
> > "Huang, Ying" <ying.huang@intel.com> writes:
> > 
> > > Do you think it is a good idea to check the collision between setup data
> > > and memory area used during kernel boot through bootmem allocator?
> > 
> > You can't solve this through bootmem because x86-64 allocates memory
> > in several places before bootmem (using functions in e820.c) Right now
> > this is quite hackish with hard coded areas to avoid conflicts.  But I
> > recently had a need to allocate more memory that early too and changed
> > the code to a generic early reservation interface. With that it would
> > be relatively easy to reserve.
> 
> Can you tell me what that early reservation interface is? What I find in
> x86_64 that does early memory allocation is alloc_low_page, which gets
> non-conflict memory area through e820 map.

It's a new interface I only recently wrote:

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve

Then you can use early_reserve() and the e820 allocator will not touch
it.

> Because setup data is allocated by bootloader or kernel 16-bit setup
> code, and the e820 map is created there too, the memory area used by
> setup data can be made reserved memory area in e820 map by bootloader or
> kernel 16-bit setup code. This way, they will not be overwritten by
> kernel. Do you think this works.

It has a little of a chicken'n'egg problem because the e820 map will
be actually in the area you want to reserve. But it might work too.
Boot data is normally copied before other allocations in head64.c
If you do variable size boot data that might not work though.  And might
be a little fragile overall.

-Andi
