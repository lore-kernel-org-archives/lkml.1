Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbZKRRSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbZKRRSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbZKRRSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:18:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33153 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932070AbZKRRSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:18:11 -0500
Message-ID: <4B042C51.7000500@sgi.com>
Date: Wed, 18 Nov 2009 09:18:09 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com> <20091117191757.651569000@alcatraz.americas.sgi.com> <20091118104855.GA593@aftab>
In-Reply-To: <20091118104855.GA593@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Borislav Petkov wrote:
> Hi,
> 
> On Tue, Nov 17, 2009 at 01:17:53PM -0600, Mike Travis wrote:
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
> 
> Aren't we missing core 0 here?

Core 0 already booted as it's the Boot CPU.  The info is earlier
in the log.

> 
>> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
>> ..
>> Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
>> Brought up 64 CPUs
> 
> Also, I'm getting
> 
> Booting Node   0, Processors  #1
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)

There are other patches that deal with these:

http://git.kernel.org/tip/15cd8812ab2ce62a2f779e93a8398bdad752291a
http://git.kernel.org/tip/b01c845f0f2e3f9e54e6a78d5d56895f5b95e818

>  #2
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
>  #3
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
>  #4
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
>  #5
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
>  Ok.
> Booting Node   1, Processors  #6
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
>  #7
> 
> ...
> 
> and clearly CPU cache info is too verbose. We might want to
> kill it since we have it replicated in /sysfs. In that case,
> arch/x86/kernel/cpu/common.c:display_cacheinfo() could become obsolete
> and we could remove it... Or is there some reason for dumping that
> particular information during boot?
> 

Yes, the above patches remove them entirely.

Thanks,
Mike
