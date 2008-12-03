Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYLCOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYLCOeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLCOeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:34:08 -0500
Received: from lucidpixels.com ([75.144.35.66]:49319 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYLCOeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:34:07 -0500
Date: Wed, 3 Dec 2008 09:34:04 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: 3ware 9650SE-16ML w/XFS & RAID6: first impressions
Message-ID: <alpine.DEB.1.10.0812030930450.22299@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For read speed, it appears that there is some overhead (2x). With software 
raid6 I used to get 1.0Gbyte/sec read speed, or at least 800MiB/s across the 
entire array, now I only get 538MiB/s across the entire array. However, 
write speed is improved. Before it was in the mid 400s for RAID6 and peaking at
502MiB/s at the outer edge of the drives. For the write speed now, its around 
620-640MiB/s at the end of the array and 580-620MiB/s going in further and 
502MiB/s across the entire array. I always heard all of the horror stories with 3ware cards, it turns out they're not so bad after all.

Here is the STR across a RAID6 array of 10 velociraptors configured as RAID6 with storsave=perform and blockdev --setra 65536 and using the XFS filesystem.

p34:/t# /usr/bin/time dd if=/dev/zero of=really_big_file bs=1M
dd: writing `really_big_file': No space left on device
2288604+0 records in
2288603+0 records out
2399774998528 bytes (2.4 TB) copied, 4777.22 s, 502 MB/s
Command exited with non-zero status 1
1.47user 3322.83system 1:19:37elapsed 69%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+506minor)pagefaults 0swaps

p34:/t# /usr/bin/time dd if=really_big_file of=/dev/null bs=1M
2288603+1 records in
2288603+1 records out
2399774998528 bytes (2.4 TB) copied, 4457.55 s, 538 MB/s
1.66user 1538.87system 1:14:17elapsed 34%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (4major+498minor)pagefaults 0swaps
p34:/t#

So what is the difference between protect, balance and perform?

Protect
p34:~# /opt/3ware/9500/tw_cli /c0/u1 set storsave=protect
Setting Command Storsave Policy for unit /c0/u1 to [protect] ... Done.

p34:/t# dd if=/dev/zero of=bigfile bs=1M count=20480
20480+0 records in
20480+0 records out
21474836480 bytes (21 GB) copied, 60.6041 s, 354 MB/s

Balance:
p34:~# /opt/3ware/9500/tw_cli /c0/u1 set storsave=balance
Setting Command Storsave Policy for unit /c0/u1 to [balance] ... Done.

# dd if=/dev/zero of=bigfile bs=1M count=20480
20480+0 records in
20480+0 records out
21474836480 bytes (21 GB) copied, 60.4287 s, 355 MB/s

Perform
p34:~# /opt/3ware/9500/tw_cli /c0/u1 set storsave=perform
Warning: Unit /c0/u1 storsave policy is set to Performance which may cause data loss in the event of power failure.
Do you want to continue ? Y|N [N]: Y
Setting Command Storsave Policy for unit /c0/u1 to [perform] ... Done.

p34:/t# dd if=/dev/zero of=bigfile bs=1M count=20480
20480+0 records in
20480+0 records out
21474836480 bytes (21 GB) copied, 34.4955 s, 623 MB/s

--

And yes, I have a BBU attached to this card and everything is on a UPS.
Something I do not like though is 3ware states "TwinStor" "TwinStor" etc
etc if you read a file it will read from both drives, maybe it does this but
I have the I/O results to prove it-- it never breaks the barrier of a 
single drive's STR. Whereas with SW RAID, you can read 2 or more files
concurrently and you will get the bandwidth of both drives. I have a lot
more testing to do, RAID0, RAID5, RAID6, RAID10, not sure when I will get
to it but just thought I'd post this to show that 3ware cards aren't as
slow as everyone says, at least not when attached to Velociraptors, a BBU
and XFS as the filesystem.

Justin.
