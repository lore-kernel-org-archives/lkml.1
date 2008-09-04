Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYIDOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYIDOzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYIDOza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:55:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYIDOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pHzWjXyIdt33KOVCY9h23sHwXIqMXYG5Hmrdwsn4KdYKdKTeflkrwn7duyhRHLFoUu
         l9IeZGbTF9FFRF7Q/QaH7ceI0k2VqbbcTii83gwFS1HRvHx56gaT493alZiHJKWGq0uf
         nhimkD6GG+NBtl6N3cesvizucBImj1gACZiJA=
Message-ID: <48BFF6DB.1060807@gmail.com>
Date: Thu, 04 Sep 2008 16:55:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
References: <7419.1220261347@turing-police.cc.vt.edu> <48BD4D20.5020704@gmail.com> <13476.1220371878@turing-police.cc.vt.edu>            <48BDA9F2.7000203@gmail.com> <4909.1220499086@turing-police.cc.vt.edu>
In-Reply-To: <4909.1220499086@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu napsal(a):
> (Adding Alan Cox to the cc: in case he can shed light on this one - it
> appears that HID_COMPAT only puts the bullet in the chamber, and doesn't
> actually cause the hang...)
> 
> On Tue, 02 Sep 2008 23:02:42 +0200, Jiri Slaby said:
>> On 09/02/2008 06:11 PM, Valdis.Kletnieks@vt.edu wrote:
>>> The following 3 lines don't go to console by default due to loglevel setting.
>>> So I'm not sure exactly where it hangs. But it's somewhere in here.
> 
> Right around here, we kick off a modprobe for 'hid_dummy'.
>>>>> [    1.959193] usbcore: registered new interface driver usbhid
>>>>> [    1.973037] usbhid: v2.6:USB HID core driver
> 
> And since my initrd doesn't include any modules (since until now, I've had
> a kernel that can everything builtin so it can boot far enough to do the
> whole udev/modprobe off my root filesystem, and hid_dummy is a new one on
> me), this modprobe spits out a:
> 
> modprobe: FATAL: Could not open '/lib/modules/2.6.27-rc5-mmotm0829/modules.dep': No such file or directory
> 
> Well, yeah.. No modules on the initrd, so no modules.dep.  But having spewed
> its error message, modprobe apparently decides to go off in a snit and hang.
> Eventually, the usermode_helper call does a wait() on the modprobe, and then
> *that* hangs because modprobe isn't returning.  And eventually the whole
> level of initcalls comes to a screeching halt...
> 
> And here's the totally unexpected kernel traceback for the modprobe:
> 
> schedule_timeout+0x22/0xb4
> ? _raw_spin_lock+0xce/0x186
> ? _raw_spin_unlock+0xb7/0xe0
> wait_for_common+-xb2/0xfb
> ? default_wake_function+0x0/0xf
> wait_for_completion+0x18/0x1a
> flush_cpu_workqueue+0x6b/0x77
> ? wq_barrior_func+0x0/0xf
> flush_workqueue+0x4f/0x68
> flush_scheduled_work+0x10/0x12
> tty_ldisc_release+0x4a/0x21e
> ? _raw_pin_lock+0xce/0x186
> ? debug_mutex_unlock+0x127/0x14d
> ? mutex_unlock_slowpath+0x14a/0x15c
> tty_release_dev+0x4da/0x508
> ? get_parent_ip+0x11/0x41
> ? get_parent_ip+0x11/0x41
> tty_release+0x19/0x24
> __fput+0xd9/0x198
> fput+0x15/0x17
> filp_close+0x67/0x72
> sys_close+0xa9/0x104
> system_call_fastpath+0x16/0x1b
> 
> WTF? We hang trying to close a tty??!?

Hmm, *if* we stuck in request_module in hid, workqueue cannot be flushed and
tty waits... Could you stick 2 printks into hid_compat_load if it finishes?
