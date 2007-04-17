Return-Path: <linux-kernel-owner+w=401wt.eu-S1031177AbXDQQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031177AbXDQQud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031170AbXDQQud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:50:33 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:52993 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031146AbXDQQuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:50:32 -0400
Message-ID: <4624FA85.9010704@free.fr>
Date: Tue, 17 Apr 2007 18:49:09 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux.kernel@free.fr
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de>
In-Reply-To: <p73odlo55q2.fsf@bingen.suse.de>
Content-Type: multipart/mixed;
 boundary="------------050608050507060408060704"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608050507060408060704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:

> Please use a full real name for posting.

OK.

> John Sigler wrote:
> 
>> AFAIU, even a hard real-time OS is "defenseless" against SMIs that
>> kick the CPU into SMM.
> 
> There are usually chipset specific bits that can be set to disable SMMs.
> See the datasheet if you can get them. Unfortunately most chipset vendors
> don't give out data sheets easily.

I've asked the manufacturer to send me the data sheets.
We'll see how they react.

>> .globl foo
>> foo:
>>    push %ebx
>>    push %esi
>>    cpuid
>>    rdtsc
> 
> At least some SMM implementations restore the old TSC value. Sad but true.

Why would they do that?

How would you detect periodic SMM on such a system?

> Besides RDTSC can be speculated around on some CPUs which also adds errors.

I don't understand this sentence. Could you clarify?

I've attached my kernel module (hello.c)

# : >/var/log/kern.log; cat /proc/interrupts; /bin/time insmod houba.ko; 
cat /proc/interrupts; rmmod houba
            CPU0
   0:     519083    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:       9786    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      16920    XT-PIC-XT        ide0
NMI:          0
ERR:          0
0.00user 0.00system 5:00.00elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+111minor)pagefaults 0swaps
            CPU0
   0:     549094    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:       9791    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      16970    XT-PIC-XT        ide0
NMI:          0
ERR:          0

(HZ=100)
30011 timer interrupts
5 eth0 interrupts
50 ide0 interrupts

# cat /var/log/kern.log
Apr 17 18:22:27 SEND kernel: INIT
Apr 17 18:27:27 SEND kernel: 2350080 29995
Apr 17 18:27:27 SEND kernel: 2369792 1
Apr 17 18:27:27 SEND kernel: 2440192 1
Apr 17 18:27:27 SEND kernel: 2441216 1
Apr 17 18:27:27 SEND kernel: 2583296 1
Apr 17 18:27:27 SEND kernel: 2852096 1
Apr 17 18:27:27 SEND kernel: EXIT

First column is the cycle count clamped to a multiple of 256.
(1266.7 MHz CPU)
Second column is occurence count.

In the second experiment, I added the IRQ disable/enable around foo.

# : >/var/log/kern.log; cat /proc/interrupts; /bin/time insmod houba.ko; 
cat /proc/interrupts; rmmod houba
            CPU0
   0:     583666    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:      10084    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      17012    XT-PIC-XT        ide0
NMI:          0
ERR:          0
0.00user 0.01system 5:00.00elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+110minor)pagefaults 0swaps
            CPU0
   0:     613677    XT-PIC-XT        timer
   2:          0    XT-PIC-XT        cascade
   9:          0    XT-PIC-XT        acpi
  10:      10089    XT-PIC-XT        eth0
  11:          5    XT-PIC-XT        eth1
  12:          5    XT-PIC-XT        eth2
  14:      17070    XT-PIC-XT        ide0
NMI:          0
ERR:          0

30011 timer interrupts
5 eth0 interrupts
58 ide0 interrupts

# cat /var/log/kern.log
Apr 17 18:33:12 SEND kernel: INIT
Apr 17 18:38:12 SEND kernel: 2350080 30000
Apr 17 18:38:12 SEND kernel: EXIT

In this experiment, all the calls to foo had a latency between
2350080 and 2350335 cycles (1.88528 to 1.88548 ms).

I don't think I can conclude anything based on this experiment.

I'll let it run all night long.

Regards.

--------------050608050507060408060704
Content-Type: text/plain;
 name="hello.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hello.c"

#include <linux/init.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");

#define N 30000
#define MAX 20000

extern unsigned foo(void);

static int hello_init(void)
{
  int i;
  int *lat;
  printk(KERN_ALERT "INIT\n");
  lat = kmalloc(MAX * sizeof *lat, GFP_KERNEL);
  if (lat == NULL) return -1;
  for (i=0; i < MAX; ++i) lat[i] = 0;
  for (i=0; i < 5; ++i) foo();
  for (i=0; i < N; ++i)
  {
    unsigned count, res;
    set_current_state(TASK_INTERRUPTIBLE);
    schedule_timeout(1);
    foo();
    local_irq_disable();
    count = foo();
    local_irq_enable();
    res = count >> 8;
    if (res < MAX) ++lat[res]; else printk(KERN_ALERT "OUT OF RANGE\n");
  }

  for (i=0; i < MAX; ++i)
    if (lat[i] != 0) printk(KERN_ALERT "%d %d\n", i<<8, lat[i]);

  return 0;
}

static void hello_exit(void)
{
  printk(KERN_ALERT "EXIT\n");
}

module_init(hello_init);
module_exit(hello_exit);

--------------050608050507060408060704--

