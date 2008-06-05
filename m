Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYFEOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYFEOBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYFEOBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:01:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755005AbYFEOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:01:07 -0400
Date: Thu, 5 Jun 2008 08:51:28 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] hotplug cpus on ia64
Message-ID: <20080605135128.GA22767@sgi.com>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com> <1212154614.12349.244.camel@twins> <20080603221759.GA19039@sgi.com> <1212670198.23439.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212670198.23439.45.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 02:49:58PM +0200, Peter Zijlstra wrote:
> 
> Does the below fix it?
> 

I don't believe so:


:~ # taskset -p $$
pid 4502's current affinity mask: 8
:~ # cd /sys/devices/system
:/sys/devices/system # cd cpu
:/sys/devices/system/cpu # cd cpu2
:/sys/devices/system/cpu/cpu2 # cat online
1
:/sys/devices/system/cpu/cpu2 # echo 0 >online
:/sys/devices/system/cpu/cpu2 # taskset -p $$
pid 4502's current affinity mask: 8
:/sys/devices/system/cpu/cpu2 # taskset -cp 0-3 $$
pid 4502's current affinity list: 3
pid 4502's new affinity list: 0,1,3
:/sys/devices/system/cpu/cpu2 # taskset -p $$
pid 4502's current affinity mask: b
:/sys/devices/system/cpu/cpu2 # echo 1 >online
:/sys/devices/system/cpu/cpu2 # taskset -p $$
pid 4502's current affinity mask: b
:/sys/devices/system/cpu/cpu2 # taskset -cp 0-3 $$
pid 4502's current affinity list: 0,1,3
pid 4502's new affinity list: 0-3
:/sys/devices/system/cpu/cpu2 # taskset -p $$
pid 4502's current affinity mask: f
:/sys/devices/system/cpu/cpu2 # echo 0 >online
:/sys/devices/system/cpu/cpu2 # taskset -p $$
pid 4502's current affinity mask: b
:/sys/devices/system/cpu/cpu2 # echo 1 >online
:/sys/devices/system/cpu/cpu2 # taskset -p $$
(above command now hangs)


(ps output)
0xe0000060b5650000     4502     4349  0    2   S  0xe0000060b5650390  bash
0xe0000060b8da0000     4843     4502  0    2   D  0xe0000060b8da0390  bash


Stack traceback for pid 4843
0xe0000060b8da0000     4843     4502  0    2   D  0xe0000060b8da0390  bash
0xa0000001007d44b0 schedule+0x1210
        args (0xe0000060ba470ce4, 0xa000000100dae190, 0xe000006003129200, 0xa000000100084b70, 0x48c, 0xe0000060b8dafda8, 0xe000006003129200, 0x200, 0xe0000060f780fe80)
0xa0000001007d4ac0 schedule_timeout+0x40
        args (0x7fffffffffffffff, 0x0, 0x0, 0xa0000001007d2f00, 0x309, 0xe000006003129200)
0xa0000001007d2f00 wait_for_common+0x240
        args (0xe0000060b8dafe08, 0x7fffffffffffffff, 0x2, 0xa0000001007d3280, 0x207, 0xe0000060ba470070)
0xa0000001007d3280 wait_for_completion+0x40
        args (0xe0000060b8dafe08, 0xa00000010008d990, 0x38a, 0xffffffffffff9200)
0xa00000010008d990 sched_exec+0x1b0
        args (0x2, 0xe0000060ba470000, 0xe0000060ba470010, 0xe000006003129200, 0xa00000010017e980, 0x58e, 0xa00000010017dce0)
0xa00000010017e980 do_execve+0xa0
        args (0xe0000060f39e5000, 0x60000000000394b0, 0x6000000000056150, 0xe0000060b8dafe40, 0xe0000060f799f100, 0xe0000060f799bb00, 0xe0000060f799bbd8, 0x60000000000620b1, 0xa000000100013940)
0xa000000100013940 sys_execve+0x60
        args (0xe0000060f39e5000, 0xe0000060f39e5000, 0x6000000000056150, 0xe0000060b8dafe40, 0xa00000010000a270, 0x50e, 0x2000000000028490)
0xa00000010000a270 ia64_execve+0x30
        args (0x60000000000620a0, 0x60000000000394b0, 0x6000000000056150, 0x0, 0xc00000000000058e, 0x400000000003d020, 0x60000000000394b0, 0x0, 0xa00000010000aba0)
0xa00000010000aba0 ia64_ret_from_syscall
        args (0x60000000000620a0, 0x60000000000394b0, 0x6000000000056150, 0x0, 0xc00000000000058e, 0x400000000003d020, 0x60000000000394b0, 0x0)
0xa000000000010720 __kernel_syscall_via_break
        args (0x60000000000620a0, 0x60000000000394b0, 0x6000000000056150, 0x0, 0xc00000000000058e, 0x400000000003d020, 0x60000000000394b0, 0x0)

