Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYA2LeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYA2LeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYA2Ld5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:33:57 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:43195 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbYA2Ld4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:33:56 -0500
Date: Tue, 29 Jan 2008 14:36:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de,
       viro@zeniv.linux.org.uk
Subject: Re: + fix-procfs-task-exe-symlink.patch added to -mm tree
Message-ID: <20080129113646.GA76@tv-sign.ru>
References: <200801270518.m0R5ILbT031199@imap1.linux-foundation.org> <20080127162553.GA8791@tv-sign.ru> <1201565920.10206.149.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201565920.10206.149.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mm-commits/lkml/

On 01/28, Matt Helsley wrote:
>
> On Sun, 2008-01-27 at 19:25 +0300, Oleg Nesterov wrote:
> >
> > Why? Linux doesn't allow sys_mmap(MAP_EXECUTABLE), so any VM_EXECUTABLE vma
> > should refer to the same bprm->file which was mapped by elf_map(), no?
>
> You're right. So in this case the kernel wouldn't find any VMA marked
> VM_EXECUTABLE and it would return with -ENOENT. The same would happen
> with this patch since we drop the extra file reference once the
> VM_EXECTUABLE VMAs disappear.

OK, thanks. This leads to another question which I forgot to ask.

This patch has a lot of complications because it tries to preserve the
current behaviour: we release the bprm->file when all VM_EXECTUABLE vmas
are unmapped. Q: is this so important/useful? I don't think this is very
common case, and I don't quite understand why it is critical to release
the file. To unmount fs after starting the app? One can always copy
the file before execing, or do "/lib/ld-linus.so application" and then
unmap the vmas.

(I am not arguing, just curious).

> > I don't understand why do we need ->exe_file_lock. Afaics, all callers of
> > added_exe_file_vma/removed_exe_file_vma must hold ->mmap_sem, yes? But this
> > means get_mm_exe_file() can use down_read(mm->map_sem). No?
>
> Yes, I could get the task's ->mmap_sem there too and reuse the mmap_sem
> rather than add a lock. That allows nearly any task to grab another
> tasks mmap_sem simply by doing a readlink on /proc/pid/exe. So I thought
> avoiding reuse of the mmap_sem might be best.
>
> Do you still think it would be better to reuse mmap_sem?

Well, we only need down_read(mmap_sem) for the very short time. /proc/pid/maps
is much "worse" in this sense.

> > > @@ -409,6 +410,7 @@ void mmput(struct mm_struct *mm)
> > >  	if (atomic_dec_and_test(&mm->mm_users)) {
> > >  		exit_aio(mm);
> > >  		exit_mmap(mm);
> > > +		set_mm_exe_file(mm, NULL);
> >
> > This change looks unneeded. exit_mmap() removes all vmas. The last VM_EXECUTABLE
> > vma should clear ->exe_file via removed_exe_file_vma() ?
>
> You're right -- it's redundant. I'll fix that.

Sorry, I was wrong.

mmput() has to release ->exe_file if it is called when exec fails before the
first do_mmmap(MAP_EXECUTABLE). This also means that it is not completely
trivial to set ->exe_file before exec_mmap(), it can fail. This is solvable,
but I'm not sure we should do this.

Still, the accounting looks a little bit fragile to me. flush_old_exec()
increments ->f_count but sets ->num_exe_file_vmas = 0 because we know that
the next elf_map() will bump ->num_exe_file_vmas and thus "sync" 2 counters.
But I don't see how to do better if we really want to release the file when
VM_EXECUTABLE disappears.

Oleg.

