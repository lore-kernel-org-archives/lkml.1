Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab0BDIhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:37:01 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:45667 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0BDIg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kCgf/IFo57Rw+Iv2SYeF8amx1c9OXzqQFmXpeRviXenbeu2ZwMDdD64Y5lLXaiN/Hn
         rtFeeGQIgUNecPxRJ2Xioy84aBuc3sZd9wkcBOZ07zKcOdh7JYT979FIhKDPyT3dinsj
         4Lkp9agAlwgmct3drCNP0ylgpQVHFPTjWUDrg=
MIME-Version: 1.0
In-Reply-To: <4B6A4576.5050401@kernel.org>
References: <12651725962428@site> <1265203299.2919.1.camel@localhost>
	 <20100203233720.GA28271@suse.de> <201002040446.05068.s.L-H@gmx.de>
	 <4B6A4576.5050401@kernel.org>
Date: Thu, 4 Feb 2010 16:36:57 +0800
Message-ID: <7b6bb4a51002040036q4080785cv5fb961755cdaad92@mail.gmail.com>
Subject: Re: patch idr-fix-a-critical-misallocation-bug.patch added to 
	2.6.32-stable tree
From: Xiaotian Feng <xtfeng@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 11:56 AM, Tejun Heo <tj@kernel.org> wrote:
> On 02/04/2010 12:46 PM, Stefan Lippers-Hollmann wrote:
>> Hi
>>
>> [ Sorry for not reporting this earlier today, while
>>   idr-fix-a-critical-misallocation-bug was still part of queue-2.6.32, but
>>   bisecting this (and previously net-restore-ip-source-validation.patch)
>>   took its time. ]
>>
>> On Thursday 04 February 2010, Greg KH wrote:
>>> On Wed, Feb 03, 2010 at 08:21:39AM -0500, Eric Paris wrote:
>>>> On Wed, 2010-02-03 at 14:21 +0900, Tejun Heo wrote:
>>>>
>>>>>> Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
>>>>>> layers when id 4096 is first allocated.  When that happens, idr wraps
>>>>>> incorrectly and searches the idr array ignoring the high bits.  The
>>>>>> following test code from Eric demonstrates the bug nicely.
>>>>> ...
>>>>>> Based-on-patch-from: Eric Paris <eparis@redhat.com>
>>>>>> Reported-by: Eric Paris <eparis@redhat.com>
>>>>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>>>
>>>>> Greg, can this wait a bit more, maybe until the next -stable release?
>>>>> The code there is very fragile and this has been broken forever so I
>>>>> think it would be better if we wait a bit more while it gets testing
>>>>> mainline.
>>
>> Just as a side note, this patch as part of the 2.6.32 stable queue (before
>> this patch was removed again) seems to break logging into KDE 4.3.4 through
>> kdm on several different systems with Intel chipsets/ graphics (kvm
>> active). X and kdm start normally, logging in shows the ksplash, which
>> quickly terminates the xsession and dumps back to kdm. Removing just this
>> patch from 2.6.32 + (previous) stable queue fixes the problem for me;
>> however 2.6.33-rc6-git3 seems to be affected as well, but freezes X,
>> instead of "just" terminating the current X session and reverting to kdm.
>>
>> While I have reports from several different intel chipsets, I can
>> personally reproduce it on an Intel D945GCLF2 mainboard:

My x86_64 box gets following messages when I'm running ltp testcase
msgctl10, and my system hangs then.
reverting this patch makes msgctl10 go through.

BUG: spinlock already unlocked on CPU#3, msgctl10/1824
 lock: ffff88021b627110, .magic: dead4ead, .owner: msgctl10/1824, .owner_cpu: 3
Pid: 1824, comm: msgctl10 Not tainted 2.6.33-rc6-git #56
Call Trace:
 [<ffffffff81225889>] spin_bug+0x9c/0xa3
 [<ffffffff812258cc>] do_raw_spin_unlock+0x3c/0x8d
 [<ffffffff814497c3>] _raw_spin_unlock+0x2b/0x2f
 [<ffffffff811cdf90>] ipc_unlock+0xe/0x15
 [<ffffffff811ce9f0>] newque+0x137/0x147
 [<ffffffff8144812a>] ? down_write+0x7a/0x81
 [<ffffffff811cd689>] ipcget+0x121/0x1a9
 [<ffffffff811ce8a5>] sys_msgget+0x55/0x59
 [<ffffffff811ce8b9>] ? newque+0x0/0x147
 [<ffffffff811ce8a9>] ? msg_security+0x0/0x10
 [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b

>
> Does this patch make any difference?

This solves my spinlock already unlock issue.

>
> diff --git a/lib/idr.c b/lib/idr.c
> index ba7d37c..a96c604 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
>        id = *starting_id;
>  restart:
>        p = idp->top;
> -       l = p->layer;
> +       l = idp->layers;
> +       pa[l--] = NULL;
>        while (1) {
>                /*
>                 * We run around this while until we reach the leaf node...
>
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
