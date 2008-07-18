Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYGRSIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYGRSIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYGRSIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:08:30 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:18667 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYGRSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KOs+11crx/sXHv+lYi4BJWtB7X2WdT1xcBUnhA7RJvYUjCQEToqS1K9MuELvQkBLdE
         zugN+eDT2KYomWAJ2Jp/F1WyXha5DHRez+eDZhIqkahuG9Pkr08BjZZPglQsI5d/FOdO
         lu+4E0ZV4eT2eZgWUHNSygco66gzVo1M4IeTs=
Message-ID: <19f34abd0807181108r53ea74adsd471e49f87d77024@mail.gmail.com>
Date: Fri, 18 Jul 2008 20:08:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1216402157.11215.21.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
	 <1216402157.11215.21.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 7:29 PM, Dave Kleikamp
<shaggy@linux.vnet.ibm.com> wrote:
>> BUG: unable to handle kernel paging request at c08845af
>> IP: [<c02f9122>] release_metapage+0x32/0x1c0
>> *pde = 37ab2163 *pte = 00884161
>> Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
>> EIP: 0060:[<c02f9122>] EFLAGS: 00010202 CPU: 1
>> EIP is at release_metapage+0x32/0x1c0
>> EAX: 00000246 EBX: f470e5d8 ECX: f7a2afd0 EDX: 00000000
>> ESI: c08845af EDI: 00000000 EBP: f735fd98 ESP: f735fd7c
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process jfsCommit (pid: 387, ti=f735e000 task=f7a2afd0 task.ti=f735e000)
>> Stack: c015b6e9 00000001 00000286 00000246 00000002 00000000 00000000 f735fed0
>>        c02e4202 00000020 f7a2afd0 c015addb 00000000 f470e9a4 f735fe34 00000000
>>        00000000 f470e85c c015addb 00000000 00000000 f470e5d8 f470e6d8 00000002
>> Call Trace:
>>  [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
>>  [<c02e4202>] ? xtTruncate+0xd42/0x1060
>
> xtTruncate can call release_metapage() in several places.  If you still
> have this kernel, could you please run addr2line against c02e4202?  If
> you've rebuilt your kernel since then, I understand.

Sorry, it's gone. However, I just recompiled it and the size of the
function is now 0x105f, and the offset 0xd42 matches with a call to
release_metapage. So with this new address, it's this call:

$ addr2line -e vmlinux -i c02e428d
fs/jfs/jfs_metapage.h:101
fs/jfs/jfs_xtree.c:3723

...which is this one:

    /* invalidate empty leaf page */
    discard_metapage(mp);


With your two patches applied, I now got this:

ERROR: (device loop0): remounting filesystem as read-only
blkno = 200000687, nblocks = f
ERROR: (device loop0): dbFree: block to be freed is outside the map
BUG: unable to handle kernel paging request at 338f8038
IP: [<c02ee352>] dbAllocBits+0x252/0x2b0
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 5034, comm: dmesg Not tainted (2.6.26-03421-g7f4c453 #48)
EIP: 0060:[<c02ee352>] EFLAGS: 00210246 CPU: 1
EIP is at dbAllocBits+0x252/0x2b0
EAX: 00000001 EBX: f38f8448 ECX: 08000000 EDX: f38f8000
ESI: f38f8000 EDI: 00000000 EBP: f62c9b14 ESP: f62c9ad8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process dmesg (pid: 5034, ti=f62c8000 task=f62e1fe0 task.ti=f62c8000)
Stack: 00000004 c0179d5e 00000000 f62c9b38 f393f000 f38f8000 f393f800 00000022
       00000000 00000001 f393f010 f393f076 0000000a 00000000 f393f000 f62c9b38
       c02ee3e8 00000022 00000100 00000001 f38f8000 f393f000 00000001 00000005
Call Trace:
 [<c0179d5e>] ? unlock_page+0x4e/0x60
 [<c02ee3e8>] ? dbAllocDmap+0x38/0xa0
 [<c02ef95a>] ? dbAlloc+0x54a/0x5d0
 [<c02f82e0>] ? extAlloc+0x200/0x620
 [<c02de051>] ? jfs_get_block+0x41/0x2a0
 [<c014f837>] ? down_write_nested+0x77/0x90
 [<c02de051>] ? jfs_get_block+0x41/0x2a0
 [<c02de24f>] ? jfs_get_block+0x23f/0x2a0
 [<c01c76f1>] ? alloc_buffer_head+0x11/0x70
 [<c01c80ef>] ? set_bh_page+0x3f/0x70
 [<c01c8200>] ? alloc_page_buffers+0x70/0xd0
 [<c01cb1d5>] ? nobh_write_begin+0x155/0x400
 [<c015b6f9>] ? __lock_acquire+0x2c9/0x1110
 [<c02ddbad>] ? jfs_write_begin+0x3d/0x50
 [<c02de010>] ? jfs_get_block+0x0/0x2a0
 [<c017aec5>] ? generic_file_buffered_write+0x165/0x5f0
 [<c074a787>] ? _spin_unlock+0x27/0x50
 [<c017b896>] ? __generic_file_aio_write_nolock+0x236/0x530
 [<c015adeb>] ? trace_hardirqs_on+0xb/0x10
 [<c017c423>] ? generic_file_aio_write+0x63/0xd0
 [<c01a46e1>] ? do_sync_write+0xd1/0x110
 [<c015909e>] ? get_lock_stats+0x1e/0x50
 [<c014b320>] ? autoremove_wake_function+0x0/0x50
 [<c074a787>] ? _spin_unlock+0x27/0x50
 [<c01a507c>] ? vfs_write+0x9c/0x140
 [<c01a4610>] ? do_sync_write+0x0/0x110
 [<c01a51dd>] ? sys_write+0x3d/0x70
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 8b 55 0c 8b 45 08 8b 4e 34 0f ad d0 d3 fa f6 c1 20 0f 45 c2 3b
46 1c 89 c1 7e 03 89 46 1c 8b 45 10 89 c2 c1 fa 1f 89 d7 8b 55 d8 <29>
44 ca 38 19 7c ca 3c 29 42 08 89 d8 19 7a 0c e8 89 b0 45 00
EIP: [<c02ee352>] dbAllocBits+0x252/0x2b0 SS:ESP 0068:f62c9ad8
Kernel panic - not syncing: Fatal exception

$ addr2line -e vmlinux -i c02ee352
fs/jfs/jfs_dmap.c:2188

You can also have a copy of my scripts if you want to try to reproduce
it locally. But I don't mind testing either :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
