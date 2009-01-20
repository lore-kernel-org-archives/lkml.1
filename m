Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZATGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZATGU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZATGUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:20:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:40911 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZATGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:20:14 -0500
Message-ID: <49756D07.7080804@gawab.com>
Date: Mon, 19 Jan 2009 22:19:51 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com> <49752823.9020403@ct.jp.nec.com>
In-Reply-To: <49752823.9020403@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> Justin Madru wrote:
>> Ok, finally bisected the bug, but the commit isn't related to networking!
>> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>> on current git and that fixed the bug.
>>
>> By the way, how do I undo my git revert, so I'm back to a pristine tree?
>> I want to drop my changes - the revert.
>> Also how do I find the commit that merged/pulled in this commit?
>>
>> commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Date: Fri Dec 5 17:17:09 2008 -0800
>>
>> x86: signal: change type of paramter for sys_rt_sigreturn()
>>
>> Impact: cleanup on 32-bit
>>
>> Peter pointed this parameter can be changed.
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> Hi,
> thanks for reporting.
>
> I'm not sure why this commit affects.
> Can you check vmlinux? size, objdump, etc.
> On my environment, the generated code looks same.
>
> Thanks,
> Hiroshi
>
I tried to do an objdump but it gave an error. How am I suppose to do an 
objdump?

$ objdump -x /boot/vmlinuz-2.6.29-rc2-git
objdump: /boot/vmlinuz-2.6.29-rc2-git: File format not recognized
$ readelf -a /boot/vmlinuz-2.6.29-rc2-git
readelf: Error: Unable to seek to 0xc031f2eb for section headers
readelf: Error: Not an ELF file - it has the wrong magic bytes at the start
$ ls -la /boot/vmlinuz-2.6.29-rc2-git
-rw-r--r-- 1 root root 2286480 2009-01-19 18:44 /boot/vmlinuz-2.6.29-rc2-git

Anyways, I've uploaded the extracted data.tar.gz file from the kernel 
deb file created when I
build a kernel (I use ubuntu and make-kpkg). The archive includes the 
kernel, config, system.map
and modules that I used. The files can be found at 
http://jdserver.homelinux.org/bugreports/002/
There are 2 files: data-norevert.tar.bz2 is a build without the revert, 
data-revert.tar.bz2 has the revert.

I think peter annema might have have a reason why it's crashing firefox.
If sizeof(struct pt_regs) != sizeof(unsigned long) the the stack could 
become
unbalanced if other code is not expecting a struct pt_regs.

Peter Annema wrote:
> > #ifdef CONFIG_X86_32
> > -asmlinkage int sys_rt_sigreturn(unsigned long __unused)
> > +asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
> > {
> > - struct pt_regs *regs = (struct pt_regs *)&__unused;
> > -
> > - return do_rt_sigreturn(regs);
> > + return do_rt_sigreturn(&regs);
> > }
>
> Is sizeof(struct pt_regs) different from sizeof(unsigned long)? If so, 
> is some
> code somewhere messing with the stack and not expecting a struct 
> pt_regs to have
> been put on it?

Justin Madru
