Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab0BBVwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:52:54 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58867 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0BBVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:52:52 -0500
Date: Tue, 2 Feb 2010 22:52:51 +0100
From: Andreas Mohr <andi@lisas.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202215251.GA18570@rhlx01.hs-esslingen.de>
References: <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org> <1265131212.12634.112.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265131212.12634.112.camel@pc1117.cambridge.arm.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 02, 2010 at 05:20:11PM +0000, Catalin Marinas wrote:
> My issues is with both I-D coherency and D-cache aliasing caused by
> pages mapped in both user and kernel space (with different colours). The
> flush_dcache_page() call should target both cases.

Yup, it does, and quite successfully at that (aka "at that point in time we
having nothing any more to worry about, everything dealt with" ;-)


usbcore: registered new interface driver ums-datafab                                                                  
hub 2-1:1.0: state 7 ports 2 chg 0002 evt 0000                                                                        
kobject: 'ums-freecom' (81de0a80): kobject_add_internal: parent: 'drivers', set: 'drivers'                            
hub 2-1:1.0: port 1, status 0101, change 0000, 12 Mb/s                                                                
kobject: 'ums-freecom' (81de0a80): kobject_uevent_env                                                                 
kobject: 'ums-freecom' (81de0a80): fill_kobj_path: path = '/bus/usb/drivers/ums-freecom'                              
usbcore: registered new interface driver ums-freecom                                                                  
kobject: 'ums-jumpshot' (81de0c80): kobject_add_internal: parent: 'drivers', set: 'drivers'                           
CPU 0 Unable to handle kernel paging request at virtual address 0000041c, epc == 800171e8, ra == 801da5dc             
Oops[#1]:                                                                                                             
Cpu 0                                                                                                                 
$ 0   : 00000000 10008000 803b0000 00010000                                                                           
$ 4   : 00000408 8143bc60 0043bc60 00000001                                                                           
$ 8   : 81dd7124 81dd7190 00000004 00000000                                                                           
$12   : 0000003b 80380000 00000002 f2d9b780                                                                           
$16   : a1de4020 803b0000 8037f840 81de7f00                                                                           
$20   : 00000000 81dd7080 80000000 00000000                                                                           
$24   : 00000000 80016bb8                                                                                             
$28   : 81c0c000 81c0da98 a1dd414c 801da5dc                                                                           
Hi    : 00000008                                                                                                      
Lo    : 00000000                                                                                                      
epc   : 800171e8 __flush_dcache_page+0x38/0x120
    Not tainted
ra    : 801da5dc ehci_urb_done+0x178/0x1dc
Status: 10008002    KERNEL EXL
Cause : 00805008
BadVA : 0000041c
PrId  : 00029029 (Broadcom BCM3302)
Modules linked in:
Process swapper (pid: 1, threadinfo=81c0c000, task=81c08480, tls=00000000)
Stack : 81dd7080 00000001 10009000 8033dab8 a1dd8120 a1dd4114 ffffff6a ffffff6a
        81de7f00 a1dd414c a1dd4100 801db39c 05b8d800 00000000 00000018 803a0000
        803a0000 0000054c 00000001 00000000 a1dd8180 81dd7080 00000000 a1dd4100
        00000000 81c0dbb8 00000000 80318d24 81dd7158 81dd7080 81dda004 801deb38
        81dd7158 8004f984 01f63104 0000003c 81c0dc78 8033feb8 00000008 00000042
        ...
Call Trace:
[<800171e8>] __flush_dcache_page+0x38/0x120
[<801da5dc>] ehci_urb_done+0x178/0x1dc
[<801db39c>] qh_completions+0x484/0x554
[<801deb38>] ehci_work+0x438/0xb68
[<801df2bc>] ehci_watchdog+0x54/0x94
[<8003d3ec>] run_timer_softirq+0x1b0/0x268
[<80037fbc>] __do_softirq+0xb8/0x174
[<800380d4>] do_softirq+0x5c/0x98
[<80038244>] irq_exit+0x40/0x88
[<8000e12c>] plat_irq_dispatch+0x60/0x178
[<80001444>] ret_from_irq+0x0/0x4
[<80031de8>] vprintk+0x36c/0x3bc
[<8000a48c>] printk+0x24/0x30
[<80151918>] kobject_add_internal+0x124/0x254
[<80151f80>] kobject_init_and_add+0x40/0x58
[<8018e854>] bus_add_driver+0xdc/0x2b4
[<801902c8>] driver_register+0xe0/0x19c
[<801ce000>] usb_register_driver+0x84/0x118
[<8000d640>] do_one_initcall+0x70/0x1f4
[<80354334>] kernel_init+0xd0/0x140
[<8000fb4c>] kernel_thread_helper+0x10/0x18


Code: 00000000  10800029  3c02803b <8c820014> 14400026  3c02803b  8c83001c  2482001c  14620021
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt



Any ideas? To my uncaring mind this would look like __flush_dcache_page()
not being quite so happy with a NULL pointer that it is being served
(although I haven't managed to precisely investigate yet where the
dereferencing offset 0000041c is coming from).

Yes, crash is reproducible (three times on boot already, although some bootup
does make it successfully).

My ehci-q.c has:

       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) != PIPE_CONTROL) {
               void *ptr;
               for (ptr = urb->transfer_buffer;
                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
                    ptr += PAGE_SIZE)
                       flush_dcache_page(virt_to_page(ptr));
       }

Hmm, OTOH this code seems to postulate that urb->transfer_buffer_length
is that 0x41c from above...
(IOW the code is simply missing an urb->transfer_buffer NULL check)
OTOH there would also be the question whether flush_dcache_page() should
have caught the NULL pointer input...
And then there's the question whether urb->transfer_buffer is allowed to end
up as NULL anyway...



BTW, trying to keep open /dev/dsp by another app when closing the playback app
does not prevent the audio OOPS.


Been seeing a nano-tiny wee bit too many crashes these days,

Andreas Mohr
