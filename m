Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYCaJdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYCaJdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYCaJdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:33:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:10187 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753945AbYCaJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,581,1199692800"; 
   d="scan'208";a="542774401"
Message-ID: <47F0AFD7.5080307@linux.intel.com>
Date: Mon, 31 Mar 2008 02:33:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <47F08AC1.6010406@tungstengraphics.com>
In-Reply-To: <47F08AC1.6010406@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Dave Airlie wrote:
>> When cpa was refactored to the new set_memory_ interfaces, it removed
>> a special case fast path for AGP systems, which did a lot of page by page
>> attribute changing and held the flushes until they were finished. The
>> DRM memory manager also required this to get useable speeds.
>>
>> This introduces a new interface, which accepts an array of memory 
>> addresses
>> to have attributes changed on and to flush once finished.
>>
>> Further changes to the AGP stack to actually use this interface will be
>> published later.
>>
>> Signed-off-by: Dave Airlie <airlied@redhat.com>
>> ---
>>  arch/x86/mm/pageattr-test.c  |   12 ++-
>>  arch/x86/mm/pageattr.c       |  164 
>> +++++++++++++++++++++++++++++++-----------
>>  include/asm-x86/cacheflush.h |    3 +
>>  3 files changed, 132 insertions(+), 47 deletions(-)
>>   
> ...
> Dave,
> Nice work, but how do we handle highmem pages? 

Cache attributes fundamentally work on a mapping and not on physical memory.
(MTRR's are special there, they do work on physical memory, but that's a special case and not relevant here)

So to be honest, your question doesn't make sense;  because all I can do is ask "which mapping of these pages".

Even the old interfaces prior to 2.6.24 only managed to deal with SOME of the mappings of a page.
And if/when future CPUs don't require all mappings to be in sync, clearly the kernel will only change
the mapping that is requested as well.



> Since this is an AGPgart and DRM fastpath, the interface should ideally 
> be adapted to match the data structures used by those callers. 

Actually, the interface has to make sense conceptually convey the right information,
the implementation should not have to second guess internals of AGP/DRM because that
would just be a recipe for disaster.
>The 
> AGPgart module uses an array of addresses, which effectively stops it 
> from using pages beyond the DMA32 limit. The DRM memory manager uses an 
> array of struct page pointers, but using that was, If I understand 
> things correctly, rejected.

yes because simply put, if you pass a struct page to such a function, you're not telling it which
mapping or mappings you want changed....
(And if you say "only the 1:1 mapping, so why doesn't the other side calculate that"... there's no speed gain in doing
the calculation for that on the other side of an interface, and that makes it zero reason to misdesign the interface
to only have the "which mapping" information implicit)

