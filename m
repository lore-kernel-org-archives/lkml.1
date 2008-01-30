Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYA3XdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYA3XdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYA3XdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:33:06 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41830 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbYA3XdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:33:04 -0500
Subject: Re: + fix-procfs-task-exe-symlink.patch added to -mm tree
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de,
       viro@zeniv.linux.org.uk
In-Reply-To: <20080130110617.GA245@tv-sign.ru>
References: <200801270518.m0R5ILbT031199@imap1.linux-foundation.org>
	 <20080127162553.GA8791@tv-sign.ru>
	 <1201565920.10206.149.camel@localhost.localdomain>
	 <20080129113646.GA76@tv-sign.ru>
	 <1201656208.4400.141.camel@localhost.localdomain>
	 <20080130110617.GA245@tv-sign.ru>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Jan 2008 15:32:48 -0800
Message-Id: <1201735968.4028.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 14:06 +0300, Oleg Nesterov wrote:

<snip>

> Err, I was double wrong. It _is_ trivial to set ->exe_file before exec_mmap(),
> 
> 	flush_old_exec:
> 
> + 		get_file(bprm->file);
> + 		set_mm_exe_file(bprm->mm, bprm->file);
> 		retval = exec_mmap(bprm->mm);
> 		if (retval)
> 			goto mmap_failed;
> 
> 		bprm->mm = NULL;		/* We're using it now */
> 
> If exec_mmap() fails, the caller (do_execve) has to mmput(bprm->mm)
> anyway, and this imply set_mm_exe_file(NULL). This way set_mm_exe_file()
> doesn't need any locking.
> 
> Not that this is relly important, but still.

I've got the patch written and will be testing this shortly.

> However. I didn't notice this patch plays with #ifdef CONFIG_PROC_FS.

There are portions in there to deal with the presence or lack of proc
fs. In include/linux/mm_types.h for example. Also, I placed some of the
functions in fs/proc/base.c and avoided the need for #ifdefs in the .c
files.

> Without CONFIG_PROC_FS we seem to leak bprm->file, I'd suggest to move
> get_file(bprm->file) into set_mm_exe_file().

Good catch. Also I noticed that I was still setting the exe_file field
in fork.c regardles of CONFIG_PROC_FS.

So based on your feedback I'm working on 3 patches:
1 - fix the two CONFIG_PROC_FS issues
	a) breaks compilation when CONFIG_PROC_FS is not defined
	b) struct file leak when CONFIG_PROC_FS is not defined
2 - reuse mmap semaphore
3 - move the mm initialization bits in the exec path to close the window
where userspace could see a "NULL" exe_file.

I will post each after it passes testing.

Thanks again!

Cheers,
	-Matt Helsley

