Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbYFVHz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYFVHz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYFVHzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:55:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:17546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYFVHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JgLMIqOFQQr7hXEWN2e8/5EAf1TU+nLQnTNIl5GumSsTJpwuRmEWNds8LP52dq8kYC
         gf1WwsN/lRWctHd6cvqa9u8Rwmo7MuE6tOswS/WxsJ+QjbmBzHfXQFDXLwDLjbjZm0Ol
         vwDzs6jWv/roJbr9bxqMMaAPZEoM4JZMcCofw=
Message-ID: <19f34abd0806220055j6b30ad67rc0d32a109faaea08@mail.gmail.com>
Date: Sun, 22 Jun 2008 09:55:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621192400.GA2992@damson.getinternet.no>
	 <20080621192845.GB2992@damson.getinternet.no>
	 <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 10:41 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>  INFO: 0xf53ab018-0xf53ab02b. First byte 0x71 instead of 0x6b
>>  INFO: Allocated in copy_process+0x70/0x1090 age=110 cpu=1 pid=28664
>>  INFO: Freed in free_task+0x2c/0x30 age=68 cpu=0 pid=28667
>>  INFO: Slab 0xc1ba6cc0 objects=8 used=5 fp=0xf53aafd0 flags=0x400020c3
>>  INFO: Object 0xf53aafd0 @offset=12240 fp=0xf53acfb0
>>
>>  Bytes b4 0xf53aafc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>>   Object 0xf53aafd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>   Object 0xf53aafe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>   Object 0xf53aaff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>   Object 0xf53ab000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>   Object 0xf53ab010:  6b 6b 6b 6b 6b 6b 6b 6b 71 19 6f be dd 07 00 00 kkkkkkkkq.o<BE><DD>...
>>   Object 0xf53ab020:  71 19 6f be 6b 6b 6b 6b 6a 6b 6b eb 6b 6b 6b 6b q.o<BE>kkkkjkk<EB>kkkk
>
> So what to notice is that this is offset hex(0xf53ab018-0xf53aafc0) =
> '0x58L' from the beginning of the object (would be nice to have SLUB
> print that too, btw), which corresponds to (struct
> task_struct).se.vruntime (the "se" is a struct sched_entity). I'm
> putting Ingo and Peter on the Cc.

Oops, this calculation is bogus. The start of the object is
0xf53aafd0. This corresponds to 0x48L or .se.exec_start. So it seems
that exec_start, sum_exec_runtime, and vruntime have all been written
after the object was freed.

I guess the high number of 6bs in there is simply because the poison
was read, used for some calculation, then written back with not all
bits modified by the calculation.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
