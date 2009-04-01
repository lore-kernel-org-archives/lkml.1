Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZDAAOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZDAAOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZDAAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:14:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53877 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763952AbZDAAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:14:35 -0400
Date: Tue, 31 Mar 2009 17:14:27 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>,
       Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Remove struct mm_struct::exe_file et al
Message-ID: <20090401001427.GG29821@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 23rd Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task exe symlink".
> introduced struct mm_struct::exe_file and struct mm_struct::num_exe_file_vmas.
> 
> The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
> code. For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit become
> slower, c) patch adds more code than removes in fact. ->exe_file maybe well

Your patch adds a VMA walk with the mmap semaphore held when openning
/proc/*/exe. That gives unrelated tasks the opportunity to contend on each
others mmap semaphores just by doing a readlink on /proc/*/exe.

Did you have any measurements to report showing an improvement in performance
with your patch or are you expecting it to be "slower" based purely on code
inspection? 

(Which reminds me of this thread: http://lkml.org/lkml/2009/3/11/114 )

> defined, but doesn't make sense always. After original executable is unmapped,
> /proc/*/exe will still report it and, more importantly, pin corresponding
> struct file. ->num_exe_file_vmas is even worse -- it just counts number of

->exe_file does not pin the file. It uses the num_exe_file_vmas count to drop
the mm->exe_file reference when the last executable VMA is gone. Since
MAP_EXECUTABLE (and hence VM_EXECUTABLE) is only applied to the first executable
file opened during exec (stored in ->exe_file) and since userspace can't use it
(the mmap syscall code masks it out), num_exe_file_vmas counts VMAs related to 
exe_file.

So ->exe_file does not pin the file any more or less than the old VMA does...

> executable file-backed VMAs even if those VMAs aren't related to ->exe_file.

and this part of your argument is incorrect as well.

> After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka
> "NOMMU: Make VMAs per MM as for MMU-mode linux" no-MMU kernels also
> maintain list of VMAs in ->mmap, so we can switch back for MMU version
> of /proc/*/exe.

Unless the executable is fully unmapped ->exe_file won't change even if
something else manages to get mapped at a lower address. In contrast, the MMU
version is sensitive to changes in the order of the VMAs over the lifetime of
the task. It has worked in the past because MAP_EXECUTABLE only gets applied
during exec, MAP_EXECUTABLE can only be applied by the kernel, all binary
format handlers place the executable low in the mmap, and nothing else
maps MAP_EXECUTABLE regions. While ->exe_file still relies on
MAP_EXECUTABLE, it does not care about the mapped address because it
does not walk the VMAs.

Cheers,
	-Matt Helsley
