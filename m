Return-Path: <linux-kernel-owner+w=401wt.eu-S942479AbYCSXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942479AbYCSXEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934869AbYCSVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:31:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbYCSVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:31:12 -0400
Date: Wed, 19 Mar 2008 14:31:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, joe@fruitfly.org
Subject: Re: [Bugme-new] [Bug 10284] New: executables with read bit 'off'
 cannot open /dev/stdin
Message-Id: <20080319143108.c8f8a544.akpm@linux-foundation.org>
In-Reply-To: <bug-10284-10286@http.bugzilla.kernel.org/>
References: <bug-10284-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 19 Mar 2008 13:15:36 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10284
> 
>            Summary: executables with read bit 'off' cannot open /dev/stdin
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.16.27-0.9-smp
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: devfs
>         AssignedTo: fs_devfs@kernel-bugs.osdl.org
>         ReportedBy: joe@fruitfly.org
> 
> 
> Latest working kernel version: 2.6.16.27
> Earliest failing kernel version: 2.4.21
> Distribution: suse
> Hardware Environment: x86_64
> Software Environment:
> Problem Description: if the read bit of a binary executable is off, then open()
> on /dev/stdin fails with a EACCES error.

This is, umm, unexpected?

> Steps to reproduce:
> A short program that calls open on /dev/stdin:
> 
> cat open_stdin.c
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> int main(int argc, char **argv) {
>   open("/dev/stdin",O_RDONLY);
>   return 0;
> }
> 
> tracing system calls with normal operation shows that this completes
> successfully. But: 
> 
> chmod -r open_stdin
> strace ./open_stdin
> execve("./open_stdin", ["./open_stdin"], [/* 96 vars */]) = 0
> brk(0)                                  = 0x501000
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0x2b25d01b6000
> uname({sys="Linux", node="lush", ...})  = 0
> access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
> ... (open's on .so's deleted) ...
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=158841, ...}) = 0
> mmap(NULL, 158841, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2b25d01b7000
> close(3)                                = 0
> open("/lib64/libc.so.6", O_RDONLY)      = 3
> read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\322\1\0"..., 832) =
> 832
> fstat(3, {st_mode=S_IFREG|0755, st_size=1475924, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0x2b25d01de000
> mmap(NULL, 2289896, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
> 0x2b25d02b8000
> madvise(0x2b25d02b8000, 2289896, MADV_SEQUENTIAL|0x1) = 0
> mprotect(0x2b25d03df000, 1044480, PROT_NONE) = 0
> mmap(0x2b25d04de000, 20480, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x126000) = 0x2b25d04de000
> mmap(0x2b25d04e3000, 16616, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x2b25d04e3000close(3)           
>                     = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0x2b25d04e8000
> arch_prctl(ARCH_SET_FS, 0x2b25d04e86d0) = 0
> mprotect(0x2b25d04de000, 12288, PROT_READ) = 0
> munmap(0x2b25d01b7000, 158841)          = 0
> open("/dev/stdin", O_RDONLY)            = -1 EACCES (Permission denied)
> 
> 
> The last line shows a Permission denied error on opening /dev/stdin. If a
> normal filesystem (i.e. not-/dev/) filename is used, the open works normally.
> 
> I have reproduced this on 2.4 and 2.6 kernels
> Just a guess here: is an error flag from attempting to read the binary not
> getting cleared and is being reported when trying to open stdin?
> 

