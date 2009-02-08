Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZBHTX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZBHTX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZBHTXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:23:48 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:39150 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZBHTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:23:47 -0500
Date: Sun, 8 Feb 2009 21:23:40 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.28.4 regression: mmap fails if mlockall used
Message-ID: <20090208192340.mydonrnzi3os734u@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Hugh Dickins <hugh@veritas.com>
References: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi> <Pine.LNX.4.64.0902081802480.14394@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902081802480.14394@blonde.anvils>
User-Agent: Mutt/1.5.19 (2009-01-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 18:25:45 +0000, Hugh Dickins wrote:
> On Sun, 8 Feb 2009, Sami Farin wrote:
> 
> > 2.6.28.2 + gcc-4.3.2-7 works.
> > 2.6.28.4 + gcc-4.4.0-0.16 does not work.
> > I run x86_64 SMP kernel.
> 
> If it's really a bug, in kernel or gcc, then it will help to know
> how 2.6.28.4 + gcc-4.3.2-7 behaves.  And are you using the respective
> version of gcc to build both the kernel and the a.out?

Yes, I used the same gcc for both of them.
I noticed ntpd (started with -m for mlockall) did not work with 2.6.28.4:
getpwnam, getaddrinfo, and maybe others failed.  ntpd was originally compiled
with gcc 4.3.2-7, but using gcc 4.4.0-0.16 did not change anything.

> > # strace ./a.out ntp
> > 12:10:14.780726 mmap(NULL, 2147624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000038>
> 
> I wonder where that 2147624 originates from.  Because EFAULT is exactly

yeah I snipped a bit too much...:

21:01:54.543468 open("/lib64/libnss_files.so.2", O_RDONLY) = 3 <0.000034>
21:01:54.543562 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@ \0\0\0\0\0\0@\0\0\0\0\0\0\0\230\352\0\0\0\0\0\0\0\0\0\0@\0008\0\t\0@\0!\0 \0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\370\1\0\0\0\0\0\0\370\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0\340"..., 832) = 832 <0.000016>
21:01:54.543683 fstat(3, {st_dev=makedev(8, 6), st_ino=101893687, st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=128, st_size=62168, st_atime=2008/11/01-00:18:43, st_mtime=2008/11/01-00:18:43, st_ctime=2008/11/06-23:46:26}) = 0 <0.000012>
21:01:54.543791 mmap(NULL, 2147624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000046>

> what you get on an mmap of a file, following an mlockall(MCL_FUTURE),
> if the file is actually a page or more shorter than the size given:
> the mlocking tries to fault in a non-existent page of the file, if
> in userspace you'd get SIGBUS, but within the kernel it's EFAULT
> returned from the mmap.
> 
> My suspicion is that the 2147624 is just wrong: is it a filesize,

I haven't looked at glibc where it pulls the value.
But  that mmap calls succeeds if mlockall is not called.

Yes, bug can also be in gcc, but I'd bet my euros (but not very many)
on mlock changes introduced in 2.6.28.2 --> 2.6.28.4.

If I don't hear others crying about mlockall in 2.6.28.4
in a week or so, I may bother trying older gcc with 2.6.28.4,
but not right now..

> but the file gets truncated before the mmap? or is it the size given
> in an ELF section perhaps, but the file actually not that big?
> Any ENOSPC in that filesystem recently?

No ENOSPC.
 
> > 12:10:14.780809 close(3)                = 0 <0.000012>
> > 12:10:14.780856 munmap(0x7f3476e0d000, 421232) = 0 <0.000145>
> > 12:10:14.781054 write(2, "./a.out: getpwnam failed: Success\n"..., 34./a.out: getpwnam failed: Success
> > ) = 34 <0.000015>
> > 
> > I can do malloc(3000000), then mmap call is
> > 12:50:20.694207 mmap(NULL, 3002368, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8a8d16b000 <0.003078>
> 
> Whereas in the case of anonymous, we don't have an underlying object
> to fault in (or create the object in response to the mmap), so no
> such problem.
> 
> I didn't manage to reproduce this here, but I wasn't using the same
> version of gcc nor (I'd guess!) your kernel config nor your a.out.

To be sure: you tried to reproduce by compiling the attached file
on 2.6.28.4 kernel?

Thanks for looking at this...!
 
> Hugh

-- 
"Distrust and caution are the parents of security."
 - Benjamin Franklin

