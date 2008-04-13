Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYDMXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYDMXCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYDMXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:02:28 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:51524 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYDMXC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:02:26 -0400
Date: Sun, 13 Apr 2008 17:56:32 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/35] W1: w1 core deadlock and oops fixes, ds2490 updates
Message-ID: <20080413225632.GA14058@spacedout.fries.net>
References: <20080328122311.GA3613@spacedout.fries.net> <20080330112716.GB15122@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20080330112716.GB15122@2ka.mipt.ru>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 17:56:56 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Andrew Morton, I quoted you near the end.

On Sun, Mar 30, 2008 at 03:27:16PM +0400, Evgeniy Polyakov wrote:
> Hi David.
>=20
> On Fri, Mar 28, 2008 at 07:23:11AM -0500, David Fries (david@fries.net) w=
rote:
> > The Linux one wire system allows talking to little devices, mostly
> > sensors.  Sensors such as temperature sensors that I want to put
> > around the house, but first the one wire system and ds2490 USB to one
> > wire controller driver needs to be stable.  After a kernel panic, I
> > did most all of the development inside of qemu.  I had an issue with
> > bulk transfers failing unless I told qemu to disconnect and reconnect
> > the USB device every time I reloaded, the module, but it worked really
> > nicely.  What follows is a long list of fixes and enhancements.  I
> > would like some tester feedback.  I only have the ds2490 USB to one
> > wire controller and ds18b20 thermometer.
>=20
> Well, in our private converstion you never showed kernel panic dump or
> at least talks about where it was located, but nevertheless I'm overall
> ok with your changes. I ack all ds2490 changes and generally do not
> object against others, although description of them some times are
> really wrong, like what you call a deadlock was intended - driver
> specially can not be unloaded while there are users of given bus.

I dug out a panic before I started modifying the driver, see the end
of the message.  There is still a remaining oops.  Register the same
sensor with two masters.  The serial id of the sensor is assumed to be
unique and the sysfs code will cause an oops when the second sensor is
registered.  If you have two master devices that are both doing bus
searching, let one detect the sensor, the move it to the other master.
The second master will detect the device before the first one times it
out.  None of my patches address this.

Could you be more specific on "really wrong, like what you call a
deadlock was intended"?  I only use 'intended' once, and that is is
patch 1 in "The slave reconnect was incorrectly coded."  That
paragraph is describing a infinite loop inserting a slave driver, not
unloading a device driver.

If something is really wrong with the descriptions I'll fix it.

> There is another problem with your submission - please split it into 3-5
> patches which are logically compound, so that there would not be things
> like: patch1: replace A with B, patch2: remove B and the like.

You must be talking about patch 14 and patch 15 w1_slave_read_id sort
read bug.  That's the only place it does that.

I debated on how to submit
patch 14 "w1_slave_read_id multiple short read bug"
and
patch 15 "w1_slave_read_id from bin_attribute to device_attribute"
and I did it that way to first show what he bug was and fix it, then
show how simple the code was using a different method.  I'll submit it
in one patch.

> You also have lots of codying style issues in the patchset.
Such as?

> > This set of patches fixes bugs in the one wire driver and the ds2490
> > one wire USB controller.  Some of the bugs will deadlock the one wire
> > system and print out a message every second reminding you of this.
> > Others will panic the system.  One will spam with printk in an
> > infinite loop.  The w1_therm slave device driver would overflow the
> > userspace buffer, and didn't even work properly with `cat`.
>=20
> The latter is wrong, and you never showed signs of previous errors,

This was the overview e-mail, and it was long enough without going
into details on each of the issues.  But here they are.

"will deadlock the one wire system and print out a message every second
reminding you of this."

This example requires a temperature sensor that uses w1_therm (it
isn't specific to w1_therm though).

insmod wire.ko
insmod slaves/w1_therm.ko
insmod masters/ds2490.ko
(wait for devices to be detected)
rmmod slaves/w1_therm

Waiting for family 40 to become free: refcnt=3D1.
Waiting for family 40 to become free: refcnt=3D1.
Waiting for family 40 to become free: refcnt=3D1.
=2E..

40 =3D 0x28
#define W1_THERM_DS18B20        0x28
It is w1_therm that is trying to be removed, but it can't because the
slave is using w1_therm.  The error is nothing told the slave to stop
using w1_therm, so unless you do something it never breaks out of the
loop.  In this case,
rmmod ds2490
will allow you to break out of it, but it is in a deadlock until then.

[PATCH 1/35] W1: fix deadlocks and remove w1_control_thread
w1.c 1.2
w1_family.c 1.3
Fixed the infinite loop that happens if a slave device module is
removed from the kernel and there is a slave using that driver family.
That involves unattaching all slaves that are using that family after
the family has been removed from the list of available family drivers.
This is not a race condition, it will happen everytime.



"One will spam with printk in an infinite loop."

This requires two devices that aren't used by w1_smem, the slave
module doesn't matter, it just requires two devices that will not be
claimed by the driver loaded.

insmod wire.ko
insmod masters/ds2490.ko
(wait for devices to be detected)
insmod slaves/w1_smem.ko

w1_slave_release: Releasing 21-34c0000039c5.
w1_master_driver w1_bus_master1: Family 21 for 21.34c0000039c5.ba is not re=
gistered.
w1_slave_release: Releasing 23-00000002937d.
w1_master_driver w1_bus_master1: Family 23 for 23.00000002937d.84 is not re=
gistered.
w1_slave_release: Releasing 28-0000000e84a2.
w1_master_driver w1_bus_master1: Family 28 for 28.0000000e84a2.ed is not re=
gistered.
w1_slave_release: Releasing 21-34c0000039c5.
w1_master_driver w1_bus_master1: Family 21 for 21.34c0000039c5.ba is not re=
gistered.
w1_slave_release: Releasing 23-00000002937d.
w1_master_driver w1_bus_master1: Family 23 for 23.00000002937d.84 is not re=
gistered.
w1_slave_release: Releasing 28-0000000e84a2.
w1_master_driver w1_bus_master1: Family 28 for 28.0000000e84a2.ed is not re=
gistered.

21, 23, 28, LOOP

And yes, I had to hang the machine to collect this output.

[PATCH 1/35] W1: fix deadlocks and remove w1_control_thread
w1.c 1.3
w1.h 1.6
The slave reconnect was incorrectly coded.  When a new slave device
driver (and family code) was available it was intended to give slaves
using the default device a chance to use the specific slave device
driver.  It was using the list_for_each_entry_safe and took the brute
force method of any device using the default device was detached and
reconnected.  If there was a slave device driver that matched the
family code it would be added back to the list with that driver,
otherwise it would be added back with the default driver.  It only
takes two devices that don't match the current set of family codes to
be added to the end of the list to get into an infinite loop of
detach, add to the end of the list, get next entry.

(copy)
> The latter is wrong, and you never showed signs of previous errors,
Which latter are you referring to?

"The w1_therm slave device driver would overflow the userspace buffer"

Strace make it obvious, request one byte, '..., 1)', get 72, that's a
buffer overflow.

cait:/sys/devices/w1_bus_master1/28-0000000e84a2$ strace -e read,open dd if=
=3Dw1_slave bs=3D1 count=3D1
open("w1_slave", O_RDONLY)              =3D 0
read(0, "00 01 4b 46 7f ff 10 10 54 : crc"..., 1) =3D 72
00 01 4b 46 7f ff 10 10 54 : crc=3D54 YES
00 01 4b 46 7f ff 10 10 54 t=3D16
1+0 records in
0+1 records out
72 bytes (72 B) copied, 32.8605 seconds, 0.0 kB/s
Process 2204 detached

[PATCH 16/35] [W1] w1_therm fix user buffer overflow and cat
slaves/w1_therm.c 1.8
buffer overflow:
	Execute a short read on w1_slave and w1_therm_read_bin would still
	return the full string size worth of data clobbering the user space
	buffer when it returned.  Switching to device_attribute avoids the
	buffer overflow problems.  With the snprintf formatted output dealing
	with short reads without doing a conversion per read would have
	been difficult.

'and didn't even work properly with `cat`."

cait:/sys/devices/w1_bus_master1/28-0000000e84a2$ cat w1_slave
05 01 4b 46 7f ff 0b 10 cd : crc=3Dcd YES
05 01 4b 46 7f ff 0b 10 cd t=3D16
05 01 4b 46 7f ff 0b 10 cd : crc=3Dcd YES
05 01 4b 46 7f ff 0b 10 cd t=3D16

That's two reads, two temperature conversions when there should have
only been one.

cait:/sys/devices/w1_bus_master1/28-0000000e84a2$ strace -e read,open
cat w1_slave=20
read(3, "ff 00 4b 46 7f ff 01 10 9c : crc"..., 4096) =3D 72
read(3, "ff 00 4b 46 7f ff 01 10 9c : crc"..., 4096) =3D 72
read(3, "", 4096)                       =3D 0

[PATCH 16/35] [W1] w1_therm fix user buffer overflow and cat
slaves/w1_therm.c 1.8
bad behavior:
	`cat w1_slave` would cause two temperature conversions to take place.
	Previously the code assumed W1_SLAVE_DATA_SIZE would be returned with
	each read.  It would not return 0 unless the offset was less
	than W1_SLAVE_DATA_SIZE.  The result was the first read did a
	temperature conversion, filled the buffer and returned, the
	offset in the second read would be less than
	W1_SLAVE_DATA_SIZE and also fill the buffer and return, the
	third read would finnally have a big enough offset to return 0
	and cause cat to stop.  Now w1_therm_read will be called at
	most once per open.


Interesting, now that I have more sensors connected to the network and
I loaded the old in tree w1 driver (for the above tests), I see it
fails to detect one sensor.  The old driver consistently gets 4, while
with my changes it is consistently getting 5 and there should be 5
devices out there.  I must have fixed some bug without knowning it.

2.6.24 w1 system
28-0000000e84a2
81-00000020bbd0
21-34c0000039c5
23-00000002937d

submitted patch,
21-34c0000039c5
23-00000002937d
28-0000000e84a2
28-0000000e9812
81-00000020bbd0

> but looking at the end results I agree that it is better solution
> (especially eliminating of the additional thread and related changes).

Thanks, it pleased me greatly to remove the w1_thread that only polled
when it wasn't required.

> > In the name of being nice to the rest of the system, I've eliminated a
> > thread that was waking up and polling every second, for pretty much
> > only startup and shutdown events.  The other thread, w1_process, will
> > now block when there isn't anything to do, and if sleeping it will be
> > immediately woken for a new search or for preparing to exit.
> >=20
> > ds2490 USB to one wire master driver has been improved.  The original
> > code was observed to take 3.91 seconds for a temperature conversion
> > and reading with 0.002s user and 3.001s system times.  The system was
> > very unresponsive, mostly due to some mdelay(750) calls.  Now it is
> > taking 0.860s elapsed with 0.004s user and 0.004s system time.  That
> > is pretty good considering that the temperature conversion takes 750ms
> > (rounded up to 752ms).  Some of the 108ms overload could be reduced by
> > a shorter reset period, overdrive data transfer speed, and combining
> > USB operations.  The driver now supports the strong pullup, which is
> > useful for parasite powered devices.
>=20
> Yeah, mdelay was not a good solution.

How's the status of your one wire network?  What kind of sensors do
you have available?

> > I was keeping track of my changes in cvs.  I've included the file, cvs
> > version number and log for that commit that make up the given patch.
> > The cvs number is just to help me keep everything organized to make
> > the patches.  The patches are against 2.6.25-rc4.
>=20
> Please reorganize your patches into something like this:
> 1. threads changes
> 2. master device removal changes (remove slaves which are on the bus
> master being removed) and related things
> 3. ds2490 changes
> 4. cleanups
>=20
> or something like that, reviewing 35 small patches which are removing
> things past another is not a really good time...

You want me to take 35 patches and merge them down to 4?  There were a
lot of issues in here, and I don't have an automagic patch reorder
tool.  If you want to review fewer patches apply 1-6, do a diff and
look at that.

Documentation/SubmittingPatches '3) Separate your changes.' It goes on
to specifically separate out bug fixes and performance enhancements.

You requested in another e-mail to merge patch 1-6.  The deadlocks in
1 is clearly a bug.  6 block (instead of sleeping with a timeout) is a
performance enhancement.  5 might be a deadlock, but it's not at all
related to 1.  2 and 3 have nothing to do with any of the above.
Logically this come out to be a bunch of patches.

On Mon, Jan 21, 2008 at 06:56:35PM -0800, Andrew Morton wrote:
> On Mon, 21 Jan 2008 20:47:19 -0600 David Fries <david@fries.net> wrote:
> > Thanks.  Question, at what point should I just submit these one liner,
> > but independent bugs in one patch?
>=20
> You shouldn't, unless they are dependent in both directions.

If Andrew Morton is going to say no for independent one line bugs, I'm
going to say No (for a bunch of complicated sometimes overlapping
bugs, features, and performance enhancements) as well.  Besides I have
something like 27KB in 664 lines of descriptions, if I tried to merge
the changes down there's no way I could figure out which patch lines
went with what descriptions, and no one else could either.

> Thank you. I will comment on separate patches.
>=20
> --=20
> 	Evgeniy Polyakov

--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)


ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:02.2[D] -> Link [LNKD] -> GSI 11 (level, low) -=
> IRQ 11
ohci_hcd 0000:00:02.2: OHCI Host Controller
ohci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.2: irq 11, io mem 0xdfffe000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:02.3[D] -> Link [LNKD] -> GSI 11 (level, low) -=
> IRQ 11
ohci_hcd 0000:00:02.3: OHCI Host Controller
ohci_hcd 0000:00:02.3: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.3: irq 11, io mem 0xdffff000
usb usb2: configuration #1 chosen from 1 choice
usb 1-2: new low speed USB device using ohci_hcd and address 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb 1-2: configuration #1 chosen from 1 choice
hiddev96: USB HID v1.00 Device [American Power Conversion BackUPS Pro 500 F=
W:16.3.D USB FW:4] on usb-0000:00:02.2-2
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt=
 0 proto 2 vid 0x04A9 pid 0x1056
usb 2-1: USB disconnect, address 2
drivers/usb/class/usblp.c: usblp0: removed
usb 2-1: new full speed USB device using ohci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt=
 0 proto 2 vid 0x04A9 pid 0x1056
usb 2-1: USB disconnect, address 3
drivers/usb/class/usblp.c: usblp0: removed
usb 2-1: new full speed USB device using ohci_hcd and address 4
usb 2-1: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 4 if 0 alt=
 0 proto 2 vid 0x04A9 pid 0x1056
usb 2-3: new full speed USB device using ohci_hcd and address 5
usb 2-3: configuration #1 chosen from 1 choice
Driver for 1-wire Dallas network protocol.
usbcore: registered new interface driver DS9490R
w1_master_driver w1_bus_master1: Family 81 for 81.00000020bbd0.21 is not re=
gistered.
w1_slave_release: Releasing 81-00000020bbd0.
w1_master_driver w1_bus_master1: Family 81 for 81.00000020bbd0.21 is not re=
gistered.
w1_slave_release: Releasing 81-00000020bbd0.
0x81: count=3D16, status: 00 00 2f 40 05 04 04 00 20 29 00 00 00 01 00 00=
=20
                                  enable flag:        0
                                 1-wire speed:        0
                       strong pullup duration:       2f
                   programming pulse duration:       40
                   pulldown slew rate control:        5
                             write-1 low time:        4
     data sample offset/write-0 recovery time:        4
                     reserved (test register):        0
                          device status flags:       20
                 communication command byte 1:       29
                 communication command byte 2:        0
          communication command buffer status:        0
             1-wire data output buffer status:        0
              1-wire data input buffer status:        1
                                     reserved:        0
                                     reserved:        0
Clearing ep0x83.
0x81: count=3D16, status: 00 00 2f 40 05 04 04 00 20 29 00 00 00 00 00 00=
=20
                                  enable flag:        0
                                 1-wire speed:        0
                       strong pullup duration:       2f
                   programming pulse duration:       40
                   pulldown slew rate control:        5
                             write-1 low time:        4
     data sample offset/write-0 recovery time:        4
                     reserved (test register):        0
                          device status flags:       20
                 communication command byte 1:       29
                 communication command byte 2:        0
          communication command buffer status:        0
             1-wire data output buffer status:        0
              1-wire data input buffer status:        0
                                     reserved:        0
                                     reserved:        0
w1_master_driver w1_bus_master1: Family 21 for 21.34c0000039c5.ba is not re=
gistered.
Failed to read 1-wire data from 0x02: err=3D-110.
Failed to read 1-wire data from 0x02: err=3D-110.
usb 2-3: USB disconnect, address 5
w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free:=
 refcnt=3D1.
w1_slave_release: Releasing 81-00000020bbd0.
w1_slave_release: Releasing 21-34c0000039c5.
usb 2-3: new full speed USB device using ohci_hcd and address 6
usb 2-3: configuration #1 chosen from 1 choice
usb 2-3: USB disconnect, address 6
usb 2-3: new full speed USB device using ohci_hcd and address 7
usb 2-3: configuration #1 chosen from 1 choice
usb 2-3: USB disconnect, address 7
w1_slave_release: Releasing 28-0000000e84a2.
w1_slave_release: Releasing 81-00000020bbd0.
usb 2-3: new full speed USB device using ohci_hcd and address 8
usb 2-3: device descriptor read/64, error -62
hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
usb 2-3: new full speed USB device using ohci_hcd and address 12
usb 2-3: configuration #1 chosen from 1 choice
usb 2-3: USB disconnect, address 12
BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
00000c
 printing eip:
c02fa9a6
*pde =3D 00000000
Oops: 0000 [#1]
PREEMPT=20
Modules linked in: w1_smem w1_therm ds2490 wire cn ohci_hcd it87 hwmon_vid =
hwmon i2c_isa eeprom i2c_sis96x cx8800 cx88_dvb cx8802 cx88xx videodev tune=
r v4l1_compat v4l2_common nf_conntrack_ipv4 nfsd exportfs xt_state nf_connt=
rack nfnetlink ipt_REJECT iptable_filter ip_tables parport_pc parport flopp=
y snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_=
oss snd_pcm snd_timer snd soundcore snd_page_alloc xt_tcpudp xt_multiport x=
_tables compat_ioctl32 cx88_vp3054_i2c mt352 ir_common i2c_algo_bit tveepro=
m btcx_risc dvb_pll or51132 video_buf_dvb video_buf nxt200x firmware_class =
isl6421 zl10353 cx24123 lgdt330x dvb_core cx22702 i2c_core nfs lockd sunrpc=
 udf isofs nls_base usblp usbhid usbcore ff_memless sis900
CPU:    0
EIP:    0060:[<c02fa9a6>]    Not tainted VLI
EFLAGS: 00010282   (2.6.22 #10)
EIP is at klist_del+0x6/0x50
eax: 00000000   ebx: da0012a0   ecx: dba80000   edx: d8f05780
esi: da0012a0   edi: dba80ebc   ebp: 00000000   esp: dba80e4c
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process khubd (pid: 1079, ti=3Ddba80000 task=3Dc148ea50 task.ti=3Ddba80000)
Stack: da0012a0 e0bb6100 c02faaa8 da001274 c0218dd1 da001274 da001200 c0219=
1cd=20
       da001274 c02187eb da001274 c02171aa da001274 da001200 dba80ebc 00000=
000=20
       c0217228 ca46fcc0 e0bb323d c0110af8 00000000 00000000 df25e250 c02fa=
970=20
Call Trace:
 [<c02faaa8>] klist_remove+0x8/0x20
 [<c0218dd1>] __device_release_driver+0x31/0x90
 [<c02191cd>] device_release_driver+0x1d/0x40
 [<c02187eb>] bus_remove_device+0x5b/0x70
 [<c02171aa>] device_del+0x19a/0x210
 [<c0217228>] device_unregister+0x8/0x10
 [<e0bb323d>] __w1_remove_master_device+0x8d/0xa0 [wire]
 [<c0110af8>] complete+0x48/0x70
 [<c02fa970>] klist_release+0x0/0x30
 [<e0b7b051>] ds_disconnect+0x41/0x60 [ds2490]
 [<e0a4470a>] usb_unbind_interface+0x2a/0x60 [usbcore]
 [<c0218e0e>] __device_release_driver+0x6e/0x90
 [<c02191cd>] device_release_driver+0x1d/0x40
 [<c02187eb>] bus_remove_device+0x5b/0x70
 [<c02171aa>] device_del+0x19a/0x210
 [<e0a4238c>] usb_disable_device+0x5c/0xc0 [usbcore]
 [<e0a3ebe2>] usb_disconnect+0x82/0x100 [usbcore]
 [<e0a3f15d>] hub_thread+0x31d/0xa10 [usbcore]
 [<c010f82c>] __activate_task+0x1c/0x30
 [<c02fb59f>] schedule+0x48f/0x550
 [<c02fb638>] schedule+0x528/0x550
 [<c0123990>] autoremove_wake_function+0x0/0x40
 [<e0a3ee40>] hub_thread+0x0/0xa10 [usbcore]
 [<c01238b8>] kthread+0x38/0x60
 [<c0123880>] kthread+0x0/0x60
 [<c0104187>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 04 89 42 04 89 10 c7 43 f8 00 01 10 00 c7 41 04 00 02 20 00 8d 43 04 =
e8 19 61 e1 ff c7 43 f4 00 00 00 00 5b c3 56 53 89 c6 8b 00 <8b> 58 0c b8 0=
1 00 00 00 e8 5d 51 e1 ff 89 f0 e8 a6 ff ff ff 85=20
EIP: [<c02fa9a6>] klist_del+0x6/0x50 SS:ESP 0068:dba80e4c

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIAo+fAI852cse6PARArRAAJ9smdjRnFtH3okNPXu+eTFQvdp0zQCfTBIu
gp1t96YKQM+4Ja+zTboqMF0=
=vPLA
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
