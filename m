Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYENHdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYENHdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYENHda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:33:30 -0400
Received: from gw.goop.org ([64.81.55.164]:60703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYENHd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:33:29 -0400
Message-ID: <482A95BB.1000001@goop.org>
Date: Wed, 14 May 2008 08:33:15 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] common implementation of iterative div/mod
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>	<481DF3D8.3010108@shaw.ca>	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>	<48217674.8080903@goop.org>	<48231959.4050406@goop.org> <20080513234627.30476c20.akpm@linux-foundation.org>
In-Reply-To: <20080513234627.30476c20.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 08 May 2008 16:16:41 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> We have a few instances of the open-coded iterative div/mod loop, used
>> when we don't expcet the dividend to be much bigger than the divisor.
>> Unfortunately modern gcc's have the tendency to strength "reduce" this
>> into a full mod operation, which isn't necessarily any faster, and
>> even if it were, doesn't exist if gcc implements it in libgcc.
>>
>> The workaround is to put a dummy asm statement in the loop to prevent
>> gcc from performing the transformation.
>>
>> This patch creates a single implementation of this loop, and uses it
>> to replace the open-coded versions I know about.
>>     
>
> Believe it or not, this patch causes one of my test machines to fail to
> find its disk.
>
> good dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p.txt
> bad dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p-dead.txt
> config: http://userweb.kernel.org/~akpm/config-t61p.txt

Uh, OK.  Do your other test machines work with it?  Are there any 
relevant config differences (x86-64 vs 32?).

Hm, it's not that it can't find its disk, I think it's this:

init[1]: segfault at ffffffffff7008d2 ip ffffffffff7008d2 sp 7fff86e67488 error 14
init[1]: segfault at ffffffffff7008d2 ip 311ac07628 sp 7fff86e66cb0 error 4 in libgcc_s-4.1.2-20070925.so.1[311ac00000+d000]


Is it that the vsyscall page is trying to call into the kernel?

    notrace static noinline int do_realtime(struct timespec *ts)
    {
    	unsigned long seq, ns;
    	do {
    		seq = read_seqbegin(&gtod->lock);
    		ts->tv_sec = gtod->wall_time_sec;
    		ts->tv_nsec = gtod->wall_time_nsec;
    		ns = vgetns();
    	} while (unlikely(read_seqretry(&gtod->lock, seq)));
    	timespec_add_ns(ts, ns);
    	return 0;
    }
      

timespec_add_ns() used to be entirely inlined, but now it contains the 
call to iter_div_u64_rem().

arch/x86/vdso/vclock_gettime.c has its own copies of other kernel 
functions which it can't directly call.  We could add 
timespec_add_ns()/iter_div_u64_rem() to that list, though its pretty 
hacky.  Could we link lib/div64.o into the vdso?

    J
