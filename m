Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543Ab0ARNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0ARNeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779Ab0ARNeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:34:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0ARNeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:34:05 -0500
Message-ID: <4B546321.60607@redhat.com>
Date: Mon, 18 Jan 2010 15:33:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>	 <1263467289.4244.288.camel@laptop>	 <1263498366.4875.25.camel@localhost.localdomain>	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com>	 <1263740593.557.20967.camel@twins>  <4B53661A.9090907@redhat.com>	 <1263800752.4283.19.camel@laptop>  <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop>  <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop>  <4B544F8E.1080603@redhat.com>	 <1263816857.4283.381.camel@laptop>  <4B5455FF.7010409@redhat.com> <1263820551.4283.499.camel@laptop>
In-Reply-To: <1263820551.4283.499.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 03:15 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 14:37 +0200, Avi Kivity wrote:
>    
>> On 01/18/2010 02:14 PM, Peter Zijlstra wrote:
>>      
>>>        
>>>> Well, the alternatives are very unappealing.  Emulation and
>>>> single-stepping are going to be very slow compared to a couple of jumps.
>>>>
>>>>          
>>> With CPL2 or RPL on user segments the protection issue seems to be
>>> manageable for running the instructions from kernel space.
>>>
>>>        
>> CPL2 gives unrestricted access to the kernel address space; and RPL does
>> not affect page level protection.  Segment limits don't work on x86-64.
>> But perhaps I missed something - these things are tricky.
>>      
> So setting RPL to 3 on the user segments allows access to kernel pages
> just fine? How useful.. :/
>    

The further we stay away from segmentation, the better.  Thankfully AMD 
removed hardware task switching from x86-64 so we can't even think about 
that.

>> It should be possible to translate the instruction into an address space
>> check, followed by the action, but that's still slower due to privilege
>> level switches.
>>      
> Well, if you manage to do the address validation you don't need the priv
> level switch anymore, right?
>    

Right.

> Are the ins encodings sane enough to recognize mem parameters without
> needing to know the actual ins?
>    

No.  You need to know whether the instruction accesses memory or not.

Look at the tables at the beginning of arch/x86/kvm/emulate.c.  Opcodes 
marked with ModRM, BitOp, MemAbs, String, Stack are all different styles 
of memory instructions.  You need to know the operand size for the edge 
cases.  And there are probably a few special cases in the code.

> How about using a hw-breakpoint to close the gap for the inline single
> step? You could even re-insert the int3 lazily when you need the
> hw-breakpoint again. It would consume one hw-breakpoint register for
> each task/cpu that has probes though..
>    

If you have more than four threads, it breaks, no?  And you need an IPI 
each time you hit the breakpoint.

Ultimately I'd like to see the breakpoint avoided as well, use a jump to 
the XOL area and trace in ~20 cycles instead of ~1000.

-- 
error compiling committee.c: too many arguments to function

