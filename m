Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZJPDLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZJPDLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 23:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZJPDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 23:11:34 -0400
Received: from claw.goop.org ([74.207.240.146]:39507 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZJPDLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 23:11:34 -0400
Message-ID: <4AD7E440.2030503@goop.org>
Date: Thu, 15 Oct 2009 20:10:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
References: <4AD6B1F0.6030904@goop.org>	 <c7f37ead-3cf2-4277-a44e-425a7b940d31@default> <1f1b08da0910151832m59d14ac2i4add6555d6a1208a@mail.gmail.com>
In-Reply-To: <1f1b08da0910151832m59d14ac2i4add6555d6a1208a@mail.gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/09 18:32, john stultz wrote:
>>> No, cycle_last isn't updated on every read, only on timer ticks.  This
>>> test doesn't seem to be intended to make sure that every
>>> clocksource_read is globally monotonic, but just to avoid
>>> some boundary
>>> conditions in the timer interrupt.  I just copied it directly from
>>> read_tsc().
>>>       
>> I understand but you are now essentially emulating a
>> reliable platform timer with a potentially unreliable
>> (but still high resolution) per-CPU timer AND probably
>> delivering that result to userland.
>>
>> Read_tsc should only be used if either CONSTANT_TSC
>> or TSC_RELIABLE is true, so read_tsc is guaranteed
>> to be monotonically-strictly-increasing by hardware
>> (and enforced for CONSTANT_TSC by check_tsc_warp
>> at boot).
>>     
> Ideally, yes, only perfect TSCs should be used.
>
> But in reality, its a big performance win for folks who can get away
> with just slightly offset TSCs.
>   

What monotonicity guarantees do we make to usermode, for both syscall
and vsyscall gettimeofday and clock_gettime?

Though its not clear to me how usermode would even notice very small
amounts of cross-thread/cpu non-monotonicity anyway.  It would need make
sure that it samples the time and stores it to some globally visible
place atomically (with locks, compare-and-swap, etc), which is going to
be pretty expensive.  And if its going to all that effort it may as well
do its own monotonicity checking/adjustments if its all that important.

(I can think of plenty of ways of doing it incorrectly, where you'd get
apparent non-monotonicity regardless of the quality of the time source.)

    J
