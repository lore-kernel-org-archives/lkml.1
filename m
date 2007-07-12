Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXGLVht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXGLVht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXGLVhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:37:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbXGLVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:37:40 -0400
Date: Thu, 12 Jul 2007 14:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jim.houston@ccur.com
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Kristian Hoegsberg <krh@redhat.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] fix idr_get_new_above id alias bugs
Message-Id: <20070712143501.2c2cdf1f.akpm@linux-foundation.org>
In-Reply-To: <1184097931.3020.73.camel@localhost.localdomain>
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
	<1183422700.3130.27.camel@localhost.localdomain>
	<200707041611.30056.hnguyen@linux.vnet.ibm.com>
	<1184097931.3020.73.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 16:05:31 -0400
Jim Houston <jim.houston@ccur.com> wrote:

> Hoang-Nam Nguyen reported a bug in idr_get_new_above() 
> which occurred with a starting id value like 0x3ffffffc.
> His test module easily reproduced the problem.  Thanks.
> 
> The test revealed the following bugs:
> 
> 1. Relying on shift operations which have undefined results
>    e.g.: 1 << n where n > word size.  On i386 an integer shift
>    only uses the low 5 bits of the shift count.
> 
> 2. An off by one error which prevented the top most layer
>    of the radix tree from being allocated.  This meant that
>    sub_alloc() would allocate an entry in the existing portion
>    of the radix tree which aliased the requested address.  When
>    it tried to allocate id 0x40000000, it might use the slot 
>    belonging to id 0.
> 
> 3. There was also a failure in the code which walked back up
>    the tree if an allocation failed.  The normal case is to
>    descend the tree checking the starting id value against the
>    bitmap at each level.  If the bit is set, we know that the
>    entire sub-tree is full and we can short cut the search.
>    We may still descend to the lowest level and find that the
>    portion of the id space we want is full.  In this case we
>    need to walk back up the tree and continue the search.
>    The existing code just returned to the previous level and
>    continued.  This resulted in an attempt to allocate an id
>    above 0x3ffffffc using the slot for id 0x3ffffc00 instead of
>    0x40000000 which it then claimed to have allocated.  The same
>    problem occurs with 0x3ff as the requested id value if it
>    is already in use.
> 
> With this patch, idr.c should work as advertised allocating id
> values in the range 0...0x7fffffff.  Andrew had speculated that
> it should allow the full range 0...0xffffffff to be used.  I was
> tempted to make changes to allow this, but it would require changes
> to API, e.g. making the starting id value and the return value
> unsigned.

Problem.  There are a large number of IDR changes pending and this
patch breaks in way which I am not at all confident in fixing.

Originarily I'd just dump the earlier patches because bugfixes come
first.  But this time there's a very large dependency trail on the
earlier patches (especially Tejun's extensive sysfs rework in Greg's
driver tree) so the wreckage would be extensive.

Also, it's possible that Tejun's changes already fixed some of the things
which you fixed.  Or added new bugs ;)

Bottom line: a reworked patch against 2.6.22-rc6-mm1 would be muchly
appreciated if poss, please.

While you're there, it would be helpful if you could review all these
pending IDR changes:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-ida-implement-idr-based-id-allocator.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-idr-fix-obscure-bug-in-allocation-path.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-idr-separate-out-idr_mark_full.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_for_each.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_for_each-fix.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_remove_all.patch

Thanks.
