Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974Ab0A0JuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0A0JuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0A0JuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:50:05 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:55017 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0A0JuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:50:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N/cCh+OqOZ8aLfbxSQd0wfiBH7fAImvDqOvzs5guiKx/sPrmtCyhj6EyyGDj/jhfO3
         dM75lw3bHQkb2AGeWLDlH/ciBBzR4nfE823ffXuH4NFQevZ6VRafhpQYmylj5vplONmf
         2WktymrUzZlxhqYCfDrdJs8et/Gxi1lNAS9/s=
MIME-Version: 1.0
In-Reply-To: <201001261925.13249.rjw@sisk.pl>
References: <4B5F1F8C.6090406@lwfinger.net> <201001261925.13249.rjw@sisk.pl>
Date: Wed, 27 Jan 2010 17:50:00 +0800
Message-ID: <2375c9f91001270150o57cb87a4m7f0ecfbe39c333f1@mail.gmail.com>
Subject: Re: Locking Problem in 2.6.33-rc5
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 2:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 26 January 2010, Larry Finger wrote:
>> On suspend to RAM, I get the following recursive locking message:
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.33-rc5-Linus-dirty #173
>> ---------------------------------------------
>> sh/3488 is trying to acquire lock:
>>    (s_active){++++.+}, at: [<ffffffff81167413>] sysfs_addrm_finish+0x43/0x70
>>
>> but task is already holding lock:
>>    (s_active){++++.+}, at: [<ffffffff8116771d>] sysfs_get_active_two+0x3d/0x60
>>
>> other info that might help us debug this:
>> 4 locks held by sh/3488:
>>    #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81165b7f>]
>> sysfs_write_file+0x3f/0x160
>>    #1:  (s_active){++++.+}, at: [<ffffffff8116771d>] sysfs_get_active_two+0x3d/0x60
>>    #2:  (s_active){++++.+}, at: [<ffffffff81167702>] sysfs_get_active_two+0x22/0x60
>>    #3:  (dbs_mutex){+.+.+.}, at: [<ffffffff81271517>]
>> cpufreq_governor_dbs+0xe7/0x480
>>
>> stack backtrace:
>> Pid: 3488, comm: sh Not tainted 2.6.33-rc5-Linus-dirty #173
>> Call Trace:
>>    [<ffffffff8107c36b>] __lock_acquire+0xf6b/0x1d30
>>    [<ffffffff81078e9f>] ? lockdep_init_map+0x5f/0x5d0
>>    [<ffffffff8107d1cb>] lock_acquire+0x9b/0x120
>>    [<ffffffff81167413>] ? sysfs_addrm_finish+0x43/0x70
>>    [<ffffffff81166ba3>] sysfs_deactivate+0xc3/0x110
>>    [<ffffffff81167413>] ? sysfs_addrm_finish+0x43/0x70
>>    [<ffffffff81167413>] sysfs_addrm_finish+0x43/0x70
>>    [<ffffffff81165206>] sysfs_hash_and_remove+0x56/0x80
>>    [<ffffffff8116895f>] sysfs_remove_group+0x4f/0xf0
>>    [<ffffffff8127152b>] cpufreq_governor_dbs+0xfb/0x480
>>    [<ffffffff8107a8dd>] ? trace_hardirqs_on_caller+0x14d/0x190
>>    [<ffffffff8107a92d>] ? trace_hardirqs_on+0xd/0x10
>>    [<ffffffff8126e314>] __cpufreq_governor+0x94/0x160
>>    [<ffffffff8126f84f>] __cpufreq_set_policy+0x11f/0x180
>>    [<ffffffff8126fc66>] store_scaling_governor+0xc6/0x200
>>    [<ffffffff81270530>] ? handle_update+0x0/0x10
>>    [<ffffffff8126f702>] store+0x62/0x90
>>    [<ffffffff81165c21>] sysfs_write_file+0xe1/0x160
>>    [<ffffffff8110b0c8>] vfs_write+0xb8/0x180
>>    [<ffffffff8110b26c>] sys_write+0x4c/0x80
>>    [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
>
> Does the patch at http://patchwork.kernel.org/patch/70461/ fix it?
>

It is not related with this bug, IMO.

This bug was reported at least 3 times recently, Eric sent a patch for this
bug, but amazingly that patch doesn't work, I will look for some time
to dig more to see what is wrong with that patch.

Thanks.
