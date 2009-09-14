Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZINH5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZINH5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZINH5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:57:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49961 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZINH5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WYU35aCoM7mNBfDCco6eSbsniUkhUleVc3az1es4Ln00++j9B8IoMBWxeN3/Ff4vYQ
         RBWRmBUf47RW1u/kGoBEsa1bBrWkMyD8jdwECH/SLfnhSjdP8X9ok5trNRdNG8Fw4SgU
         yd3AIZe2lHkH9vfFTfwJnLPTgmDqR5j1o26sM=
MIME-Version: 1.0
In-Reply-To: <20090914071631.GA24801@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
	 <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
	 <20090914071631.GA24801@elte.hu>
Date: Mon, 14 Sep 2009 10:57:03 +0300
X-Google-Sender-Auth: cd95e56c6028b498
Message-ID: <84144f020909140057j542a3ee8wc996ffc6f8fcbbd1@mail.gmail.com>
Subject: Re: [origin tree SLAB corruption] BUG kmalloc-64: Poison overwritten, 
	INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Paris <eparis@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris <eparis@redhat.com> wrote:
>> On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:
>> > James - i did not see a security pull request email from you in my
>> > lkml folder so i created this new thread. -tip testing found the
>> > easy crash below. It reverts cleanly so i went that easy route.
>> >
>> > At a really quick 10-seconds glance the crash happens because we
>> > destroy the slab cache twice, if the sysctl is toggled twice?
>>
>> Something a lot worse than SELinux here.  I added this exact code and
>> got this warning.  Something is wrong in the world of
>> kmem_cache_destroy.....

Btw, the kmem_cache_destroy() bug Eric found is not in Linu's tree yet.

On Mon, Sep 14, 2009 at 10:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> -tip testing just triggered another type of SLAB problem (this time
> not apparently related to the security subsystem):
>
> BUG kmalloc-64: Poison overwritten
> -----------------------------------------------------------------------------
>
> INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
> INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
> INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
> INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
> INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00
>
> Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a «....'ÿÿZZZZZZZZ
>  Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>  Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .ó.ô`<.Ákkkkkkkk

This would be use-after-free in kmalloc-64 cache. Given the trace and
the fact that bdi_work_alloc() got introduce recently, it seems more
likely that fs/fs-writeback.c is to blame here. Jens, does the warning
ring a bell to you?

>  Object 0xf498f6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>  Object 0xf498f6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
>  Redzone 0xf498f6d0:  bb bb bb bb                                     »»»»
>  Padding 0xf498f6f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
> Pid: 3514, comm: sync Not tainted 2.6.31-tip-02343-gb432421-dirty #14071
> Call Trace:
>  [<c10e5b29>] print_trailer+0xf9/0x170
>  [<c10e5c95>] check_bytes_and_report+0xf5/0x120
>  [<c10e7129>] check_object+0x1e9/0x230
>  [<c10e848d>] alloc_debug_processing+0xfd/0x1d0
>  [<c111394b>] ? bdi_alloc_work+0x2b/0x100
>  [<c10e8687>] __slab_alloc+0x127/0x330
>  [<c111394b>] ? bdi_alloc_work+0x2b/0x100
>  [<c111394b>] ? bdi_alloc_work+0x2b/0x100
>  [<c10e8a43>] kmem_cache_alloc+0x1b3/0x1d0
>  [<c111394b>] ? bdi_alloc_work+0x2b/0x100
>  [<c111394b>] ? bdi_alloc_work+0x2b/0x100
>  [<c11148a4>] ? bdi_writeback_all+0x34/0x190
>  [<c111394b>] bdi_alloc_work+0x2b/0x100
>  [<c194c6b2>] ? _spin_lock+0x72/0x90
>  [<c11148e2>] bdi_writeback_all+0x72/0x190
>  [<c107b3db>] ? mark_held_locks+0x6b/0xb0
>  [<c194ab75>] ? __mutex_unlock_slowpath+0xf5/0x160
>  [<c107b76c>] ? trace_hardirqs_on_caller+0x15c/0x1c0
>  [<c1114a48>] sync_inodes_sb+0x48/0x70
>  [<c1118b0b>] __sync_filesystem+0x7b/0x90
>  [<c1118c13>] sync_filesystems+0xf3/0x140
>  [<c1118cd7>] sys_sync+0x27/0x60
>  [<c100344b>] sysenter_do_call+0x12/0x36
> FIX kmalloc-64: Restoring 0xf498f6a0-0xf498f6a7=0x6b
>
> Now, this might be an extended arm of the security related slab
> troubles. (which seem to have been cured by the revert i posted
> though.)
>
> This bug is not bisectable at all - it happened after 1000+
> successful random bootups. The mainline base for
> 2.6.31-tip-02343-gb432421 is upstream commit 86d7101.
>
> Full bootlog and config attached.
>
>        Ingo
>
>
