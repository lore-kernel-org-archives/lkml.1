Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDDU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDDU11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXDDU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:27:27 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:57743 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXDDU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:27:25 -0400
Message-ID: <46140A2A.9050609@nagafix.co.uk>
Date: Wed, 04 Apr 2007 21:27:22 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       devzero@web.de,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, kraxel@suse.de
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <Pine.LNX.4.64.0704021318410.1276@anakin> <20070402145300.GA6179@c2.user-mode-linux.org> <461124A9.7080609@nagafix.co.uk> <4612E802.7000302@nagafix.co.uk> <Pine.LNX.4.64.0704040834450.20803@anakin>
In-Reply-To: <Pine.LNX.4.64.0704040834450.20803@anakin>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 4 Apr 2007, Antoine Martin wrote:
>> and this one:
>> http://www.suse.de/~kraxel/uml/patches/2.6.18-rc4/uml-x11-fb
>> which applied cleanly, but is not letting me set the option - Kconfig is
>> beyond me:
>>
>> arch/um/Kconfig:144:warning: 'select' used by config symbol 'X11_FB' refer to
>> undefined symbol 'FB_CFB_FILLRECT'
>> arch/um/Kconfig:145:warning: 'select' used by config symbol 'X11_FB' refer to
>> undefined symbol 'FB_CFB_COPYAREA'
>> arch/um/Kconfig:146:warning: 'select' used by config symbol 'X11_FB' refer to
>> undefined symbol 'FB_CFB_IMAGEBLIT'
> 
> Try adding
> 
>     source "drivers/video/Kconfig"
> 
> to arch/um/Kconfig.
Ahh, thanks for that, it did the trick.

I also needed to add this to include/asm-um/pgtable.h:
#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)         \
                 remap_pfn_range(vma, vaddr, pfn, size, prot)

And replace config.h with autoconf.h in arch/um/drivers/x11_kern.c

Then I hit:
arch/um/drivers/built-in.o:include/linux/input.h:1168: more undefined 
references to `input_event' follow
So I added: "select INPUT" to Kconfig
(starting with a defconfig might have done the trick too)

Then I hit:
arch/um/drivers/built-in.o: In function `x11_probe':
arch/um/drivers/x11_kern.c:442: undefined reference to `init_input_dev'
So I replaced:
         init_input_dev(kd->mouse);
with:
	kd->mouse = input_allocate_device();

That gave me a working kernel, but no x11 window appeared....
(I tried adding x11=640x480 to the command line too - no effect)

I then tried this patch:
http://user-mode-linux.sourceforge.net/work/current/2.6/2.6.21-rc1/patches/x11-fb
(fixing similar issues)

I had to comment out the line containing "soft_cursor" (couldn't figure 
out where to get it from)
It also required a lot of search and replace to change all instances of:
	kd->mouse.XXX
to
	kd->mouse->XXX
(same for kbd and changes to the initialization code)


Looks like the CONFIG_FB_CFB_FILLRECT and friends should not be set:
   LD      .tmp_vmlinux1
drivers/built-in.o: In function `cfb_copyarea':
drivers/video/cfbcopyarea.c:344: multiple definition of `cfb_copyarea'
arch/um/drivers/built-in.o:arch/um/drivers/../../../drivers/video/cfbcopyarea.c:344: 
first defined here
drivers/built-in.o: In function `cfb_imageblit':
drivers/video/cfbimgblt.c:263: multiple definition of `cfb_imageblit'
arch/um/drivers/built-in.o:arch/um/drivers/../../../drivers/video/cfbimgblt.c:263: 
first defined here
drivers/built-in.o: In function `cfb_fillrect':
drivers/video/cfbfillrect.c:345: multiple definition of `cfb_fillrect'
arch/um/drivers/built-in.o:arch/um/drivers/../../../drivers/video/cfbfillrect.c:345: 


Finally, this one pops up an X11 window, but it dies instantly:
[...]
Checking syscall emulation patch for ptrace...missing

Program received signal SIGSEGV, Segmentation fault.
kref_get (kref=0x5a5a5a5a5a5a5aa6) at lib/kref.c:32
32              WARN_ON(!atomic_read(&kref->refcount));
(gdb) bt
#0  kref_get (kref=0x5a5a5a5a5a5a5aa6) at lib/kref.c:32
#1  0x00000000600f4aa2 in kobject_get (kobj=0x5a5a5a5a5a5a5a8a) at 
lib/kobject.c:394
#2  0x0000000060109a95 in class_get (cls=<value optimized out>) at 
include/linux/kobject.h:145
#3  0x000000006010a3e5 in class_device_add (class_dev=0x602c9b38) at 
drivers/base/class.c:594
#4  0x000000006010ff5d in input_register_device (dev=0x602c9488) at 
drivers/input/input.c:987
#5  0x000000006001ed60 in x11_probe () at arch/um/drivers/x11_kern.c:482
#6  0x000000006000444d in x11_init () at arch/um/drivers/x11_kern.c:504
#7  0x00000000600015a6 in do_initcalls () at init/main.c:651
#8  0x0000000060001690 in do_basic_setup () at init/main.c:695
#9  0x000000006000f9ce in init (unused=<value optimized out>) at 
init/main.c:744
#10 0x00000000600241ca in run_kernel_thread (fn=0x6000f985 <init>, 
arg=0x0, jmp_ptr=<value optimized out>)
     at arch/um/os-Linux/process.c:289
#11 0x00000000600149b8 in new_thread_handler () at 
arch/um/kernel/skas/process.c:64
#12 0xa55a5a5a5a5a5a5a in ?? ()
#13 0x00000000602bd100 in ?? ()
#14 0x0000000060205f40 in ident_map ()
#15 0x0000000000000000 in ?? ()

And I am now completely out of my depth!

Antoine

> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 

