Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZDABBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZDABBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZDABBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:01:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:65070 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZDABBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XlQ3q5CA39DvxeVm20asFgOJ6U7Sw626ugMvdhP88kcBEN194IGdVu49+vKg0j9PsG
         oKD0lyXQx6e4wXSUiciLMrUPUwjF8VWjeo/9Hngp5RIVPsfP/4WuT6W8uNB/AFHTGPZc
         ToT9XMCB9X49/nyQnio4/pFmNHpQ4ocR37HSM=
Date: Wed, 1 Apr 2009 05:08:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>,
       Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Remove struct mm_struct::exe_file et al
Message-ID: <20090401010844.GA22398@x200.localdomain>
References: <20090401001427.GG29821@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401001427.GG29821@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 05:14:27PM -0700, Matt Helsley wrote:
> On March 23rd Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task exe symlink".
> > introduced struct mm_struct::exe_file and struct mm_struct::num_exe_file_vmas.
> > 
> > The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
> > code. For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit become
> > slower, c) patch adds more code than removes in fact. ->exe_file maybe well
> 
> Your patch adds a VMA walk with the mmap semaphore held when openning
> /proc/*/exe. That gives unrelated tasks the opportunity to contend on each
> others mmap semaphores just by doing a readlink on /proc/*/exe.

This is dealt with in proc_fd_access_allowed() with ptrace check.

> Did you have any measurements to report showing an improvement in performance
> with your patch or are you expecting it to be "slower" based purely on code
> inspection? 

The performance is restored to previous levels, because code became the same
as before ->exe_file.

> > defined, but doesn't make sense always. After original executable is unmapped,
> > /proc/*/exe will still report it and, more importantly, pin corresponding
> > struct file. ->num_exe_file_vmas is even worse -- it just counts number of
> 
> ->exe_file does not pin the file. It uses the num_exe_file_vmas count to drop
> the mm->exe_file reference when the last executable VMA is gone. Since
> MAP_EXECUTABLE (and hence VM_EXECUTABLE) is only applied to the first executable
> file opened during exec (stored in ->exe_file) and since userspace can't use it
> (the mmap syscall code masks it out), num_exe_file_vmas counts VMAs related to 
> exe_file.

OK.

> So ->exe_file does not pin the file any more or less than the old VMA does...
> 
> > executable file-backed VMAs even if those VMAs aren't related to ->exe_file.
> 
> and this part of your argument is incorrect as well.
> 
> > After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka
> > "NOMMU: Make VMAs per MM as for MMU-mode linux" no-MMU kernels also
> > maintain list of VMAs in ->mmap, so we can switch back for MMU version
> > of /proc/*/exe.
> 
> Unless the executable is fully unmapped ->exe_file won't change even if
> something else manages to get mapped at a lower address. In contrast, the MMU
> version is sensitive to changes in the order of the VMAs over the lifetime of
> the task. It has worked in the past because MAP_EXECUTABLE only gets applied
> during exec, MAP_EXECUTABLE can only be applied by the kernel, all binary
> format handlers place the executable low in the mmap, and nothing else
> maps MAP_EXECUTABLE regions. While ->exe_file still relies on
> MAP_EXECUTABLE, it does not care about the mapped address because it
> does not walk the VMAs.

Both VMA walk for /proc/*/exe and ->exe_file are heuristics and rely on
the fact that userspace can't create explicit VM_EXECUTABLE mappings.
Take out that and ->exe_file becomes incorrect by design -- which is
the point of the patch to remove incorectness.
