Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbZEFAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbZEFAJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFAJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:09:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:52397 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbZEFAJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:09:02 -0400
Message-ID: <4A00D51D.4080707@snapgear.com>
Date: Wed, 06 May 2009 10:09:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] NOMMU: Make the initial mmap allocation excess behaviour
 Kconfig configurable
References: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>	<20090505212648.17034.18375.stgit@warthog.procyon.org.uk> <20090505151520.070c84c1.akpm@linux-foundation.org>
In-Reply-To: <20090505151520.070c84c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Tue, 05 May 2009 22:26:48 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
>> NOMMU mmap() has an option controlled by a sysctl variable that determines
>> whether the allocations made by do_mmap_private() should have the excess space
>> trimmed off and returned to the allocator.  Make the initial setting of this
>> variable a Kconfig configuration option.
>>
>> The reason there can be excess space is that the allocator only allocates in
>> power-of-2 size chunks, but mmap()'s can be made in sizes that aren't a power
>> of 2.
>>
>> There are two alternatives:
>>
>>  (1) Keep the excess as dead space.  The dead space then remains unused for the
>>      lifetime of the mapping.  Mappings of shared objects such as libc, ld.so
>>      or busybox's text segment may retain their dead space forever.
>>
>>  (2) Return the excess to the allocator.  This means that the dead space is
>>      limited to less than a page per mapping, but it means that for a transient
>>      process, there's more chance of fragmentation as the excess space may be
>>      reused fairly quickly.
>>
>> During the boot process, a lot of transient processes are created, and this can
>> cause a lot of fragmentation as the pagecache and various slabs grow greatly
>> during this time.
>>
>> By turning off the trimming of excess space during boot and disabling batching
>> of frees, Coldfire can manage to boot.

To put that in perspective better. Its not that all ColdFire platforms
don't boot. It depends very much on what you try to run from user space.
Typical small setups (which realistically is most ColdFire systems)
just don't try to run that much. As with anything embedded there is a
great variance on what people try to do...

Regards
Greg



>> A better way of doing things might be to have /sbin/init turn this option off.
>> By that point libc, ld.so and init - which are all long-duration processes -
>> have all been loaded and trimmed.
>>
> 
> Nasty problem.
> 
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -66,7 +66,7 @@ struct percpu_counter vm_committed_as;
>>  int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
>>  int sysctl_overcommit_ratio = 50; /* default is 50% */
>>  int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
>> -int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
>> +int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
>>  int heap_stack_gap = 0;
>>  
> 
> But there's a risk of -ENOMEM regression on other system here?
> 
> It's unlikely to be a huge problem for real-world embedded developers,
> as long as they know about this change.  And because you set the
> Kconfig default to "no change" then I guess they'll be none the wiser.
> 
> I think that patches 2 and 3 (and #1 unless I reorder and redo things)
> are 2.6.30 material.  Agree?
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
