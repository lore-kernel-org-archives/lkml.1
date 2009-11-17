Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZKQVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZKQVFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZKQVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:05:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35379 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbZKQVFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:05:20 -0500
Message-ID: <4B03100F.4080307@sgi.com>
Date: Tue, 17 Nov 2009 13:05:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>	 <20091117191757.651569000@alcatraz.americas.sgi.com> <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
In-Reply-To: <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Tue, Nov 17, 2009 at 11:17 AM, Mike Travis <travis@sgi.com> wrote:
>> When there are a large number of processors in a system, there
>> is an excessive amount of messages sent to the system console.
>> It's estimated that with 4096 processors in a system, and the
>> console baudrate set to 56K, the startup messages will take
>> about 84 minutes to clear the serial port.
>>
>> This set of patches limits the number of repetitious messages
>> which contain no additional information.  Much of this information
>> is obtainable from the /proc and /sysfs.   Some of the messages
>> are also sent to the kernel log buffer as KERN_DEBUG messages so
>> dmesg can be used to examine more closely any details specific to
>> a problem.
>>
>> The list of message transformations....
>>
>> For system_state == SYSTEM_BOOTING:
>>
>> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
>> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
>> ..
>> Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
>> Brought up 64 CPUs
>>
>> The following lines have been removed:
>>
>>        CPU: Physical Processor ID:
>>        CPU: Processor Core ID:
>>        CPU %d/0x%x -> Node %d
> 
> please don't.
> 
> YH

The current output format is:

[    1.752861] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    2.271831] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    2.858473] Booting Node   2, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
[    3.445168] Booting Node   3, Processors  #24 #25 #26 #27 #28 #29 #30 #31 Ok.
[    4.031750] Booting Node   0, Processors  #32 #33 #34 #35 #36 #37 #38 #39 Ok.
[    4.618461] Booting Node   1, Processors  #40 #41 #42 #43 #44 #45 #46 #47 Ok.
[    5.206036] Booting Node   2, Processors  #48 #49 #50 #51 #52 #53 #54 #55 Ok.
[    5.795760] Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
[    6.382678] Skipped synchronization checks as TSC is reliable.
[    6.389254] Brought up 64 CPUs
[    6.392705] Total of 64 processors activated (294277.71 BogoMIPS).

So cpu/node is retained.  How would you propose interjecting the core and cpu ids?
A summary after the above?  (These are obtainable from /proc/cpuinfo.  Any reason
why the information is required at boot time?)

I had proposed to send them to the kernel debug log buffer, but was told they
were not needed so I removed them.

Here is the same info:

53> cat simple.awk
#!/bin/bash

cat $1 | awk '
{
        if ($1 == "processor")
                cpu = $3;

        if ($1 == "physical" && $2 == "id")
                phyid = $4;

        if ($1 == "core" && $2 == "id") {
                coreid = $4;
                printf "CPU%d: Physical Processor ID: %d\n", cpu, phyid;
                printf "CPU%d: Physical Core ID: %d\n", cpu, coreid;
        }
}
'
54> ./simple.awk /proc/cpuinfo
CPU0: Physical Processor ID: 0
CPU0: Physical Core ID: 0
CPU1: Physical Processor ID: 0
CPU1: Physical Core ID: 1
CPU2: Physical Processor ID: 0
CPU2: Physical Core ID: 3
CPU3: Physical Processor ID: 0
CPU3: Physical Core ID: 8
CPU4: Physical Processor ID: 0
CPU4: Physical Core ID: 10
CPU5: Physical Processor ID: 0
CPU5: Physical Core ID: 11
CPU6: Physical Processor ID: 1
CPU6: Physical Core ID: 0
CPU7: Physical Processor ID: 1
CPU7: Physical Core ID: 1
CPU8: Physical Processor ID: 1

<and so on>

CPU45: Physical Processor ID: 3
CPU45: Physical Core ID: 9
CPU46: Physical Processor ID: 3
CPU46: Physical Core ID: 10
CPU47: Physical Processor ID: 3
CPU47: Physical Core ID: 11
