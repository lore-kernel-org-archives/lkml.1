Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYFUUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYFUUlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYFUUlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 16:41:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:55416 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYFUUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 16:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hev9+ZtSw2yg991bTtPCBU1+j4mzyIETuFn/zlhzdOEIgEMvKS1PqCz/fQI1AradC0
         qmdflQ9GT1/dYaKkDwcm+xV9/piapa3dpBdB9XQFM8KVHdCor+F9zl9dbLqAyxMUlMF8
         9WUJvQ1xQl2jLcxauGmZomlcm0IjLvpczp5YE=
Message-ID: <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
Date: Sat, 21 Jun 2008 22:41:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080621192845.GB2992@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621192400.GA2992@damson.getinternet.no>
	 <20080621192845.GB2992@damson.getinternet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 9:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Oops, seems there was another one a bit earlier (about 5 minutes) that I
> didn't notice. I don't think it helps that much, but here it is:

I actually got a third one too, but it's similar to the first two.

>
>
>  =============================================================================
>  BUG task_struct: Poison overwritten
>  -----------------------------------------------------------------------------
>
>  INFO: 0xf53ab018-0xf53ab02b. First byte 0x71 instead of 0x6b
>  INFO: Allocated in copy_process+0x70/0x1090 age=110 cpu=1 pid=28664
>  INFO: Freed in free_task+0x2c/0x30 age=68 cpu=0 pid=28667
>  INFO: Slab 0xc1ba6cc0 objects=8 used=5 fp=0xf53aafd0 flags=0x400020c3
>  INFO: Object 0xf53aafd0 @offset=12240 fp=0xf53acfb0
>
>  Bytes b4 0xf53aafc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xf53aafd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xf53aafe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xf53aaff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xf53ab000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xf53ab010:  6b 6b 6b 6b 6b 6b 6b 6b 71 19 6f be dd 07 00 00 kkkkkkkkq.o<BE><DD>...
>   Object 0xf53ab020:  71 19 6f be 6b 6b 6b 6b 6a 6b 6b eb 6b 6b 6b 6b q.o<BE>kkkkjkk<EB>kkkk

So what to notice is that this is offset hex(0xf53ab018-0xf53aafc0) =
'0x58L' from the beginning of the object (would be nice to have SLUB
print that too, btw), which corresponds to (struct
task_struct).se.vruntime (the "se" is a struct sched_entity). I'm
putting Ingo and Peter on the Cc.

What I find odd is that only some of the bytes in there are wrong,
take the stray "eb" in the last line (above), for example. And these
variables around offset 0x58 from the struct task struct are all u64s.
Is it possible that the corruption comes from somewhere else?

(Does the number look like a valid vruntime, for example?)

For the record,

$ grep SCHED .config
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_HRTICK=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
