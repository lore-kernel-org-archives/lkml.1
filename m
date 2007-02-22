Return-Path: <linux-kernel-owner+w=401wt.eu-S1751415AbXBVFds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbXBVFds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXBVFds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:33:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41382 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbXBVFdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:33:46 -0500
Message-ID: <45DD2B15.1030605@hitachi.com>
Date: Thu, 22 Feb 2007 14:33:09 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>, David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
    memory
References: <45DC184C.3080600@hitachi.com> <45DAC32B.4030603@hitachi.com> 
    <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> 
    <20368.1171638335@redhat.com> <18826.1171969097@redhat.com> 
    <8347.1172057611@redhat.com> 
    <20070221115436.GA31332@lnx-holt.americas.sgi.com>
In-Reply-To: <20070221115436.GA31332@lnx-holt.americas.sgi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Robin,

Thank you for your reply.

Robin Holt wrote:
> On Wed, Feb 21, 2007 at 11:33:31AM +0000, David Howells wrote:
> 
>>Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:
>>
>>>Is coredump_setting_sem a global semaphore?  If so, it prevents concurrent
>>>core dumping.
>>
>>No, it doesn't.  Look again:
>>
>>	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
>>	{
>>		<setup vars>
>>
>> >>>>		down_read(&coredump_settings_sem);

Oh, I'm sorry.  I have overlooked it.  There is no problem.


>>>Additionally, while some process is dumped, writing to
>>>coredump_omit_anon_shared of unrelated process will be blocked.
>>
>>Yes, but that's probably reasonable.  How likely (a) is a process to coredump,
>>and (b) is a coredump to occur simultaneously with someone altering their
>>settings?
> 
> And (c) altering the setting during a core dump going to produce an
> unusable core dump.  I don't think the locking is that difficult to add
> and it just makes sense.  I would venture a guess that it will take less
> time to actually do the locking than to continue arguing it is not needed
> when it clearly appears it is needed for even a small number of cases.

Okay, the probability that the process is blocked in the proc handler seems
to be small.  But I'm not sure if problems never occur in enterprise use.
So I'd like to use down_write_trylock() as Robin said before. And if it
fails to acquire the lock, it returns EBUSY immediately.
Do you have any comments?

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

