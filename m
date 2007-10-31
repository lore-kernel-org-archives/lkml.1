Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbXJaETn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbXJaETn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJaETg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:19:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbXJaETf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:19:35 -0400
Date: Wed, 31 Oct 2007 05:19:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Duane Griffin <duaneg@dghda.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071031041932.GA12189@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 12:45:35AM +0000, Duane Griffin wrote:
> Accessing a memory mapped region past the last page containing a valid
> file mapping produces a SIGBUS fault (as it should). Running a program
> that does this under gdb, then accessing the invalid memory from gdb,
> causes it to start consuming 100% CPU and become unkillable. Once in
> that state, SysRq-T doesn't show a stack trace for gdb, although it is
> shown as running and stack traces are dumped for other tasks.
> 
> 2.6.22 does not have this bug (gdb just prints '\0' as the contents,
> although arguably that is also a bug, and it should instead report the
> SIGBUS).
> 
> Bisection indicates the problem was introduced by:
> 
> 54cb8821de07f2ffcd28c380ce9b93d5784b40d7
> "mm: merge populate and nopage into fault (fixes nonlinear)"
> 
> The following program demonstrates the issue:
> 
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> 
> int main(int argc, char *argv[])
> {
>         int fd;
>         struct stat buf;
> 
>         if (argc != 2) {
>                 fprintf(stderr, "usage: %s <filename>\n", argv[0]);
>                 exit(1);
>         }
> 
>         fd = open(argv[1], O_RDONLY);
>         fstat(fd, &buf);
>         int count = buf.st_size + sysconf(_SC_PAGE_SIZE);
>         char *file = (char *) mmap(NULL, count, PROT_READ, MAP_PRIVATE, fd, 0);
>         if (file == MAP_FAILED) {
>                 fprintf(stderr, "mmap failed: %s\n", strerror(errno));
>         } else {
>                 char ch;
>                 fprintf(stderr, "using offset %d\n", (count - 1));
>                 ch = file[count - 1];
>                 munmap(file, count);
>         }
>         close(fd);
>         return 0;
> }
> 
> To reproduce the bug, run it under gdb, go up a couple of frames to
> the main function, then access invalid memory, for e.g. with: "print
> file[4095]", or whatever offset was reported.


Well that's probably the best bug report I've ever had, thanks Duane!

The issue is a silly thinko -- I didn't pay enough attention to the ptrace
rules in filemap_fault :( partly I think that's because I don't understand
them and am scared of them ;)

The following minimal patch fixes it here, and should probably be applied to
2.6.23 stable as well as 2.6.24. If you could verify it, that would be much
appreciated.

However I actually don't really like how this all works. I don't like that
filemap.c should have to know about ptrace, or exactly what ptrace wants here.
It's a bit hairy to force insert page into pagecache and pte into pagetables
here, given the races.

In access_process_vm, can't we just zero fill in the case of a sigbus? Linus?
That will also avoid changing applicatoin behaviour due to a gdb read...

Thanks,
Nick

--
Duane Griffin noticed a 2.6.23 regression that will cause gdb to hang when
it tries to access the memory of another process beyond i_size.

This is because the solution to the fault vs invalidate race requires that
we recheck i_size after the page lock is taken. However in that case, I
had not accounted for the fact that ptracers are granted an exception to this
rule.

Cc: Duane Griffin <duaneg@dghda.com>
Cc: stable@kernel.org
Signed-off-by: Nick Piggin <npiggin@suse.de
---
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1374,7 +1374,7 @@ retry_find:
 
 	/* Must recheck i_size under page lock */
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
+	if (unlikely(vmf->pgoff >= size) && vma->vm_mm == current->mm) {
 		unlock_page(page);
 		page_cache_release(page);
 		goto outside_data_content;
