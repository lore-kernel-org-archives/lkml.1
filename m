Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYERROI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYERROI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYERRNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:13:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:1967 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYERRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RwbjcqfRmDTwZtGNcPlDz3UUfabBwbIgzmDmnt/ye+vLNnnzNczN6gv3PyQUUJ+SISNgYhlpVQSP5R5JQ3rrz3DYxopVjdU2mE4O04z+fuKXshIDPAW2krF9bvZJ1lF3h2TBvFNa7qM74KRrvFIPwxeH8JlKxgUcwGVIJjGDMjk=
Message-ID: <19f34abd0805181013g8274992uffbdb337e72bfa98@mail.gmail.com>
Date: Sun, 18 May 2008 19:13:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Error in save_stack_trace() on x86_64?
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <48274C9E.3020608@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
	 <48274C9E.3020608@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 11, 2008 at 9:44 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Vegard Nossum wrote:
>>
>> I am having a problem with v2.6.26-rc1 on x86_64. It seems that
>> save_stack_trace() is not able to follow page fault boundaries, since
>> all my saved traces look like this:
>>
>> RIP: 0010:[<ffffffff8039b004>]  [<ffffffff8039b004>]
>> add_uevent_var+0xb4/0x160
>>    ...
>>  [<ffffffff80221f97>] kmemcheck_read+0x127/0x1e0
>>  [<ffffffff80222269>] kmemcheck_access+0x179/0x1d0
>>  [<ffffffff8022231f>] kmemcheck_fault+0x5f/0x80
>>  [<ffffffff8061cd1e>] do_page_fault+0x4de/0x8d0
>>  [<ffffffff8061a7d9>] error_exit+0x0/0x51
>>  [<ffffffffffffffff>] 0xffffffffffffffff
...
>>
>> On 32-bit, I am able to see the calls leading up to the page fault as
>> well. Did I miss something here?
>
> can you give an example?
>
> if a pagefault happens in userspace this trace looks correct.
>
> if it happens in kernel space... I wonder if the separate exception stack
> thing
> is hurting us with the stacks not being properly connected...
> (but oopses and the like seem to come out just fine so I kinda doubt you're
> hitting that)

Okay, this is slightly emberrassing. I made a new test, here's the output:

dump_stack():
 [<ffffffff8062b021>] do_page_fault+0x31/0x70
 [<ffffffff80224195>] ? cpa_fill_pool+0x135/0x140
 [<ffffffff80224c40>] ? change_page_attr_set_clr+0x1c0/0x220
 [<ffffffff80220a21>] ? address_get_pte+0x11/0x30
 [<ffffffff80628fb9>] error_exit+0x0/0x51
 [<ffffffff8028655a>] ? __slab_alloc+0x35a/0x560
 [<ffffffff80286556>] ? __slab_alloc+0x356/0x560
 [<ffffffff80386535>] ? kvasprintf+0x55/0x90
 [<ffffffff80287809>] ? __kmalloc+0xf9/0x110
 [<ffffffff80386535>] ? kvasprintf+0x55/0x90
 [<ffffffff8038660b>] ? kasprintf+0x9b/0xa0
 [<ffffffff802898ba>] ? create_kmalloc_cache+0xaa/0xe0
 [<ffffffff80898193>] ? kmem_cache_init+0xf3/0x170
 [<ffffffff80882b35>] ? start_kernel+0x245/0x340
 [<ffffffff80882457>] ? x86_64_start_kernel+0x257/0x290

save_stack_trace()/print_stack_trace():
 [<ffffffff80213eca>] save_stack_trace+0x2a/0x50
 [<ffffffff8062b049>] do_page_fault+0x59/0x70
 [<ffffffff80628fb9>] error_exit+0x0/0x51
 [<ffffffffffffffff>] 0xffffffffffffffff

And what seems now immediately clear is that the difference is that
the latter doesn't print the unreliable stack frames. Which reminds me
that *I* was the person who submitted the patch to do that:

commit 1650743cdc0db73478f72c57544ce79ea8f3dda6
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Fri Feb 22 19:23:58 2008 +0100

    x86: don't save unreliable stack trace entries

    Currently, there is no way for print_stack_trace() to determine whether
    a given stack trace entry was deemed reliable or not, simply because
    save_stack_trace() does not record this information. (Perhaps needless
    to say, this makes the saved stack traces A LOT harder to read, and
    probably with no other benefits, since debugging features that use
    save_stack_trace() most likely also require frame pointers, etc.)

    This patch reverts to the old behaviour of only recording the reliable trace
    entries for saved stack traces.

    Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Still, this seems to be the better behaviour (that patch should not be
reverted), and I think it's the tracer itself that should be fixed to
not mark these entries as unreliable, like the 32-bit version
apparently does.

I did send a patch in february that would allow the reliability of
frames to be saved along with the frames themselves, though it had no
replies:

http://lkml.org/lkml/2008/2/23/173

Would you reconsider this patch, or provide some feedback if it needs
to be improved? In the meantime, I will make some attempts at making
the pre-pagefault frames be seen as reliable :-)

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
