Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbZKMXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbZKMXpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932552AbZKMXpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:45:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbZKMXpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:45:31 -0500
Message-ID: <4AFDEF75.1080101@redhat.com>
Date: Fri, 13 Nov 2009 18:44:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
 consistency
References: <20091113225226.15079.90813.stgit@harusame> <20091113150904.56c15910.akpm@linux-foundation.org> <20091113232457.GC21666@elte.hu>
In-Reply-To: <20091113232457.GC21666@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Andrew Morton<akpm@linux-foundation.org>  wrote:
>
>> On Fri, 13 Nov 2009 17:52:27 -0500
>> Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>>
>>> Pass mm->flags to binfmt core_dump for bitflag consistency.
>>> Since mm->flags bit flags is not protected by locks, it will be
>>> changed while dumping core. This patch copies mm->flags to a
>>> mm_flags local variable at the beginning of do_coredump() and
>>> use it while dumping. mm_flags also includes dump_filter which
>>> filters elf sections from core file in elf_core_dump().
>>> So, this patch also passes mm_flags to each binfmt->core_dump().
>>
>> I can kind-of guess the answer, but it would be much more reliable if
>> we were to hear this from yourself:
>>
>>    Why did you write this patch?  What problem is being observed?
>
> i'm not Masami so i'm only guessing that while writing the tracepoint a
> race got noticed but that otherwise there's no big practical effect,
> 'just' a cleanliness problem fixed.

Right, I'd like to add a tracepoint of coredump event with
its information. And also, this patch may fix a small
dumpable inconsistency issue below code

---
1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
1788                 up_write(&mm->mmap_sem);
1789                 put_cred(cred);
1790                 goto fail;
1791         }
1792
[...]
1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
1799                 flag = O_EXCL;          /* Stop rewrite attacks */
1800                 cred->fsuid = 0;        /* Dump root private */
1801         }

Since dumpable bits are not protected by lock, there is a
chance to change these bits between (1) and (2).

This patch copies mm->flags to a local variable and check the variable
for consistency.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

