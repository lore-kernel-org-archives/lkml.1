Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0BNUyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:54:43 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:32956 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0BNUyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PPkKBVPl2Lhyv+F6e6onQgUJTOrp3XAn1WnM2FQad22dC9Ydz94CYyfjNKDJNWNmRz
         +ti3W+5slB8JKdYwiJElRa956nNM5AIJ99jvixnfxtl/k9KrrMaRLVS77I47xisabiaF
         uI9i36fybPeQZodIO6zE5X+yQc82U6h6mkUrw=
MIME-Version: 1.0
In-Reply-To: <aca0ce8b1002140657l4f767635ob9b1611e4da2540b@mail.gmail.com>
References: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
	 <520f0cf11002140510w5c57d196n12f8036ea6085c52@mail.gmail.com>
	 <aca0ce8b1002140657l4f767635ob9b1611e4da2540b@mail.gmail.com>
Date: Sun, 14 Feb 2010 15:54:40 -0500
X-Google-Sender-Auth: 063ca841af67e574
Message-ID: <520f0cf11002141254y3f4536a9ta968dbaefbff58f7@mail.gmail.com>
Subject: Re: [BUG]: Possibe recursive locking detected in sysfs
From: John Kacur <jkacur@redhat.com>
To: Eric Biederman <ebiederm@aristanetworks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 9:57 AM, Eric Biederman
<ebiederm@aristanetworks.com> wrote:
> On Sun, Feb 14, 2010 at 5:10 AM, John Kacur <jkacur@redhat.com> wrote:
>> On Thu, Feb 11, 2010 at 12:11 PM, John Kacur <jkacur@redhat.com> wrote:
>>> I'm not sure if this one has already been reported. - thanks.
>>>
>>> Feb 11 07:24:15 localhost kernel: [ INFO: possible recursive locking detected ]
>>> Feb 11 07:24:15 localhost kernel: 2.6.33-rc7 #1
>>> Feb 11 07:24:15 localhost kernel: ---------------------------------------------
>>> Feb 11 07:24:15 localhost kernel: 94cpufreq/2933 is trying to acquire lock:
>>> Feb 11 07:24:15 localhost kernel: (s_active){++++.+}, at:
>>> [<ffffffff81157408>] sysfs_hash_and_remove+0x53/0x6a
>>> Feb 11 07:24:15 localhost kernel:
>>> Feb 11 07:24:15 localhost kernel: but task is already holding lock:
>>> Feb 11 07:24:15 localhost kernel: (s_active){++++.+}, at:
>>> [<ffffffff81159530>] sysfs_get_active_two+0x24/0x48
>>> Feb 11 07:24:15 localhost kernel:
>>> Feb 11 07:24:15 localhost kernel: other info that might help us debug this:
>>> Feb 11 07:24:15 localhost kernel: 4 locks held by 94cpufreq/2933:
>>> Feb 11 07:24:15 localhost kernel: #0:  (&buffer->mutex){+.+.+.}, at:
>>> [<ffffffff81157dbd>] sysfs_write_file+0x3e/0x12b
>>> Feb 11 07:24:15 localhost kernel: #1:  (s_active){++++.+}, at:
>>> [<ffffffff81159530>] sysfs_get_active_two+0x24/0x48
>>> Feb 11 07:24:15 localhost kernel: #2:  (s_active){++++.+}, at:
>>> [<ffffffff8115953d>] sysfs_get_active_two+0x31/0x48
>>> Feb 11 07:24:15 localhost kernel: #3:  (dbs_mutex){+.+.+.}, at:
>>> [<ffffffffa04bcdb3>] cpufreq_governor_dbs+0x29b/0x348
>>> [cpufreq_ondemand]
>>> Feb 11 07:24:15 localhost kernel:
>>> Feb 11 07:24:15 localhost kernel: stack backtrace:
>>> Feb 11 07:24:15 localhost kernel: Pid: 2933, comm: 94cpufreq Not
>>> tainted 2.6.33-rc7 #1
>>> Feb 11 07:24:15 localhost kernel: Call Trace:
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81071f53>]
>>> __lock_acquire+0xcf6/0xd8b
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81070914>] ?
>>> debug_check_no_locks_freed+0x120/0x12f
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff8107020e>] ?
>>> trace_hardirqs_on_caller+0x11f/0x14a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff810720c0>] lock_acquire+0xd8/0xf5
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>] ?
>>> sysfs_hash_and_remove+0x53/0x6a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81159231>]
>>> sysfs_addrm_finish+0xe1/0x175
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>] ?
>>> sysfs_hash_and_remove+0x53/0x6a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff8137b1b5>] ?
>>> sub_preempt_count+0xa3/0xb6
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>]
>>> sysfs_hash_and_remove+0x53/0x6a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff8115a59d>]
>>> sysfs_remove_group+0x91/0xc9
>>> Feb 11 07:24:15 localhost kernel: [<ffffffffa04bcdc6>]
>>> cpufreq_governor_dbs+0x2ae/0x348 [cpufreq_ondemand]
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff8137b1b5>] ?
>>> sub_preempt_count+0xa3/0xb6
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff812ab9cc>]
>>> __cpufreq_governor+0x89/0xc7
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff812ac7b9>]
>>> __cpufreq_set_policy+0x18e/0x22a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff812accd6>]
>>> store_scaling_governor+0x199/0x1ed
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff812ad50d>] ? handle_update+0x0/0x39
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff8137685d>] ? down_write+0x76/0x7e
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff812ac607>] store+0x67/0x8b
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81157e75>]
>>> sysfs_write_file+0xf6/0x12b
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff811003c9>] vfs_write+0xb0/0x10a
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff811004f1>] sys_write+0x4c/0x75
>>> Feb 11 07:24:15 localhost kernel: [<ffffffff81002d9b>]
>>> system_call_fastpath+0x16/0x1b
>>>
>>
>> This is still present in 2.6.33-rc8.
>> I can trigger it every time. I have T500 laptop, the trick is to boot
>> it up without plugging it in, so it is working on battery power, and
>> then to shut the lid.
>> first you get the message from above, and then it does a few more
>> things before it freezes and I have to hard reboot it.
>> The above problem does not occur if I have the laptop plugged into the wall.
>>
>> Here is the 2.6.33-rc8 version of above. If anyone has further
>> suggestions for debugging, pls let me know.
>> I've cced the folks that get_maintainer.pl reports for
>> fs/sysfs/inode.c and fs/sysfs/dir.c
>
> We have a real hang and a possibly spurious lockdep report.
> Could you try my latest patches that I sent to gregkh to clear up the sysfs
> lockdep reports?   I don't expect it will fix your issue but it will
> at least give
> us a better idea of where to look.
>
> Eric
>
Sure, are you referring to the patch-set that begins with
"[PATCH 1/6] sysfs: Serialize updates to the vfs inode"?
