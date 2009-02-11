Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZBKG4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZBKG4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZBKGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:55:56 -0500
Received: from newbox.bazarnic.net ([209.188.29.80]:53395 "EHLO
	newbox.bazarnic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZBKGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:55:55 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=private; d=bazarnic.net;
  b=RrmgiO46mbUXSssAgLBjuqqfVUJhwL4MDLwO8JuthnPK0j+aTdqvsNBNqCidUw+B;
From: "Doug Bazarnic" <kernel@bazarnic.net>
To: <linux-kernel@vger.kernel.org>
Cc: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Sami Farin'" <safari-kernel@safari.iki.fi>
References: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi> <Pine.LNX.4.64.0902081802480.14394@blonde.anvils> <20090208192340.mydonrnzi3os734u@m.safari.iki.fi> <Pine.LNX.4.64.0902082025470.14955@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902082025470.14955@blonde.anvils>
Subject: RE: 2.6.28.4 regression: mmap fails if mlockall used
Date: Tue, 10 Feb 2009 23:55:50 -0700
Message-ID: <033401c98c15$c868c100$593a4300$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcmKMA7pPQ6pc0wqTde1lUh9tRN4SAB4oBPg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm the mlock.c patch works on 2.6.28.4.  2.6.28.3 works fine.
This issue happens on both Centos 5.2 x86_64 and RHEL 5.3 x86_64.

Without the mlock.c patch, ntpd fails to start on 2.6.28.4:
Feb 10 22:03:19 testbox ntpd[4030]: kernel time sync status 0040
Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.0.0.1" invalid host
address, ignored
Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "::1" invalid host address,
ignored
Feb 10 22:03:19 testbox ntpd[4030]: getaddrinfo: "127.127.1.0" invalid host
address, ignored
Feb 10 22:03:19 testbox ntpd[4030]: Cannot find user `ntp'
Feb 10 22:03:21 testbox ntpd_initres[4034]: parent died before we finished,
exiting

Fyi.. gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)

Thanks to Sami for mentioning ntpd failures, as I was going nuts trying to
figure out why my ntpd.conf file wasn't working anymore.  

Thanks for the patch as well.

Doug Bazarnic

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Hugh Dickins
Sent: Sunday, February 08, 2009 1:57 PM
To: Sami Farin
Cc: Linus Torvalds; Andrew Morton; Lee Schermerhorn; Rik van Riel;
linux-kernel@vger.kernel.org; stable@kernel.org
Subject: Re: 2.6.28.4 regression: mmap fails if mlockall used

On Sun, 8 Feb 2009, Sami Farin wrote:
> On Sun, Feb 08, 2009 at 18:25:45 +0000, Hugh Dickins wrote:
> > On Sun, 8 Feb 2009, Sami Farin wrote:
> > 
> > > 2.6.28.2 + gcc-4.3.2-7 works.
> > > 2.6.28.4 + gcc-4.4.0-0.16 does not work.
> > > I run x86_64 SMP kernel.
> > 
> > If it's really a bug, in kernel or gcc, then it will help to know
> > how 2.6.28.4 + gcc-4.3.2-7 behaves.  And are you using the respective
> > version of gcc to build both the kernel and the a.out?
> 
> Yes, I used the same gcc for both of them.
> I noticed ntpd (started with -m for mlockall) did not work with 2.6.28.4:
> getpwnam, getaddrinfo, and maybe others failed.  ntpd was originally
compiled
> with gcc 4.3.2-7, but using gcc 4.4.0-0.16 did not change anything.
> 
> > > # strace ./a.out ntp
> > > 12:10:14.780726 mmap(NULL, 2147624, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000038>
> > 
> > I wonder where that 2147624 originates from.  Because EFAULT is exactly
> 
> yeah I snipped a bit too much...:
> 
> 21:01:54.543468 open("/lib64/libnss_files.so.2", O_RDONLY) = 3 <0.000034>
> 21:01:54.543562 read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@
\0\0\0\0\0\0@\0\0\0\0\0\0\0\230\352\0\0\0\0\0\0\0\0\0\0@\0008\0\t\0@\0!\0
\0\6\0\0\0\5\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\370\1\0\0\0\
0\0\0\370\1\0\0\0\0\0\0\10\0\0\0\0\0\0\0\3\0\0\0\4\0\0\0\340"..., 832) = 832
<0.000016>
> 21:01:54.543683 fstat(3, {st_dev=makedev(8, 6), st_ino=101893687,
st_mode=S_IFREG|0755, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=128, st_size=62168, st_atime=2008/11/01-00:18:43,
st_mtime=2008/11/01-00:18:43, st_ctime=2008/11/06-23:46:26}) = 0 <0.000012>
> 21:01:54.543791 mmap(NULL, 2147624, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000046>

Right, st_size=62168 but it's mapping 2147624, so it's not surprising
that an EFAULT comes into it if we're mlocking (but see below, you're
perfectly correct).

In my case I don't actually see that happening in the getpwnam() after
the mlockall(), but I can see a similar instance earlier, while it's
mmaping /lib64/libc.so.6.

At first I was very puzzled, then remembered: it does the one oversized
mmap from the file in order to reserve contiguous virtual memory space,
then follows it up with MAP_FIXED mmaps to replace the beyond-EOF parts
with what it actually wants in there.  Fair enough: it could be done
differently, but this is an efficient and accepted way to do it.

> 
> > what you get on an mmap of a file, following an mlockall(MCL_FUTURE),
> > if the file is actually a page or more shorter than the size given:
> > the mlocking tries to fault in a non-existent page of the file, if
> > in userspace you'd get SIGBUS, but within the kernel it's EFAULT
> > returned from the mmap.
> > 
> > My suspicion is that the 2147624 is just wrong: is it a filesize,
> 
> I haven't looked at glibc where it pulls the value.
> But  that mmap calls succeeds if mlockall is not called.
> 
> Yes, bug can also be in gcc, but I'd bet my euros (but not very many)
> on mlock changes introduced in 2.6.28.2 --> 2.6.28.4.

You are perfectly correct.  The 2.6.28 code was careful to hide
the -EFAULT (or other) locking error from higher levels - and we
can see why that's necessary, given MCL_FUTURE and this technique
for reserving space with one oversized mapping from file.  But
the 2.6.28.4 code is mistakenly passing the error back on up.

> 
> If I don't hear others crying about mlockall in 2.6.28.4
> in a week or so, I may bother trying older gcc with 2.6.28.4,
> but not right now..

There may be some tears, but you've really helped to sooth this.

> 
> > but the file gets truncated before the mmap? or is it the size given
> > in an ELF section perhaps, but the file actually not that big?
> > Any ENOSPC in that filesystem recently?
> 
> No ENOSPC.
>  
> > > 12:10:14.780809 close(3)                = 0 <0.000012>
> > > 12:10:14.780856 munmap(0x7f3476e0d000, 421232) = 0 <0.000145>
> > > 12:10:14.781054 write(2, "./a.out: getpwnam failed: Success\n"...,
34./a.out: getpwnam failed: Success
> > > ) = 34 <0.000015>
> > > 
> > > I can do malloc(3000000), then mmap call is
> > > 12:50:20.694207 mmap(NULL, 3002368, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8a8d16b000 <0.003078>
> > 
> > Whereas in the case of anonymous, we don't have an underlying object
> > to fault in (or create the object in response to the mmap), so no
> > such problem.
> > 
> > I didn't manage to reproduce this here, but I wasn't using the same
> > version of gcc nor (I'd guess!) your kernel config nor your a.out.
> 
> To be sure: you tried to reproduce by compiling the attached file
> on 2.6.28.4 kernel?

Silly me missed the attachment, thanks for pointing it out: as I said
above, in my case it didn't actually show the problem (I guess because
my getpwnam() can ignore the network), but stracing it certainly helped
to clarify the issue.

> 
> Thanks for looking at this...!

More thanks to you for reporting it.  Here's a patch against 2.6.28.4
(or applies at offset to current linux-2.6 git), please test and report
back when you've a moment:


[PATCH] mm: fix error case in mlock downgrade reversion

Commit 27421e211a39784694b597dbf35848b88363c248, Manually revert
"mlock: downgrade mmap sem while populating mlocked regions", has
introduced its own regression: __mlock_vma_pages_range() may report
an error (for example, -EFAULT from trying to lock down pages from
beyond EOF), but mlock_vma_pages_range() must hide that from its
callers as before.

Reported-by: Sami Farin <safari-kernel@safari.iki.fi>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 2.6.28.4/mm/mlock.c	2009-02-07 01:00:40.000000000 +0000
+++ linux/mm/mlock.c	2009-02-08 20:12:38.000000000 +0000
@@ -310,7 +310,10 @@ long mlock_vma_pages_range(struct vm_are
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 
-		return __mlock_vma_pages_range(vma, start, end, 1);
+		__mlock_vma_pages_range(vma, start, end, 1);
+
+		/* Hide errors from mmap() and other callers */
+		return 0;
 	}
 
 	/*
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

