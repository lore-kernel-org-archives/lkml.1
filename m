Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXC1Mi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXC1Mi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXC1Mi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:38:28 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43062 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXC1Mi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:38:27 -0400
Message-ID: <460A6173.9040808@hitachi.com>
Date: Wed, 28 Mar 2007 21:37:07 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v4
References: <45E7AAFA.4070402@hitachi.com> 
    <20070315133721.ecbec123.akpm@linux-foundation.org> 
    <4603D281.1000101@hitachi.com>
In-Reply-To: <4603D281.1000101@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thank you for your kind comments.
I'm sorry for my late reply. 

Andrew Morton wrote:

> On Fri, 02 Mar 2007 13:41:30 +0900
> "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>This patch series is version 4 of the core dump masking feature,
>>which provides a per-process flag not to dump anonymous shared
>>memory segments.
> 
> First up, please convince us that this problem cannot be solved in
> userspace. 
> Note that we now support dumping core over a pipe to a
> userspace application which can perform filtering such as this (see
> Documentation/sysctl/kernel.txt:core_pattern).

I understand.  Thank you for your suggestion.  I'll reply about it in
another mail, but it may take a few days.

 
> Assuming that your argument is successful...
> 
> - The unpleasing trylock in proc_coredump_omit_anon_shared_write() is
>   there, I believe, to handle the case where a coredump is presently in
>   progress.  We don't want to change the filtering rule while the dump is
>   happening.
> 
>   What I suggest you do instead is to take a copy of
>   mm->coredump_omit_anon_shared into a local variable with one single read
>   per coredump.  Pass that local down into all the callees which need to
>   see it.  That way, no locking is needed.

Previous v3 patchset does what you suggest, and here are links to the
patches:

[PATCH 2/4] coredump: ELF: enable to omit anonymous shared memory
http://lkml.org/lkml/2007/2/16/156

[PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory
http://lkml.org/lkml/2007/2/16/157

However, there was an opposite opinion.  To pass the flag status, I
added omit_anon_shared argument to elf_fdpic_dump_segments().  Then,
David pointed that the argument was unncecessary, because the function
also receives mm_struct *mm which includes coredump_omit_anon_shared.
But mm->coredump_omit_anon_shared can be changed while core dumping, and
it may causes the core file to be corrupted.  So in v4 patchset I used
r/w semaphore to prevent mm->coredump_omit_anon_shared from being changed.

If I add an addtional argument to elf_fdpic_dump_segments() again, I
have to explain it to David.  I'll tell him that removing mm argument
from the function will be a solution since it refers current->mm directly
and the mm argument is never used.

 
> - These games we're playing with the atomicity of the bitfields in the
>   mm_struct need to go away.
> 
>   First up, please prepare a standalone patch which removes
>   mm_struct.dumpable and adds `unsigned long mm_struct.flags'.  Include a
>   comment telling people that they must use atomic bitops (set_bit, clear_bit) on
>   mm_struct.flags.

OK.  I'll do it in the next version.


> - Finally, the code as you have it here is very specific to your specific
>   requirement: don't dump shared memory segments.
> 
>   But if we're going to implement in-kernel core-dump filtering of this
>   nature, we should design it extensibly, even if we don't actually
>   implement those extensions at this time.

I understood. Since I had done so initially, I'll revert it to.

 
>   Because other people might (reasonably) wish to omit anonymous memory,
>   or private mappings, or file-backed VMAs, or whatever.
> 
>   So maybe /proc/pid/coredump_omit_anon_shared should become
>   /proc/pid/core_dumpfilter, which is a carefully documented bitmask.

There are people who wish to dump VMAs which are not dumped by default.
Taking this into account, some bits of core_dumpfilter will be set by
default.  This means users have to be aware of the default bitmask
when they change the bitmask.  Perhaps changing the bitmask requires
3 steps:

  1. read the default bitmask
  2. change bits of the mask
  3. write it to the proc entry

So I think it is better if we provide /proc/pid/core_flags (default:
all bits are 0) instead of core_dumpfilter.  With this interface,
users who use only one bit of the bitmask (this will be a common case) 
just have to write 2^n to the proc entry.  It takes only one step:

 1. write a value to the proc entry

If we can implement at the same cost, core_flags will be better
because it is useful for users.  What would you think about that?


By the way, Robin Holt wrote as follows:

> Can you make this a little more transparent?  Having a magic bitmask does
> not seem like the best way to do stuff.  Could you maybe make a core_flags
> directory with a seperate file for each flag.  It could still map to a
> single field in the mm, but be broken out for the proc filesystem.

Do you think Robin's suggestion is acceptable?

Best regards,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

