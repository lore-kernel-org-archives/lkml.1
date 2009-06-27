Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZF0LKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZF0LKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZF0LKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:10:46 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41771 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZF0LKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yCdJ3o34WGPiN79ijY1xA0qxHuK9O8xwIDwejJ1lmaPhEdMCNfh7M8vrEYbXkXJlFM
         e4wsWcfwWvEruOrrjNd609yz+cycwCd3T67InJ5m4ynR5j/ts10RaF5TFbia6JKWsUZe
         7A7wOh/errE914SZxGllCISfTTUG7DYXr5EWo=
MIME-Version: 1.0
In-Reply-To: <20090626073919.GD8633@ZenIV.linux.org.uk>
References: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com>
	 <20090626071520.GC8633@ZenIV.linux.org.uk>
	 <20090626073919.GD8633@ZenIV.linux.org.uk>
Date: Sat, 27 Jun 2009 13:10:46 +0200
Message-ID: <40a4ed590906270410o9e17587p68a2d688b551b667@mail.gmail.com>
Subject: Re: 2.6.31-rc1 crashes randomly on my Machine.
From: Zeno Davatz <zdavatz@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 9:39 AM, Al Viro<viro@zeniv.linux.org.uk> wrote:
> On Fri, Jun 26, 2009 at 08:15:21AM +0100, Al Viro wrote:
>> On Fri, Jun 26, 2009 at 08:56:52AM +0200, Zeno Davatz wrote:
>>
>> > Jun 25 21:19:12 zenogentoo Code: 00 00 00 c7 47 20 00 00 00 00 c7 47
>> > 24 00 00 00 00 c7 47 10 00 00 00 00 c7 47 14 00 00 00 00 c7 47 0c 00
>> > 00 00 00 e9 27 ff ff ff <ff> 89 e5 57 56 53 83 ec 34 89 45 d0 89 55 cc
>> > 89 4d c8 8b 70 6c
>> > Jun 25 21:19:12 zenogentoo EIP: [<c10d1d35>] seq_read+0x0/0x3a5 SS:ESP
>> > 0068:f4b01f44
>> > Jun 25 21:19:12 zenogentoo CR2: 0000000053565be5
>> > Jun 25 21:19:12 zenogentoo ---[ end trace 6254fef9dc80950b ]---
>> > Jun 25 21:19:12 zenogentoo BUG: unable to handle kernel paging request
>> > at 53565be5
>>
>> Real cute...  Disassembly of that sucker:
>>       decl   0x535657e5(%ecx)
>> which matches nicely the address in page fault.  However, that doesn't
>> look even remotely plausible for a beginning of function.  OTOH,
>> disassembly at one byte offset from that gives
>>       mov    %esp,%ebp
>>       push   %edi
>>       push   %esi
>>       push   %ebx
>> which is exactly what you'd expect to see in such place.
>
> Actually, it's not *quite* what you'd expect to see.  What's missing is
>        push   %ebp
> as the first instruction, preceding that stuff.  And it would take one
> byte, so...
>
>>  IOW, you've
>> got an off-by-one - it had jumped at one byte before the actual entry
>> point of seq_read().
>
> ... this is not an off-by-one at all.  The first byte of function code
> got overwritten with 0xff.  Code before that doesn't seem to be mangled -
> it's
>        movl   $0x0,0x20(%edi)
>        movl   $0x0,0x24(%edi)
>        movl   $0x0,0x10(%edi)
>        movl   $0x0,0x14(%edi)
>        movl   $0x0,0xc(%edi)
>        jmp    <a bit back>
> which is at least not entirely implausible.  So it seems to be a memory
> corruption in .text, which might or might not affect the directly
> preceding bytes (0xe9 <signed 32bit int> is a relative jump, so there's
> no way to tell whether this 0xff had been the only byte affected - it
> would be preceded by 3 0xff coming from small negative integer anyway).

I just done another pull from the Git repository of Linus and booted
from the latest 2.6.31-rc1 and my Machine still hangs after boot up,
with the following message at the end in /var/log/messages

Jun 27 03:01:52 zenogentoo Stack:
Jun 27 03:01:52 zenogentoo c10d14f2 f2eb9f5c c10ab407 00000400
b8033000 f6b43d80 f33cbe28 00000000
Jun 27 03:01:52 zenogentoo <0> 00000000 f65c9000 00001000 00000000
00000000 00000000 f721a100 fffffffb
Jun 27 03:01:52 zenogentoo <0> c10d13e5 f2eb9f64 c10f1522 f2eb9f98
00000400 b8033000 f6b43d80 f6b43d80
Jun 27 03:01:52 zenogentoo Call Trace:
Jun 27 03:01:52 zenogentoo [<c10d14f2>] ? seq_read+0x10d/0x3a5
Jun 27 03:01:52 zenogentoo [<c10ab407>] ? mmap_region+0x1bf/0x41a
Jun 27 03:01:52 zenogentoo [<c10d13e5>] ? seq_read+0x0/0x3a5
Jun 27 03:01:52 zenogentoo [<c10f1522>] ? proc_reg_read+0x57/0x78
Jun 27 03:01:52 zenogentoo [<c10bb257>] ? vfs_read+0x8b/0x141
Jun 27 03:01:52 zenogentoo [<c10f14cb>] ? proc_reg_read+0x0/0x78
Jun 27 03:01:52 zenogentoo [<c10bb3b6>] ? sys_read+0x3d/0x6b
Jun 27 03:01:52 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
Jun 27 03:01:52 zenogentoo Code: 0b fc f6 50 0b fc f6 01 00 00 00 00
00 00 00 60 0b fc f6 60 0b fc f6 00 00 00 00 00 00 00 00 00 00 00 00
08 00 00 00 00 00 00 00 <ff> ff ff ff ff ff ff ff 00 00 00 00 00 00 00
00 00 00 00 00 00
Jun 27 03:01:52 zenogentoo EIP: [<f6fc0b7c>] 0xf6fc0b7c SS:ESP 0068:f2eb9efc
Jun 27 03:01:52 zenogentoo ---[ end trace 1b3422263ead727b ]---

Jun 27 13:02:32 zenogentoo Stack:
Jun 27 13:02:32 zenogentoo 00000002 f7000a00 f7002564 f7002550
f7002540 f7000a00 c2686660 f707bf70
Jun 27 13:02:32 zenogentoo <0> c10b509e 00000000 00000000 f707bf70
c2689600 c2686660 f7059130 f707bfb8
Jun 27 13:02:32 zenogentoo <0> c105f8a7 c2688f80 00000001 fffedb31
c2684e00 c268960c c2689604 c2689600
Jun 27 13:02:32 zenogentoo Call Trace:
Jun 27 13:02:32 zenogentoo [<c10b509e>] ? cache_reap+0xbf/0xe9
Jun 27 13:02:32 zenogentoo [<c105f8a7>] ? worker_thread+0x158/0x23b
Jun 27 13:02:32 zenogentoo [<c10b4fdf>] ? cache_reap+0x0/0xe9
Jun 27 13:02:32 zenogentoo [<c1063a8f>] ? autoremove_wake_function+0x0/0x3a
Jun 27 13:02:32 zenogentoo [<c105f74f>] ? worker_thread+0x0/0x23b
Jun 27 13:02:32 zenogentoo [<c106376c>] ? kthread+0x6f/0x75
Jun 27 13:02:32 zenogentoo [<c10636fd>] ? kthread+0x0/0x75
Jun 27 13:02:32 zenogentoo [<c1021da7>] ? kernel_thread_helper+0x7/0x10
Jun 27 13:02:32 zenogentoo Code: 56 53 83 ec 10 89 45 e8 89 d6 89 4d
e4 85 c9 7e 79 8d 42 10 89 45 f0 3b 42 10 74 6e 8d 52 24 89 55 ec 31
ff eb 42 8b 13 8b 43 04 <89> 42 04 89 10 c7 03 00 01 10 00 c7 43 04 00
02 20 00 8b 55 e8
Jun 27 13:02:32 zenogentoo EIP: [<c10b4f7c>] drain_freelist+0x2f/0x92
SS:ESP 0068:f707bf34
Jun 27 13:02:32 zenogentoo CR2: 0000000000000104
Jun 27 13:02:32 zenogentoo ---[ end trace 1b3422263ead727d ]---

Also the date does not seem to be set correctly from the system (ion3
shows me some ??? where I normally get the time and date).

Best
Zeno
