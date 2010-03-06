Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CFJdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:33:16 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:44149 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0CFJdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LmF8/eQ1/x0Wc2MeVURJMZlLOdXQL6d8VeHsTe1pJzz94FhwRMsQa1bULa6iV/y5xT
         7Z4Itu574D5zQef+QM9o98ARrYk5z8Y9opJRjNfvepfHMQ2pmWkIlq9phc9iRa4FAnaf
         XGi3kZntZYBY/LaJgwGhCzBtvSlL/rPrmXBq8=
Date: Sat, 6 Mar 2010 01:33:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Petr Vandrovec <petr@vmware.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Jeff Chua <jeff.tw.chua@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for
 vmware 7.0.1
Message-ID: <20100306093306.GA27247@core.coreip.homeip.net>
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>
 <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain>
 <4B91CFE0.8000705@vmware.com>
 <b6a2187b1003052129l7703dee6s6e820b8ca18b9e2d@mail.gmail.com>
 <4B91FA42.8020400@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B91FA42.8020400@vmware.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:46:26PM -0800, Petr Vandrovec wrote:
> Jeff Chua wrote:
> >
> >
> >On Sat, Mar 6, 2010 at 11:45 AM, Petr Vandrovec <petr@vmware.com
> ><mailto:petr@vmware.com>> wrote:
> >
> >      does your box hang, or is it just vmware process that is hung?
> >
> >
> >Just the "vmware" process that hangs only. It just got stuck, and
> >even kill -9 doesn't free it.
> >
> >     I've noticed that my box here at work has this change too, and I do
> >    not see any hang - neither in kernel, or in GUI startup, nor in test
> >    sample:
> >
> >    open("/proc/bus/usb/devices", O_RDWR)   = 3
> >    poll([{fd=3, events=POLLIN}], 1, 5000)  = 1 ([{fd=3, revents=POLLIN}])
> >    poll([{fd=3, events=POLLIN}], 1, 5000)  = 0 (Timeout)
> >    exit_group(0)                           = ?
> >    petr-dev3:/tmp# uname -a
> >    Linux petr-dev3 2.6.33-64-05079-g6517b45-dirty #51 SMP PREEMPT Thu
> >    Mar 4 20:29:55 PST 2010 x86_64 GNU/Linux
> >
> >
> >Here's mine ...
> >open("/proc/bus/usb/devices", O_RDONLY) = 65
> >fcntl(65, F_GETFL)                      = 0x8000 (flags
> >O_RDONLY|O_LARGEFILE)
> >fstat(65, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> >mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> >-1, 0) = 0x7f85396c8000
> >lseek(65, 0, SEEK_CUR)                  = 0
> >read(65,
> >
> >
> >Again in my previous email, on my box,  "cat
> >/proc/bus/usb/devices" hangs as well. You sure you've commit
> >554f76962d3a6eb5110415f1591aca83f96a84ae
> > on yours?
> 
> Well, I hope.  Disassembly of usbcore says that I have
> mutex_lock(&usbfs_mutex) in usbfs_conn_disc_event, so that checkin
> should be in my tree:
> 
> 000000000001cc10 <usbfs_conn_disc_event>:
>    1cc10:       55                      push   %rbp
>    1cc11:       48 89 e5                mov    %rsp,%rbp
>    1cc14:       e8 00 00 00 00          callq  1cc19
> <usbfs_conn_disc_event+0x9>
>                         1cc15: R_X86_64_PC32    mcount+0xfffffffffffffffc
>    1cc19:       31 f6                   xor    %esi,%esi
>    1cc1b:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
>                         1cc1e: R_X86_64_32S     usbfs_mutex
>    1cc22:       e8 00 00 00 00          callq  1cc27
> <usbfs_conn_disc_event+0x17>
>                         1cc23: R_X86_64_PC32
> mutex_lock_nested+0xfffffffffffffffc
>    1cc27:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
>                         1cc2a: R_X86_64_32S     usbfs_mutex
>    1cc2e:       ff 05 00 00 00 00       incl   0x0(%rip)        #
> 1cc34 <usbfs_conn_disc_event+0x24>
>                         1cc30: R_X86_64_PC32    .bss+0x9a4
>    1cc34:       e8 00 00 00 00          callq  1cc39
> <usbfs_conn_disc_event+0x29>
>                         1cc35: R_X86_64_PC32
> mutex_unlock+0xfffffffffffffffc
>    1cc39:       31 c9                   xor    %ecx,%ecx
>    1cc3b:       ba 01 00 00 00          mov    $0x1,%edx
>    1cc40:       be 03 00 00 00          mov    $0x3,%esi
>    1cc45:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
>                         1cc48: R_X86_64_32S     .data+0x1d00
>    1cc4c:       e8 00 00 00 00          callq  1cc51
> <usbfs_conn_disc_event+0x41>
>                         1cc4d: R_X86_64_PC32
> __wake_up+0xfffffffffffffffc
>    1cc51:       c9                      leaveq
>    1cc52:       c3                      retq
> 
> 
> One thing is that I brought my only USB device home, so currently I
> have none attached to the box:
> 
> petr-dev3:/usr/src/git/linux-2.6# cat /proc/bus/usb/devices
> 
> T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 3
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.33-64-05079-g6517b45-dirty ohci_hcd
> S:  Product=OHCI Host Controller
> S:  SerialNumber=0000:03:00.1
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 3
> B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=1d6b ProdID=0001 Rev= 2.06
> S:  Manufacturer=Linux 2.6.33-64-05079-g6517b45-dirty ohci_hcd
> S:  Product=OHCI Host Controller
> S:  SerialNumber=0000:03:00.0
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> petr-dev3:/usr/src/git/linux-2.6#
> 
> I'll try upgrading my box at home.  Maybe that one will hang.

I did not have issues with bringing VMware GUI with
64096c17417380d8a472d096645f4cbc9406c987 as tip of Linus's tree (which
is a believe the latest published), but got the following traces when
yanked USB keyboard out:

[ 1784.954389] usb 5-1: USB disconnect, address 2
[ 1784.954394] usb 5-1.3: USB disconnect, address 3
[ 1920.558046] INFO: task khubd:27 blocked for more than 120 seconds.
[ 1920.558051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1920.558054] khubd         D 0000000000000202     0    27      2 0x00000000
[ 1920.558060]  ffff88011ba29960 0000000000000046 ffff88000260eec0 ffff88011ba20000
[ 1920.558067]  ffff88011ba28000 ffff88011ba29fd8 ffff88011ba29fd8 ffff88011ba20000
[ 1920.558073]  ffff88011ba29fd8 0000000000013d80 0000000000013d80 0000000000013d80
[ 1920.558079] Call Trace:
[ 1920.558088]  [<ffffffff81478591>] __mutex_lock_common+0x1a1/0x4a0
[ 1920.558094]  [<ffffffff8136f922>] ? usbfs_conn_disc_event+0x12/0x40
[ 1920.558099]  [<ffffffff8107eb7d>] ? trace_hardirqs_on+0xd/0x10
[ 1920.558103]  [<ffffffff8136f922>] ? usbfs_conn_disc_event+0x12/0x40
[ 1920.558107]  [<ffffffff8147896e>] mutex_lock_nested+0x3e/0x50
[ 1920.558111]  [<ffffffff8136f922>] usbfs_conn_disc_event+0x12/0x40
[ 1920.558115]  [<ffffffff81371184>] usbfs_notify+0xa4/0x240
[ 1920.558119]  [<ffffffff8147e007>] notifier_call_chain+0x47/0x90
[ 1920.558124]  [<ffffffff8106f495>] __blocking_notifier_call_chain+0x55/0x80
[ 1920.558128]  [<ffffffff8106f4d1>] blocking_notifier_call_chain+0x11/0x20
[ 1920.558132]  [<ffffffff8136e7be>] usb_notify_remove_device+0x2e/0x50
[ 1920.558135]  [<ffffffff8136e8a1>] generic_disconnect+0x11/0x30
[ 1920.558140]  [<ffffffff81365db9>] usb_unbind_device+0x29/0x50
[ 1920.558145]  [<ffffffff81303830>] __device_release_driver+0x70/0xe0
[ 1920.558149]  [<ffffffff81303998>] device_release_driver+0x28/0x40
[ 1920.558153]  [<ffffffff813029fc>] bus_remove_device+0xac/0xe0
[ 1920.558157]  [<ffffffff81300d67>] device_del+0x127/0x1a0
[ 1920.558161]  [<ffffffff8135bf2c>] usb_disconnect+0xec/0x160
[ 1920.558165]  [<ffffffff8135bef7>] usb_disconnect+0xb7/0x160
[ 1920.558169]  [<ffffffff8135c6ee>] hub_port_connect_change+0x8e/0x9f0
[ 1920.558172]  [<ffffffff814783e9>] ? mutex_unlock+0x9/0x10
[ 1920.558176]  [<ffffffff8135e263>] hub_events+0x3c3/0x580
[ 1920.558180]  [<ffffffff8147a3cd>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
[ 1920.558184]  [<ffffffff8135e475>] hub_thread+0x55/0x190
[ 1920.558189]  [<ffffffff810695a0>] ? autoremove_wake_function+0x0/0x40
[ 1920.558193]  [<ffffffff8135e420>] ? hub_thread+0x0/0x190
[ 1920.558197]  [<ffffffff8106908e>] kthread+0x8e/0xa0
[ 1920.558202]  [<ffffffff81003dd4>] kernel_thread_helper+0x4/0x10
[ 1920.558206]  [<ffffffff8147ab40>] ? restore_args+0x0/0x30
[ 1920.558210]  [<ffffffff81069000>] ? kthread+0x0/0xa0
[ 1920.558213]  [<ffffffff81003dd0>] ? kernel_thread_helper+0x0/0x10
[ 1920.558216] INFO: lockdep is turned off.
[ 1920.558254] INFO: task vmware-usbarbit:8039 blocked for more than 120 seconds.
[ 1920.558256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1920.558259] vmware-usbarb D 0000000000000202     0  8039      1 0x00000080
[ 1920.558264]  ffff8800cf7099a8 0000000000000046 ffff8800cf709928 ffff8800c5f22010
[ 1920.558270]  ffff8800cf708000 ffff8800cf709fd8 ffff8800cf709fd8 ffff8800c5f22010
[ 1920.558276]  ffff8800cf709fd8 0000000000013d80 0000000000013d80 0000000000013d80
[ 1920.558281] Call Trace:
[ 1920.558286]  [<ffffffff81478591>] __mutex_lock_common+0x1a1/0x4a0
[ 1920.558290]  [<ffffffff8136f97f>] ? usb_device_poll+0x2f/0x170
[ 1920.558293]  [<ffffffff8136f97f>] ? usb_device_poll+0x2f/0x170
[ 1920.558297]  [<ffffffff8106cfd0>] ? hrtimer_wakeup+0x0/0x30
[ 1920.558301]  [<ffffffff8147896e>] mutex_lock_nested+0x3e/0x50
[ 1920.558305]  [<ffffffff8136f97f>] usb_device_poll+0x2f/0x170
[ 1920.558309]  [<ffffffff8112e104>] ? poll_schedule_timeout+0x44/0x60
[ 1920.558313]  [<ffffffff8112e22b>] do_poll+0x10b/0x2b0
[ 1920.558317]  [<ffffffff8112ef0e>] do_sys_poll+0x16e/0x230
[ 1920.558320]  [<ffffffff8112e490>] ? __pollwait+0x0/0xf0
[ 1920.558324]  [<ffffffff8112e580>] ? pollwake+0x0/0x60
[ 1920.558327]  [<ffffffff8112e580>] ? pollwake+0x0/0x60
[ 1920.558331]  [<ffffffff8112e580>] ? pollwake+0x0/0x60
[ 1920.558335]  [<ffffffff81127bdc>] ? path_put+0x2c/0x40
[ 1920.558339]  [<ffffffff81129854>] ? link_path_walk+0x424/0xc60
[ 1920.558343]  [<ffffffff811272b5>] ? path_init+0xb5/0x1d0
[ 1920.558347]  [<ffffffff81138bb4>] ? mntput_no_expire+0x24/0xf0
[ 1920.558351]  [<ffffffff81114315>] ? kmem_cache_free+0xd5/0x140
[ 1920.558356]  [<ffffffff8107ea09>] ? trace_hardirqs_on_caller+0x29/0x190
[ 1920.558360]  [<ffffffff8107eb7d>] ? trace_hardirqs_on+0xd/0x10
[ 1920.558363]  [<ffffffff81127400>] ? putname+0x30/0x50
[ 1920.558367]  [<ffffffff81127400>] ? putname+0x30/0x50
[ 1920.558371]  [<ffffffff8112afad>] ? user_path_at+0x5d/0xa0
[ 1920.558375]  [<ffffffff81121817>] ? vfs_fstatat+0x37/0x70
[ 1920.558380]  [<ffffffff81074029>] ? ktime_get_ts+0xa9/0xe0
[ 1920.558383]  [<ffffffff8112e090>] ? poll_select_set_timeout+0x70/0xa0
[ 1920.558387]  [<ffffffff8112f1b7>] sys_poll+0x77/0x110
[ 1920.558391]  [<ffffffff81002fab>] system_call_fastpath+0x16/0x1b
[ 1920.558394] INFO: lockdep is turned off.

-- 
Dmitry
