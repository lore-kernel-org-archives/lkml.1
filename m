Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYA3LDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYA3LDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYA3LDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:03:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60259 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYA3LDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:03:20 -0500
Date: Wed, 30 Jan 2008 14:06:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de,
       viro@zeniv.linux.org.uk
Subject: Re: + fix-procfs-task-exe-symlink.patch added to -mm tree
Message-ID: <20080130110617.GA245@tv-sign.ru>
References: <200801270518.m0R5ILbT031199@imap1.linux-foundation.org> <20080127162553.GA8791@tv-sign.ru> <1201565920.10206.149.camel@localhost.localdomain> <20080129113646.GA76@tv-sign.ru> <1201656208.4400.141.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201656208.4400.141.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Matt Helsley wrote:
> 
> On Tue, 2008-01-29 at 14:36 +0300, Oleg Nesterov wrote:
> > 
> > This patch has a lot of complications because it tries to preserve the
> > current behaviour: we release the bprm->file when all VM_EXECTUABLE vmas
> > are unmapped. Q: is this so important/useful? I don't think this is very
> > common case, and I don't quite understand why it is critical to release
> > the file. To unmount fs after starting the app? One can always copy
> 
> Yes. While most programs don't need this it is still very important for
> some critical programs to be able to unmap the executable and thereby
> allow unmounting the filesystem. Unfortunately, I don't have a confirmed
> specific example for you. A wild guess: some distro install or live CDs
> might use this.

OK, thanks. I just wanted to be sure I didn't miss some other reason.

> > Sorry, I was wrong.
> > 
> > mmput() has to release ->exe_file if it is called when exec fails before the
> > first do_mmmap(MAP_EXECUTABLE). This also means that it is not completely
> > trivial to set ->exe_file before exec_mmap(), it can fail. This is solvable,
> > but I'm not sure we should do this.
> >
> > Still, the accounting looks a little bit fragile to me. flush_old_exec()
> > increments ->f_count but sets ->num_exe_file_vmas = 0 because we know that
> > the next elf_map() will bump ->num_exe_file_vmas and thus "sync" 2 counters.
> > But I don't see how to do better if we really want to release the file when
> > VM_EXECUTABLE disappears.
> 
> OK, I'll leave it unless something better comes to mind.

Err, I was double wrong. It _is_ trivial to set ->exe_file before exec_mmap(),

	flush_old_exec:

+ 		get_file(bprm->file);
+ 		set_mm_exe_file(bprm->mm, bprm->file);
		retval = exec_mmap(bprm->mm);
		if (retval)
			goto mmap_failed;

		bprm->mm = NULL;		/* We're using it now */

If exec_mmap() fails, the caller (do_execve) has to mmput(bprm->mm)
anyway, and this imply set_mm_exe_file(NULL). This way set_mm_exe_file()
doesn't need any locking.

Not that this is relly important, but still.

However. I didn't notice this patch plays with #ifdef CONFIG_PROC_FS.
Without CONFIG_PROC_FS we seem to leak bprm->file, I'd suggest to move
get_file(bprm->file) into set_mm_exe_file().

> Thanks for taking a look at this patch and asking questions.

Thanks for your answers ;)

Oleg.

