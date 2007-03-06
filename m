Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXCFIq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXCFIq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXCFIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:46:28 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:2818 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933085AbXCFIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:46:27 -0500
Date: Tue, 6 Mar 2007 09:45:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "J.A. Magallon" <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i2c vs nVidia [Re: 2.6.21-rc2-mm1]
Message-Id: <20070306094543.abb6e290.khali@linux-fr.org>
In-Reply-To: <20070306004444.GC12566@kroah.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070306011621.5a844c41@werewolf-wl>
	<20070305163320.2b21ab7e.akpm@linux-foundation.org>
	<20070306004444.GC12566@kroah.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Andrew, J.A.,

On Mon, 5 Mar 2007 16:44:44 -0800, Greg KH wrote:
> On Mon, Mar 05, 2007 at 04:33:20PM -0800, Andrew Morton wrote:
> > On Tue, 6 Mar 2007 01:16:21 +0100
> > "J.A. Magall__n" <jamagallon@ono.com> wrote:
> > 
> > > On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > 
> > > > Temporarily at
> > > > 
> > > >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > > > 
> > > 
> > > More things...
> > > 
> > > Yes, this is related to nVidia driver. First of all, I'm not asking for help
> > > for a broken closed-source driver. I just want Linux to be fool^^^^bullet-proof ;).
> > > 
> > > As one can expect from a closed-source driver, recent changes in Linux broke it.
> > > New nVidia drivers include some i2c sensors. The driver worked till 2.6.20-rc6-mm3.

This statement is incorrect. Rather:
* New nVidia drivers register their I2C busses with i2c-core (which
  isn't a bad thing.)
* Some nVidia adapters have sensors (this isn't new.)

> > > Since then, I can't use them. I have tracked down the problem to i2c.
> > > nVidia driver tries to create 3 i2c devices, and I get this:
> > > 
> > > **WARNING** I2C adapter driver [NVIDIA i2c adapter 0 at 1:00.0] forgot to specify physical device; fix it!
> > >  i2c-10: attach_adapter failed (-16) for driver [w83627hf]
> > > **WARNING** I2C adapter driver [NVIDIA i2c adapter 1 at 1:00.0] forgot to specify physical device; fix it!
> > >  i2c-11: attach_adapter failed (-16) for driver [w83627hf]
> > > **WARNING** I2C adapter driver [NVIDIA i2c adapter 2 at 1:00.0] forgot to specify physical device; fix it!
> > >  i2c-12: attach_adapter failed (-16) for driver [w83627hf]
> > 
> > This problem has always been there - there's a patch in -mm which simply
> > converts this message from pr_debug() into printk().

The "forgot to specify physical device" messages are expected and
harmless, as Andrew said. It's up to nVidia to fix their driver, and it
should be trivial.

The "attach_adapter failed" messages are not expected, though, and this
is the first report. I'll have to investigate this.

-16 is -EBUSY, it is returned to us by the w83627hf driver which really
has no reason to ever try to attach to the nVidia I2C busses - it is
supposed to only attach to the i2c-isa driver. So I guess that the
i2c-core changes broke i2c-isa somehow.

We should really get rid of i2c-isa now so that we stop wasting our
time with it :(

> > > Two problems arise:
> > > - The directories in /sys/class/i2c-adapter/ are created, but trying to ls
> > >   its contents oopses:
> > > 
> > > last sysfs file: class/i2c-adapter/i2c-0/name
> > > Modules linked in: nvidia(P) nfsd exportfs lockd nfs_acl sunrpc snd_intel8x0 snd_ens1371 gameport snd_rawmidi snd_ac97_codec w83627hf ac97_bus hwmon_vid snd_pcm hwmon snd_timer i2c_isa snd_page_alloc i2c_i801 snd i2c_dev loop intel_agp agpgart udf e1000 3c59x microcode ohci1394 ieee1394 usblp evdev
> > > CPU:    3
> > > EIP:    0060:[<c0194b0c>]    Tainted: P       VLI
> > > EFLAGS: 00010202   (2.6.20-jam01 #1)
> > > EIP is at sysfs_follow_link+0xe6/0x254
> > > eax: 00020b36   ebx: f329edd8   ecx: 00000000   edx: f4ab84d8
> > > esi: f0df4ee8   edi: 00000100   ebp: 00000002   esp: f4039ea4
> > > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > Process sensors (pid: 4991, ti=f4038000 task=f7efa540 task.ti=f4038000)
> > > Stack: f7ee4338 f4039edc f0ef7000 ffffffea f4ab84d8 00000000 c0387128 00000000
> > >        c02f76a0 f329edd8 00000100 bfd2b6fc c0162b12 00000000 00000000 00000000
> > >        00000000 00000000 45eb5857 1f6efe56 c2235fc0 00000000 f4039f44 c011c434
> > > Call Trace:
> > >  [<c0162b12>] generic_readlink+0x27/0x6e
> > >  [<c011c434>] timespec_trunc+0x18/0x5d
> > >  [<c011ca11>] current_fs_time+0x41/0x50
> > >  [<c015f43a>] sys_readlinkat+0x61/0x7a
> > >  [<c015f47a>] sys_readlink+0x27/0x2b
> > >  [<c01027ee>] sysenter_past_esp+0x5f/0x85
> > >  [<c02f0000>] __down_interruptible+0xa2/0x10e
> > >  =======================
> > > Code: 24 18 b8 00 b2 39 c0 e8 6e ba 15 00 8b 44 24 18 85 c0 0f 84 42 01 00 00 b8 cc ee 37 c0 e8 dd 73 f9 ff 8b 44 24 10 31 ed 83 c5 01 <8b> 40 24 85 c0 75 f6 8b 44 24 18 89 04 24 bb 01 00 00 00 31 f6 
> > > EIP: [<c0194b0c>] sysfs_follow_link+0xe6/0x254 SS:ESP 0068:f4039ea4
> > > BUG: at lib/kref.c:32 kref_get()
> > >  [<c01ec858>] kref_get+0x3d/0x3f
> > >  [<c01ebcd6>] kobject_get+0xf/0x13
> > >  [<c0194c00>] sysfs_follow_link+0x1da/0x254
> > >  [<c0162b12>] generic_readlink+0x27/0x6e
> > >  [<c011c434>] timespec_trunc+0x18/0x5d
> > >  [<c011ca11>] current_fs_time+0x41/0x50
> > >  [<c015f43a>] sys_readlinkat+0x61/0x7a
> > >  [<c015f47a>] sys_readlink+0x27/0x2b
> > >  [<c01027ee>] sysenter_past_esp+0x5f/0x85
> > >  [<c02f0000>] __down_interruptible+0xa2/0x10e
> > >  =======================
> > > 
> > > - As adapters do not get a driver (or what ?), each time you start X, three
> > >   new folders are created in /sys/class/i2c-adapter/

It is true that i2c adapters no longer have a driver, but my
understanding is that this is expected for ex-class devices. Greg, can
you please confirm this?

> > >   For some AGP black magic, the driver is loaded/registered/whatever 2 times
> > >   on each X start.
> > > 
> > > So, after each X start, you get SIX broken dirs in /sys that hang and oops
> > > every app that tries to list i2c devices (like Gnome Sensors Applet, so your
> > > Gnome login hangs forever....). Just ls /sys/class/i2c-adapter/i2c-*/.
> > > It also oopses when removing i2c modules.
> > > 
> > > No driver should be able to do that to Linux, even if I try lo load a jpeg
> > > of my children renamed to .ko....
> > 
> > I agree.  It's a shame that it takes the nvidia driver to trigger it, but
> > if a driver which was previously working now explodes so horridly it
> > perhaps does indicate that we broke something in there.  Or at least, we
> > became a heck of a lot less forgiving, and we chose to report driver bugs
> > in a rather user-unfriendly fashion.
> 
> I think this is due to the recent changes by Jean and David that
> reworked the driver model for i2c.  By doing so, they fixed all of the
> in-kernel drivers.

Actually, no, we didn't yet. This is the reason why not all the i2c-core
cleanups have been done yet. We really need to fix all the remaining
(15) i2c bus drivers first, and it'll take some time and help from the
driver authors.

> It's a bit harder for them to fix up all external drivers as well, but
> it looks like nvidia just has to do that and it should work just fine.

Not harder, no. Impossible.

> Although I do agree that the error checking in the i2c core probably
> needs to be fixed up so that we don't end up with empty directories like
> this that cause problems later.  Jean, any ideas?

No immediate idea, but I can reproduce the oops so I'll investigate.

> > I guess we need to wait and see if someone hits the same problems
> > with an in-kernel driver.

I just did, with i2c-nforce2. The key to trigger it seems to be to load
an i2c bus driver _after_ loading i2c-isa and a suitable i2c-isa-based
hardware monitoring driver (w83791d, w83627hf, w83627ehf, it87, lm78,
pc87360, sis5595, smsc47m1, smsc47b397, via686a or vt8231.) I have no
idea why, though. Given that I was able to trigger the problem with
only my own patches on top of Linus' tree, it means that the bug was
clearly introduced by one of my patches. I'll bisect my stack now to
find out which one. There aren't that many patches so it should be
relatively quick.

-- 
Jean Delvare
