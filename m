Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYIXPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYIXPvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIXPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:51:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34837 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYIXPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:51:14 -0400
Date: Wed, 24 Sep 2008 18:50:15 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Daniel Gollub <dgollub@suse.de>, viro@zeniv.linux.org.uk,
       mtk.manpages@gmail.com
Cc: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: ltp getdents syscalls testcases and 2.6.27-rcX
Message-ID: <20080924155015.GA27090@cs181140183.pp.htv.fi>
References: <200809161427.36373.dgollub@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200809161427.36373.dgollub@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ kernel people added to Cc ]

On Tue, Sep 16, 2008 at 02:27:36PM +0200, Daniel Gollub wrote:
> Hi,
> 
> with 2.6.27-rc1(?) linux/dirent.h got removed Kbuild headers_install targe and 
> dirent struct got removed:
> 
> 
> commit cf6ae8b50e0ee3f764392dadd1970e3f03c40773
> Author: Adrian Bunk <bunk@kernel.org>
> Date:   Fri Jul 25 01:46:46 2008 -0700
> 
>     remove the in-kernel struct dirent{,64}
>     
>     The kernel struct dirent{,64} were different from the ones in
>     userspace.
>     
>     Even worse, we exported the kernel ones to userspace.
>     
>     But after the fat usages are fixed we can remove the conflicting
>     kernel versions.
> 
> 
> This broke the build of some LTP syscalls testcases for "getdents", since the 
> <linux/dirent.h> include is missing and the "internal" dirent struct get/got 
> used in:
> 
> testcases/kernel/syscalls/getdents/getdents01.c  
> testcases/kernel/syscalls/getdents/getdents03.c
> testcases/kernel/syscalls/getdents/getdents02.c  
> testcases/kernel/syscalls/getdents/getdents04.c
> 
> http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/syscalls/getdents/
> 
> Is it safe to use the userspace dirent struct from <dirent.h> to fix the build 
> of this? Or what should be used for testing the getdents interface instead?

Thanks for your report.

I missed this since the kernel sys_getdents() did not use the
"struct dirent" from the header but an own "struct linux_dirent".

It might be safe since the LTP tests don't seem to care whether 
getdents() returns nonsense.

But it is not correct since the reason why I removed this struct from 
the userspace headers was that the kernel and libc structs are
*different*.

E.g. when I enable the commented out code in getdents01.c I get the 
expected result that using <dirent.h> instead of <linux/dirent.h> 
changes a PASS into a FAIL. [1]

IMHO the solution is something like:
- move "struct linux_dirent" from fs/readdir.c to include/linux/dirent.h
- re-export linux/dirent.h to userspace
- change getdents(2) to consistently use "struct linux_dirent"

Questions to fsdevel:
- Do we need to preserve API compatibility with compatibility #define's
  for struct dirent{,64} here?
- LTP does malloc(sizeof(struct dirent)).
  Is this considered a valid API usage that must continue to work?

> best regards,
> Daniel

cu
Adrian

[1] I don't know whether the code is valid and guaranteed to pass,
    but it's obvious why it fails after the #include change

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

