Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbZAUDFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbZAUDFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZAUDEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:04:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:28977 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZAUDEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:04:51 -0500
Message-ID: <497690D1.1060405@ct.jp.nec.com>
Date: Tue, 20 Jan 2009 19:04:49 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com> <49752823.9020403@ct.jp.nec.com> <49756D07.7080804@gawab.com> <497617D6.8020707@ct.jp.nec.com> <4976246D.1040008@gawab.com> <49762AA3.7050402@ct.jp.nec.com> <49768ACF.5010608@gawab.com>
In-Reply-To: <49768ACF.5010608@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:
> Hiroshi Shimamoto wrote:
>> Justin Madru wrote:
>>   
>>> Hiroshi Shimamoto wrote:
>>>     
>>>> Justin Madru wrote:
>>>>   
>>>>       
>>>>> Hiroshi Shimamoto wrote:
>>>>>     
>>>>>         
>>>>>> Justin Madru wrote:
>>>>>>       
>>>>>>           
>>>>>>> Ok, finally bisected the bug, but the commit isn't related to networking!
>>>>>>> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>>>>>>> on current git and that fixed the bug.
>>>>>>>
>>>>>>> By the way, how do I undo my git revert, so I'm back to a pristine tree?
>>>>>>> I want to drop my changes - the revert.
>>>>>>> Also how do I find the commit that merged/pulled in this commit?
>>>>>>>
>>>>>>> commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>>>>>>> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>>>>> Date: Fri Dec 5 17:17:09 2008 -0800
>>>>>>>
>>>>>>> x86: signal: change type of paramter for sys_rt_sigreturn()
>>>>>>>
>>>>>>> Impact: cleanup on 32-bit
>>>>>>>
>>>>>>> Peter pointed this parameter can be changed.
>>>>>>>
>>>>>>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>>>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>>>>         
>>>>>>>             
>>>>>> Hi,
>>>>>> thanks for reporting.
>>>>>>
>>>>>> I'm not sure why this commit affects.
>>>>>> Can you check vmlinux? size, objdump, etc.
>>>>>> On my environment, the generated code looks same.
>>>>>>
>>>>>> Thanks,
>>>>>> Hiroshi
>>>>>>
>>>>>>       
>>>>>>           
>>>>> I tried to do an objdump but it gave an error. How am I suppose to do an 
>>>>> objdump?
>>>>>
>>>>> $ objdump -x /boot/vmlinuz-2.6.29-rc2-git
>>>>> objdump: /boot/vmlinuz-2.6.29-rc2-git: File format not recognized
>>>>> $ readelf -a /boot/vmlinuz-2.6.29-rc2-git
>>>>> readelf: Error: Unable to seek to 0xc031f2eb for section headers
>>>>> readelf: Error: Not an ELF file - it has the wrong magic bytes at the start
>>>>> $ ls -la /boot/vmlinuz-2.6.29-rc2-git
>>>>> -rw-r--r-- 1 root root 2286480 2009-01-19 18:44 /boot/vmlinuz-2.6.29-rc2-git
>>>>>     
>>>>>         
>>>> not vmlinuz, vmlinux.
>>>> vmlinuz is a compressed kernel, it is not ELF file.
>>>> Usually vmlinux is generated in top of source directory.
>>>> I can see disassembled image with objdump -d vmlinux.
>>>>
>>>> Thanks,
>>>> Hiroshi
>>>>
>>>>   
>>>>       
>>> Sorry, didn't know. I tried objdump -d vmlinux, but the resulting file 
>>> is ~50MB!
>>> Is there a smaller section you're interested in, because that would be 
>>> hard to send.
>>> Or am I doing it wrong again?
>>>     
>> that's OK. No need to send the disassembled result.
>> You can diff disassembled file.
>> I guess your GCC generates different code when the patch is reverted.
>>
>> Thanks,
>> Hiroshi
>>
>>   
> Ok, I tried, I really did. But no mater what I did the diff was even bigger
> if not the same size as the original dump! I even tried to cut out the 
> first two fields with
>     cut -f3- dump-revert > dump-revert2
> but that wouldn't shrink the diff size (100,000+ lines).

I'm sorry for lack of explanations.
The patch changes sys_rt_sigreturn(), it means GCC might generate
different code for that function. And might be different size, it causes
all codes after sys_rt_sigreturn() will looks different.

So I think you can see the difference begins from sys_rt_sigreturn().

> 
> Does gcc output fluctuate this wildly with such little change?
> Is there a config option that allows gcc to randomize the output?
> I recompiled just to make sure, and even two recompiles of the same 
> source (no revert)
> resulted in a different sha1 hash (didn't test the objdump diff).
> The only thing I can think of is that I compile with -O3 instead of -O2.
> 
> I'm sorry, but unless you have any suggestions I've decided to just upload
> the vmlinux files to my server (<40KB up speed) 
> http://jdserver.homelinux.org/bugreports/002/
> and rapidshare
> http://rapidshare.com/files/186890846/vmlinux.tar.bz2.html
> http://rapidshare.com/files/186890848/data-norevert.tar.bz2.html
> http://rapidshare.com/files/186890849/data-revert.tar.bz2.html

thanks for uploading vmlinux, will see the difference.
And sorry again, actually, it's just for my curiosity.
I'd like to know what difference this is.
On my environment GCC(4.2.4-1ubuntu3 and 4.3.2) generates same binary...

> 
> By the way Ingo has already added the revert to tip/master
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=1d03950243904c89b8854c10516932b029c2a8fa

Yeah, Ingo knows what GCC does. I don't know so much.

Thanks,
Hiroshi
