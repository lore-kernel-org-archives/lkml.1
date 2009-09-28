Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZI1Co6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZI1Co6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 22:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZI1Co5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 22:44:57 -0400
Received: from mail.crca.org.au ([67.207.131.56]:57907 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZI1Co4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 22:44:56 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AC0234F.2080808@crca.org.au>
Date: Mon, 28 Sep 2009 12:45:35 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au>	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>	<4ABC80B0.5010100@crca.org.au> <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

KAMEZAWA Hiroyuki wrote:
> On Fri, 25 Sep 2009 18:34:56 +1000
> Nigel Cunningham <ncunningham@crca.org.au> wrote:
>> Hi.
>>
>> KAMEZAWA Hiroyuki wrote:
>>>> I have some code in TuxOnIce that needs a bit too (explicitly mark the
>>>> VMA as needing to be atomically copied, for GEM objects), and am not
>>>> sure what the canonical way to proceed is. Should a new unsigned long be
>>>> added? The difficulty I see with that is that my flag was used in
>>>> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
>>>> function would need an extra parameter too..
>>> Hmm, how about adding vma->vm_flags2 ?
>> The difficulty there is that some functions pass these flags as arguments.
>>
> Ah yes. But I wonder some special flags, which is rarey used, can be moved
> to vm_flags2...
> 
> For example,
> 
>  #define VM_SEQ_READ     0x00008000      /* App will access data sequentially */
>  #define VM_RAND_READ    0x00010000      /* App will not benefit from clustered reads */
> are all capsuled under
> mm.h
>  117 #define VM_READHINTMASK                 (VM_SEQ_READ | VM_RAND_READ)
>  118 #define VM_ClearReadHint(v)             (v)->vm_flags &= ~VM_READHINTMASK
>  119 #define VM_NormalReadHint(v)            (!((v)->vm_flags & VM_READHINTMASK))
>  120 #define VM_SequentialReadHint(v)        ((v)->vm_flags & VM_SEQ_READ)
>  121 #define VM_RandomReadHint(v)            ((v)->vm_flags & VM_RAND_READ)
> 
> Or
> 
> 105 #define VM_PFN_AT_MMAP  0x40000000      /* PFNMAP vma that is fully mapped at mmap time */
> is only used under special situation.
> 
> etc..
> 
> They'll be able to be moved to other(new) flag field, IIUC.

I'm working on a patch to do this, and am looking at is_mergeable_vma,
which is invoked via can_vma_merge_after from vma_merge from
madvise_behaviour (which potentially modifies these hint flags). Should
those hints be considered in that function? (Do I need to pass the hints
in as well and check they're equal?)

By the way, VM_ClearReadHint and VM_NormalReadHint are currently unused.
 madvise_behaviour manipulates the flags directly (in preparing
potential replacement values). Not sure if something should be done
about that.

By the way #2, in response to the later message in this thread, I'm
calling the new var vma->vm_hints, and have put it at the end of the
struct at the moment. Is that a good place?

Regards,

Nigel
