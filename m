Return-Path: <linux-kernel-owner+w=401wt.eu-S1422941AbXCBGLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422941AbXCBGLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422945AbXCBGLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:11:55 -0500
Received: from 1wt.eu ([62.212.114.60]:4922 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422941AbXCBGLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:11:54 -0500
Date: Fri, 2 Mar 2007 07:11:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sean Young <sean@mess.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc2] divide error: 0000
Message-ID: <20070302061149.GF943@1wt.eu>
References: <20070301231241.GA32630@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301231241.GA32630@atlantis.8hz.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:12:42PM +0000, Sean Young wrote:
> Apologies if this has already been reported.
> 
> If I call clock_gettime(CLOCK_THREAD_CPUTIME_ID, .. ) twice I get:
> 
> divide error: 0000 [#1]
> Modules linked in: binfmt_misc rfcomm l2cap bluetooth sonypi speedstep_ich speedstep_lib cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative video thermal sbs processor i2c_ec fan dock button battery ac af_packet ipv6 sbp2 lp usb_storage libusual orinoco_cs orinoco hermes joydev tsdev usbhid pcmcia e100 mii psmouse ohci1394 serio_raw yenta_socket rsrc_nonstatic pcmcia_core ieee1394 sr_mod cdrom sg uhci_hcd parport_pc parport pcspkr evdev usbcore
> CPU:    0
> EIP:    0060:[<c0126a07>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21-rc2 #1)
> EIP is at sample_to_timespec+0x28/0x33
> eax: 63b5a669   ebx: fffffffa   ecx: 63b5a669   edx: fffffffa
> esi: d4a56fa4   edi: 3b9aca00   ebp: d4a56fa4   esp: d4a56f74
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process x (pid: 3894, ti=d4a56000 task=dfe9aa50 task.ti=d4a56000)
> Stack: 00000000 fffffffe 00000000 c0127d49 d4a56fa4 63b5a669 fffffffa fffffffe
>        00000003 00000000 d4a56000 c0125bf3 b7f68ff4 b7f9fce0 fffffffe 00000003
>        c0103bfc fffffffe bfd6d5d8 b7f74ff4 00000003 00000000 bfd6d5b8 00000109
> Call Trace:
>  [<c0127d49>] posix_cpu_clock_get+0x47/0xdc
>  [<c0125bf3>] sys_clock_gettime+0x80/0x82
>  [<c0103bfc>] syscall_call+0x7/0xb
>  [<c02f0000>] svc_ioctl+0xc2/0x261
>  =======================
> Code: 0b eb fe 57 56 53 89 cb 89 d1 8b 74 24 10 83 e0 03 83 f8 02 74 0c 89 f2 89 c8 5b 5e 5f e9 ee 3f ff ff bf 00 ca 9a 3b 89 d0 89 da <f7> f7 89 56 04 89 06 5b 5e 5f c3 55 57 56 53 89 c7 89 d6 89 cb
> EIP: [<c0126a07>] sample_to_timespec+0x28/0x33 SS:ESP 0068:d4a56f74
> 
> The instruction is:
> 
> 	div %edi
> 
> And edi is 1e9 (0x3b9aca00). I don't understand why this results in an 
> divide error. 

It does this because 'div' does an unsigned divide of edx:eax by edi.
Here, edx=fffffffa and eax is 63b5a669. Clearly, such a number cannot
be divided by 1e9 to return a 32 bits value.

Given the values we see here, I suspect the code should have used an
integer divide (idiv). This means that something in the code implies
that the result is unsigned while it should be signed.

Regards,
Willy

