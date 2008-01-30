Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYA3BXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYA3BXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYA3BXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:23:34 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35830 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYA3BXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:23:33 -0500
Subject: Re: + fix-procfs-task-exe-symlink.patch added to -mm tree
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de,
       viro@zeniv.linux.org.uk
In-Reply-To: <20080129113646.GA76@tv-sign.ru>
References: <200801270518.m0R5ILbT031199@imap1.linux-foundation.org>
	 <20080127162553.GA8791@tv-sign.ru>
	 <1201565920.10206.149.camel@localhost.localdomain>
	 <20080129113646.GA76@tv-sign.ru>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 29 Jan 2008 17:23:28 -0800
Message-Id: <1201656208.4400.141.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 14:36 +0300, Oleg Nesterov wrote:
> s/mm-commits/lkml/
> 
> On 01/28, Matt Helsley wrote:
> >
> > On Sun, 2008-01-27 at 19:25 +0300, Oleg Nesterov wrote:
> > >
> > > Why? Linux doesn't allow sys_mmap(MAP_EXECUTABLE), so any VM_EXECUTABLE vma
> > > should refer to the same bprm->file which was mapped by elf_map(), no?
> >
> > You're right. So in this case the kernel wouldn't find any VMA marked
> > VM_EXECUTABLE and it would return with -ENOENT. The same would happen
> > with this patch since we drop the extra file reference once the
> > VM_EXECTUABLE VMAs disappear.
> 
> OK, thanks. This leads to another question which I forgot to ask.
> 
> This patch has a lot of complications because it tries to preserve the
> current behaviour: we release the bprm->file when all VM_EXECTUABLE vmas
> are unmapped. Q: is this so important/useful? I don't think this is very
> common case, and I don't quite understand why it is critical to release
> the file. To unmount fs after starting the app? One can always copy

Yes. While most programs don't need this it is still very important for
some critical programs to be able to unmap the executable and thereby
allow unmounting the filesystem. Unfortunately, I don't have a confirmed
specific example for you. A wild guess: some distro install or live CDs
might use this.

> the file before execing, or do "/lib/ld-linus.so application" and then
> unmap the vmas.

So, rather than what ld-linux.so does now:

$ /lib/ld-linux.so.2 /bin/sleep 100 &
[1] 12645
$ cat /proc/12645/maps 
08048000-0804b000 r-xp 00000000 03:04 606421     /bin/sleep
0804b000-0804c000 rw-p 00003000 03:04 606421     /bin/sleep
80000000-8001c000 r-xp 00000000 03:04 688355     /lib/ld-2.7.so
8001c000-8001e000 rw-p 0001b000 03:04 688355     /lib/ld-2.7.so

have ld-linux.so copy the mmap'd executable areas and then unmap the
originals. So it would look roughly like:

0804c000-0804f000 r-xp 00000000 03:04 606421
0804f000-08050000 rw-p 00003000 03:04 606421
80000000-8001c000 r-xp 00000000 03:04 688355     /lib/ld-2.7.so
8001c000-8001e000 rw-p 0001b000 03:04 688355     /lib/ld-2.7.so

Then there'd be no need to have the extra reference counting this patch
adds.

I think these approaches could subtly break existing userspace
applications which don't already use these techniques. Furthermore, I
wonder if some applications may wish to unmount 'everything'. This means
there may be no mount that's acceptable to pin by either copying to or
using a modified ld-linux.so.

Fixing the problem in userspace with these techniques also requires a
non-trivial audit of userspace. There could easily be two tasks that
have little or no apparent relation to each other. One does the unmap
trick and the other expects to be able to unmount. The first would then
need to be modified to cp the executable to a suitable location or
utilize a modified ld-linux.so.

I'd be happy to submit a patch removing the extra reference counting if
there's a way to avoid breaking userspace or if there's consensus that
breaking userspace this way is acceptable.

> (I am not arguing, just curious).

Sure.

> > > I don't understand why do we need ->exe_file_lock. Afaics, all callers of
> > > added_exe_file_vma/removed_exe_file_vma must hold ->mmap_sem, yes? But this
> > > means get_mm_exe_file() can use down_read(mm->map_sem). No?
> >
> > Yes, I could get the task's ->mmap_sem there too and reuse the mmap_sem
> > rather than add a lock. That allows nearly any task to grab another
> > tasks mmap_sem simply by doing a readlink on /proc/pid/exe. So I thought
> > avoiding reuse of the mmap_sem might be best.
> >
> > Do you still think it would be better to reuse mmap_sem?
> 
> Well, we only need down_read(mmap_sem) for the very short time. /proc/pid/maps
> is much "worse" in this sense.

OK. I'll post a patch to remove the spinlock and replace it with
mmap_sem.

> > > > @@ -409,6 +410,7 @@ void mmput(struct mm_struct *mm)
> > > >  	if (atomic_dec_and_test(&mm->mm_users)) {
> > > >  		exit_aio(mm);
> > > >  		exit_mmap(mm);
> > > > +		set_mm_exe_file(mm, NULL);
> > >
> > > This change looks unneeded. exit_mmap() removes all vmas. The last VM_EXECUTABLE
> > > vma should clear ->exe_file via removed_exe_file_vma() ?
> >
> > You're right -- it's redundant. I'll fix that.
> 
> Sorry, I was wrong.
> 
> mmput() has to release ->exe_file if it is called when exec fails before the
> first do_mmmap(MAP_EXECUTABLE). This also means that it is not completely
> trivial to set ->exe_file before exec_mmap(), it can fail. This is solvable,
> but I'm not sure we should do this.
>
> Still, the accounting looks a little bit fragile to me. flush_old_exec()
> increments ->f_count but sets ->num_exe_file_vmas = 0 because we know that
> the next elf_map() will bump ->num_exe_file_vmas and thus "sync" 2 counters.
> But I don't see how to do better if we really want to release the file when
> VM_EXECUTABLE disappears.

OK, I'll leave it unless something better comes to mind.

Thanks for taking a look at this patch and asking questions.

Cheers,
	-Matt Helsley

