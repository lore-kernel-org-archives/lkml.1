Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZGJTfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZGJTfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZGJTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:35:09 -0400
Received: from mail-gx0-f215.google.com ([209.85.217.215]:61159 "EHLO
	mail-gx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbZGJTfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:35:08 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 15:35:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dFPL74oeJ94GssMbdRWt8gWMNV8NYz8flGoYY8vrfR4w1XPjnsiejnW57M4G9l4wty
         zGOd39RdYvMExcQszMtr8akivwodxhnS2VlkWuMm0lapwMmQVwDCm5mUSMoBM/6eHT4X
         vSrswyWQehQz1IWeCnEea4jdxMdKRVzHXowp0=
MIME-Version: 1.0
In-Reply-To: <24988.1247155628@redhat.com>
References: <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com> 
	<24005.1247134018@redhat.com> <8bd0f97a0907090822g1533e9dt97c3f29ccaf4945b@mail.gmail.com> 
	<24988.1247155628@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 10 Jul 2009 15:29:13 -0400
Message-ID: <8bd0f97a0907101229x143bbacco7f7e716ecda0bbc3@mail.gmail.com>
Subject: Re: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
To: David Howells <dhowells@redhat.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 12:07, David Howells wrote:
> Mike Frysinger wrote:
>> you dont need a MMU (virtual memory) to protect against it.  you only
>> need a MPU which some systems have.
>
> You may not have that either.  FRV doesn't, for example.

i wasnt suggesting every no-mmu architecture had one.  hence the word "some".

> Furthermore, if you
> have an MPU only, you can still do a lot of the missing bits of NOMMU mmap() -
> shared writable disk or NFS files for example, so it can be argued that
> MPU-only systems shouldn't be using mm/nommu.c.

perhaps, but the mmu code cant be used without virtual memory, and we
havent reviewed all the different aspects of the nommu code which
should be split based on MPU availability.  we have a patch locally
that i should push for the next release that adds appropriate calls to
the protection functions in kernel/module.c and mm/nommu.c.  basically
enough to get us up and running with standard rwx markings.

>> > This doesn't only protect the process with a mapping on that file against
>> > its own truncate, but also other processes that have made mappings against
>> > that file.
>>
>> and those too are broken
>
> Not necessarily.  They may not be expecting the truncation.  Just because the
> first process might be incorrect doesn't mean that the other affected processes
> are.

you are correct, but in the end it's largely the same -- there is a
bug in userspace here that someone needs to go fix

>> > Whilst you can argue it either way, you need a better reason to change this
>> > than it causes some LTP failures.  You cannot expect all the MM-related LTP
>> > tests to work against a NOMMU system.
>>
>> crappy programming is likely to crash regardless of standard functions we
>> attempt to disable in the kernel.  this isnt a virtual memory issue at all,
>> it's memory protection.
>
> Are you actually seeing this in a real world situation?  Or just in LTP?

atm, just LTP.  but simply discarding out of hand as "it's an
unrealistic LTP testcase" may not be appropriate.  many of the
testcases in LTP come from real world experience and tests.  i know
many of the tests ive added to LTP werent for fun but stripped down
test cases of real applications failing.

>> > Doing it this way also makes things simpler in the kernel and makes the
>> > system more robust.
>>
>> really?  looks like the kernel is a lot more complicated to me.  the fix here
>> would be to delete a whole bunch of code.
>
> Delete what?  The check for ramfs_nommu_check_mappings()?  That is not
> sufficient.  That might allow truncate to give the pages back to the system,
> but the pages are still pointed to by VMAs and regions.  NOMMU truncate, as it
> stands, will not take care of that: unmap_mapping_range() is not implemented
> for NOMMU as the aforementioned check renders it unnecessary.

so we need to first fix the nommu vmtruncate function so that it
actually updates the VMAs ?

> It is simpler in that we simply reject a truncate that would cut down a mapping
> rather than trying to shrink that mapping.
>
> It is more robust in that if one process has a file mapped, and another process
> truncates it, then that second process isn't prevented from accessing the
> region that has been taken away from it.

it is also different behavior from mmu (i dont know what POSIX has to
say on using truncate on a shared mmap -- this is kind of an edge
case).  we aim to reduce functional differences at the kernel level
rather than attempting to change behavior of every application we come
across.

>> > If a process shared mmaps a file and then wants to truncate it, it can
>> > always munmap the excess first.
>>
>> sure, we could go around changing a whole bunch of things specific to no-mmu,
>> but that's kind of the wrong way to go.  applications shouldnt need to know
>> they're running with different MMU features available.
>
> Can you point to a real world case where this is a problem?
>
>
> Note that it would be very easy to add (if such does not already exist) an LTP
> test that creates a file, expands it, maps it, shrinks it and then attempts to
> alter the removed part of the mapping in the expectation of receiving a SIGBUS.
>
> As it stands, such a test will work on MMU, but go wrong on NOMMU in a
> different way in these two cases.  With the current behaviour, the shrink
> request will be rejected, but the system will survive.  With your proposed
> behaviour, the system will potentially be wrecked.

the behavior would be different, but now you're comparing two
different things.  in the first case (truncating a shared mapping),
all nommu hardware can support this (well, enlarging a mapping may
fail if the memory right after it is not available, but this could
easily happen on a mmu system too).  in the second case, nommu
hardware that has a MPU unit would function the same as the mmu port,
but LTP can (and does) track tests that require virtual memory or
memory protection.  this test in question requires neither.
-mike
