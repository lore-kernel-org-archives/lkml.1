Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYIIGB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYIIGB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYIIGBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:01:45 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:51405 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYIIGBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:01:45 -0400
Message-ID: <48C6113A.3080804@cs.columbia.edu>
Date: Tue, 09 Sep 2008 02:01:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v3][PATCH 5/9] Memory managemnet (restore)
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>	 <Pine.LNX.4.64.0809040404060.5982@takamine.ncl.cs.columbia.edu>	 <1220551683.23386.32.camel@nimitz>  <48C345D2.1020603@cs.columbia.edu> <1220892596.23386.166.camel@nimitz>
In-Reply-To: <1220892596.23386.166.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Sat, 2008-09-06 at 23:09 -0400, Oren Laadan wrote:

[...]

>>>> +	if (writable && !(vma->vm_flags & VM_WRITE))
>>>> +		flags = vma->vm_flags | VM_WRITE;
>>>> +	else if (!writable && (vma->vm_flags & VM_WRITE))
>>>> +		flags = vma->vm_flags & ~VM_WRITE;
>>>> +	cr_debug("flags %#lx\n", flags);
>>>> +	if (flags)
>>>> +		ret = mprotect_fixup(vma, &prev, vma->vm_start,
>>>> +				     vma->vm_end, flags);
>>> Is this to fixup the same things that setup_arg_pages() uses it for?  We
>>> should probably consolidate those calls somehow.  
>> This is needed for a VMA that has modified pages but is read-only: e.g. a
>> task modifies memory then calls mprotect() to make it read-only.
>> Since during restart we will recreate this VMA as read-only, we need to
>> temporarily make it read-write to be able to read the saved contents into
>> it, and then restore the read-only protection.
>>
>> setup_arg_pages() is unrelated, and the code doesn't seem to have much in
>> common.
> 
> Have you looked at mprotect_fixup()?  It deals with two things:
> 1. altering the commit charge against RSS if the mapping is actually
>    writable.
> 2. Merging the VMA with an adjacent one if possible
> 
> We don't want to do either of these two things.  Even if we do merge the
> VMA, it will be a waste of time and energy since we'll just re-split it
> when we mprotect() again.

Your observation is correct; I chose this interface because it's really
simple and handy. I'm not worried about the performance because such VMAs
(read only but modified) are really rare, and the code can be optimized
later on.

[...]

>>>> +	/* restore original protection for this vma */
>>>> +	if (!(cr_vma->vm_flags & VM_WRITE))
>>>> +		ret = cr_vma_writable(mm, cr_vma->vm_start, cr_vma->vm_end, 0);
>>>> +
>>>> + out:
>>>> +	return ret;
>>>> +}
>>> Ugh.  Is this a security hole?  What if the user was not allowed to
>>> write to the file being mmap()'d by this VMA?  Is this a window where
>>> someone could come in and (using ptrace or something similar) write to
>>> the file?
>> Not a security hole: this is only for private memory, so it never
>> modifies the underlying file. This is related to what I explained before
>> about read-only VMAs that have modified pages.
> 
> OK, so a shared, read-only mmap() should never get into this code path.
> What if an attacker modified the checkpoint file to pretend to have
> pages for a read-only, but shared mmap().  Would this code be tricked?

VMAs of shared maps (IPC, anonymous shared) will be treated differently.

VMAs of shared files (mapped shared) are saved without their contents,
as the contents remains available on the file system !  (yes, for that
we will eventually need file system snapshots).

As for an attack that provides an altered checkpoint image: since we
(currently) don't escalate privileges, the attacker will not be able
to modify something that it doesn't have access to in the first place.

> 
>> The process is restarting, inside a container that is restarting. All
>> tasks inside should be calling sys_restart() (by design) and no other
>> process from outside should be allowed to ptrace them at this point.
> 
> Are there plans to implement this, or is it already in here somehow?

Once we get positive responses about the current patchset, the next
step is to handle multiple processes: I plan to extend the freezer
with two more state for this purpose (dumping, restarting).

> 
>> (In any case, if some other tasks ptraces this task, it can make it do
>> anything anyhow).
> 
> No.  I'm suggesting that since this lets you effectively write to
> something that is not writable, it may be a hole with which to bypass
> permissions which were set up at an earlier time.

That's a good comment, but here all we are doing here is to modify a
privately mapped/anonymous memory.

> 
>>> We copy into the process address space all the time when not in its
>>> context explicitly.  
>> Huh ?
> 
> I'm just saying that you don't need to be in a process's context in
> order to copy contents into its virtual address space.  Check out
> access_process_vm().
> 

That would be the other way to implement the restart. But, since restart
executes in task's context, it's simpler and more efficient to leverage
copy-to-user().
In terms of security, both methods brings about the same end results: the
memory is modified (perhaps bypassing the read-only property of the VMA)

Oren.
