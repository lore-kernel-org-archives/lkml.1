Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0BSEIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 23:08:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49038 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab0BSEIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 23:08:50 -0500
Message-ID: <4B7E0ECA.4000008@us.ibm.com>
Date: Thu, 18 Feb 2010 20:08:42 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: Stupid futex question - 2.6.33-rc7-mmotm0210
References: <10057.1266501862@localhost>
In-Reply-To: <10057.1266501862@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> Kernel: x86_64 2.6.33-rc7-mmotm0210
> 
> I'm debugging a problem where pulseaudio is getting killed with a SIGKILL
> out of the blue.  It appears to be a problem where pulseaudio sets
> RLIMIT_RTTIME and the bound gets exceeded.  Analysis with 'top' shows
> a short spike of 96% system time, and the tail end of strace shows this:
> 
> [pid 25065] 01:50:20.371484 ioctl(28, USBDEVFS_CONTROL, 0x7fd3d76f630c) = 0 <0.000015>
> [pid 25065] 01:50:20.371548 ioctl(28, 0x40045532, 0x7fd3d76f636c) = 0 <0.000016>
> [pid 25065] 01:50:20.371611 open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_CLOEXEC <unfinished ...>
> [pid 25064] 01:50:20.371678 <... write resumed> ) = 8 <0.002104>
> [pid 25064] 01:50:20.371718 futex(0xc2ec00, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>

So it received the signal and the task waiting in 
sys_futex(FUTEX_WAIT_PRIVATE...) wakes up to handle the signal and 
return right? What do you see here that suggests the task is spinning 
inside the futex syscall?

This is a non-rt kernel right? So spinning could occur on the hash 
bucket lock if something else is really horked. That seems unlikely.

> [pid 25066] 01:50:21.408392 +++ killed by SIGKILL +++
> PANIC: handle_group_exit: 25066 leader 25064
> [pid 25065] 01:50:21.408442 +++ killed by SIGKILL +++
> PANIC: handle_group_exit: 25065 leader 25064
> 01:50:21.420354 +++ killed by SIGKILL +++
> 
> thread 25064 apparently gets gunned down due to RTTIME because it spent a whole
> second in a futex() call - is it reasonable for futex() to not return for that
> long?

Certainly if a corresponding FUTEX_WAKE op was not sent.

--
Darrem

> In other words - kernel bug because futex() should return, or pulseaudio bug
> for not understanding futex() can snooze a while?

> If a kernel bug, anybody got a better idea than nuking the RLIMIT_RTTIME call,
> waiting for it to repeat (takes between 1 minute and 1 hour or so), and
> whomping it a few times with sysrq-T?
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
