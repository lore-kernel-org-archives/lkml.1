Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbZDDScK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbZDDScK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZDDSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:31:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:36261 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZDDSbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Frk0C+X2HRB44U6K9lHf4GpSGCwi/Kirci0zDJkeJ3Ch6wVaFNnjAzakKHjePK760s
         g5t7rhWpyKB6AoOVFK8UfpPT4+8SJBBEQjAF7B/MCSzmoAvDqcV7yfki0T+P3XU9xjEJ
         Pc66CycdtIzxGjALVfEVqd9Mzg39EtZRWbbAU=
MIME-Version: 1.0
In-Reply-To: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
Date: Sat, 4 Apr 2009 12:31:51 -0600
Message-ID: <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, what do you know, it has started again.  Check out this vmstat
output.  I'm getting a huge number of processes in uninterruptible
sleep.  That is bad, right?  I haven't seen numbers like that, even on
a heavy load.

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0 20  30204  13128    392  67836    0    0 10420    56 2126 2542  1  1 50 48
 0 21  30204  13316    380  67648    0    0  4800    12 1142 1321  2  1 50 46
 3 20  30204  13208    372  67932    0    0 24668    72 2298 2666  2  1 50 48
 0 13  30204  13268    372  68196    0    0 33216    88 11021 11494  1  2 43 54
 0 17  30204  12908    336  68272    0    0  4932    52 1546 1542  1  2 50 47
 0 13  30224  14656    348  67784    0   20  5012   116 1338 1433  1  1 50 49
 0 17  30224  13404    384  67856    0    0  4992    72 1372 1525  1  1 50 47
 0 17  30224  13444    348  67908    0    0  5516     0 1355 1400  0  1 50 49
 0 23  30224  13032    332  67972    0    0 12492    32 1346 1409  1  1 45 54
 0 17  30224  13960    372  66896    0    0 26068   228 4266 4962  1  1 35 64
 0 18  30224  13384    352  67624    0    0 10096    64  952 1141  2  1 50 47
 0 24  30224  13048    312  67836    0    0 49276   184 2407 3106  1  1 51 48
 1 31  30224  13864    328  68220    0    0 17664    88 5610 6673  1  1 24 75
 1 27  30224  12992    356  68704    0    0  4828    16 1051 1193  0  1  0 99
 0 27  30224  13072    336  68440    0    0  5324     4  985 1145  1  0  8 91
 0 33  30224  13040    372  68560    0    0  5788    52  916 1171  0  1 29 70
 0 23  30224  14616    392  66928    0    0  3628    68 1047 1187  1  1 17 82
 0 16  30224  13216    384  68332    0    0  5152     8  979 1252  0  0 50 49
 2 18  30224  12872    384  68032    0    0 14832   160 2768 3390  1  1 50 48
 0 16  30224  13632    332  68080    0    0  6192     4 1134 1439  0  1 24 74
 0 22  30224  13392    348  67928    0    0  5048    92  873 1086  1  1  9 90

OUCH, here's an strace snippet (futex takes 216 seconds)...
mprotect(0x7f99ef00d000, 4096, PROT_READ) = 0 <0.000019>
munmap(0x7f99f0273000, 214104)          = 0 <0.000032>
mmap(NULL, 1052672, PROT_READ|PROT_WRITE|PROT_EXEC,
MAP_PRIVATE|MAP_ANONYMOUS|MAP_32BIT, -1, 0) = 0x416c0000 <0.000019>
mprotect(0x416c0000, 4096, PROT_NONE)   = 0 <0.000017>
clone(child_stack=0x417c0250,

flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID,
parent_tidptr=0x417c09e0, tls=0x417c0950, child_tidptr=0x417c09e0) =
27046 <0.000035>
futex(0x417c09e0, FUTEX_WAIT, 27046, NULL) = ? ERESTARTSYS (To be
restarted) <216.418292>
--- SIGINT (Interrupt) @ 0 (0) ---

Oh, now I get it.  Last time i did the strace, I didn't see high
numbers because I didn't kill the process, like I did this time, I
instead did the skinny elephant dance.

Tell me what you want me to do, and I will.

On Sat, Apr 4, 2009 at 12:03 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> Hi Guys,
>
> I've been reading a few threads related to IO, such as the recent ext3
> fixes from Ted and such.  I didn't want to cloud that thread, so I'm
> starting a new one.
>
> Here's something I haven't reported yet, because I haven't been able
> to reproduce or identify in any reasonable way, but may be applicable
> to this thread.
>
> I am seeing instances where my work load is nil, and I run a process,
> which normally does not do a lot of IO.  I get load averages of
> 30-30-28, with a basic lockup for 10 minutes.  The only thing I can
> see that particular app doing is lots of quick IO, mostly reading,
> etc.  But, there was no other major workload at the time.  Also, one
> fix I have employed to reduce my latencies if I'm under heavy load, is
> to use "sync" mount option, or "dirty_bytes".  But, in this instance,
> they had absolutely NO AFFECT.  In addition, if I reboot the problem
> goes away, for awhile.  Swapping is not occurring when I check swap
> after my computer comes back.  So, it seems to me like this problem is
> somewhere primarily outside of the FS layer, or at least outside the
> FS layer TOO.
>
> FYI: dirty_bytes setting has a good affect for me "usually", but not
> in this case.
>
> If the problem was with primarily ext3, why did I not see it in my
> 2.6.17 kernel on my i686 gentoo Linux box?  Unless there were major
> changes to ext3 since then which caused it.  And believe me, I
> understand that this latency issue is soooo difficult to find.  Partly
> because I'm an idiot and didn't report it when I saw it two years ago.
>  If I had reported it then, then you guys would probably be in the
> right frame of mind, knowing what changes had just occurred, etc, etc.
>
> If you want, I can give you an strace on the app I ran.  I'm pretty
> sure it was the one I ran when the problem was occuring. It's 47K
> though.  Hoever, it doesn't appear that any of the system calls took
> any significant amount of time, which seems odd to me, seeing the
> massive lockup.  And, as far as I know, an app can't cause that kind
> of load average of 30 lockup, only the kernel can.  Well, also perhaps
> a reniced and ioniced realtime process could.  Am I right in that?
>
> p.s.
> Right now, I switched to data=writeback mode.  I'm waiting to see if
> this particular problem comes back.  I know that overall latencies do
> decrease when using data=writeback.  And, being on a notebook, with a
> battery, that option is okay for me.
>
