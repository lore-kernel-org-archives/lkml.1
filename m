Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZFXXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZFXXVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFXXV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:21:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbZFXXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:21:26 -0400
Date: Wed, 24 Jun 2009 16:21:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not
  mounted
Message-Id: <20090624162125.a3a9b2c4.akpm@linux-foundation.org>
In-Reply-To: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 01:00:56 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> In some circumstances running process needs to re-execute
> its image.
> 
> Among other useful cases, it is _crucial_ for NOMMU arches.
> 
> They need it to perform daemonization. Classic sequence
> of "fork, parent dies, child continues" can't be used
> due to lack of fork on NOMMU, and instead we have to do
> "vfork, child re-exec itself (with a flag to not daemonize)
> and therefore unblocks parent, parent dies".
> 
> Another crucial use case on NOMMU is POSIX shell support.
> Imagine a shell command of the form "func1 | func2 | func3".
> This can be implemented on NOMMU by vforking thrice,
> re-executing the shell in every child in the form
> "<shell> -c 'body of funcN'", and letting parent wait and collect
> exitcodes and such. As far as I can see, it's the only way
> to implement it correctly on NOMMU.
> 
> The program may re-execute itself by name if it knows the name,
> but we generally may be unsure about it. Binary may be renamed,
> or even deleted while it is being run.
> 
> More elegant way is to execute /proc/self/exe.
> This works just fine as long as /proc is mounted.
> 
> But it breaks if /proc isn't mounted, and this can happen in real-world
> usage. For example, when shell invoked very early in initrd/initramfs.

Why can't userspace mount /proc before doing the daemonization?

> With this patch, it is possible to execute /proc/self/exe
> even if /proc is not mounted. In the below example,
> ./sh is a static shell binary:
> 
> # chroot . ./sh
> / # echo $0
> ./sh
> / # . /proc/self/exe
> hush: /proc/self/exe: No such file or directory
> / # /proc/self/exe   <==========
> / # echo $0
> /proc/self/exe
> / # exit
> / # exit
> #
> 
> On an unpatched kernel, command marked with <=== would fail.
> 
> How patch does it: when execve syscall discovers that opening of binary
> image fails, a small bit of code is added to special case "/proc/self/exe"
> string. If binary name is *exactly* that string, and if error is ENOENT
> or EACCES, then exec will still succeed, using current binary's image.
> 
> Please apply.
> 
>
> diff -urp ../linux-2.6.30.org/fs/exec.c linux-2.6.30/fs/exec.c
> --- ../linux-2.6.30.org/fs/exec.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.30/fs/exec.c	2009-06-25 00:20:13.000000000 +0200
> @@ -652,9 +652,25 @@ struct file *open_exec(const char *name)
>  	file = do_filp_open(AT_FDCWD, name,
>  				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
>  				MAY_EXEC | MAY_OPEN);
> -	if (IS_ERR(file))
> -		goto out;
> +	if (IS_ERR(file)) {
> +		if ((PTR_ERR(file) == -ENOENT || PTR_ERR(file) == -EACCES)
> +		 && strcmp(name, "/proc/self/exe") == 0
> +		) {
> +			struct file *sv = file;
> +			struct mm_struct *mm;
>  
> +			mm = get_task_mm(current);
> +			if (!mm)
> +				goto out;
> +			file = get_mm_exe_file(mm);
> +			mmput(mm);
> +			if (file)
> +				goto ok;
> +			file = sv;
> +		}
> +		goto out;
> +	}
> +ok:
>  	err = -EACCES;
>  	if (!S_ISREG(file->f_path.dentry->d_inode->i_mode))
>  		goto exit;

Oh geeze.  Hard-coded "/proc/self/exec" it the middle of the core exec
code?  You're a brave man.

Relatively minor observations:

- The code layout is weird

- This hack should be hidden in a separate function, not splattered
  all over the middle of open_exec().

- That function should be documented in a way which will permit
  readers to understand why it exists.


But don't do any of that yet.  This will be an unpopular patch and I
fear for its future ;)

