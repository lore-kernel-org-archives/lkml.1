Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863Ab0AVDYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0AVDYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820Ab0AVDYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:24:44 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:39545 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0AVDYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tc93Tw/X7CiZLK5KiORMvi3CGw4pT0hZTr1FHVk38JPkceshTQvcFsb+F63VNk67n7
         WogRXl36as7+6Fu+UVBTSZZXGtkDTcVYguFJF0f65in7nLsX1Tj4XWuUG3USQyw5lp7T
         aCq9gwZzYM3C8SAlY52eSef+HCC9T3qsskuFM=
MIME-Version: 1.0
In-Reply-To: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
References: <20100121155335.GB4471@osiris.boeblingen.de.ibm.com>
Date: Fri, 22 Jan 2010 11:24:42 +0800
Message-ID: <7b6bb4a51001211924v12e6ebf9ve4795ce96cd0a3f8@mail.gmail.com>
Subject: Re: [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug
From: Xiaotian Feng <xtfeng@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:53 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> Hi Eric,
>
> rumours are that you could be responsible for the following lockdep message:
>
> Happens on cpu hotplug on s390:

I can see the same warnings on x86_64

>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.33-rc4-00399-g24bc734 #1
> ---------------------------------------------
> bash/2576 is trying to acquire lock:
>  (s_active){++++.+}, at: [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8
>
> but task is already holding lock:
>  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
>
> other info that might help us debug this:
> 5 locks held by bash/2576:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<000000000016a912>] sysfs_write_file+0x4a/0x1a8
>  #1:  (s_active){++++.+}, at: [<000000000016c90c>] sysfs_get_active_two+0x64/0x88
>  #2:  (s_active){++++.+}, at: [<000000000016c8e6>] sysfs_get_active_two+0x3e/0x88
>  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000003dd318>] cpu_down+0x44/0x88
>  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000056eee>] cpu_hotplug_begin+0x3e/0x74
>
> stack backtrace:
> CPU: 1 Not tainted 2.6.33-rc4-00399-g24bc734 #1
> Process bash (pid: 2576, task: 000000003f0e25d0, ksp: 000000003d9339d8)
> 000000003d9338b0 000000003d933830 0000000000000002 0000000000000000
>       000000003d9338d0 000000003d933848 000000003d933848 00000000003e4996
>       0000000000000000 0000000000000000 000000003f0e2cb8 0000000000835208
>       000000000000000d 000000000000000c 000000003d933898 0000000000000000
>       0000000000000000 00000000000172aa 000000003d933830 000000003d933870
> Call Trace:
> ([<00000000000171b2>] show_trace+0xee/0x144)
>  [<000000000008a1a0>] validate_chain+0xa2c/0x1100
>  [<000000000008ad84>] __lock_acquire+0x510/0xbfc
>  [<000000000008b51c>] lock_acquire+0xac/0xd4
>  [<000000000016bba8>] sysfs_deactivate+0x94/0x108
>  [<000000000016c506>] sysfs_addrm_finish+0x5a/0xa8
>  [<0000000000169f38>] sysfs_hash_and_remove+0x64/0x9c
>  [<000000000016dbae>] sysfs_remove_group+0x76/0x12c
>  [<00000000003dfaae>] smp_cpu_notify+0xae/0xc8
>  [<00000000003eb652>] notifier_call_chain+0x56/0x98
>  [<000000000007a1b2>] raw_notifier_call_chain+0x2a/0x3c
>  [<00000000003dd132>] _cpu_down+0x1aa/0x34c
>  [<00000000003dd356>] cpu_down+0x82/0x88
>  [<00000000003ddac0>] store_online+0x5c/0xc8
>  [<000000000016a9be>] sysfs_write_file+0xf6/0x1a8
>  [<00000000000ffd5c>] vfs_write+0xac/0x178
>  [<00000000000fff24>] SyS_write+0x58/0xa8
>  [<00000000000295b6>] sysc_noemu+0x10/0x16
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
