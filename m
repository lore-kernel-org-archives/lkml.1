Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYJYWe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYJYWe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJYWer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:34:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41800 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYJYWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:34:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, <linux-fsdevel@vger.kernel.org>
In-Reply-To: <200810252241.53601.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 25 Oct 2008 22:41:52 +0200")
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	<200810252241.53601.rjw@sisk.pl>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Sat, 25 Oct 2008 15:28:33 -0700
Message-ID: <m163nggvhq.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ***;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4684]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.5 XMLngstWrd_00 words over 45 charachters don't exist
	*  0.8 XMLngstWrd_01 words over 55 charachters don't exist
	*  1.0 XMLngstWrd_04 words over 85 charachters don't exist
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  1.0 XMLngstWrd_02 words over 65 charachters don't exist
	*  1.5 XMLngstWrd_03 words over 75 charachters don't exist
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday, 25 of October 2008, Vegard Nossum wrote:
>> Hi,
>> 
>> When I run readlink on the /proc/*/exe-file for udevd, the kernel
>> returns some unitialized data to userspace:
>> 
>> # strace -e trace=readlink readlink /proc/4762/exe
>> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
>> 
>> You can see it because the kernel thinks that the string is 30 bytes
>> long, but in fact it is only 12 (including the '\0').
>> 
>> If we explicitly clear the buffer before calling readlink, we can also
>> see that some garbage has been filled in there, after the string:
>> 
>> # ./readlink /proc/4762/exe
>> readlink(/proc/4762/exe) = 30
>>
> 2f7362696e2f7564657664000000ffffffad4effffffadffffffdeffffffffffffffff202864656c657465642900000000000000000000000000000
>> 
>> (Output is from following simple program:)
>> 
>> #include <stdio.h>
>> #include <string.h>
>> #include <unistd.h>
>> 
>> int main(int argc, char *argv[])
>> {
>>         char buf[1024];
>>         int i;
>>         ssize_t n;
>> 
>>         memset(buf, 0, sizeof(buf));
>>         n = readlink(argv[1], buf, sizeof(buf));
>> 
>>         printf("readlink(%s) = %d\n", argv[1], n);
>> 
>>         for (i = 0; i < sizeof(buf); ++i)
>>                 printf("%02x", buf[i]);
>>         printf("\n");
>> 
>>         return 0;
>> }
>> 
>> It was discovered by kmemcheck:
>> 
>> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6a109e4)
>> 64000000ad4eaddeffffffffffffffff000000000200000000000000c0838ff8
>>  i i u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
>>          ^
>> 
>> Pid: 21511, comm: readlink Not tainted (2.6.28-rc1 #58) 945P-A
>> EIP: 0060:[<c04f988d>] EFLAGS: 00000296 CPU: 0
>> EIP is at __d_path+0x8d/0x1c0
>> EAX: 0000000e EBX: d7ba0fe7 ECX: 00000001 EDX: f68b0b40
>> ESI: f6a109e4 EDI: d7ba0fef EBP: e58c3f28 ESP: c2569c08
>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> CR0: 8005003b CR2: f6c1d704 CR3: 31fc7000 CR4: 00000650
>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> DR6: ffff4ff0 DR7: 00000400
>>  [<c04fa4b0>] d_path+0xb0/0xd0
>>  [<c052c37c>] proc_pid_readlink+0x6c/0xc0
>>  [<c04eda34>] sys_readlinkat+0x94/0xa0
>>  [<c04eda67>] sys_readlink+0x27/0x30
>>  [<c0422f83>] sysenter_do_call+0x12/0x3f
>>  [<ffffffff>] 0xffffffff
>> 
>> Line numbers are these (as of commit
>> e013e13bf605b9e6b702adffbe2853cfc60e7806 in Linus's tree):
>> 
>> $ addr2line -e vmlinux -i c04f988d c04fa4b0 c052c37c c04eda34 c04eda67
>> fs/dcache.c:1895
>> fs/dcache.c:1901
>> fs/dcache.c:1957
>> fs/dcache.c:2016
>> fs/proc/base.c:1347
>> fs/proc/base.c:1374
>> fs/stat.c:312
>> fs/stat.c:325
>> 
>> I couldn't immediately figure out who/what to blame, please Cc in
>> right direction if you think you know it :-)
>
> Well, I only can say who may be interested (CCs added).

Weird.  The dentry for "udevd" has an incorrect length.
Is something stomping the length somewhere?

What filesystem does /sbin/udevd reside on?

Eric
