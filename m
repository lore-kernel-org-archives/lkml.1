Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYKFDpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYKFDpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYKFDpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:45:43 -0500
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:53033 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYKFDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:45:41 -0500
From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: "Luck, Tony" <tony.luck@intel.com>
Date: Thu, 06 Nov 2008 14:01:19 +1100
Message-ID: <49125DFF.5080900@cse.unsw.edu.au>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
CC: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
References: <490F880E.4000801@cse.unsw.edu.au> <57C9024A16AD2D4C97DC78E552063EA35BE05F00@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35BE05F00@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> Added Cc: linux-ia64 ... more likely to attract attention of HP
> ia64 experts there.
> 
>> arch/ia64/hp/common/sba_iommu.c: I/O MMU is out of mapping resources
> 
> Odd ... the code (back to the dawn of git time in 2.6.12-rc1) looks like
> 
>         panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n"
>                 ioc->ioc_hpa);
> 
> I wonder why you don't see the "@ HEXADDRESS"?

That was copy paste from memory. You're right. There is a hex address.
I've copied a full message at the end of the email.

> 
>> Using git-bisect, I've zeroed in on the commit that introduced this.
>> Please see the attached file for the commit.
> 
> Did you confirm that reverting this commit on a recent kernel
> fixes the problem (once in a while git bisect can point to
> the wrong commit ... it seems very likely that it got the
> right one here, but it is always good to check).  When I
> tried to use "patch -R" to revert this it got confused on
> the Kconfig file because the lines that were added were
> subsequently changed ... so you may need to revert that
> by hand ... the sba_iommu.c apparently reverted ok).


Yes, reverting this commit in 2.6.27 prevents kernel panic on both
workloads.

> 
>> Other info:
>> System is HP RX6600(16Gb RAM, 16 processors w/ dual cores and HT)
>> 20 SATA disks under software RAID0 with 6 TB capacity.
>> Silicon Image 3124 controller.
>> File system is XFS.
> 
> My HP test system is way too small to attempt to recreate
> this (just 2 cpus & 1 disk).  How long does each of your
> tests take to hit the problems ... a few minutes? Or hours?

The points at which panic occur are variable for both tests but
generally, I felt the panics were occurring nearer to the end of the
750G to 1TB writes.

> 
>> I'd much appreciate some help in fixing this because this panic has
>> basically stalled my own work. I'd be willing to run more tests on my
>> setup to test any patches that possibly fix this issue.
> 
> Adding some printk() before the panic might give a clue as to what
> is going wrong.  Either a bogus call is trying to allocate far
> too much space, or the bitmap is leaking, or we have a totally
> messed up "ioc" structure.
> 
> Printing "pages_needed" the address of "ioc" and some interesting
> fields from ioc (at least ioc->res_size) would help.  I assume
> the the return value from sba_search_bitmap() is ~0x0 ... but
> you should print "pide" just to be sure.


Heres some more info from a printk:

Kernel panic - not syncing: arch/ia64/hp/common/sba_iommu.c: I/O MMU @ 
c0000000fed01000 is out of mapping resources: pide: 
18446744073709551615, pages_needed: 5, iocres_size: 8192

> 
> -Tony

