Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYGGN1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYGGN1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYGGN0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:26:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:34343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753382AbYGGN0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:26:49 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX182bbZioiM2qbf0/5B0RSAPEwxbVberkZWEzV6i1i
	QcHuGGw7/VRtiD
Message-ID: <48721996.8050708@gmx.net>
Date: Mon, 07 Jul 2008 15:26:46 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Eric Sesterhenn <snakebyte@gmx.de>, linux-ntfs-dev@lists.sourceforge.net,
       Anton Altaparmakov <aia21@cam.ac.uk>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
References: <20080706172147.GA19559@alice>	<F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>	<20080707122450.GC19313@alice> <19f34abd0807070603p23b30372l5bee26b05b6fa9c7@mail.gmail.com>
In-Reply-To: <19f34abd0807070603p23b30372l5bee26b05b6fa9c7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.2008 15:03, Vegard Nossum wrote:
> On Mon, Jul 7, 2008 at 2:24 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
>   
>> (gdb) l *(ntfs_read_locked_inode+0x16c)
>> 0xc030adbc is in ntfs_read_locked_inode (fs/ntfs/time.h:90).
>> 85      static inline struct timespec ntfs2utc(const sle64 time)
>> 86      {
>> 87              struct timespec ts;
>> 88
>> 89              /* Subtract the NTFS time offset. */
>> 90              u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
>> 91              /*
>> 92               * Convert the time to 1-second intervals and the remainder to
>> 93               * 1-nano-second intervals.
>> 94               */
>> (gdb) quit
>>
>> Not sure why this happens. I checked out a fresh git tree to
>> make sure my tree isnt broken or something. Might gcc be bogus
>> or the debug information and the bug happens in reality somewhere else?
>>     

As I pointed out in my other mail, gcc compiler optimizations may have
caused a slightly off location being printed.
My suspicions about time were correct.

> Are you sure you didn't recompile/relink vmlinux after getting the
> error? If not, maybe it's gdb which gets confused (somehow) by the
> inlining.
>
> Your 'Code:' line decodes to these instructions:
>
>    0:   8b 58 08                mov    0x8(%eax),%ebx
>    3:   8b 70 0c                mov    0xc(%eax),%esi
>
> And I find this in my own compiled vmlinux at:
>
> c025bcc1:       8b 58 08                mov    0x8(%eax),%ebx
> c025bcc4:       8b 70 0c                mov    0xc(%eax),%esi
>
> which is at...
>
>     $ addr2line -e vmlinux -i c025bcc1
>     fs/ntfs/inode.c:670
>
> which is...
>
>         vi->i_mtime = ntfs2utc(si->last_data_change_time);
>
> which is probably what is causing the NULL pointer dereference.
>   

The problem of this theory is that there is no NULL pointer dereference,
unless you meant "invalid memory access".

Regards,
Carl-Daniel

-- 
http://www.hailfinger.org/

