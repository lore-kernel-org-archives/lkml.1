Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXLTLhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXLTLhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXLTLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:37:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:42663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbXLTLg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=hsQ9nWUpQjZ4DwVGjDp9DrgyTFZWTITftupDkRqHNFR/7Dbx8M1HTUI5RaVyS3twJBBi1PyeYUZwGjOqso+jmQ5bvGC22pilXwd1/S2wCLU5GEkuU4poDe6JCA7V9VVWWHWqq//Yikf3jvIuqaZc6f8J1/FAHZZVbUlotxRJJH0=
Message-ID: <476A53D4.7040909@gmail.com>
Date: Thu, 20 Dec 2007 12:36:52 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: akpm@linux-foundation.org, lkml@davidb.org, paulus@samba.org
CC: Ulrich Drepper <drepper@redhat.com>, Chris Friesen <cfriesen@nortel.com>,
       Andreas Schwab <schwab@suse.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
References: <20071107152833.6f302c2a.akpm@linux-foundation.org> <20071107161853.044b6e8f.akpm@linux-foundation.org> <18226.27701.782268.375231@cargo.ozlabs.ibm.com> <20071107.180918.263752219.davem@davemloft.net> <jetznxt4wu.fsf@sykes.suse.de> <4733206C.8030903@nortel.com> <4734A4D9.3090907@redhat.com>
In-Reply-To: <4734A4D9.3090907@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Andrew, Paul,

A late coda to this thread, but I'll just note some changes I'm making to
the man page (which I'd like you to review -- please see below), and note a
few other points.

Andrew, you asked about what happens for x86 with the -1 to -4095 return
for other syscalls.  At least two other syscalls suffer the same problem.
>From the fcntl(2) man page:

   BUGS
       A limitation of the Linux system call conventions on some
       architectures  (notably  x86)  means that if a (negative)
       process group ID to be returned by F_GETOWN falls in  the
       range  -1  to  -4095,  then  the  return value is wrongly
       interpreted by glibc as an error in the system call; that
       is,  the  return  value  of fcntl() will be -1, and errno
       will contain the (positive) process group ID.

Some testing just now shows me that lseek() on /dev/mem suffers similar
problems when seeking to bytes 0xfffff001 through to 0xffffffff.

Ulrich Drepper wrote:
> Chris Friesen wrote:
>>> A possible remedy is to return the ticks since process start time, which
>>> delays the wrap around much further.  POSIX only demands consistency
>>> within the same process.
>> This would be an interesting solution.
> 
>> The man page for linux states that the return code is time since system
>> boot, so that could realistically be expected to correlate between
>> different processes.
> 
> The Linux man page is documenting existing functionality on top of what
> the standard requires.  Programmers should ever only require what the
> standard guarantees.
> 
> I am perfectly willing to support a solution where the time is measured
>>from process startup time.  The only code using times() I found is
> cross-platform and most likely does not depend on the value returned is
> usable in isolation (only in a difference).

Did I miss anything?  Is anyone actually working on a solution along these
lines?

In the meantime, for man-pages-2.74, I've reworked the description of the
return value:

   RETURN VALUE
       times() returns the  number  of  clock  ticks  that  have
       elapsed since an arbitrary point in the past.  The return
       value may overflow the possible range  of  type  clock_t.
       On  error,  (clock_t) -1  is  returned,  and errno is set
       appropriately.

I moved the Linux specific details of the return value to NOTES, and added
a warning about relying on those details:

   NOTES
       ...

       On Linux, the "arbitrary point in the  past"  from  which
       the return value of times() is measured has varied across
       kernel versions.  On Linux 2.4 and earlier this point  is
       the  moment the system was booted.  Since Linux 2.6, this
       point is (2^32/HZ) - 300 (i.e., about 429  million)  sec-
       onds  before  system  boot time.  This variability across
       kernel versions (and across Unix  implementations),  com-
       bined  with the fact that the returned value may overflow
       the range of clock_t, means that a  portable  application
       would  be  wise  to  avoid  using this value.  To measure
       changes in elapsed time, use gettimeofday(2) instead.

Under BUGS I added:

   BUGS
       A limitation of the Linux system call conventions on some
       architectures (notably x86) means that on Linux 2.6 there
       is  a small time window (41 seconds) soon after boot when
       times(2) can return -1, falsely indicating that an  error
       occurred.   The  same  problem  can occur when the return
       value wraps passed the maximum value that can  be  stored
       in clockid_t.

Look okay to you folks?

Cheers,

Michael
-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


