Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZHXGsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZHXGsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZHXGsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:48:50 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:59313 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZHXGst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bh+zwKVms3/Mw0MFtQjtbV9eNiM4dZFJIl67poUdt7F/bFZqcclhMJlh+LBP92ipmu
         aX1WKzlNkpgyVIIIzOmzrwhUTABtGPcL7KFIUiVsgMdCeu91mAt7zYTx+2wHuFwFuzvW
         M4CDELlz9jBqx1vnXjVAfcccMqmURZI9i2voY=
Message-ID: <4A9237E5.9050601@gmail.com>
Date: Sun, 23 Aug 2009 23:49:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>	 <20090818160911.GA21243@goodmis.org>	 <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>	 <4A8FA2BD.4030707@gmail.com>  <4A91FDED.9050801@cn.fujitsu.com> <1251093523.7538.118.camel@twins> <4A922F82.9080000@cn.fujitsu.com>
In-Reply-To: <4A922F82.9080000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Peter Zijlstra wrote:
>    
>> On Mon, 2009-08-24 at 10:41 +0800, Li Zefan wrote:
>>
>>      
>>>> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentr
>>>>                  entry = trace_create_file("enable", 0644, call->dir, call,
>>>>                                            enable);
>>>>
>>>> -       if (call->id)
>>>> +       if (call->id&&  call->profile_enable)
>>>>          
>>> We do an extra check on ->profile_enable, shouldn't cause bug..
>>>
>>>        
>>>>                  entry = trace_create_file("id", 0444, call->dir, call,
>>>>                                            id);
>>>>          
>>> Any way, I don't think this commit does the right thing:
>>>
>>>    - If CONFIG_EVENT_PROFILE=y, we'll create events/<dir>/<event>/id,
>>>      except events/ftrace/<event>/id.
>>>
>>>    - if CONFIG_EVENT_PROFILE=n, there's no 'id' file at all!
>>>
>>> I think it's better to skip ftrace/ dir in perf tool code, instead of
>>> skipping creating id files in ftrace code.
>>>        
>> No, it does do the right thing. Your patch breaks things because not all
>> tracepoints are created through TRACE_EVENT() and will thus not have
>> their profile_enable/disable hooks set.
>>
>> By giving them an ID file, there is no way to distinguish good from bad
>> tracepoints.
>>
>>      
>
> But removing the id file from events/ftrace/ might break some ftrace
> binary parsers?
>
> And this commit makes 'id' file disapeared with CONFIG_EVENT_PROFILE=n.
>
>    
>> Expempting ftrace is no solid solution, suppose someone else does a
>> TRACE_EVENT_FORMAT() tracepoint, how would you know you could use it as
>> a profile event source?
>>
>>      
>
> Agree.
>
>    
>> The id files really must stay conditional.
>>
>>      
>
> I don't think it's a good idea to connect it with perfcounter
> this way. Wouldn't adding a 'profilable' file more intuitive?
>
>    
>> Aside from that, you only add #ifdef fuzz back which with his config is
>> moot, and shouldn't result in anything but a slightly bigger structure
>> to begin with.
>>
>>      
>
> Yeah, actually I still fail to see where the bug is, maybe
> the commit that Justin bisected down is not the real culprit..
>
>
>    
FWIW, here is the git bisect log:

git bisect start
# bad: [6c30c53fd5ae6a99a23ad78e90c428d2c8ffb07f] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2
git bisect bad 6c30c53fd5ae6a99a23ad78e90c428d2c8ffb07f
# good: [b600ffaebcc4791add19e04306f0478a963abe71] Merge branch 
'irq-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good b600ffaebcc4791add19e04306f0478a963abe71
# good: [ae83060026537885fd23737af161fee8afd04f4b] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect good ae83060026537885fd23737af161fee8afd04f4b
# bad: [b637dc0dba6a243da2c74f5d02b42ba5eeb9425e] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad b637dc0dba6a243da2c74f5d02b42ba5eeb9425e
# bad: [cf7fdd57f978d40ceb9a0f58a25f5cf9c84d6f33] USB: fix oops on 
disconnect in cdc-acm
git bisect bad cf7fdd57f978d40ceb9a0f58a25f5cf9c84d6f33
# good: [131f7340b4f93f9a4a8e5a65abbd352b34d0ee08] Merge branch 
'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect good 131f7340b4f93f9a4a8e5a65abbd352b34d0ee08
# good: [c0c60c4b9ab45bb02b20796401dd6a90770fd0ee] ARM: 5639/1: arm: 
clkdev.c should include <linux/clk.h>
git bisect good c0c60c4b9ab45bb02b20796401dd6a90770fd0ee
# bad: [da758ddede96dd850945d3417ff75209a666ba0d] Merge branch 
'perfcounters-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad da758ddede96dd850945d3417ff75209a666ba0d
# good: [389623fef0e8b088f293c437d3b7094fe82349fd] Merge 
git://git.infradead.org/mtd-2.6
git bisect good 389623fef0e8b088f293c437d3b7094fe82349fd
# bad: [af6af30c0fcd77e621638e53ef8b176bca8bd3b4] ftrace: Fix 
perf-tracepoint OOPS
git bisect bad af6af30c0fcd77e621638e53ef8b176bca8bd3b4
# good: [2cdbc46d7b2cb0acb68c3ecad93b000552121fa6] perf: Auto-detect libbfd
git bisect good 2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
# good: [386c0b702b1ea81c0f54f5c9832a3d4a52270f14] perf report: Add 
missing command line options to man page
git bisect good 386c0b702b1ea81c0f54f5c9832a3d4a52270f14

all I know is with 2.6.31-rc5 booted fine, as soon I loaded 2.6.31-rc6
I hit this stuckage(I can write it manually down if you need it,
seems ohci1394_dma gets a panic).

Justin P. Mattock

