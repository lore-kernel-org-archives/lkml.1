Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbXIMUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbXIMUeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbXIMUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:34:17 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:40220 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763788AbXIMUeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:34:16 -0400
Subject: RFC: incorrect results from RTC reading method
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Contractor at HP
Date: Thu, 13 Sep 2007 14:33:55 -0600
Message-Id: <1189715635.12439.62.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not a subscriber to this list.  Please cc me in correspondence.
Thanks for your consideration.

Bob Montgomery
Contracting at HP, Fort Collins
-----------------------------

Incorrect method of reading the RTC

I think the code used to read the RTC in arch/x86_64/kernel/time.c is
incorrect.  This code was added in patch:

2006-03-28 	Matt Mackall 	[PATCH] RTC: Remove RTC UIP synchronization on x86_64

I have been investigating intermittent boot problems on x86_64 systems
running a variant of 2.6.18.

My tests were originally designed to test kdump, by hanging a CPU and
allowing the nmi_watchdog to crash the system to obtain the dumpfile.

During these tests, the system fails to come back up one out of every
100 (or 300?) or so tests with:

"ALERT! /dev/sda2 does not exist.  Dropping to a shell!" 

This occurs when udevsettle returns immediately instead of waiting
the usual 15-18 seconds for the disks to get ready.  And *that*
happens when the system wakes up thinking the year is 2135.

 Sun Sep 25 07:07:56 UTC 2135

That's the result of BCD conversion and mktime() when every field
of the RTC time and date comes back "0xbf".  (Note, the example time
shown had advanced since being initially set.)

The code that reads the Real Time Clock during boot up (currently in
arch/x86_64/kernel/time.c:get_persistent_time, but in get_cmos_time
on my kernel) uses a loop sort of like this:

 spin_lock_irqsave(&rtc_lock, flags);

 do {
         sec = CMOS_READ(RTC_SECONDS);
         min = CMOS_READ(RTC_MINUTES);
         hour = CMOS_READ(RTC_HOURS);
         day = CMOS_READ(RTC_DAY_OF_MONTH);
         mon = CMOS_READ(RTC_MONTH);
         year = CMOS_READ(RTC_YEAR);
 } while (sec != CMOS_READ(RTC_SECONDS));

 spin_unlock_irqrestore(&rtc_lock, flags);

The idea appears to be that if a final read of RTC_SECONDS returns
the same value as the initial read, then it has successfully avoided
the update cycle of the RTC and thus acquired good values.  I don't
believe that this strategy is correct, because of the bad reads that
are shown in results below.

Note, there are still several other mysteries in this investigation.
But I believe this basic code for the reading the clock is a
contributing factor.

I wrote a module to sample the real time clock with several successive
reads with very little delay in between.  The routine waits until the
0->1 transition of the UIP bit, in order to get near the "undefined"
period of the cycle, and then reads the clock with a udelay(1)
(1 usec) delay in between.

The results below show the tick value from rdtscll that is read first
on each sample, but give all the other tsc tick values converted
to usec, using cpu_khz as shown in the code snippet included below.
On my system, I believe the tsc is advancing at 1800.199 MHz.

The samples are reported in the order they are read: sec, min, hour,
day, month, year, and sec read a second time.  I also sample the tsc
value before and after the cmos reads.  The output from my module
shows the TSC value at the beginning, followed by the before and after
times of each read cycle normalized to usec since the first read,
followed by the values actually read (BCD), and ending with the time
to complete that read cycle.

The second reading of the sec value is supposed to verify a valid read
if the sec value matches the original.  Unfortunely, the reads during
the "undefined" period can easily give matching values for the seconds
(since they often give the same bogus value for everything).

The old MC156818A spec says I have 244 usec to complete a read once
the UIP bit goes high.  Then I enter the "undefined" period for up to
1984 usec.  The samples show that each read cycle takes 42-43 usec.
As you can see, after the 5th read, the values start to go bad in
the read cycle that occurs between 218 and 261 usec.

Then it enters the 1984 usec period of undefined behavior while the
clock is updated (in this case, to change the sec value from 39 to 40).
So including the 244 usec grace period, the value should be stable
again at around 2228 usec.  Here you see the value coming around on
the read cycle that occurs at 2273 - 2316 usec, with a complete good
read occurring at 2317 - 2360 usec.

I think any method for reading the RTC must consider the (Update In
Progress) flag to avoid bogus results.


Thu Sep  6 18:01:36 MDT 2007

TSC			Sample Interval    Sec Min Hr Day Mon Yr  Sec 

tsc: 000013b135af2a5d,      0 -     42 us, 39s 01m 00h 07d 09m 07y 39s (42 us)
tsc: 000013b135b06031,     44 -     86 us, 39s 01m 00h 07d 09m 07y 39s (42 us)
tsc: 000013b135b19343,     87 -    130 us, 39s 01m 00h 07d 09m 07y 39s (42 us)
tsc: 000013b135b2c6cf,    131 -    174 us, 39s 01m 00h 07d 09m 07y 39s (42 us)
tsc: 000013b135b3f9ef,    175 -    217 us, 39s 01m 00h 07d 09m 07y 39s (42 us)
tsc: 000013b135b52d0f,    218 -    261 us, 39s 01m 00h 00d 00m 00y 01s (42 us)
tsc: 000013b135b6609b,    262 -    305 us, 01s 01m 01h 01d 01m 01y 01s (42 us)
tsc: 000013b135b793bb,    306 -    348 us, 01s 01m 01h 01d 01m 01y 01s (42 us)
tsc: 000013b135b8c6db,    349 -    393 us, 39s 39m 39h 39d 39m 3ay 3as (43 us)
tsc: 000013b135b9ff45,    394 -    437 us, 3as 3am 40h 40d 40m 40y 40s (42 us)
tsc: 000013b135bb3265,    438 -    480 us, 40s 40m 40h 40d 40m 01y 01s (42 us)
tsc: 000013b135bc6585,    481 -    524 us, 01s 01m 01h 01d 01m 01y 01s (42 us)
tsc: 000013b135bd98a5,    525 -    568 us, 01s 01m 01h 01d 01m 01y 01s (42 us)
tsc: 000013b135becbc5,    569 -    611 us, 01s 01m 01h 01d 00m 00y 00s (42 us)
tsc: 000013b135bffee5,    612 -    655 us, 00s 00m 00h 00d 00m 00y 00s (42 us)
tsc: 000013b135c13205,    656 -    699 us, 00s 00m 00h 00d 00m 00y 00s (42 us)
tsc: 000013b135c26525,    700 -    742 us, 00s 00m 04h 04d 04m 04y 04s (42 us)
tsc: 000013b135c39845,    743 -    786 us, 04s 04m 04h 04d 04m 04y 04s (42 us)
tsc: 000013b135c4cb65,    787 -    830 us, 04s 04m 04h 04d 04m 04y 04s (42 us)
tsc: 000013b135c5fe85,    831 -    873 us, 04s 07m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135c731a5,    874 -    917 us, 07s 07m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135c864c5,    918 -    961 us, 07s 07m 07h 07d 07m 07y 09s (42 us)
tsc: 000013b135c997e5,    962 -   1004 us, 09s 09m 09h 09d 09m 09y 09s (42 us)
tsc: 000013b135cacb05,   1005 -   1048 us, 09s 09m 09h 09d 09m 09y 09s (42 us)
tsc: 000013b135cbfe25,   1049 -   1092 us, 09s 09m 09h 09d 09m 07y 07s (42 us)
tsc: 000013b135cd3145,   1093 -   1135 us, 07s 07m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135ce6465,   1136 -   1179 us, 07s 07m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135cf9785,   1180 -   1223 us, 07s 07m 07h 20d 20m 20y 20s (42 us)
tsc: 000013b135d0caa5,   1224 -   1266 us, 20s 20m 20h 20d 20m 20y 20s (42 us)
tsc: 000013b135d1fdc5,   1267 -   1310 us, 20s 20m 20h 20d 20m 20y 20s (42 us)
tsc: 000013b135d330e5,   1311 -   1354 us, 20s 20m 20h 20d 20m 20y 20s (42 us)
tsc: 000013b135d46405,   1355 -   1397 us, 20s 20m 20h 20d 20m 20y 20s (42 us)
tsc: 000013b135d59725,   1399 -   1441 us, 20s 20m 20h ffd ffm ffy ffs (42 us)
tsc: 000013b135d6ca45,   1442 -   1486 us, 40s 40m 40h 40d 40m bfy bfs (43 us)
tsc: 000013b135d80607,   1487 -   1530 us, bfs bfm bfh bfd bfm bfy bfs (42 us)
tsc: 000013b135d93927,   1531 -   1573 us, bfs 81m 81h 81d 81m 81y 01s (42 us)
tsc: 000013b135da6c47,   1574 -   1617 us, 01s 01m 01h 01d bfm bfy bfs (42 us)
tsc: 000013b135db9f67,   1618 -   1661 us, bfs bfm bfh bfd bfm bfy bfs (42 us)
tsc: 000013b135dcd287,   1662 -   1704 us, 42s 42m 42h 42d 42m 00y 00s (42 us)
tsc: 000013b135de05a7,   1705 -   1748 us, 00s 00m bfh bfd bfm bfy bfs (42 us)
tsc: 000013b135df38c7,   1749 -   1792 us, bfs bfm bfh bfd bfm 41y 41s (42 us)
tsc: 000013b135e06be7,   1793 -   1835 us, 41s 41m 41h 04d 04m 04y 04s (42 us)
tsc: 000013b135e19f07,   1837 -   1879 us, 04s 04m 04h 04d 04m 04y 04s (42 us)
tsc: 000013b135e2d227,   1880 -   1923 us, 04s 04m 04h 04d 00m 00y 00s (42 us)
tsc: 000013b135e40547,   1924 -   1967 us, 00s 00m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135e53867,   1968 -   2010 us, c0s c0m c0h c0d c0m c0y c0s (42 us)
tsc: 000013b135e66b87,   2011 -   2054 us, c0s c0m 47h 47d 47m 47y 47s (42 us)
tsc: 000013b135e79ea7,   2055 -   2098 us, 09s 09m 09h 09d 09m 09y 09s (42 us)
tsc: 000013b135e8d1c7,   2099 -   2141 us, 09s 09m 09h 09d 09m 09y 09s (42 us)
tsc: 000013b135ea04e7,   2142 -   2185 us, 09s 00m 00h 00d 00m 00y 07s (42 us)
tsc: 000013b135eb3807,   2186 -   2229 us, 07s 07m 07h 07d 07m 07y 07s (42 us)
tsc: 000013b135ec6b27,   2230 -   2272 us, 07s 07m 07h 07d 07m 07y 00s (42 us)
tsc: 000013b135ed9e47,   2273 -   2316 us, 00s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135eed167,   2317 -   2360 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f00487,   2361 -   2403 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f137a7,   2404 -   2447 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f26acb,   2448 -   2491 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f39e53,   2492 -   2534 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f4d1df,   2536 -   2579 us, 40s 01m 00h 07d 09m 07y 40s (43 us)
tsc: 000013b135f60ae7,   2580 -   2623 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f73e07,   2624 -   2666 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f87127,   2667 -   2710 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135f9a447,   2711 -   2754 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135fad767,   2755 -   2797 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135fc0a87,   2798 -   2841 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135fd3da7,   2842 -   2885 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135fe70c7,   2886 -   2928 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b135ffa3e7,   2929 -   2972 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13600d707,   2973 -   3016 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136020a27,   3017 -   3059 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136033d47,   3061 -   3103 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136047067,   3104 -   3147 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13605a387,   3148 -   3191 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13606d6a7,   3192 -   3234 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360809c7,   3235 -   3278 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136093ce7,   3279 -   3322 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360a7007,   3323 -   3365 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360ba327,   3366 -   3409 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360cd71f,   3410 -   3453 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360e0a3f,   3454 -   3497 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1360f3e71,   3498 -   3540 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136107191,   3541 -   3584 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13611a4b1,   3585 -   3628 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13612da1f,   3629 -   3672 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136140ebd,   3673 -   3716 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361541dd,   3717 -   3759 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361674fd,   3760 -   3803 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13617a81d,   3804 -   3847 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13618db3d,   3848 -   3892 us, 40s 01m 00h 07d 09m 07y 40s (44 us)
tsc: 000013b1361a1d8e,   3893 -   3936 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361b50ad,   3937 -   3980 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361c83cd,   3981 -   4023 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361db6ed,   4024 -   4067 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b1361eea0d,   4068 -   4111 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136201d2d,   4112 -   4154 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13621504d,   4156 -   4198 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13622836d,   4199 -   4242 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13623b68d,   4243 -   4286 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b13624e9ad,   4287 -   4329 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
tsc: 000013b136261ccd,   4330 -   4373 us, 40s 01m 00h 07d 09m 07y 40s (42 us)
Thu Sep  6 18:01:36 MDT 2007


Here is the code that collected and reported these samples:


...
struct sample {
	unsigned long tscll_before;
	unsigned long tscll_after;
	unsigned char sec0;
	unsigned char min;
	unsigned char hour;
	unsigned char day;
	unsigned char mon;
	unsigned char year;
	unsigned char sec1;
};

static struct sample *samples;
#define NSAMPLES 1024

int
gen_open(struct inode *i, struct file *f)
{
	samples = kmalloc(NSAMPLES * sizeof(struct sample), GFP_KERNEL);
	return(0);
}

int
gen_release(struct inode *i, struct file *f)
{
	kfree(samples);
	return(0);
}



static int check_cmos_time(void)
{
	unsigned int timeout = 1000000;
	unsigned char uip = 1, this = 1;
	unsigned long flags;
	int ii;
	unsigned long tsc_per_usec;

	if (!samples) return 0;

	/* wait until the UIP goes high (and start into the short
	 * safe window) */

	spin_lock_irqsave(&rtc_lock, flags);

	while (timeout && (uip || !this)) {
		uip &= this;
		this = CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP;
		timeout--;
	}

	for (ii=0; ii<NSAMPLES; ii++) {
		rdtscll(samples[ii].tscll_before);
		samples[ii].sec0 = CMOS_READ(RTC_SECONDS);
		samples[ii].min = CMOS_READ(RTC_MINUTES);
		samples[ii].hour = CMOS_READ(RTC_HOURS);
		samples[ii].day = CMOS_READ(RTC_DAY_OF_MONTH);
		samples[ii].mon = CMOS_READ(RTC_MONTH);
		samples[ii].year = CMOS_READ(RTC_YEAR);
		samples[ii].sec1 = CMOS_READ(RTC_SECONDS);
		rdtscll(samples[ii].tscll_after);
		udelay(1);
	}

	spin_unlock_irqrestore(&rtc_lock, flags);

	tsc_per_usec = cpu_khz/1000;

	printk(KERN_ALERT "\n");
	for (ii=0; ii<100; ii++) {
		printk(KERN_ALERT "tsc: %16.16lx, %6ld - %6ld us, %2.2xs "
			"%2.2xm %2.2xh %2.2xd %2.2xm %2.2xy %2.2xs (%ld us)\n",
			samples[ii].tscll_before,
			(samples[ii].tscll_before - samples[0].tscll_before)/
				tsc_per_usec,
			(samples[ii].tscll_after - samples[0].tscll_before)/
				tsc_per_usec,
			samples[ii].sec0, samples[ii].min,
			samples[ii].hour, samples[ii].day,
			samples[ii].mon, samples[ii].year,
			samples[ii].sec1,
			(samples[ii].tscll_after - samples[ii].tscll_before)/
				tsc_per_usec);
	}
	return NSAMPLES;
}
...

Here is cpuinfo from this machine:

ned:/home/bobm/Source/Buncho/buncho/gen# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 65
model name      : Dual-Core AMD Opteron(tm) Processor 2210
stepping        : 2
cpu MHz         : 1800.199
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips        : 3604.60
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 65
model name      : Dual-Core AMD Opteron(tm) Processor 2210
stepping        : 2
cpu MHz         : 1800.199
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips        : 3600.14
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc




