Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZHNRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZHNRDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZHNRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:03:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49751 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZHNRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:03:18 -0400
Date: Fri, 14 Aug 2009 19:02:28 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Tim Bird <tim.bird@am.sony.com>,
       kernel@pengutronix.de
Subject: New fast(?)-boot results on ARM
Message-ID: <20090814170228.GM13320@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 18:42:59 up 9 days,  4:02, 37 users,  load average: 0.08, 0.06,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 13, 2009 at 05:33:26PM +0200, Robert Schwebel wrote:
> On Thu, Aug 13, 2009 at 08:28:26AM -0700, Arjan van de Ven wrote:
> > > That's bad :-) So there is no room for improvement any more in our
> > > ARM boot sequences ...
> >
> > on x86 we're doing pretty well ;-)
>
> On i.MX27 (400 MHz ARM926EJ-S) we currently need 7 s, measured from
> power-on through the kernel up to "starting init". This is with
>
> - no delay in u-boot-v2
> - rootfs on NAND (UBIFS)
> - quiet
> - precalculated loops-per-jiffy
> - zImage kernel instead of uImage

Here's a little video of our demo system booting:
http://www.youtube.com/watch?v=xDbUnNsj0cI

As you can see there, it needs about 15 s from the release of the reset button
up to the moment where the application shows it's Qt 4.5.2 based GUI (which is
when we fade over from the initial framebuffer to the final one, in order to
hide the qt application startup noise).

And below is the boot log (after turning "quiet" off again). The numbers are
the timestamp and the delta to the last timestamp, measured on the controlling
PC by looking at the serial console output. The ptx_ts script starts when the
regexp was found, so the numbers start basically in the moment when u-boot-v2
has initialized the system up to the point where we can see something.

Result:

- 2.4 s up from u-boot to the end of "Uncompressing Linux"
- 300 ms until ubifs initialization starts
- 3.7 s for ubifs, until "mounted root"

So we basically have 7 s for the kernel. The rest is userspace, which hasn't
seen much optimization yet, other than trying to start the GUI application as
early as possible, while doing all other init stuff in parallel. Adding "quiet"
brings us another 300 ms.

That's factor 70 away from the 110 ms boot time Tim has talked about some days
ago (and he measured on an ARM cpu which had almost half the speed of this
one), and I'm wondering what we can do to improve the boot time.

Robert

rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
[  2.395740] <  2.395740>
[  2.395860] <  0.000120>
[  0.000011] <  0.000011> U-Boot 2.0.0-rc9 (Aug  5 2009 - 10:05:58)
[  0.000059] <  0.000048>
[  0.003823] <  0.003764> Board: Phytec phyCORE-i.MX27
[  0.010753] <  0.006930> cfi_probe: cfi_flash base: 0xc0000000 size: 0x02000000
[  0.018711] <  0.007958> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
[  0.026592] <  0.007881> imxfb@imxfb0: i.MX Framebuffer driver
[  0.178655] <  0.152063> dev_protect: currently broken
[  0.178736] <  0.000081> Using environment in NOR Flash
[  0.182577] <  0.003841> initialising PLLs
[  0.367142] <  0.184565> Malloc space: 0xa3f00000 -> 0xa7f00000 (size 64 MB)
[  0.370568] <  0.003426> Stack space : 0xa3ef8000 -> 0xa3f00000 (size 32 kB)
[  0.445993] <  0.075425> running /env/bin/init...
[  0.870592] <  0.424599>
[  0.874559] <  0.003967> Hit any key to stop autoboot:  0
[  1.326621] <  0.452062> loaded zImage from /dev/nand0.kernel.bb with size 1679656
[  2.009996] <  0.683375> Uncompressing Linux............................................................................................................... done, booting the kernel.
[  2.416999] <  0.407003> Linux version 2.6.31-rc4-g056f82f-dirty (sha@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #1 PREEMPT Thu Aug 6 08:37:19 CEST 2009
[  2.418729] <  0.001730> CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
[  2.423081] <  0.004352> CPU: VIVT data cache, VIVT instruction cache
[  2.426592] <  0.003511> Machine: phyCORE-i.MX27
[  2.430609] <  0.004017> Memory policy: ECC disabled, Data cache writeback
[  2.439704] <  0.009095> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[  2.463977] <  0.024273> Kernel command line: console=ttymxc0,115200 mt9v022.sensor_type=color ip=192.168.23.197:192.168.23.2:192.168.23.2:255.255.0.0::: ubi.mtd=7 root=ubi0:root rootfstype=ubifs mtdparts="physmap-flash.0:256k(uboot)ro,128k(ubootenv),3M(kernel),-(root);mxc_nand:256k(uboot)ro,128k(ubootenv),3M(kernel),-(root)"
[  2.467580] <  0.003603> Unknown boot option `mt9v022.sensor_type=color': ignoring
[  2.471632] <  0.004052> PID hash table entries: 512 (order: 9, 2048 bytes)
[  2.479971] <  0.008339> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[  2.485485] <  0.005514> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[  2.485560] <  0.000075> Memory: 128MB = 128MB total
[  2.490595] <  0.005035> Memory: 126108KB available (3104K code, 350K data, 100K init, 0K highmem)
[  2.494609] <  0.004014> NR_IRQS:272
[  2.494654] <  0.000045> MXC GPIO hardware
[  2.498595] <  0.003941> MXC IRQ initialized
[  2.502600] <  0.004005> Console: colour dummy device 80x30
[  2.506591] <  0.003991> Calibrating delay loop... 199.06 BogoMIPS (lpj=995328)
[  2.506641] <  0.000050> Mount-cache hash table entries: 512
[  2.510651] <  0.004010> CPU: Testing write buffer coherency: ok
[  2.514594] <  0.003943> NET: Registered protocol family 16
[  2.518678] <  0.004084> bio: create slab <bio-0> at 0
[  2.522584] <  0.003906> NET: Registered protocol family 2
[  2.526639] <  0.004055> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[  2.530592] <  0.003953> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[  2.539728] <  0.009136> TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[  2.542647] <  0.002919> TCP: Hash tables configured (established 4096 bind 4096)
[  2.542696] <  0.000049> TCP reno registered
[  2.546573] <  0.003877> NET: Registered protocol family 1
[  2.555898] <  0.009325> NetWinder Floating Point Emulator V0.97 (extended precision)
[  2.555969] <  0.000071> msgmni has been set to 246
[  2.560063] <  0.004094> io scheduler noop registered (default)
[  2.560109] <  0.000046> i.MX Framebuffer driver
[  2.564237] <  0.004128> Serial: IMX driver
[  2.567840] <  0.003603> Platform driver 'imx-uart' needs updating - please use dev_pm_ops
[  2.571898] <  0.004058> imx-uart.0: ttymxc0 at MMIO 0x1000a000 (irq = 20) is a IMX
[  2.576220] <  0.004322> console [ttymxc0] enabled
[  2.583937] <  0.007717> imx-uart.1: ttymxc1 at MMIO 0x1000b000 (irq = 19) is a IMX
[  2.590616] <  0.006679> imx-uart.2: ttymxc2 at MMIO 0x1000c000 (irq = 18) is a IMX
[  2.590734] <  0.000118> FEC Ethernet Driver
[  2.599694] <  0.008960> Platform driver 'fec' needs updating - please use dev_pm_ops
[  2.599745] <  0.000051> fec: PHY @ 0x0, ID 0x00221613 -- KS8721BL
[  2.612095] <  0.012350> physmap platform flash device: 02000000 at c0000000
[  2.615634] <  0.003539> physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
[  2.620073] <  0.004439>  Intel/Sharp Extended Query Table at 0x010A
[  2.624187] <  0.004114>  Intel/Sharp Extended Query Table at 0x010A
[  2.627835] <  0.003648>  Intel/Sharp Extended Query Table at 0x010A
[  2.631976] <  0.004141>  Intel/Sharp Extended Query Table at 0x010A
[  2.636182] <  0.004206>  Intel/Sharp Extended Query Table at 0x010A
[  2.640245] <  0.004063> Using buffer write method
[  2.642569] <  0.002324> Using auto-unlock on power-up/resume
[  2.646576] <  0.004007> cfi_cmdset_0001: Erase suspend on write enabled
[  2.650581] <  0.004005> 4 cmdlinepart partitions found on MTD device physmap-flash.0
[  2.654627] <  0.004046> Creating 4 MTD partitions on "physmap-flash.0":
[  2.658594] <  0.003967> 0x000000000000-0x000000040000 : "uboot"
[  2.666646] <  0.008052> 0x000000040000-0x000000060000 : "ubootenv"
[  2.674574] <  0.007928> 0x000000060000-0x000000360000 : "kernel"
[  2.678570] <  0.003996> 0x000000360000-0x000002000000 : "root"
[  2.690623] <  0.012053> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
[  2.694572] <  0.003949> RedBoot partition parsing not available
[  2.698575] <  0.004003> 4 cmdlinepart partitions found on MTD device mxc_nand
[  2.706596] <  0.008021> Creating 4 MTD partitions on "mxc_nand":
[  2.706645] <  0.000049> 0x000000000000-0x000000040000 : "uboot"
[  2.717895] <  0.011250> 0x000000040000-0x000000060000 : "ubootenv"
[  2.726578] <  0.008683> 0x000000060000-0x000000360000 : "kernel"
[  2.742628] <  0.016050> 0x000000360000-0x000004000000 : "root"
[  3.058610] <  0.315982> UBI: attaching mtd7 to ubi0
[  3.062878] <  0.004268> UBI: physical eraseblock size:   16384 bytes (16 KiB)
[  3.070601] <  0.007723> UBI: logical eraseblock size:    15360 bytes
[  3.070665] <  0.000064> UBI: smallest flash I/O unit:    512
[  3.078564] <  0.007899> UBI: VID header offset:          512 (aligned 512)
[  3.078609] <  0.000045> UBI: data offset:                1024
[  5.006609] <  1.928000> UBI: attached mtd7 to ubi0
[  5.013157] <  0.006548> UBI: MTD device name:            "root"
[  5.014566] <  0.001409> UBI: MTD device size:            60 MiB
[  5.018660] <  0.004094> UBI: number of good PEBs:        3880
[  5.022585] <  0.003925> UBI: number of bad PEBs:         0
[  5.026797] <  0.004212> UBI: max. allowed volumes:       89
[  5.026849] <  0.000052> UBI: wear-leveling threshold:    4096
[  5.030779] <  0.003930> UBI: number of internal volumes: 1
[  5.034583] <  0.003804> UBI: number of user volumes:     1
[  5.046572] <  0.011989> UBI: available PEBs:             0
[  5.046622] <  0.000050> UBI: total number of reserved PEBs: 3880
[  5.046657] <  0.000035> UBI: number of PEBs reserved for bad PEB handling: 38
[  5.050606] <  0.003949> UBI: max/mean erase counter: 2/0
[  5.050668] <  0.000062> UBI: image sequence number: 0
[  5.058619] <  0.007951> UBI: background thread "ubi_bgt0d" started, PID 215
[  5.062620] <  0.004001> oprofile: using timer interrupt.
[  5.070584] <  0.007964> TCP cubic registered
[  5.070637] <  0.000053> NET: Registered protocol family 17
[  5.074624] <  0.003987> RPC: Registered udp transport module.
[  5.082616] <  0.007992> RPC: Registered tcp transport module.
[  5.605159] <  0.522543> eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
[  6.602621] <  0.997462> IP-Config: Complete:
[  6.606638] <  0.004017>      device=eth0, addr=192.168.23.197, mask=255.255.0.0, gw=192.168.23.2,
[  6.614588] <  0.007950>      host=192.168.23.197, domain=, nis-domain=(none),
[  6.618652] <  0.004064>      bootserver=192.168.23.2, rootserver=192.168.23.2, rootpath=
[  6.630579] <  0.011927> UBIFS: recovery needed
[  6.662655] <  0.032076> UBIFS: recovery completed
[  6.666587] <  0.003932> UBIFS: mounted UBI device 0, volume 1, name "root"
[  6.670570] <  0.003983> UBIFS: file system size:   58490880 bytes (57120 KiB, 55 MiB, 3808 LEBs)
[  6.678572] <  0.008002> UBIFS: journal size:       7741440 bytes (7560 KiB, 7 MiB, 504 LEBs)
[  6.682573] <  0.004001> UBIFS: media format:       w4/r0 (latest is w4/r0)
[  6.686572] <  0.003999> UBIFS: default compressor: lzo
[  6.690562] <  0.003990> UBIFS: reserved for root:  0 bytes (0 KiB)
[  6.694599] <  0.004037> VFS: Mounted root (ubifs filesystem) on device 0:12.
[  6.702568] <  0.007969> Freeing init memory: 100K
init started: BusyBox v1.13.4 (2009-08-06 08:30:14 CEST)
[  7.050625] <  0.187504> mounting filesystems...done.
[  7.078608] <  0.027983> running rc.d services...
[  7.137924] <  0.059316> starting udev
[  7.147925] <  0.010001> mounting tmpfs at /dev
[  7.182299] <  0.034374> creating static nodes
[  7.410613] <  0.228314> starting udevd...done
[  8.811097] <  1.400484> waiting for devices...done
[  8.918710] <  0.107613> syslogd starting
[  9.050585] <  0.131875> tweaking ondemand scaling governor
[ 10.010600] <  0.960015> Starting system message bus: dbus.
[ 10.118607] <  0.108007> /etc/rc.d/S16openssh: .: line 11: can't open /lib/init/initmethod-bbinit-functions.sh
[ 10.122561] <  0.003954> run-parts: /etc/rc.d/S16openssh exited with code 2
[ 10.246641] <  0.124080> Starting telnetd...
[ 10.442761] <  0.196120> sound not supported, skipping mixer state
[ 10.756354] <  0.313593> sound:  restoring
[ 10.940567] <  0.184213> alsactl: load_state:1608: No soundcards found...
[ 11.046578] <  0.106011> starting network interfaces...
[ 11.370586] <  0.324008> ALSA lib confmisc.c:768:(parse_card) cannot find card '0'
[ 11.377491] <  0.006905> ALSA lib conf.c:3513:(_snd_config_evaluate) function snd_func_card_driver returned error: No such file or directory
[ 11.384742] <  0.007251> ALSA lib confmisc.c:392:(snd_func_concat) error evaluating strings
[ 11.392825] <  0.008083> ALSA lib conf.c:3513:(_snd_config_evaluate) function snd_func_concat returned error: No such file or directory
[ 11.398567] <  0.005742> ALSA lib confmisc.c:1251:(snd_func_refer) error evaluating name
[ 11.410599] <  0.012032> ALSA lib conf.c:3513:(_snd_config_evaluate) function snd_func_refer returned error: No such file or directory
[ 11.418625] <  0.008026> ALSA lib conf.c:3985:(snd_config_expand) Evaluate error: No such file or directory
[ 11.422605] <  0.003980> ALSA lib pcm.c:2202:(snd_pcm_open_noupdate) Unknown PCM default
[ 11.428764] <  0.006159> aplay: main:590: audio open error: No such file or directory
[ 11.490669] <  0.061905> ip: RTNETLINK answers: File exists
[ 12.150608] <  0.659939> ip: cannot find device "can0"
[ 12.213228] <  0.062620> ip: SIOCGIFFLAGS: No such device
[ 12.314609] <  0.101381> lighttpd: starting
[ 12.767898] <  0.453289> lighttpd: done
[ 12.846591] <  0.078693> pure-ftpd: no /etc/pure-ftpd.defaults found.
[ 12.914630] <  0.068039> /usr/sbin/pure-ftpd
[ 13.035649] <  0.121019> pure-ftpd: starting pure-ftpd: /usr/sbin/pure-ftpd
[ 13.082624] <  0.046975> pure-ftpd: no upload script defined, skipping
[ 13.090595] <  0.007971> done
[ 13.242901] <  0.152306> loading modules
[ 13.291592] <  0.048691>     mx27_camera
[ 13.334611] <  0.043019> FATAL: Module mx27_camera not found.
[ 13.354552] <  0.019941>     pca953x
[ 13.414614] <  0.060062> FATAL: Module pca953x not found.
[ 13.434597] <  0.019983>     plat-ram
[ 13.479436] <  0.044839> FATAL: Module plat_ram not found.
[ 13.522625] <  0.043189>
[ 13.546627] <  0.024002> OSELAS(R)-phyCORE-trunk (PTXdist-1.99.svn/2009-08-06T08:37:25+0200)
[ 13.558613] <  0.011986>
[ 13.690643] <  0.132030>        _            ____ ___  ____  _____
[ 13.690731] <  0.000088>  _ __ | |__  _   _ / ___/ _ \|  _ \| ____|
[ 13.698595] <  0.007864> | '_ \| '_ \| | | | |  | | | | |_) |  _|
[ 13.698654] <  0.000059> | |_) | | | | |_| | |__| |_| |  _ <| |___
[ 13.702581] <  0.003927> | .__/|_| |_|\__, |\____\___/|_| \_\_____|
[ 13.706573] <  0.003992> |_|          |___/
[ 13.706622] <  0.000049>
[ 13.725043] <  0.018421>
[ 14.742608] <  1.017565>

Robert
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
