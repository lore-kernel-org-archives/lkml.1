Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXF0AQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXF0AQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXF0AQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:16:20 -0400
Received: from mail.suse.de ([195.135.220.2]:47333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXF0AQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:16:19 -0400
Date: Wed, 27 Jun 2007 02:15:54 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070627001554.GA6670@v2.random>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com> <Pine.LNX.4.64.0706252356400.1817@scrub.home> <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com> <20070626161857.GA7178@elte.hu> <20070626164907.GF7059@v2.random> <2c0942db0706261013pd1010b5iebfa912e7c9f8c9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0706261013pd1010b5iebfa912e7c9f8c9c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:13:31AM -0700, Ray Lee wrote:
> faster? Weird. It shouldn't. They must be doing something wrong,
> therefore the patch is stupid."

Just in case it's not obvious the above are Ray Lee words, mine not.

-----------
#!/usr/bin/env stap 

# edited top.stp from systemtap

global syscalls

function print_top () {
	printf ("SYSCALL\t\t\t\tCOUNT\n")
	foreach ([name] in syscalls- limit 20)
		printf("%-20s\t\t%5d\n",name, syscalls[name])
	printf("--------------------------------------\n")
}

probe syscall.time {
	syscalls[probefunc()]++
}
probe syscall.gettimeofday {
	syscalls[probefunc()]++
}

# print top syscalls every 5 seconds
probe timer.ms(5000) {
	print_top ()
}
-----------

The above while running various huge sql operations with real life
postgresql app running sql in loop for a minute or so (sorry no mysql
setup but the world isn't mysql, I'd rather want to see oracle if
something):

SYSCALL                         COUNT
sys_gettimeofday                 4998
sys_time                          120
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                 9989
sys_time                          185
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                15219
sys_time                          335
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                21215
sys_time                          428
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                26194
sys_time                          629
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                30752
sys_time                          734
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                37379
sys_time                          976
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                42381
sys_time                         1125
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                47722
sys_time                         1391
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                53138
sys_time                         1520
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                57499
sys_time                         1651
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                62314
sys_time                         1712
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                66874
sys_time                         1827
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                71757
sys_time                         2007
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                76335
sys_time                         2240
SYSCALL                         COUNT
sys_gettimeofday                80469
sys_time                         2354
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                85420
sys_time                         2519
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                90662
sys_time                         2648
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                95513
sys_time                         2909
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                100767
sys_time                         3111
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                106553
sys_time                         3427
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                112300
sys_time                         3673
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                115706
sys_time                         3793
SYSCALL                         COUNT
sys_gettimeofday                119842
sys_time                         3893
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                123054
sys_time                         4113
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                126286
sys_time                         4250
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                129077
sys_time                         4396
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                132002
sys_time                         4506
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                138518
sys_time                         4800
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                143572
sys_time                         4901
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                148621
sys_time                         5069

Now if I play some music with projectm in the background:

SYSCALL                         COUNT
sys_gettimeofday                 6337
sys_time                          128
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                11462
sys_time                          249
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                21905
sys_time                          332
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                36205
sys_time                          494
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                53792
sys_time                          569
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                69699
sys_time                          709
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                85663
sys_time                          791
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                101427
sys_time                          908
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                117199
sys_time                          985
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                132963
sys_time                         1100
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                148974
sys_time                         1162
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                164677
sys_time                         1288
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                180697
sys_time                         1356
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                196517
sys_time                         1479
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                209618
sys_time                         1546
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                214914
sys_time                         1726
--------------------------------------
SYSCALL                         COUNT
sys_gettimeofday                221257
sys_time                         1798

If I listen some music on youtube.com:

SYSCALL                         COUNT
sys_gettimeofday                 5151
sys32_gettimeofday               3951
sys_time                          202
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              16427
sys_gettimeofday                10247
sys_time                          306
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              42436
sys_gettimeofday                15633
sys_time                          438
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              64931
sys_gettimeofday                21121
sys_time                          509
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              94366
sys_gettimeofday                26399
sys_time                          638
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              117573
sys_gettimeofday                33100
sys_time                          722
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              137415
sys_gettimeofday                38357
sys_time                          863
compat_sys_time                     1
--------------------------------------
SYSCALL                         COUNT
sys32_gettimeofday              154831
sys_gettimeofday                43459
sys_time                          933
compat_sys_time                     1

Those aren't gettimeofday heavy users at all, they're the normal
"light" kernel users of the most common workloads. The sql wasn't
gettimeofday intensive either. The very heavy users will run hundred
thousands gettimeofday or more per second so they're not even
interesting to measure because the sys_time system time will be close
to zero compared to the gettimeofday one.

BTW, to run the above I had to disable vsyscall64 sysctl, my x2 would
never waste any time running sys_time or sys_gettimeofday in the first
place ;).

This patch may be a good tradeoff anyway, but IMHO it's not possible
to judje the idea of adding a branch to sys_gettimeofday to make
sys_time faster without knowing why mysql calls time() so
frequently. Even if you care only about the present and you don't care
about the future, mysql isn't the only db in the marketplace and like
I wrote in the other email the others I've seen were running floods of
gettimeofday (I repeat, some even went as far as giving an option to
call rdtsc directly on the few servers with tsc synchronized in smp).
