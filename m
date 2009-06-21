Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZFUORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZFUORU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZFUORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 10:17:12 -0400
Received: from mx38.mail.ru ([94.100.176.52]:51035 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZFUORL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 10:17:11 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: hal@lists.freedesktop.org
Subject: Re: 2.6.30: hald crashes on resume from STR apparently on LED device
Date: Sun, 21 Jun 2009 18:17:23 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-2mnb; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
References: <200906142219.06891.arvidjaar@mail.ru>
In-Reply-To: <200906142219.06891.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1376712.0k0tYoQDbk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906211817.25878.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1376712.0k0tYoQDbk
Content-Type: multipart/mixed;
  boundary="Boundary-01=_zDkPKxfzc2cuu6o"
Content-Transfer-Encoding: 7bit


--Boundary-01=_zDkPKxfzc2cuu6o
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 14 of June 2009 22:19:02 Andrey Borzenkov wrote:
> I did not experience this crash under 2.6.29. I got it under 2.6.30
> (both rc and final) with varying frequency. At least for me it is
> 2.6.30 regression.
>
> hald aborts on D-Bus assertion with stack trace below.Program
> received signal SIGABRT, Aborted.
> 0x00007f183ff9e915 in raise (sig=3D<value optimized out>) at
> ../nptl/sysdeps/unix/sysv/linux/raise.c:64
> 64	  return INLINE_SYSCALL (tgkill, 3, pid, selftid, sig);
> (gdb) bt
> #0  0x00007f183ff9e915 in raise (sig=3D<value optimized out>) at
> ../nptl/sysdeps/unix/sysv/linux/raise.c:64
> #1  0x00007f183ff9ff8a in abort () at abort.c:88
> #2  0x00007f1840793f35 in _dbus_abort () at dbus-sysdeps.c:88
> #3  0x00007f184078fd6d in _dbus_warn_check_failed (
>     format=3D0x7f184079c5a0 "arguments to %s() were incorrect,
> assertion \"%s\" failed in file %s line %d.\nThis is normally a bug
> in some application using the D-Bus library.\n") at
> dbus-internals.c:283 #4  0x00007f18407873f9 in
> dbus_pending_call_set_notify (pending=3D0x0, function=3D0x41b320
> <reply_from_singleton_device_changed>,
>     user_data=3D0xc74c30, free_user_data=3D0x416000 <del_sdci>) at dbus-
> pending-call.c:598
> #5  0x0000000000415f6e in singleton_signal_device_changed
> (connection=3D0xbdc140, device=3D0x7f18411af2c0, added=3D1)
>     at hald_dbus.c:3481
> #6  0x0000000000419fe2 in hald_singleton_device_added
> (command_line=3D0xc601e0 "hald-addon-leds", device=3D0x7f18411af2c0)
>     at hald_dbus.c:3570

OK this is HAL bug which could be triggered by some changes in 2.6.30=20
series. I leave kernel on Cc list so far to ask whether there was=20
actually behaviour change in 2.6.30 or it is just different timing that=20
now hits badly.

So what happens is simple. During suspend led device is removed; during=20
resume it is recreated. Apparently removing led device cause hald-addon-
leds to exit (thus disconnecting D-Bus connection); and sometimes next=20
"add" event comes too early, before hald had chance to notice missing=20
addon.

So attached is POC patch that simply adds extra check to=20
hald_singleton_device_added() to ensure we do not abort on disconnected=20
D-Bus connection. It does not seem to have evil effects; it is possible=20
that we do miss some event but I do not quite understand processing=20
logic here. Apparently event should be replayed ...

Here is list of hald processes after resume. Notice that hald-addon-leds=20
is restarted every time:

pts/1}% pgrep -l hald               =20
13996 hald                           =20
13997 hald-runner                    =20
14098 hald-addon-rfki                =20
14130 hald-addon-gene                =20
14156 hald-addon-inpu                =20
14190 hald-addon-stor                =20
14194 hald-addon-cpuf                =20
14195 hald-addon-acpi                =20
14796 hald-addon-leds                =20
{pts/1}% pgrep -l hald               =20
13996 hald                           =20
13997 hald-runner                    =20
14098 hald-addon-rfki                =20
14130 hald-addon-gene                =20
14156 hald-addon-inpu                =20
14190 hald-addon-stor                =20
14194 hald-addon-cpuf                =20
14195 hald-addon-acpi                =20
16145 hald-addon-leds                =20
{pts/1}% pgrep -l hald               =20
13996 hald                           =20
13997 hald-runner                    =20
14098 hald-addon-rfki                =20
14130 hald-addon-gene                =20
14156 hald-addon-inpu
14190 hald-addon-stor
14194 hald-addon-cpuf
14195 hald-addon-acpi
17543 hald-addon-leds
{pts/1}% pgrep -l hald
13996 hald
13997 hald-runner
14098 hald-addon-rfki
14130 hald-addon-gene
14156 hald-addon-inpu
14190 hald-addon-stor
14194 hald-addon-cpuf
14195 hald-addon-acpi
{pts/1}% pgrep -l hald
13996 hald
13997 hald-runner
14098 hald-addon-rfki
14130 hald-addon-gene
14156 hald-addon-inpu
14190 hald-addon-stor
14194 hald-addon-cpuf
14195 hald-addon-acpi
21842 hald-addon-leds
{pts/1}% pgrep -l hald
13996 hald
13997 hald-runner
14098 hald-addon-rfki
14130 hald-addon-gene
14156 hald-addon-inpu
14190 hald-addon-stor
14194 hald-addon-cpuf
14195 hald-addon-acpi
23946 hald-addon-leds

and events that are generated by kernel during suspend/remove cycle:

{pts/0}% sudo udevadm monitor --env --kernel
monitor will print the received events for:=20
KERNEL - the kernel uevent                 =20

KERNEL[1245593084.803490] remove  =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::assoc=20
(leds)                                                   =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dremove                                                            =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-
phy0::assoc     =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1458                                                              =
      =20

KERNEL[1245593084.803530] remove  =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::RX (leds)     =
                                                 =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dremove                                                            =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::RX  =
      =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1459                                                              =
      =20

KERNEL[1245593084.803550] remove  =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::TX (leds)     =
                                                 =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dremove                                                            =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::TX  =
      =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1460                                                              =
      =20

KERNEL[1245593084.803570] remove  =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::radio=20
(leds)                                                   =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dremove                                                            =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-
phy0::radio     =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1461                                                              =
      =20

KERNEL[1245593084.803590] remove   /devices/system/cpu/cpu1/cpufreq=20
(cpu)
UDEV_LOG=3D3                                                              =
=20
ACTION=3Dremove                                                           =
=20
DEVPATH=3D/devices/system/cpu/cpu1/cpufreq                                =
=20
SUBSYSTEM=3Dcpu                                                           =
=20
SEQNUM=3D1462                                                             =
=20

KERNEL[1245593084.803610] remove   /devices/system/cpu/cpu1/cache/index0=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dremove                                                            =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index0                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1463                                                              =
    =20

KERNEL[1245593084.803629] remove   /devices/system/cpu/cpu1/cache/index1=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dremove                                                            =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index1                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1464                                                              =
    =20

KERNEL[1245593084.803648] remove   /devices/system/cpu/cpu1/cache/index2=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dremove                                                            =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index2                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1465                                                              =
    =20

KERNEL[1245593084.803667] remove   /devices/system/cpu/cpu1/cache (cpu)
UDEV_LOG=3D3                                                            =20
ACTION=3Dremove                                                         =20
DEVPATH=3D/devices/system/cpu/cpu1/cache                                =20
SUBSYSTEM=3Dcpu                                                         =20
SEQNUM=3D1466                                                           =20

KERNEL[1245593084.803687] remove  =20
/devices/system/machinecheck/machinecheck1 (machinecheck)                  =
                                                 =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dremove                                                            =
      =20
DEVPATH=3D/devices/system/machinecheck/machinecheck1                       =
      =20
SUBSYSTEM=3Dmachinecheck                                                   =
      =20
SEQNUM=3D1467                                                              =
      =20

KERNEL[1245593084.803707] add      /devices/system/cpu/cpu1/cache/index0=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dadd                                                               =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index0                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1468                                                              =
    =20

KERNEL[1245593084.803726] add      /devices/system/cpu/cpu1/cache/index1=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dadd                                                               =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index1                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1469                                                              =
    =20

KERNEL[1245593084.803745] add      /devices/system/cpu/cpu1/cache/index2=20
(cpu)
UDEV_LOG=3D3                                                               =
    =20
ACTION=3Dadd                                                               =
    =20
DEVPATH=3D/devices/system/cpu/cpu1/cache/index2                            =
    =20
SUBSYSTEM=3Dcpu                                                            =
    =20
SEQNUM=3D1470                                                              =
    =20

KERNEL[1245593084.803764] add      /devices/system/cpu/cpu1/cache (cpu)
UDEV_LOG=3D3                                                            =20
ACTION=3Dadd                                                            =20
DEVPATH=3D/devices/system/cpu/cpu1/cache                                =20
SUBSYSTEM=3Dcpu                                                         =20
SEQNUM=3D1471                                                           =20

KERNEL[1245593084.803784] add     =20
/devices/system/machinecheck/machinecheck1 (machinecheck)                  =
                                                 =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dadd                                                               =
      =20
DEVPATH=3D/devices/system/machinecheck/machinecheck1                       =
      =20
SUBSYSTEM=3Dmachinecheck                                                   =
      =20
SEQNUM=3D1472                                                              =
      =20

KERNEL[1245593084.803804] add      /devices/system/cpu/cpu1/cpufreq=20
(cpu)
UDEV_LOG=3D3                                                              =
=20
ACTION=3Dadd                                                              =
=20
DEVPATH=3D/devices/system/cpu/cpu1/cpufreq                                =
=20
SUBSYSTEM=3Dcpu                                                           =
=20
SEQNUM=3D1473                                                             =
=20

KERNEL[1245593084.803825] change  =20
/devices/LNXSYSTM:00/device:00/ACPI0003:00/power_supply/AC=20
(power_supply)                                                   =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dchange                                                            =
      =20
DEVPATH=3D/devices/LNXSYSTM:00/device:00/ACPI0003:00/power_supply/AC       =
      =20
SUBSYSTEM=3Dpower_supply                                                   =
      =20
POWER_SUPPLY_NAME=3DAC                                                     =
      =20
POWER_SUPPLY_TYPE=3DMains                                                  =
      =20
POWER_SUPPLY_ONLINE=3D1                                                    =
      =20
SEQNUM=3D1474                                                              =
      =20

KERNEL[1245593084.803860] change  =20
/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0=20
(power_supply)                                                  =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dchange                                                            =
      =20
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0      =
      =20
SUBSYSTEM=3Dpower_supply                                                   =
      =20
POWER_SUPPLY_NAME=3DBAT0                                                   =
      =20
POWER_SUPPLY_TYPE=3DBattery                                                =
      =20
POWER_SUPPLY_STATUS=3DUnknown                                              =
      =20
POWER_SUPPLY_PRESENT=3D1                                                   =
      =20
POWER_SUPPLY_TECHNOLOGY=3DLi-ion                                           =
      =20
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D11100000                                 =
      =20
POWER_SUPPLY_VOLTAGE_NOW=3D12016000                                        =
      =20
POWER_SUPPLY_CURRENT_NOW=3D2595000                                         =
      =20
POWER_SUPPLY_CHARGE_FULL_DESIGN=3D5200000                                  =
      =20
POWER_SUPPLY_CHARGE_FULL=3D4925000                                         =
      =20
POWER_SUPPLY_CHARGE_NOW=3D2819000                                          =
      =20
POWER_SUPPLY_MODEL_NAME=3DDELL WR0478                                      =
      =20
POWER_SUPPLY_MANUFACTURER=3DSamsung SDI                                    =
      =20
POWER_SUPPLY_SERIAL_NUMBER=3D21873                                         =
      =20
SEQNUM=3D1475                                                              =
      =20

KERNEL[1245593084.817242] change  =20
/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0=20
(power_supply)                                                  =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dchange                                                            =
      =20
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0      =
      =20
SUBSYSTEM=3Dpower_supply                                                   =
      =20
POWER_SUPPLY_NAME=3DBAT0                                                   =
      =20
POWER_SUPPLY_TYPE=3DBattery                                                =
      =20
POWER_SUPPLY_STATUS=3DUnknown                                              =
      =20
POWER_SUPPLY_PRESENT=3D1                                                   =
      =20
POWER_SUPPLY_TECHNOLOGY=3DLi-ion                                           =
      =20
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D11100000                                 =
      =20
POWER_SUPPLY_VOLTAGE_NOW=3D12016000                                        =
      =20
POWER_SUPPLY_CURRENT_NOW=3D2595000                                         =
      =20
POWER_SUPPLY_CHARGE_FULL_DESIGN=3D5200000                                  =
      =20
POWER_SUPPLY_CHARGE_FULL=3D4925000                                         =
      =20
POWER_SUPPLY_CHARGE_NOW=3D2819000                                          =
      =20
POWER_SUPPLY_MODEL_NAME=3DDELL WR0478                                      =
      =20
POWER_SUPPLY_MANUFACTURER=3DSamsung SDI                                    =
      =20
POWER_SUPPLY_SERIAL_NUMBER=3D21873                                         =
      =20
SEQNUM=3D1476                                                              =
      =20

KERNEL[1245593084.817297] change  =20
/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0=20
(power_supply)                                                  =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dchange                                                            =
      =20
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0      =
      =20
SUBSYSTEM=3Dpower_supply                                                   =
      =20
POWER_SUPPLY_NAME=3DBAT0                                                   =
      =20
POWER_SUPPLY_TYPE=3DBattery                                                =
      =20
POWER_SUPPLY_STATUS=3DCharging                                             =
      =20
POWER_SUPPLY_PRESENT=3D1                                                   =
      =20
POWER_SUPPLY_TECHNOLOGY=3DLi-ion                                           =
      =20
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D11100000                                 =
      =20
POWER_SUPPLY_VOLTAGE_NOW=3D11717000                                        =
      =20
POWER_SUPPLY_CURRENT_NOW=3D2275000                                         =
      =20
POWER_SUPPLY_CHARGE_FULL_DESIGN=3D5200000                                  =
      =20
POWER_SUPPLY_CHARGE_FULL=3D4925000                                         =
      =20
POWER_SUPPLY_CHARGE_NOW=3D2819000                                          =
      =20
POWER_SUPPLY_MODEL_NAME=3DDELL WR0478                                      =
      =20
POWER_SUPPLY_MANUFACTURER=3DSamsung SDI                                    =
      =20
POWER_SUPPLY_SERIAL_NUMBER=3D21873                                         =
      =20
SEQNUM=3D1477                                                              =
      =20

KERNEL[1245593084.817342] add     =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::radio=20
(leds)                                                   =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dadd                                                               =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-
phy0::radio     =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1478                                                              =
      =20

KERNEL[1245593084.817382] add     =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::assoc=20
(leds)                                                   =20
UDEV_LOG=3D3                                                               =
      =20
ACTION=3Dadd                                                               =
      =20
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-
phy0::assoc     =20
SUBSYSTEM=3Dleds                                                           =
      =20
SEQNUM=3D1479                                                              =
      =20

KERNEL[1245593084.817402] add     =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::RX (leds)
UDEV_LOG=3D3
ACTION=3Dadd
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::RX
SUBSYSTEM=3Dleds
SEQNUM=3D1480

KERNEL[1245593084.817421] add     =20
/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::TX (leds)
UDEV_LOG=3D3
ACTION=3Dadd
DEVPATH=3D/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::TX
SUBSYSTEM=3Dleds
SEQNUM=3D1481

KERNEL[1245593084.817442] remove  =20
/devices/pci0000:00/0000:00:1a.0/usb2/2-2/2-2.1/2-2.1:1.0/bluetooth/hci0=20
(bluetooth)
UDEV_LOG=3D3
ACTION=3Dremove
DEVPATH=3D/devices/pci0000:00/0000:00:1a.0/usb2/2-2/2-2.1/2-2.1:1.0/bluetoo=
th/hci0
SUBSYSTEM=3Dbluetooth
DEVTYPE=3Dhost
SEQNUM=3D1482

KERNEL[1245593084.817464] add     =20
/devices/pci0000:00/0000:00:1a.0/usb2/2-2/2-2.1/2-2.1:1.0/bluetooth/hci0=20
(bluetooth)
UDEV_LOG=3D3
ACTION=3Dadd
DEVPATH=3D/devices/pci0000:00/0000:00:1a.0/usb2/2-2/2-2.1/2-2.1:1.0/bluetoo=
th/hci0
SUBSYSTEM=3Dbluetooth
DEVTYPE=3Dhost
SEQNUM=3D1483


--Boundary-01=_zDkPKxfzc2cuu6o
Content-Type: text/x-patch;
  charset="us-ascii";
  name="hal-0.5.12-singleton_connection.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="hal-0.5.12-singleton_connection.patch"

+++ hald/hald_dbus.c.singleton_connection	2009-02-26 08:55:36.000000000 +0100
--- hald/hald_dbus.c	2009-06-21 13:48:15.000000000 +0200
@@ -3476,7 +3476,7 @@ singleton_signal_device_changed (DBusCon
 	if (dbus_connection_send_with_reply (connection,
 					     message,
 					     &pending_call,
-					     /*-1*/ 8000)) {
+					     /*-1*/ 8000) && pending_call) {
 		/*HAL_INFO (("connection=%x message=%x", connection, message));*/
 		dbus_pending_call_set_notify (pending_call,
 					      reply_from_singleton_device_changed,

--Boundary-01=_zDkPKxfzc2cuu6o--

--nextPart1376712.0k0tYoQDbk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko+QPMACgkQR6LMutpd94wi9gCeM+pXUwbPCpaZMapZvaX16Wmb
ZlQAni11EPObFx1FsE2DFvoszmq3+Eb6
=bSR9
-----END PGP SIGNATURE-----

--nextPart1376712.0k0tYoQDbk--
