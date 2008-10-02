Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYJBLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYJBLh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYJBLhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:37:10 -0400
Received: from po-out-1718.google.com ([72.14.252.157]:24233 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYJBLhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=vyfgkRC3gm6Rd5gwlZZwHpT3eN165UlwH40pfIp7ufEEYFfbA01JyzYfgBqRyxbLmj
         48Kl1Hj7/aeh6wx7AX8MMPObDOKMcO61g20xmIk201l7/e5gE51dN/97r0y0xa5viBS5
         BTCeT9Bh9XYY61G+qn0IuIBwkdnCQI2EDI/CI=
Message-ID: <cfd18e0f0810020437o6562ea70pfa96a171b97d530a@mail.gmail.com>
Date: Thu, 2 Oct 2008 13:37:04 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: ltp getdents syscalls testcases and 2.6.27-rcX
Cc: "Daniel Gollub" <dgollub@suse.de>, viro@zeniv.linux.org.uk,
       ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Petr Gajdos" <pgajdos@suse.cz>
In-Reply-To: <20080924155015.GA27090@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809161427.36373.dgollub@suse.de>
	 <20080924155015.GA27090@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 5:50 PM, Adrian Bunk <bunk@stusta.de> wrote:
> [ kernel people added to Cc ]
>
> On Tue, Sep 16, 2008 at 02:27:36PM +0200, Daniel Gollub wrote:
>> Hi,
>>
>> with 2.6.27-rc1(?) linux/dirent.h got removed Kbuild headers_install targe and
>> dirent struct got removed:
>>
>>
>> commit cf6ae8b50e0ee3f764392dadd1970e3f03c40773
>> Author: Adrian Bunk <bunk@kernel.org>
>> Date:   Fri Jul 25 01:46:46 2008 -0700
>>
>>     remove the in-kernel struct dirent{,64}
>>
>>     The kernel struct dirent{,64} were different from the ones in
>>     userspace.
>>
>>     Even worse, we exported the kernel ones to userspace.
>>
>>     But after the fat usages are fixed we can remove the conflicting
>>     kernel versions.
>>
>>
>> This broke the build of some LTP syscalls testcases for "getdents", since the
>> <linux/dirent.h> include is missing and the "internal" dirent struct get/got
>> used in:
>>
>> testcases/kernel/syscalls/getdents/getdents01.c
>> testcases/kernel/syscalls/getdents/getdents03.c
>> testcases/kernel/syscalls/getdents/getdents02.c
>> testcases/kernel/syscalls/getdents/getdents04.c
>>
>> http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/syscalls/getdents/
>>
>> Is it safe to use the userspace dirent struct from <dirent.h> to fix the build
>> of this? Or what should be used for testing the getdents interface instead?
>
> Thanks for your report.
>
> I missed this since the kernel sys_getdents() did not use the
> "struct dirent" from the header but an own "struct linux_dirent".
>
> It might be safe since the LTP tests don't seem to care whether
> getdents() returns nonsense.
>
> But it is not correct since the reason why I removed this struct from
> the userspace headers was that the kernel and libc structs are
> *different*.
>
> E.g. when I enable the commented out code in getdents01.c I get the
> expected result that using <dirent.h> instead of <linux/dirent.h>
> changes a PASS into a FAIL. [1]
>
> IMHO the solution is something like:
> - move "struct linux_dirent" from fs/readdir.c to include/linux/dirent.h
> - re-export linux/dirent.h to userspace
> - change getdents(2) to consistently use "struct linux_dirent"
>
> Questions to fsdevel:
> - Do we need to preserve API compatibility with compatibility #define's
>  for struct dirent{,64} here?
> - LTP does malloc(sizeof(struct dirent)).
>  Is this considered a valid API usage that must continue to work?
>
>> best regards,
>> Daniel

I've made some changes to the readdir(2) and getdents(2) man pages to
make it clearer that the "dirent" structures used by these to syscalls
are different from one another (old_linux_dirent vs linux_dirent), and
also different from that used by glibc's readdir(3). (dirent)  The
changes are already pushed out to man-pages git.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
