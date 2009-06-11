Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZFKGV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZFKGV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZFKGVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:21:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48556 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZFKGVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:21:20 -0400
Message-ID: <4A30A25F.1080503@us.ibm.com>
Date: Wed, 10 Jun 2009 23:21:19 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug: fio traps into kernel without exiting because futex has
 a deadloop
References: <1244689688.2560.268.camel@ymzhang> <1244699756.6691.4.camel@laptop> <1244701128.6691.5.camel@laptop>
In-Reply-To: <1244701128.6691.5.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-06-11 at 07:55 +0200, Peter Zijlstra wrote:
>> On Thu, 2009-06-11 at 11:08 +0800, Zhang, Yanmin wrote:
>>> I investigate a fio hang issue. When I run fio multi-process
>>> testing on many disks, fio traps into kernel and doesn't exit
>>> (mostly hit once after runing sub test cases for ﻿hundreds of times).
>>>
>>> Oprofile data shows kernel consumes time with some futex functions.
>>> Command kill couldn't kill the process and machine reboot also hangs.
>>>
>>> Eventually, I locate the root cause as a bug of futex. Kernel enters
>>> a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
>>> By unknown reason (might be an issue of fio or glibc), parameter uaddr2
>>> points to an area which is READONLY. So futex_atomic_op_inuser returns
>>> -EFAULT when trying to changing the data at uaddr2, but later get_user
>>> still succeeds becasue the area is READONLY. Then go back to retry.
>>>
>>> I create a simple test case to trigger it, which just shmat an READONLY
>>> area for address uaddr2.
>>>
>>> It could be used as a DOS attack.
> 
> /me has morning juice and notices he sent the wrong commit...
> 
> commit 64d1304a64477629cb16b75491a77bafe6f86963
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon May 18 21:20:10 2009 +0200
> 
>     futex: setup writeable mapping for futex ops which modify user space data

Yup, that's the one.  I was trying to locate it myself, but you beat me 
to it.  Thanks Peter.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
