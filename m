Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbZIDHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbZIDHxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZIDHxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:53:51 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:43418 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbZIDHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:53:50 -0400
Date: Fri, 4 Sep 2009 09:53:51 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: CPU scheduler weirdness?
In-Reply-To: <1252045561.7005.7.camel@marge.simson.net>
Message-ID: <alpine.LNX.2.00.0909040933540.7248@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>  <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>  <20090813155812.GA15714@rhlx01.hs-esslingen.de>  <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>  <1250665455.7583.326.camel@twins> 
 <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu>  <1250683834.7583.360.camel@twins>  <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu>  <1250707331.7154.1.camel@laptop>  <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>  <20090820105645.GA23635@elte.hu>
  <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu>  <alpine.LNX.2.00.0908282240480.32738@cinke.fazekas.hu>  <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu> <1252045561.7005.7.camel@marge.simson.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Mike Galbraith wrote:

> On Thu, 2009-09-03 at 23:57 +0200, Marton Balint wrote:
>
>>>> In the meantime, I updated my original C program and also created a kernel
>>>> module (schedtest_mod.c) which causes the same scheduling problems as the
>>>> kernel module of my TV card. The kernel module is a skeleton of the
>>>> infrared sensor polling code in cx88-input.c. It uses
>>>> schedule_delayed_work, this seems to cause the problem. The C program
>>>> (schedtest.c) is also updated, it now detects the number of CPU cores, from
>>>> now, what you can set as a command line parameter is the CPU core number,
>>>> on which the schedtest processes will not quit. (previously this was always
>>>> the last core).
>>>>
>>>> So to reproduce the bug on a dual core system, compile and insert the
>>>> kernel module (schedtest_mod.c). Then check dmesg, it should contain on
>>>> which CPU core is the delayed_work running. You should use the CPU core id
>>>> of the _other_ CPU core as a command line parameter to the updated
>>>> schedtest program.
>>>>
>>>> And by the way, thank you guys for the help so far, hopefully we'll get to
>>>> the bottom of this :)
>>>
>>> I reproduced the bug with the previously provided kernel module and C program
>>> on a different computer (it's a laptop with a core2 duo P8400 CPU), and also
>>> bisected the bug to this commit:
>>>
>>> sched: fine-tune SD_MC_INIT:
>>> 14800984706bf6936bbec5187f736e928be5c218
>>>
>>> If I add again the removed SD_BALANCE_NEWIDLE to flags, then everything works
>>> as expected. So what would be the correct fix for this bug? Revert the patch?
>>> Or just add SD_BALANCE_NEWIDLE to flags?
>
> Or, figure out what's going weird with that module loaded.

The problem is most likely caused by scheduled_delayed_work, a work 
function is called every time a CPU wakes up.

>> Ingo, Peter, could any of you guys have a look at the commit that caused
>> this bug? Is it OK to revert it? Or a fix somewhere else is necessary? I'm
>> pushing this because I hope that this bug will get fixed in the upcoming
>> stable kernel...
>
> Where does your schedtest.c and schedtest_mod.c live?

They were attached to one of my previous mails, i'm inlining them here to 
make the discussion easier. Thanks for looking into this.

Regards,
   Marton


schedtest_mod.c
-------------------
#include <linux/module.h>
#include <linux/init.h>
#include <linux/workqueue.h>
#include <asm/smp.h>

static int i;
static struct delayed_work d_work;

static void schedtest_work(struct work_struct *work)
{
 	schedule_delayed_work(&d_work, msecs_to_jiffies(1));
 	if (i++ % 500 == 0) {
 		printk(KERN_DEBUG "schedtest: I am on CPU %d.\n", get_cpu());
 		put_cpu();
 	}
}

static int __init schedtest_init_module(void)
{
 	INIT_DELAYED_WORK(&d_work, schedtest_work);
 	schedule_delayed_work(&d_work, 0);
 	return 0;
}

static void __exit schedtest_cleanup_module(void)
{
 	cancel_delayed_work_sync(&d_work);
}

module_init(schedtest_init_module);
module_exit(schedtest_cleanup_module);

MODULE_LICENSE("GPL");



schedtest.c:
--------------------

#define _GNU_SOURCE
#include <utmpx.h>
#include <sys/time.h>
#include <unistd.h>

/* Usage: ./schedtest <cpu core to test> */

int miliseconds() {
   struct timeval tv;
   gettimeofday(&tv, 0);
   return tv.tv_usec/1000;
}

int main(int argc, char *argv[]) {
   int lives = 1000, time, lasttime, childs, cores, core_to_test;
   cores = sysconf(_SC_NPROCESSORS_ONLN);
   childs = cores * 2;
   if (argc > 1)
     core_to_test = atoi(argv[1]);
   else
     core_to_test = cores-1;
   while (childs-- && !fork());
   while (lives) {
     time = miliseconds();
     if (lasttime != time && sched_getcpu() != core_to_test)
        lives--;
     lasttime = time;
   }
   return 0;
}
