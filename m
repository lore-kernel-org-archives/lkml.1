Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYDJX72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYDJX72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYDJX7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:59:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:17826 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYDJX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DKDn78pS0BxG9UyEP+NCsipD1rXYhj5a9A3s9Kl/rXMm1tuxdXj1y3/F6kWN3Td5/rlkCFWIhv+Bg/BBSquVtHHO0RBQ3i8UG9o6fA20G7PBImEJ1RKYPOQ7IfJfpMzhohY4W5sAIBYkfmJRSrRmQh65ZxcWTeLeZU7kEv0dbR0=
Message-ID: <29495f1d0804101659r44f4a8c2wa1ec05a84e7876fe@mail.gmail.com>
Date: Thu, 10 Apr 2008 16:59:15 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [patch 00/17] multi size, and giant hugetlb page support, 1GB hugetlb for x86
Cc: akpm@linux-foundation.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com,
       andi@firstfloor.org, kniht@linux.vnet.ibm.com,
       "Adam Litke" <agl@us.ibm.com>
In-Reply-To: <20080410170232.015351000@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080410170232.015351000@nick.local0.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On 4/10/08, npiggin@suse.de <npiggin@suse.de> wrote:
> Hi,
>
>  I'm taking care of Andi's hugetlb patchset now. I've taken a while to appear
>  to do anything with it because I have had other things to do and also needed
>  some time to get up to speed on it.
>
>  Anyway, from my reviewing of the patchset, I didn't find a great deal
>  wrong with it in the technical aspects. Taking hstate out of the hugetlbfs
>  inode and vma is really the main thing I did.

Have you tested with the libhugetlbfs test suite? We're gearing up for
libhugetlbfs 1.3, so most of the test are uptodate and expected to run
cleanly, even with giant hugetlb page support (Jon has been working
diligently to test with his 16G page support for power). I'm planning
on pushing the last bits out today for Adam to pick up before we start
stabilizing for 1.3, so I'm hoping if you grab tomorrow's development
snapshot from libhugetlbfs.ozlabs.org, things should run ok. Probably
only with just 1G hugepages, though, we haven't yet taught
libhugetlbfs about multiple hugepage size availability at run-time,
but that shouldn't be hard.

>  However on the less technical side, I think a few things could be improved,
>  eg. to do with the configuring and reporting, as well as the "administrative"
>  type of code. I tried to make improvements to things in the last patch of
>  the series. I will end up folding this properly into the rest of the patchset
>  where possible.

I've got a few ideas here. Are we sure that
/proc/sys/vm/nr_{,overcommit}_hugepages is the pool allocation
interface we want going forward? I'm fairly sure we don't. I think
we're best off moving to a sysfs-based allocator scheme, while keeping
/proc/sys/vm/nr_{,overcommit}_hugepages around for the default
hugepage size (which may be the only for many folks for now).

I'm thinking something like:

/sys/devices/system/[DIRNAME]/nr_hugepages ->
nr_hugepages_{default_hugepagesize}
/sys/devices/system/[DIRNAME]/nr_hugepages_default_hugepagesize
/sys/devices/system/[DIRNAME]/nr_hugepages_other_hugepagesize1
/sys/devices/system/[DIRNAME]/nr_hugepages_other_hugepagesize2
/sys/devices/system/[DIRNAME]/nr_overcommit_hugepages ->
nr_overcommit_hugepages_{default_hugepagesize}
/sys/devices/system/[DIRNAME]/nr_overcommit_hugepages_default_hugepagesize
/sys/devices/system/[DIRNAME]/nr_overcommit_hugepages_other_hugepagesize1
/sys/devices/system/[DIRNAME]/nr_overcommit_hugepages_other_hugepagesize2

That is, nr_hugepages in the directory (should it be called vm?
memory? hugepages specifically? I'm looking for ideas!) will just be a
symlink to the underlying default hugepagesize allocator. The files
themselves would probably be named along the lines of:

nr_hugepages_2M
nr_hugepages_1G
nr_hugepages_64K

etc?

We'd want to have a similar layout on a per-node basis, I think (see
my patchsets to add a per-node interface).

>  The other thing I did was try to shuffle the patches around a bit. There
>  were one or two (pretty trivial) points where it wasn't bisectable, and also
>  merge a couple of patches.
>
>  I will try to get this patchset merged in -mm soon if feedback is positive.
>  I would also like to take patches for other architectures or any other
>  patches or suggestions for improvements.

There are definitely going to be conflicts between my per-node stack
and your set, but if you agree the interface should be cleaned up for
multiple hugepage size support, then I'd like to get my sysfs bits
into -mm and work on putting the global allocator into sysfs properly
for you to base off. I think there's enough room for discussion that
-mm may be a bit premature, but that's just my opinion.

Thanks for keeping the patchset uptodate, I hope to do a more careful
review next week of the individual patches.

Thanks,
Nish
