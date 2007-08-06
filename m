Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXHFE1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXHFE1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 00:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXHFE0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 00:26:54 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39725 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbXHFE0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 00:26:53 -0400
X-Sasl-enc: p/elCO3v/QUKUCKiZ2IGHhtXGypXTLOOZuy/LUtj6KmZ 1186374410
Message-ID: <2cdd01c7d7e2$1fb7fa00$0a01a8c0@robmhp>
From: "Rob Mueller" <robm@fastmail.fm>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
       "Bron Gondwana" <brong@fastmail.fm>,
       "Oleg Drokin" <green@linuxhacker.ru>
References: <1185436893.18946.1202118935@webmail.messagingengine.com> <20070727130739.9376a2b5.akpm@linux-foundation.org>
Subject: Re: Memory leaking behaviour in 2.6.20.11, reiserfs related?
Date: Mon, 6 Aug 2007 14:27:35 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is pretty much a vanilla kernel, with just one patch to work
>> around a deadlock problem in the reiserfs_file_write code that I
>> think isn't fixed.
>>
>> http://lists.linuxcoding.com/kernel/2006-q1/msg32508.html
>
> So that sounds like a reiserfs bug.

Yes, and it was definitely there still in 2.6.16. I don't know if it's been 
fixed since or not, haven't heard anything more from anyone on it.

>> BUG: at fs/reiserfs/inode.c:2868 reiserfs_releasepage()
>>  [<c0199ecb>] reiserfs_releasepage+0xa3/0xa8
...
>>  [<c010383b>] kernel_thread_helper+0x7/0x1c
>>  =======================
>
> And so does that.

These messages are "new", in that I think we've only seen them since 
upgrading to 2.6.20, they weren't in 2.6.16. They do seem like a reiserfs 
bug, but haven't seen any confirmation of that either. I thought they might 
be related to the leak behaviour.

> Re: 2.6.22-rc6-mm1 + leak patches

I haven't had a chance to test these. Given that you're not sure they'll 
even be helpful, is there something else we can test first before going down 
this path?

> Quite a few people are using reiserfs and yours is the only report of this
> which I can recall.  Can you think of any reason why your setup differs
> from most other people's?

No, not really, that 1 patch I mentioned previously is the only difference 
to a vanilla kernel.

Some other things that are interesting/strange

1. After rebooting that machine, I found it in the same memory leaked state 
17 hours later, so it doesn't even take a day to leak all that memory.
2. Although it ended up in the same leaked state after just 17 hours, even a 
week later, the machine is still running fine. It seems to reach a "steady 
state" where it has lots of leaked memory, but it doesn't cause the machine 
to swap or do anything particularly crazy, it just sits in that state.
3. We use the exact same kernel on some Prescott Xeon based machines with 8G 
of memory, and they don't display the same problem at all. The problem only 
seems to be occuring on our newer 12G Woodcrest Xeon based machines. For 
example.

[root@imap8 ~]$ uname -a
Linux imap8 2.6.20.11-reiserfix-fai #1 SMP Wed May 23 09:40:20 UTC 2007 i686 
GNU/Linux
[root@imap8 ~]$ cat /proc/cpuinfo | grep 'model name'
model name      : Intel(R) Xeon(TM) CPU 3.00GHz
model name      : Intel(R) Xeon(TM) CPU 3.00GHz
[root@imap8 ~]$ free
             total       used       free     shared    buffers     cached
Mem:       8308908    8034260     274648          0     493724    2008128
-/+ buffers/cache:    5532408    2776500
Swap:      2048276      61820    1986456
[root@imap8 ~]$ ps auxw | wc -l
1538

[root@imap9 ~]$ uname -a
Linux imap9 2.6.20.11-reiserfix-fai #1 SMP Thu May 10 01:57:03 UTC 2007 i686 
GNU/Linux
[root@imap9 ~]$ cat /proc/cpuinfo | grep 'model name'
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
[root@imap9 ~]$ free
             total       used       free     shared    buffers     cached
Mem:      12466848   12419764      47084          0     463564    1550232
-/+ buffers/cache:   10405968    2060880
Swap:      2048276      69828    1978448
[root@imap9 ~]$ ps auxw | wc -l
1523

Actually, maybe the other machines are displaying the same problem, I just 
wasn't as aware of it because it doesn't actually make the machine seem to 
do anything crazy. I guess I realised that there was definitely a problem 
with the new machines, because they were using a similar number and mix of 
processes to the other machines, but seemed to be using twice as much 
memory!

Rob

