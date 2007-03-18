Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXCRRnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXCRRnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbXCRRnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:43:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34262 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXCRRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:43:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@sw.ru
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
	<20070313190931.1417c012@lxorguk.ukuu.org.uk>
	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	<1174062660.8184.8.camel@localhost.localdomain>
	<m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
	<1174074412.8184.29.camel@localhost.localdomain>
Date: Sun, 18 Mar 2007 11:42:15 -0600
In-Reply-To: <1174074412.8184.29.camel@localhost.localdomain> (Dave Hansen's
	message of "Fri, 16 Mar 2007 12:46:52 -0700")
Message-ID: <m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <hansendc@us.ibm.com> writes:

> On Fri, 2007-03-16 at 12:54 -0600, Eric W. Biederman wrote:
>> Dave Hansen <hansendc@us.ibm.com> writes:
>
>> - Why do limits have to apply to the unmapped page cache?
>
> To me, it is just because it consumes memory.  Unmapped cache is, of
> couse, much more easily reclaimed than mapped files, but it still
> fundamentally causes pressure on the VM.  
>
> To me, a process sitting there doing constant reads of 10 pages has the
> same overhead to the VM as a process sitting there with a 10 page file
> mmaped, and reading that.

I can see temporarily accounting for pages in use for such a
read/write and possibly during things such as read ahead.

However I doubt it is enough memory to be significant, and as
such is probably a waste of time accounting for it.

A memory limit is not about accounting for memory pressure, so I think
the reasoning for wanting to account for unmapped pages as a hard
requirement is still suspect.  A memory limit is to prevent one container
from hogging all of the memory in the system, and denying it to other
containers.

The page cache by definition is a global resource that facilitates
global kernel optimizations.  If we kill those optimizations we
are on the wrong track.  By requiring limits there I think we are
very likely to kill our very important global optimizations, and bring
the performance of the entire system down.

>> - Could you mention proper multi process RSS limits.
>>   (I.e.  we count the number of pages each group of processes have mapped
>>    and limit that).
>>   It is the same basic idea as partial page ownership, but instead of
>>   page ownership you just count how many pages each group is using and
>>   strictly limit that.  There is no page owner ship or partial charges.
>>   The overhead is just walking the rmap list at map and unmap time to
>>   see if this is the first users in the container.  No additional kernel
>>   data structures are needed.
>
> I've tried to capture this.  Let me know what else you think it
> needs.

Requirements:
- The current kernel global optimizations are preserved and useful.

  This does mean one container can affect another when the
  optimizations go awry but on average it means much better
  performance.  For many the global optimizations are what make
  the in-kernel approach attractive over paravirtualization.

Very nice to have:
- Limits should be on things user space have control of.
  
  Saying you can only have X bytes of kernel memory for file
  descriptors and the like is very hard to work with.  Saying you
  can have only N file descriptors open is much easier to deal with.

- SMP Scalability.

  The final implementation should have per cpu counters or per task
  reservations so in most instances we don't need to bounce a global
  cache line around to perform the accounting.

Nice to have:

- Perfect precision.

  Having every last byte always accounted for is nice but a
  little bit of bounded fuzziness in the accounting is acceptable
  if it that make the accounting problem more tractable.

We need several more limits in this discussion to get a full picture,
otherwise we may to try and build the all singing all dancing limit.
- A limit on the number of anonymous pages.
  (Pages that are or may be in the swap cache).
- Filesystem per container quotas.  
  (Only applicable in some contexts but you get the idea).
- Inode, file descriptor, and similar limits.
- I/O limits.

Eric

