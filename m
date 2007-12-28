Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXL1QtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXL1QtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 11:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXL1QtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 11:49:08 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:39227 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbXL1Qs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NyOr6WiqpxVXkKmDDP0PXKyoga65O4DXDx/o6JmNurZWO6nlkLK3BlQue6OxoKHjFPZAQdcwyy757m/ahuPwanVDdiczH8cAnF2DAE2OT1ojtWS1IuA2oLJG+p+QLXIU1ip4XvYpkDoy4SxMC920oFP7+loshqLnqopZ7SzWDAY=
Message-ID: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
Date: Fri, 28 Dec 2007 14:48:51 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: USB HID: Missing keys on Gyration Media Center Universal Remote Control
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings folks,

  I have recently bought one of these for use with my Linux HTPC (using MythTV):

http://www.gyration.com/p-21-universal-remote-control-for-pc-media-center-and-audiovideo-functions.aspx

  It is a 2.4 Ghz RF remote, and its receiver connects via USB to the
computer, registering two devices, a keyboard and a mouse.  From
/proc/bus/input/devices:

I: Bus=0003 Vendor=0c16 Product=0002 Version=0110
N: Name="Gyration Gyration RF Technology Receiver"
P: Phys=usb-0000:00:02.0-9/input0
S: Sysfs=/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input7
U: Uniq=
H: Handlers=kbd event7
B: EV=10001f
B: KEY=37fff ac3027 bf004444 0 0 1 c04 a37c000 267bfa d941dfed
e09effdf 1cfffff ffffffff fffffffe
B: REL=40
B: ABS=1 0
B: MSC=10

I: Bus=0003 Vendor=0c16 Product=0002 Version=0120
N: Name="Gyration Gyration RF Technology Receiver"
P: Phys=usb-0000:00:02.0-9/input1
S: Sysfs=/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.1/input/input8
U: Uniq=
H: Handlers=kbd mouse2 event8
B: EV=10001f
B: KEY=37fff 4aff3b7 bf0d4444 0 0 1f0001 c04 a37c007 ffa67bfa d941dfff
80beffcd 1cfffff febffbff dffffffe
B: REL=143
B: ABS=1 0
B: MSC=10

  As Bruce Perens once advertised
(http://perens.com/FreeSoftware/gyration.html), for the most part it
works as it should, even if one must recur to utilities such as
xbindkeys or evrouter for most of the keys.  However, up until
2.6.24-rc6 there are two outstanding issues as of yet unresolved
(independently confirmed here,
http://ubuntuforums.org/showthread.php?t=479897):

1) The power button, which is actually a Sleep or Suspend button, when
pressed repeats endlessly.  One must disconnect the receiver for it to
stop.  I suspect this is because the key press event registers
correctly, but not the key release.

2) Four of the buttons ("TV", "SETUP MENU", "LAST", and "INPUT") are
not recognized and do not register any events.

  I generated a log using a 2.6.24-rc6 kernel with
CONFIG_HID_DEBUG=yes and evbug loaded, and saw that:

* "SETUP MENU", "LAST", and "INPUT" keys do absolutely nothing.
* "TV" registers something, but apparently not enough for an event.
* "Power" correctly registers a Sleep event, but repeats endlessly.

  As far as I can tell there is not much that can be done in
userspace, and it is a bigger problem than, for example, the one
specified in this thread: http://lkml.org/lkml/2007/6/11/100 . Any
tips on what could be done?  Must another driver be written?  Or is
this a hid quirk?  Can Lyu's "Simple HID Device" solution for the
extra keys on the Microsoft Natural Keyboard 4000 be used?  Thanks in
advance for any help.

  Here is the complete log.  It encompasses the following events
(which I labeled to the best of my ability in the log itself):

* Connect receiver.
* Press "0" key.
* Press "TV" key.
* Press "0" key.
* Press "SETUP MENU" key.
* Press "0" key.
* Press "LAST" key.
* Press "0" key.
* Press "INPUT" key.
* Press "0" key.
* Press "Power" key.
* Press "0" key.
* Disconnect receiver.

Start log
-----------------
#######################
CONNECT
#######################

Dec 28 13:31:32 adolfo kernel: [ 3380.080494] usb 2-9: new low speed
USB device using ohci_hcd and address 12
Dec 28 13:31:32 adolfo NetworkManager: <debug> [1198855892.584262]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial').
Dec 28 13:31:32 adolfo kernel: [ 3380.295172] usb 2-9: configuration
#1 chosen from 1 choice
Dec 28 13:31:32 adolfo kernel: [ 3380.301629]
drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
Dec 28 13:31:32 adolfo kernel: [ 3380.310081]
drivers/hid/usbhid/hid-core.c: report descriptor (size 149, read 149)
=  05 01 09 06 a1 01 85 01 05 07 19 e0 29 e7 15 00 25 01 75 01 95 08
81 02 75 08 95 01 81 01 05 07 19 00 29 65 15 00 25 65 75 08 95 05 81
00 c0 05 0c 09 01 a1 01 85 02 19 00 2a 3c 02 15 00 26 3c 02 95 01 75
10 81 00 c0 05 01 09 80 a1 01 85 03 19 81 29 83 15 00 25 01 75 01 95
03 81 02 95 05 81 01 c0 06 01 ff 09 01 a1 01 85 04 95 01 75 08 15 01
25 0a 09 20 81 03 25 4f 09 21 81 03 25 30 09 22 81 03 09 23 81 03 09
24 81 03 09 25 81 03 09 26 81 03 c0
Dec 28 13:31:32 adolfo kernel: [ 3380.310325]   INPUT(1)[INPUT]
Dec 28 13:31:32 adolfo kernel: [ 3380.310328]     Field(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.310329]       Usage(8)
Dec 28 13:31:32 adolfo kernel: [ 3380.310331]         Keyboard.00e0
Dec 28 13:31:32 adolfo kernel: [ 3380.310334]         Keyboard.00e1
Dec 28 13:31:32 adolfo kernel: [ 3380.310336]         Keyboard.00e2
Dec 28 13:31:32 adolfo kernel: [ 3380.310338]         Keyboard.00e3
Dec 28 13:31:32 adolfo kernel: [ 3380.310340]         Keyboard.00e4
Dec 28 13:31:32 adolfo kernel: [ 3380.310342]         Keyboard.00e5
Dec 28 13:31:32 adolfo kernel: [ 3380.310344]         Keyboard.00e6
Dec 28 13:31:32 adolfo kernel: [ 3380.310346]         Keyboard.00e7
Dec 28 13:31:32 adolfo kernel: [ 3380.310348]       Logical Minimum(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.310349]       Logical Maximum(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.310351]       Report Size(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.310352]       Report Count(8)
Dec 28 13:31:32 adolfo kernel: [ 3380.310354]       Report Offset(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.310355]       Flags( Variable Absolute )
Dec 28 13:31:32 adolfo kernel: [ 3380.310359]     Field(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.310360]       Usage(102)
Dec 28 13:31:32 adolfo kernel: [ 3380.310361]         Keyboard.0000
Dec 28 13:31:32 adolfo kernel: [ 3380.310363]         Keyboard.0001
Dec 28 13:31:32 adolfo kernel: [ 3380.310365]         Keyboard.0002
Dec 28 13:31:32 adolfo kernel: [ 3380.310367]         Keyboard.0003
Dec 28 13:31:32 adolfo kernel: [ 3380.310369]         Keyboard.0004
Dec 28 13:31:32 adolfo kernel: [ 3380.310371]         Keyboard.0005
Dec 28 13:31:32 adolfo kernel: [ 3380.310373]         Keyboard.0006
Dec 28 13:31:32 adolfo kernel: [ 3380.310375]         Keyboard.0007
Dec 28 13:31:32 adolfo kernel: [ 3380.310377]         Keyboard.0008
Dec 28 13:31:32 adolfo kernel: [ 3380.310379]         Keyboard.0009
Dec 28 13:31:32 adolfo kernel: [ 3380.310381]         Keyboard.000a
Dec 28 13:31:32 adolfo kernel: [ 3380.310383]         Keyboard.000b
Dec 28 13:31:32 adolfo kernel: [ 3380.310385]         Keyboard.000c
Dec 28 13:31:32 adolfo kernel: [ 3380.310387]         Keyboard.000d
Dec 28 13:31:32 adolfo kernel: [ 3380.310389]         Keyboard.000e
Dec 28 13:31:32 adolfo kernel: [ 3380.310391]         Keyboard.000f
Dec 28 13:31:32 adolfo kernel: [ 3380.310393]         Keyboard.0010
Dec 28 13:31:32 adolfo kernel: [ 3380.310395]         Keyboard.0011
Dec 28 13:31:32 adolfo kernel: [ 3380.310398]         Keyboard.0012
Dec 28 13:31:32 adolfo kernel: [ 3380.310400]         Keyboard.0013
Dec 28 13:31:32 adolfo kernel: [ 3380.310401]         Keyboard.0014
Dec 28 13:31:32 adolfo kernel: [ 3380.310404]         Keyboard.0015
Dec 28 13:31:32 adolfo kernel: [ 3380.310406]         Keyboard.0016
Dec 28 13:31:32 adolfo kernel: [ 3380.310408]         Keyboard.0017
Dec 28 13:31:32 adolfo kernel: [ 3380.310410]         Keyboard.0018
Dec 28 13:31:32 adolfo kernel: [ 3380.310412]         Keyboard.0019
Dec 28 13:31:32 adolfo kernel: [ 3380.310414]         Keyboard.001a
Dec 28 13:31:32 adolfo kernel: [ 3380.310416]         Keyboard.001b
Dec 28 13:31:32 adolfo kernel: [ 3380.310418]         Keyboard.001c
Dec 28 13:31:32 adolfo kernel: [ 3380.310420]         Keyboard.001d
Dec 28 13:31:32 adolfo kernel: [ 3380.310422]         Keyboard.001e
Dec 28 13:31:32 adolfo kernel: [ 3380.310424]         Keyboard.001f
Dec 28 13:31:32 adolfo kernel: [ 3380.310426]         Keyboard.0020
Dec 28 13:31:32 adolfo kernel: [ 3380.310428]         Keyboard.0021
Dec 28 13:31:32 adolfo kernel: [ 3380.310430]         Keyboard.0022
Dec 28 13:31:32 adolfo kernel: [ 3380.310432]         Keyboard.0023
Dec 28 13:31:32 adolfo kernel: [ 3380.310434]         Keyboard.0024
Dec 28 13:31:32 adolfo kernel: [ 3380.310436]         Keyboard.0025
Dec 28 13:31:32 adolfo kernel: [ 3380.310438]         Keyboard.0026
Dec 28 13:31:32 adolfo kernel: [ 3380.310440]         Keyboard.0027
Dec 28 13:31:32 adolfo kernel: [ 3380.310442]         Keyboard.0028
Dec 28 13:31:32 adolfo kernel: [ 3380.310444]         Keyboard.0029
Dec 28 13:31:32 adolfo kernel: [ 3380.310446]         Keyboard.002a
Dec 28 13:31:32 adolfo kernel: [ 3380.310448]         Keyboard.002b
Dec 28 13:31:32 adolfo kernel: [ 3380.310450]         Keyboard.002c
Dec 28 13:31:32 adolfo kernel: [ 3380.310452]         Keyboard.002d
Dec 28 13:31:32 adolfo kernel: [ 3380.310454]         Keyboard.002e
Dec 28 13:31:32 adolfo kernel: [ 3380.310456]         Keyboard.002f
Dec 28 13:31:32 adolfo kernel: [ 3380.310458]         Keyboard.0030
Dec 28 13:31:32 adolfo kernel: [ 3380.310460]         Keyboard.0031
Dec 28 13:31:32 adolfo kernel: [ 3380.310462]         Keyboard.0032
Dec 28 13:31:32 adolfo kernel: [ 3380.310464]         Keyboard.0033
Dec 28 13:31:32 adolfo kernel: [ 3380.310466]         Keyboard.0034
Dec 28 13:31:32 adolfo kernel: [ 3380.310468]         Keyboard.0035
Dec 28 13:31:32 adolfo kernel: [ 3380.310470]         Keyboard.0036
Dec 28 13:31:32 adolfo kernel: [ 3380.310472]         Keyboard.0037
Dec 28 13:31:32 adolfo kernel: [ 3380.310474]         Keyboard.0038
Dec 28 13:31:32 adolfo kernel: [ 3380.310476]         Keyboard.0039
Dec 28 13:31:32 adolfo kernel: [ 3380.310478]         Keyboard.003a
Dec 28 13:31:32 adolfo kernel: [ 3380.310480]         Keyboard.003b
Dec 28 13:31:32 adolfo kernel: [ 3380.310482]         Keyboard.003c
Dec 28 13:31:32 adolfo kernel: [ 3380.310484]         Keyboard.003d
Dec 28 13:31:32 adolfo kernel: [ 3380.310486]         Keyboard.003e
Dec 28 13:31:32 adolfo kernel: [ 3380.310488]         Keyboard.003f
Dec 28 13:31:32 adolfo kernel: [ 3380.310490]         Keyboard.0040
Dec 28 13:31:32 adolfo kernel: [ 3380.310492]         Keyboard.0041
Dec 28 13:31:32 adolfo kernel: [ 3380.310494]         Keyboard.0042
Dec 28 13:31:32 adolfo kernel: [ 3380.310496]         Keyboard.0043
Dec 28 13:31:32 adolfo kernel: [ 3380.310498]         Keyboard.0044
Dec 28 13:31:32 adolfo kernel: [ 3380.310500]         Keyboard.0045
Dec 28 13:31:32 adolfo kernel: [ 3380.310502]         Keyboard.0046
Dec 28 13:31:32 adolfo kernel: [ 3380.310504]         Keyboard.0047
Dec 28 13:31:32 adolfo kernel: [ 3380.310506]         Keyboard.0048
Dec 28 13:31:32 adolfo kernel: [ 3380.310508]         Keyboard.0049
Dec 28 13:31:32 adolfo kernel: [ 3380.310510]         Keyboard.004a
Dec 28 13:31:32 adolfo kernel: [ 3380.310512]         Keyboard.004b
Dec 28 13:31:32 adolfo kernel: [ 3380.310514]         Keyboard.004c
Dec 28 13:31:32 adolfo kernel: [ 3380.310516]         Keyboard.004d
Dec 28 13:31:32 adolfo kernel: [ 3380.310518]         Keyboard.004e
Dec 28 13:31:32 adolfo kernel: [ 3380.310520]         Keyboard.004f
Dec 28 13:31:32 adolfo kernel: [ 3380.310522]         Keyboard.0050
Dec 28 13:31:32 adolfo kernel: [ 3380.310524]         Keyboard.0051
Dec 28 13:31:32 adolfo kernel: [ 3380.310526]         Keyboard.0052
Dec 28 13:31:32 adolfo kernel: [ 3380.310528]         Keyboard.0053
Dec 28 13:31:32 adolfo kernel: [ 3380.310530]         Keyboard.0054
Dec 28 13:31:32 adolfo kernel: [ 3380.310532]         Keyboard.0055
Dec 28 13:31:32 adolfo kernel: [ 3380.310534]         Keyboard.0056
Dec 28 13:31:32 adolfo kernel: [ 3380.310536]         Keyboard.0057
Dec 28 13:31:32 adolfo kernel: [ 3380.310538]         Keyboard.0058
Dec 28 13:31:32 adolfo kernel: [ 3380.310540]         Keyboard.0059
Dec 28 13:31:32 adolfo kernel: [ 3380.310542]         Keyboard.005a
Dec 28 13:31:32 adolfo kernel: [ 3380.310544]         Keyboard.005b
Dec 28 13:31:32 adolfo kernel: [ 3380.310546]         Keyboard.005c
Dec 28 13:31:32 adolfo kernel: [ 3380.310548]         Keyboard.005d
Dec 28 13:31:32 adolfo kernel: [ 3380.310550]         Keyboard.005e
Dec 28 13:31:32 adolfo kernel: [ 3380.310552]         Keyboard.005f
Dec 28 13:31:32 adolfo kernel: [ 3380.310554]         Keyboard.0060
Dec 28 13:31:32 adolfo kernel: [ 3380.310556]         Keyboard.0061
Dec 28 13:31:32 adolfo kernel: [ 3380.310558]         Keyboard.0062
Dec 28 13:31:32 adolfo kernel: [ 3380.310560]         Keyboard.0063
Dec 28 13:31:32 adolfo kernel: [ 3380.310562]         Keyboard.0064
Dec 28 13:31:32 adolfo kernel: [ 3380.310564]         Keyboard.0065
Dec 28 13:31:32 adolfo kernel: [ 3380.310566]       Logical Minimum(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.310567]       Logical Maximum(101)
Dec 28 13:31:32 adolfo kernel: [ 3380.310569]       Report Size(8)
Dec 28 13:31:32 adolfo kernel: [ 3380.310570]       Report Count(5)
Dec 28 13:31:32 adolfo kernel: [ 3380.310572]       Report Offset(16)
Dec 28 13:31:32 adolfo kernel: [ 3380.310573]       Flags( Array Absolute )
Dec 28 13:31:32 adolfo kernel: [ 3380.310576]   INPUT(2)[INPUT]
Dec 28 13:31:32 adolfo kernel: [ 3380.310578]     Field(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.310579]       Usage(573)
Dec 28 13:31:32 adolfo kernel: [ 3380.310580]         Consumer.0000
Dec 28 13:31:32 adolfo kernel: [ 3380.310583]         Consumer.0001
Dec 28 13:31:32 adolfo kernel: [ 3380.310585]         Consumer.0002
Dec 28 13:31:32 adolfo kernel: [ 3380.310587]         Consumer.0003
Dec 28 13:31:32 adolfo kernel: [ 3380.310589]         Consumer.0004
Dec 28 13:31:32 adolfo kernel: [ 3380.310591]         Consumer.0005
Dec 28 13:31:32 adolfo kernel: [ 3380.310593]         Consumer.0006
Dec 28 13:31:32 adolfo kernel: [ 3380.310595]         Consumer.0007
Dec 28 13:31:32 adolfo kernel: [ 3380.310597]         Consumer.0008
Dec 28 13:31:32 adolfo kernel: [ 3380.310599]         Consumer.0009
Dec 28 13:31:32 adolfo kernel: [ 3380.310601]         Consumer.000a
Dec 28 13:31:32 adolfo kernel: [ 3380.310603]         Consumer.000b
Dec 28 13:31:32 adolfo kernel: [ 3380.310605]         Consumer.000c
Dec 28 13:31:32 adolfo kernel: [ 3380.310607]         Consumer.000d
Dec 28 13:31:32 adolfo kernel: [ 3380.310609]         Consumer.000e
Dec 28 13:31:32 adolfo kernel: [ 3380.310611]         Consumer.000f
Dec 28 13:31:32 adolfo kernel: [ 3380.310613]         Consumer.0010
Dec 28 13:31:32 adolfo kernel: [ 3380.310615]         Consumer.0011
Dec 28 13:31:32 adolfo kernel: [ 3380.310617]         Consumer.0012
Dec 28 13:31:32 adolfo kernel: [ 3380.310619]         Consumer.0013
Dec 28 13:31:32 adolfo kernel: [ 3380.310621]         Consumer.0014
Dec 28 13:31:32 adolfo kernel: [ 3380.310623]         Consumer.0015
Dec 28 13:31:32 adolfo kernel: [ 3380.310625]         Consumer.0016
Dec 28 13:31:32 adolfo kernel: [ 3380.310627]         Consumer.0017
Dec 28 13:31:32 adolfo kernel: [ 3380.310629]         Consumer.0018
Dec 28 13:31:32 adolfo kernel: [ 3380.310631]         Consumer.0019
Dec 28 13:31:32 adolfo kernel: [ 3380.310633]         Consumer.001a
Dec 28 13:31:32 adolfo kernel: [ 3380.310635]         Consumer.001b
Dec 28 13:31:32 adolfo kernel: [ 3380.310637]         Consumer.001c
Dec 28 13:31:32 adolfo kernel: [ 3380.310639]         Consumer.001d
Dec 28 13:31:32 adolfo kernel: [ 3380.310641]         Consumer.001e
Dec 28 13:31:32 adolfo kernel: [ 3380.310643]         Consumer.001f
Dec 28 13:31:32 adolfo kernel: [ 3380.310645]         Consumer.0020
Dec 28 13:31:32 adolfo kernel: [ 3380.310647]         Consumer.0021
Dec 28 13:31:32 adolfo kernel: [ 3380.310649]         Consumer.0022
Dec 28 13:31:32 adolfo kernel: [ 3380.310651]         Consumer.0023
Dec 28 13:31:32 adolfo kernel: [ 3380.310653]         Consumer.0024
Dec 28 13:31:32 adolfo kernel: [ 3380.310655]         Consumer.0025
Dec 28 13:31:32 adolfo kernel: [ 3380.310658]         Consumer.0026
Dec 28 13:31:32 adolfo kernel: [ 3380.310660]         Consumer.0027
Dec 28 13:31:32 adolfo kernel: [ 3380.310662]         Consumer.0028
Dec 28 13:31:32 adolfo kernel: [ 3380.310664]         Consumer.0029
Dec 28 13:31:32 adolfo kernel: [ 3380.310666]         Consumer.002a
Dec 28 13:31:32 adolfo kernel: [ 3380.310668]         Consumer.002b
Dec 28 13:31:32 adolfo kernel: [ 3380.310670]         Consumer.002c
Dec 28 13:31:32 adolfo kernel: [ 3380.310672]         Consumer.002d
Dec 28 13:31:32 adolfo kernel: [ 3380.310674]         Consumer.002e
Dec 28 13:31:32 adolfo kernel: [ 3380.310676]         Consumer.002f
Dec 28 13:31:32 adolfo kernel: [ 3380.310678]         Consumer.0030
Dec 28 13:31:32 adolfo kernel: [ 3380.310680]         Consumer.0031
Dec 28 13:31:32 adolfo kernel: [ 3380.310682]         Consumer.0032
Dec 28 13:31:32 adolfo kernel: [ 3380.310684]         Consumer.0033
Dec 28 13:31:32 adolfo kernel: [ 3380.310686]         Consumer.0034
Dec 28 13:31:32 adolfo kernel: [ 3380.310688]         Consumer.0035
Dec 28 13:31:32 adolfo kernel: [ 3380.310690]         Consumer.0036
Dec 28 13:31:32 adolfo kernel: [ 3380.310692]         Consumer.0037
Dec 28 13:31:32 adolfo kernel: [ 3380.310694]         Consumer.0038
Dec 28 13:31:32 adolfo kernel: [ 3380.310696]         Consumer.0039
Dec 28 13:31:32 adolfo kernel: [ 3380.310698]         Consumer.003a
Dec 28 13:31:32 adolfo kernel: [ 3380.310700]         Consumer.003b
Dec 28 13:31:32 adolfo kernel: [ 3380.310702]         Consumer.003c
Dec 28 13:31:32 adolfo kernel: [ 3380.310704]         Consumer.003d
Dec 28 13:31:32 adolfo kernel: [ 3380.310706]         Consumer.003e
Dec 28 13:31:32 adolfo kernel: [ 3380.310708]         Consumer.003f
Dec 28 13:31:32 adolfo kernel: [ 3380.310710]         Consumer.0040
Dec 28 13:31:32 adolfo kernel: [ 3380.310712]         Consumer.0041
Dec 28 13:31:32 adolfo kernel: [ 3380.310714]         Consumer.0042
Dec 28 13:31:32 adolfo kernel: [ 3380.310716]         Consumer.0043
Dec 28 13:31:32 adolfo kernel: [ 3380.310718]         Consumer.0044
Dec 28 13:31:32 adolfo kernel: [ 3380.310720]         Consumer.0045
Dec 28 13:31:32 adolfo kernel: [ 3380.310722]         Consumer.0046
Dec 28 13:31:32 adolfo kernel: [ 3380.310724]         Consumer.0047
Dec 28 13:31:32 adolfo kernel: [ 3380.310727]         Consumer.0048
Dec 28 13:31:32 adolfo kernel: [ 3380.310729]         Consumer.0049
Dec 28 13:31:32 adolfo kernel: [ 3380.310731]         Consumer.004a
Dec 28 13:31:32 adolfo kernel: [ 3380.310733]         Consumer.004b
Dec 28 13:31:32 adolfo kernel: [ 3380.310735]         Consumer.004c
Dec 28 13:31:32 adolfo kernel: [ 3380.310737]         Consumer.004d
Dec 28 13:31:32 adolfo kernel: [ 3380.310739]         Consumer.004e
Dec 28 13:31:32 adolfo kernel: [ 3380.310741]         Consumer.004f
Dec 28 13:31:32 adolfo kernel: [ 3380.310743]         Consumer.0050
Dec 28 13:31:32 adolfo kernel: [ 3380.310745]         Consumer.0051
Dec 28 13:31:32 adolfo kernel: [ 3380.310747]         Consumer.0052
Dec 28 13:31:32 adolfo kernel: [ 3380.310749]         Consumer.0053
Dec 28 13:31:32 adolfo kernel: [ 3380.310751]         Consumer.0054
Dec 28 13:31:32 adolfo kernel: [ 3380.310753]         Consumer.0055
Dec 28 13:31:32 adolfo kernel: [ 3380.310755]         Consumer.0056
Dec 28 13:31:32 adolfo kernel: [ 3380.310757]         Consumer.0057
Dec 28 13:31:32 adolfo kernel: [ 3380.310759]         Consumer.0058
Dec 28 13:31:32 adolfo kernel: [ 3380.310761]         Consumer.0059
Dec 28 13:31:32 adolfo kernel: [ 3380.310763]         Consumer.005a
Dec 28 13:31:32 adolfo kernel: [ 3380.310765]         Consumer.005b
Dec 28 13:31:32 adolfo kernel: [ 3380.310767]         Consumer.005c
Dec 28 13:31:32 adolfo kernel: [ 3380.310769]         Consumer.005d
Dec 28 13:31:32 adolfo kernel: [ 3380.310771]         Consumer.005e
Dec 28 13:31:32 adolfo kernel: [ 3380.310773]         Consumer.005f
Dec 28 13:31:32 adolfo kernel: [ 3380.310775]         Consumer.0060
Dec 28 13:31:32 adolfo kernel: [ 3380.310777]         Consumer.0061
Dec 28 13:31:32 adolfo kernel: [ 3380.310779]         Consumer.0062
Dec 28 13:31:32 adolfo kernel: [ 3380.310781]         Consumer.0063
Dec 28 13:31:32 adolfo kernel: [ 3380.310783]         Consumer.0064
Dec 28 13:31:32 adolfo kernel: [ 3380.310785]         Consumer.0065
Dec 28 13:31:32 adolfo kernel: [ 3380.310787]         Consumer.0066
Dec 28 13:31:32 adolfo kernel: [ 3380.310789]         Consumer.0067
Dec 28 13:31:32 adolfo kernel: [ 3380.310791]         Consumer.0068
Dec 28 13:31:32 adolfo kernel: [ 3380.310793]         Consumer.0069
Dec 28 13:31:32 adolfo kernel: [ 3380.310795]         Consumer.006a
Dec 28 13:31:32 adolfo kernel: [ 3380.310798]         Consumer.006b
Dec 28 13:31:32 adolfo kernel: [ 3380.310800]         Consumer.006c
Dec 28 13:31:32 adolfo kernel: [ 3380.310802]         Consumer.006d
Dec 28 13:31:32 adolfo kernel: [ 3380.310804]         Consumer.006e
Dec 28 13:31:32 adolfo kernel: [ 3380.310806]         Consumer.006f
Dec 28 13:31:32 adolfo kernel: [ 3380.310808]         Consumer.0070
Dec 28 13:31:32 adolfo kernel: [ 3380.310810]         Consumer.0071
Dec 28 13:31:32 adolfo kernel: [ 3380.310812]         Consumer.0072
Dec 28 13:31:32 adolfo kernel: [ 3380.310814]         Consumer.0073
Dec 28 13:31:32 adolfo kernel: [ 3380.310816]         Consumer.0074
Dec 28 13:31:32 adolfo kernel: [ 3380.310818]         Consumer.0075
Dec 28 13:31:32 adolfo kernel: [ 3380.310820]         Consumer.0076
Dec 28 13:31:32 adolfo kernel: [ 3380.310822]         Consumer.0077
Dec 28 13:31:32 adolfo kernel: [ 3380.310824]         Consumer.0078
Dec 28 13:31:32 adolfo kernel: [ 3380.310826]         Consumer.0079
Dec 28 13:31:32 adolfo kernel: [ 3380.310828]         Consumer.007a
Dec 28 13:31:32 adolfo kernel: [ 3380.310830]         Consumer.007b
Dec 28 13:31:32 adolfo kernel: [ 3380.310837]
Consumer.007cumer.0198 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313554] drivers/hid/hid-input.c:
Mapping: Consumer.0199 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313557] drivers/hid/hid-input.c:
Mapping: Consumer.019a ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313560] drivers/hid/hid-input.c:
Mapping: Consumer.019b ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313563] drivers/hid/hid-input.c:
Mapping: Consumer.019c ---> Key.Logoff
Dec 28 13:31:32 adolfo kernel: [ 3380.313566] drivers/hid/hid-input.c:
Mapping: Consumer.019d ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313569] drivers/hid/hid-input.c:
Mapping: Consumer.019e ---> Key.Coffee
Dec 28 13:31:32 adolfo kernel: [ 3380.313573] drivers/hid/hid-input.c:
Mapping: Consumer.019f ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313576] drivers/hid/hid-input.c:
Mapping: Consumer.01a0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313578] drivers/hid/hid-input.c:
Mapping: Consumer.01a1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313581] drivers/hid/hid-input.c:
Mapping: Consumer.01a2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313584] drivers/hid/hid-input.c:
Mapping: Consumer.01a3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313587] drivers/hid/hid-input.c:
Mapping: Consumer.01a4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313590] drivers/hid/hid-input.c:
Mapping: Consumer.01a5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313593] drivers/hid/hid-input.c:
Mapping: Consumer.01a6 ---> Key.Help
Dec 28 13:31:32 adolfo kernel: [ 3380.313596] drivers/hid/hid-input.c:
Mapping: Consumer.01a7 ---> Key.Documents
Dec 28 13:31:32 adolfo kernel: [ 3380.313600] drivers/hid/hid-input.c:
Mapping: Consumer.01a8 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313603] drivers/hid/hid-input.c:
Mapping: Consumer.01a9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313606] drivers/hid/hid-input.c:
Mapping: Consumer.01aa ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313609] drivers/hid/hid-input.c:
Mapping: Consumer.01ab ---> Key.SpellCheck
Dec 28 13:31:32 adolfo kernel: [ 3380.313612] drivers/hid/hid-input.c:
Mapping: Consumer.01ac ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313615] drivers/hid/hid-input.c:
Mapping: Consumer.01ad ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313618] drivers/hid/hid-input.c:
Mapping: Consumer.01ae ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313621] drivers/hid/hid-input.c:
Mapping: Consumer.01af ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313624] drivers/hid/hid-input.c:
Mapping: Consumer.01b0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313627] drivers/hid/hid-input.c:
Mapping: Consumer.01b1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313630] drivers/hid/hid-input.c:
Mapping: Consumer.01b2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313633] drivers/hid/hid-input.c:
Mapping: Consumer.01b3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313636] drivers/hid/hid-input.c:
Mapping: Consumer.01b4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313638] drivers/hid/hid-input.c:
Mapping: Consumer.01b5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313641] drivers/hid/hid-input.c:
Mapping: Consumer.01b6 ---> Key.Media
Dec 28 13:31:32 adolfo kernel: [ 3380.313645] drivers/hid/hid-input.c:
Mapping: Consumer.01b7 ---> Key.Sound
Dec 28 13:31:32 adolfo kernel: [ 3380.313648] drivers/hid/hid-input.c:
Mapping: Consumer.01b8 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313651] drivers/hid/hid-input.c:
Mapping: Consumer.01b9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313654] drivers/hid/hid-input.c:
Mapping: Consumer.01ba ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313657] drivers/hid/hid-input.c:
Mapping: Consumer.01bb ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313660] drivers/hid/hid-input.c:
Mapping: Consumer.01bc ---> Key.?
Dec 28 13:31:32 adolfo kernel: [ 3380.313663] drivers/hid/hid-input.c:
Mapping: Consumer.01bd ---> Key.Info
Dec 28 13:31:32 adolfo kernel: [ 3380.313666] drivers/hid/hid-input.c:
Mapping: Consumer.01be ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313669] drivers/hid/hid-input.c:
Mapping: Consumer.01bf ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313672] drivers/hid/hid-input.c:
Mapping: Consumer.01c0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313675] drivers/hid/hid-input.c:
Mapping: Consumer.01c1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313678] drivers/hid/hid-input.c:
Mapping: Consumer.01c2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313681] drivers/hid/hid-input.c:
Mapping: Consumer.01c3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313684] drivers/hid/hid-input.c:
Mapping: Consumer.01c4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313687] drivers/hid/hid-input.c:
Mapping: Consumer.01c5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313690] drivers/hid/hid-input.c:
Mapping: Consumer.01c6 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313693] drivers/hid/hid-input.c:
Mapping: Consumer.01c7 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313696] drivers/hid/hid-input.c:
Mapping: Consumer.01c8 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313699] drivers/hid/hid-input.c:
Mapping: Consumer.01c9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313702] drivers/hid/hid-input.c:
Mapping: Consumer.01ca ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313705] drivers/hid/hid-input.c:
Mapping: Consumer.01cb ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313708] drivers/hid/hid-input.c:
Mapping: Consumer.01cc ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313710] drivers/hid/hid-input.c:
Mapping: Consumer.01cd ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313713] drivers/hid/hid-input.c:
Mapping: Consumer.01ce ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313716] drivers/hid/hid-input.c:
Mapping: Consumer.01cf ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313719] drivers/hid/hid-input.c:
Mapping: Consumer.01d0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313722] drivers/hid/hid-input.c:
Mapping: Consumer.01d1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313725] drivers/hid/hid-input.c:
Mapping: Consumer.01d2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313728] drivers/hid/hid-input.c:
Mapping: Consumer.01d3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313731] drivers/hid/hid-input.c:
Mapping: Consumer.01d4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313734] drivers/hid/hid-input.c:
Mapping: Consumer.01d5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313737] drivers/hid/hid-input.c:
Mapping: Consumer.01d6 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313740] drivers/hid/hid-input.c:
Mapping: Consumer.01d7 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313743] drivers/hid/hid-input.c:
Mapping: Consumer.01d8 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313746] drivers/hid/hid-input.c:
Mapping: Consumer.01d9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313749] drivers/hid/hid-input.c:
Mapping: Consumer.01da ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313752] drivers/hid/hid-input.c:
Mapping: Consumer.01db ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313755] drivers/hid/hid-input.c:
Mapping: Consumer.01dc ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313757] drivers/hid/hid-input.c:
Mapping: Consumer.01dd ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313760] drivers/hid/hid-input.c:
Mapping: Consumer.01de ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313763] drivers/hid/hid-input.c:
Mapping: Consumer.01df ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313766] drivers/hid/hid-input.c:
Mapping: Consumer.01e0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313769] drivers/hid/hid-input.c:
Mapping: Consumer.01e1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313772] drivers/hid/hid-input.c:
Mapping: Consumer.01e2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313775] drivers/hid/hid-input.c:
Mapping: Consumer.01e3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313778] drivers/hid/hid-input.c:
Mapping: Consumer.01e4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313781] drivers/hid/hid-input.c:
Mapping: Consumer.01e5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313784] drivers/hid/hid-input.c:
Mapping: Consumer.01e6 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313787] drivers/hid/hid-input.c:
Mapping: Consumer.01e7 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313790] drivers/hid/hid-input.c:
Mapping: Consumer.01e8 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313793] drivers/hid/hid-input.c:
Mapping: Consumer.01e9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313796] drivers/hid/hid-input.c:
Mapping: Consumer.01ea ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313799] drivers/hid/hid-input.c:
Mapping: Consumer.01eb ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313801] drivers/hid/hid-input.c:
Mapping: Consumer.01ec ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313804] drivers/hid/hid-input.c:
Mapping: Consumer.01ed ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313807] drivers/hid/hid-input.c:
Mapping: Consumer.01ee ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313810] drivers/hid/hid-input.c:
Mapping: Consumer.01ef ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313813] drivers/hid/hid-input.c:
Mapping: Consumer.01f0 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313816] drivers/hid/hid-input.c:
Mapping: Consumer.01f1 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313819] drivers/hid/hid-input.c:
Mapping: Consumer.01f2 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313822] drivers/hid/hid-input.c:
Mapping: Consumer.01f3 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313825] drivers/hid/hid-input.c:
Mapping: Consumer.01f4 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313828] drivers/hid/hid-input.c:
Mapping: Consumer.01f5 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313831] drivers/hid/hid-input.c:
Mapping: Consumer.01f6 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313834] drivers/hid/hid-input.c:
Mapping: Consumer.01f7 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313837] drivers/hid/hid-input.c:
Mapping: Consumer.01f8 ---> IGNORED
Dec 28 13:31:32 adolfo NetworkManager: <debug> [1198855892.747667]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if0').
Dec 28 13:31:32 adolfo kernel: [ 3380.313840] drivers/hid/hid-input.c:
Mapping: Consumer.01f9 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313843] drivers/hid/hid-input.c:
Mapping: Consumer.01fa ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313845] drivers/hid/hid-input.c:
Mapping: Consumer.01fb ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313848] drivers/hid/hid-input.c:
Mapping: Consumer.01fc ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313851] drivers/hid/hid-input.c:
Mapping: Consumer.01fd ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313854] drivers/hid/hid-input.c:
Mapping: Consumer.01fe ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313857] drivers/hid/hid-input.c:
Mapping: Consumer.01ff ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313860] drivers/hid/hid-input.c:
Mapping: Consumer.0200 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313863] drivers/hid/hid-input.c:
Mapping: Consumer.0201 ---> Key.New
Dec 28 13:31:32 adolfo kernel: [ 3380.313866] drivers/hid/hid-input.c:
Mapping: Consumer.0202 ---> Key.Open
Dec 28 13:31:32 adolfo kernel: [ 3380.313869] drivers/hid/hid-input.c:
Mapping: Consumer.0203 ---> Key.Close
Dec 28 13:31:32 adolfo kernel: [ 3380.313873] drivers/hid/hid-input.c:
Mapping: Consumer.0204 ---> Key.Exit
Dec 28 13:31:32 adolfo kernel: [ 3380.313876] drivers/hid/hid-input.c:
Mapping: Consumer.0205 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313879] drivers/hid/hid-input.c:
Mapping: Consumer.0206 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313882] drivers/hid/hid-input.c:
Mapping: Consumer.0207 ---> Key.Save
Dec 28 13:31:32 adolfo kernel: [ 3380.313885] drivers/hid/hid-input.c:
Mapping: Consumer.0208 ---> Key.Print
Dec 28 13:31:32 adolfo kernel: [ 3380.313888] drivers/hid/hid-input.c:
Mapping: Consumer.0209 ---> Key.Props
Dec 28 13:31:32 adolfo kernel: [ 3380.313891] drivers/hid/hid-input.c:
Mapping: Consumer.020a ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313894] drivers/hid/hid-input.c:
Mapping: Consumer.020b ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313897] drivers/hid/hid-input.c:
Mapping: Consumer.020c ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313900] drivers/hid/hid-input.c:
Mapping: Consumer.020d ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313903] drivers/hid/hid-input.c:
Mapping: Consumer.020e ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313906] drivers/hid/hid-input.c:
Mapping: Consumer.020f ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313909] drivers/hid/hid-input.c:
Mapping: Consumer.0210 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313912] drivers/hid/hid-input.c:
Mapping: Consumer.0211 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313915] drivers/hid/hid-input.c:
Mapping: Consumer.0212 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313918] drivers/hid/hid-input.c:
Mapping: Consumer.0213 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313921] drivers/hid/hid-input.c:
Mapping: Consumer.0214 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313924] drivers/hid/hid-input.c:
Mapping: Consumer.0215 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313927] drivers/hid/hid-input.c:
Mapping: Consumer.0216 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313930] drivers/hid/hid-input.c:
Mapping: Consumer.0217 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313933] drivers/hid/hid-input.c:
Mapping: Consumer.0218 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313936] drivers/hid/hid-input.c:
Mapping: Consumer.0219 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313939] drivers/hid/hid-input.c:
Mapping: Consumer.021a ---> Key.Undo
Dec 28 13:31:32 adolfo kernel: [ 3380.313942] drivers/hid/hid-input.c:
Mapping: Consumer.021b ---> Key.Copy
Dec 28 13:31:32 adolfo kernel: [ 3380.313945] drivers/hid/hid-input.c:
Mapping: Consumer.021c ---> Key.Cut
Dec 28 13:31:32 adolfo kernel: [ 3380.313948] drivers/hid/hid-input.c:
Mapping: Consumer.021d ---> Key.Paste
Dec 28 13:31:32 adolfo NetworkManager: <debug> [1198855892.828791]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if1').
Dec 28 13:31:32 adolfo kernel: [ 3380.313952] drivers/hid/hid-input.c:
Mapping: Consumer.021e ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313955] drivers/hid/hid-input.c:
Mapping: Consumer.021f ---> Key.Find
Dec 28 13:31:32 adolfo kernel: [ 3380.313958] drivers/hid/hid-input.c:
Mapping: Consumer.0220 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313961] drivers/hid/hid-input.c:
Mapping: Consumer.0221 ---> Key.Search
Dec 28 13:31:32 adolfo kernel: [ 3380.313964] drivers/hid/hid-input.c:
Mapping: Consumer.0222 ---> Key.Goto
Dec 28 13:31:32 adolfo kernel: [ 3380.313967] drivers/hid/hid-input.c:
Mapping: Consumer.0223 ---> Key.HomePage
Dec 28 13:31:32 adolfo kernel: [ 3380.313970] drivers/hid/hid-input.c:
Mapping: Consumer.0224 ---> Key.Back
Dec 28 13:31:32 adolfo kernel: [ 3380.313974] drivers/hid/hid-input.c:
Mapping: Consumer.0225 ---> Key.Forward
Dec 28 13:31:32 adolfo kernel: [ 3380.313977] drivers/hid/hid-input.c:
Mapping: Consumer.0226 ---> Key.Stop
Dec 28 13:31:32 adolfo kernel: [ 3380.313980] drivers/hid/hid-input.c:
Mapping: Consumer.0227 ---> Key.Refresh
Dec 28 13:31:32 adolfo kernel: [ 3380.313983] drivers/hid/hid-input.c:
Mapping: Consumer.0228 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313986] drivers/hid/hid-input.c:
Mapping: Consumer.0229 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313989] drivers/hid/hid-input.c:
Mapping: Consumer.022a ---> Key.Bookmarks
Dec 28 13:31:32 adolfo kernel: [ 3380.313993] drivers/hid/hid-input.c:
Mapping: Consumer.022b ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313996] drivers/hid/hid-input.c:
Mapping: Consumer.022c ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.313999] drivers/hid/hid-input.c:
Mapping: Consumer.022d ---> Key.?
Dec 28 13:31:32 adolfo kernel: [ 3380.314002] drivers/hid/hid-input.c:
Mapping: Consumer.022e ---> Key.?
Dec 28 13:31:32 adolfo kernel: [ 3380.314005] drivers/hid/hid-input.c:
Mapping: Consumer.022f ---> Key.?
Dec 28 13:31:32 adolfo kernel: [ 3380.314008] drivers/hid/hid-input.c:
Mapping: Consumer.0230 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314011] drivers/hid/hid-input.c:
Mapping: Consumer.0231 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314014] drivers/hid/hid-input.c:
Mapping: Consumer.0232 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314017] drivers/hid/hid-input.c:
Mapping: Consumer.0233 ---> Key.ScrollUp
Dec 28 13:31:32 adolfo kernel: [ 3380.314020] drivers/hid/hid-input.c:
Mapping: Consumer.0234 ---> Key.ScrollDown
Dec 28 13:31:32 adolfo kernel: [ 3380.314024] drivers/hid/hid-input.c:
Mapping: Consumer.0235 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314027] drivers/hid/hid-input.c:
Mapping: Consumer.0236 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314030] drivers/hid/hid-input.c:
Mapping: Consumer.0237 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314032] drivers/hid/hid-input.c:
Mapping: Consumer.HorizontalWheel ---> Relative.HWheel
Dec 28 13:31:32 adolfo kernel: [ 3380.314036] drivers/hid/hid-input.c:
Mapping: Consumer.0239 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314039] drivers/hid/hid-input.c:
Mapping: Consumer.023a ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314042] drivers/hid/hid-input.c:
Mapping: Consumer.023b ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314045] drivers/hid/hid-input.c:
Mapping: Consumer.023c ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314048] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemPowerDown ---> Key.Power
Dec 28 13:31:32 adolfo kernel: [ 3380.314051] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemSleep ---> Key.Sleep
Dec 28 13:31:32 adolfo kernel: [ 3380.314055] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemWakeUp ---> Key.WakeUp
Dec 28 13:31:32 adolfo kernel: [ 3380.314058] drivers/hid/hid-input.c:
Mapping: ff01.0020 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314062] drivers/hid/hid-input.c:
Mapping: ff01.0021 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314066] drivers/hid/hid-input.c:
Mapping: ff01.0022 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314069] drivers/hid/hid-input.c:
Mapping: ff01.0023 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314073] drivers/hid/hid-input.c:
Mapping: ff01.0024 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314077] drivers/hid/hid-input.c:
Mapping: ff01.0025 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314081] drivers/hid/hid-input.c:
Mapping: ff01.0026 ---> IGNORED
Dec 28 13:31:32 adolfo kernel: [ 3380.314164] input: Gyration Gyration
RF Technology Receiver as
/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input24
Dec 28 13:31:32 adolfo kernel: [ 3380.339043] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:32 adolfo kernel: [ 3380.339048] drivers/hid/hid-core.c:
report 0 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:31:32 adolfo kernel: [ 3380.339052] drivers/hid/hid-core.c:
undefined report_id 0 received
Dec 28 13:31:32 adolfo kernel: [ 3380.352280] evbug.c: Connected
device: "Gyration Gyration RF Technology Receiver",
usb-0000:00:02.0-9/input0
Dec 28 13:31:32 adolfo kernel: [ 3380.352358] input,hiddev96,hidraw3:
USB HID v1.10 Keyboard [Gyration Gyration RF Technology Receiver] on
usb-0000:00:02.0-9
Dec 28 13:31:32 adolfo kernel: [ 3380.352441]
drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
Dec 28 13:31:32 adolfo kernel: [ 3380.362227]
drivers/hid/usbhid/hid-core.c: report descriptor (size 154, read 154)
=  05 01 09 02 a1 01 85 01 09 01 a1 00 05 09 19 01 29 05 15 00 25 01
95 05 75 01 81 02 95 01 75 03 81 01 05 01 09 30 09 31 09 38 15 81 25
7f 75 08 95 03 81 06 c0 c0 05 0c 09 01 a1 01 85 02 19 00 2a 3c 02 15
00 26 3c 02 95 01 75 10 81 00 c0 05 01 09 80 a1 01 85 03 19 81 29 83
25 01 75 01 95 03 81 02 95 05 81 01 c0 06 00 ff 09 01 a1 01 85 05 05
07 15 00 25 7f 19 00 29 7f 95 02 75 08 81 00 c0 06 bc ff 09 88 a1 01
85 06 19 00 29 ff 15 00 25 7f 95 02 75 08 81 00 c0
Dec 28 13:31:32 adolfo kernel: [ 3380.362475]   INPUT(1)[INPUT]
Dec 28 13:31:32 adolfo kernel: [ 3380.362478]     Field(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.362479]
Physical(GenericDesktop.Pointer)
Dec 28 13:31:32 adolfo kernel: [ 3380.362482]       Usage(5)
Dec 28 13:31:32 adolfo kernel: [ 3380.362483]         Button.0001
Dec 28 13:31:32 adolfo kernel: [ 3380.362486]         Button.0002
Dec 28 13:31:32 adolfo kernel: [ 3380.362488]         Button.0003
Dec 28 13:31:32 adolfo kernel: [ 3380.362490]         Button.0004
Dec 28 13:31:32 adolfo kernel: [ 3380.362492]         Button.0005
Dec 28 13:31:32 adolfo kernel: [ 3380.362494]       Logical Minimum(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.362496]       Logical Maximum(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.362497]       Report Size(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.362498]       Report Count(5)
Dec 28 13:31:32 adolfo kernel: [ 3380.362500]       Report Offset(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.362501]       Flags( Variable Absolute )
Dec 28 13:31:32 adolfo kernel: [ 3380.362504]     Field(1)
Dec 28 13:31:32 adolfo kernel: [ 3380.362506]
Physical(GenericDesktop.Pointer)
Dec 28 13:31:32 adolfo kernel: [ 3380.362508]       Usage(3)
Dec 28 13:31:32 adolfo kernel: [ 3380.362509]         GenericDesktop.X
Dec 28 13:31:32 adolfo kernel: [ 3380.362511]         GenericDesktop.Y
Dec 28 13:31:32 adolfo kernel: [ 3380.362513]         GenericDesktop.Wheel
Dec 28 13:31:32 adolfo kernel: [ 3380.362515]       Logical Minimum(-127)
Dec 28 13:31:32 adolfo kernel: [ 3380.362517]       Logical Maximum(127)
Dec 28 13:31:32 adolfo kernel: [ 3380.362518]       Report Size(8)
Dec 28 13:31:32 adolfo kernel: [ 3380.362520]       Report Count(3)
Dec 28 13:31:32 adolfo kernel: [ 3380.362521]       Report Offset(8)
Dec 28 13:31:32 adolfo kernel: [ 3380.362522]       Flags( Variable Relative )
Dec 28 13:31:32 adolfo kernel: [ 3380.362525]   INPUT(2)[INPUT]
Dec 28 13:31:32 adolfo kernel: [ 3380.362527]     Field(0)
Dec 28 13:31:32 adolfo kernel: [ 3380.362529]       Usage(573)
Dec 28 13:31:32 adolfo kernel: [ 3380.362530]         Consumer.0000
Dec 28 13:31:32 adolfo kernel: [ 3380.362532]         Consumer.0001
Dec 28 13:31:32 adolfo kernel: [ 3380.362534]         Consumer.0002
Dec 28 13:31:32 adolfo kernel: [ 3380.362536]         Consumer.0003
Dec 28 13:31:32 adolfo kernel: [ 3380.362538]         Consumer.0004
Dec 28 13:31:32 adolfo kernel: [ 3380.362540]         Consumer.0005
Dec 28 13:31:32 adolfo kernel: [ 3380.362542]         Consumer.0006
Dec 28 13:31:32 adolfo kernel: [ 3380.362544]         Consumer.0007
Dec 28 13:31:32 adolfo kernel: [ 3380.362546]         Consumer.0008
Dec 28 13:31:32 adolfo kernel: [ 3380.362548]         Consumer.0009
Dec 28 13:31:32 adolfo kernel: [ 3380.362550]         Consumer.000a
Dec 28 13:31:32 adolfo kernel: [ 3380.362552]         Consumer.000b
Dec 28 13:31:32 adolfo kernel: [ 3380.362554]         Consumer.000c
Dec 28 13:31:32 adolfo kernel: [ 3380.362556]         Consumer.000d
Dec 28 13:31:32 adolfo kernel: [ 3380.362558]         Consumer.000e
Dec 28 13:31:32 adolfo kernel: [ 3380.362560]         Consumer.000f
Dec 28 13:31:32 adolfo kernel: [ 3380.362563]         Consumer.0010
Dec 28 13:31:32 adolfo kernel: [ 3380.362565]         Consumer.0011
Dec 28 13:31:32 adolfo kernel: [ 3380.362567]         Consumer.0012
Dec 28 13:31:32 adolfo kernel: [ 3380.362569]         Consumer.0013
Dec 28 13:31:32 adolfo kernel: [ 3380.362571]         Consumer.0014
Dec 28 13:31:32 adolfo kernel: [ 3380.362573]         Consumer.0015
Dec 28 13:31:32 adolfo kernel: [ 3380.362575]         Consumer.0016
Dec 28 13:31:32 adolfo kernel: [ 3380.362577]         Consumer.0017
Dec 28 13:31:32 adolfo kernel: [ 3380.362579]         Consumer.0018
Dec 28 13:31:32 adolfo kernel: [ 3380.362581]         Consumer.0019
Dec 28 13:31:32 adolfo kernel: [ 3380.362583]         Consumer.001a
Dec 28 13:31:32 adolfo kernel: [ 3380.362585]         Consumer.001b
Dec 28 13:31:32 adolfo kernel: [ 3380.362587]         Consumer.001c
Dec 28 13:31:32 adolfo kernel: [ 3380.362589]         Consumer.001d
Dec 28 13:31:32 adolfo kernel: [ 3380.362591]         Consumer.001e
Dec 28 13:31:32 adolfo kernel: [ 3380.362593]         Consumer.001f
Dec 28 13:31:32 adolfo kernel: [ 3380.362595]         Consumer.0020
Dec 28 13:31:32 adolfo kernel: [ 3380.362597]         Consumer.0021
Dec 28 13:31:32 adolfo kernel: [ 3380.362599]         Consumer.0022
Dec 28 13:31:32 adolfo kernel: [ 3380.362601]         Consumer.0023
Dec 28 13:31:32 adolfo kernel: [ 3380.362603]         Consumer.0024
Dec 28 13:31:32 adolfo kernel: [ 3380.362605]         Consumer.0025
Dec 28 13:31:32 adolfo kernel: [ 3380.362607]         Consumer.0026
Dec 28 13:31:32 adolfo kernel: [ 3380.362609]         Consumer.0027
Dec 28 13:31:32 adolfo kernel: [ 3380.362611]         Consumer.0028
Dec 28 13:31:32 adolfo kernel: [ 3380.362613]         Consumer.0029
Dec 28 13:31:32 adolfo kernel: [ 3380.362615]         Consumer.002a
Dec 28 13:31:32 adolfo kernel: [ 3380.362617]         Consumer.002b
Dec 28 13:31:32 adolfo kernel: [ 3380.362619]         Consumer.002c
Dec 28 13:31:32 adolfo kernel: [ 3380.362621]         Consumer.002d
Dec 28 13:31:32 adolfo kernel: [ 3380.362623]         Consumer.002e
Dec 28 13:31:32 adolfo kernel: [ 3380.362625]         Consumer.002f
Dec 28 13:31:32 adolfo kernel: [ 3380.362627]         Consumer.0030
Dec 28 13:31:32 adolfo kernel: [ 3380.362629]         Consumer.0031
Dec 28 13:31:32 adolfo kernel: [ 3380.362631]         Consumer.0032
Dec 28 13:31:32 adolfo kernel: [ 3380.362633]         Consumer.0033
Dec 28 13:31:32 adolfo kernel: [ 3380.362635]         Consumer.0034
Dec 28 13:31:32 adolfo kernel: [ 3380.362637]         Consumer.0035
Dec 28 13:31:32 adolfo kernel: [ 3380.362639]         Consumer.0036
Dec 28 13:31:32 adolfo kernel: [ 3380.362641]         Consumer.0037
Dec 28 13:31:32 adolfo kernel: [ 3380.362643]         Consumer.0038
Dec 28 13:31:32 adolfo kernel: [ 3380.362645]         Consumer.0039
Dec 28 13:31:32 adolfo kernel: [ 3380.362647]         Consumer.003a
Dec 28 13:31:32 adolfo kernel: [ 3380.362650]         Consumer.003b
Dec 28 13:31:32 adolfo kernel: [ 3380.362652]         Consumer.003c
Dec 28 13:31:32 adolfo kernel: [ 3380.362654]         Consumer.003d
Dec 28 13:31:32 adolfo kernel: [ 3380.362656]         Consumer.003e
Dec 28 13:31:32 adolfo kernel: [ 3380.362658]         Consumer.003f
Dec 28 13:31:32 adolfo kernel: [ 3380.362660]         Consumer.0040
Dec 28 13:31:32 adolfo kernel: [ 3380.362662]         Consumer.0041
Dec 28 13:31:32 adolfo kernel: [ 3380.362664]         Consumer.0042
Dec 28 13:31:32 adolfo kernel: [ 3380.362666]         Consumer.0043
Dec 28 13:31:32 adolfo kernel: [ 3380.362668]         Consumer.0044
Dec 28 13:31:32 adolfo kernel: [ 3380.362670]         Consumer.0045
Dec 28 13:31:32 adolfo kernel: [ 3380.362672]         Consumer.0046
Dec 28 13:31:32 adolfo kernel: [ 3380.362674]         Consumer.0047
Dec 28 13:31:32 adolfo kernel: [ 3380.362676]         Consumer.0048
Dec 28 13:31:32 adolfo kernel: [ 3380.362678]         Consumer.0049
Dec 28 13:31:32 adolfo kernel: [ 3380.362680]         Consumer.004a
Dec 28 13:31:32 adolfo kernel: [ 3380.362682]         Consumer.004b
Dec 28 13:31:32 adolfo kernel: [ 3380.362684]         Consumer.004c
Dec 28 13:31:32 adolfo kernel: [ 3380.362686]         Consumer.004d
Dec 28 13:31:32 adolfo kernel: [ 3380.362688]         Consumer.004e
Dec 28 13:31:32 adolfo kernel: [ 3380.362690]         Consumer.004f
Dec 28 13:31:32 adolfo kernel: [ 3380.362692]         Consumer.0050
Dec 28 13:31:32 adolfo kernel: [ 3380.362694]         Consumer.0051
Dec 28 13:31:32 adolfo kernel: [ 3380.362696]         Consumer.0052
Dec 28 13:31:32 adolfo kernel: [ 3380.362698]         Consumer.0053
Dec 28 13:31:32 adolfo kernel: [ 3380.362700]         Consumer.0054
Dec 28 13:31:32 adolfo kernel: [ 3380.362702]         Consumer.0055
Dec 28 13:31:32 adolfo kernel: [ 3380.362704]         Consumer.0056
Dec 28 13:31:32 adolfo kernel: [ 3380.362706]         Consumer.0057
Dec 28 13:31:32 adolfo kernel: [ 3380.362708]         Consumer.0058
Dec 28 13:31:32 adolfo kernel: [ 3380.362710]         Consumer.0059
Dec 28 13:31:32 adolfo kernel: [ 3380.362712]         Consumer.005a
Dec 28 13:31:32 adolfo kernel: [ 3380.362714]         Consumer.005b
Dec 28 13:31:32 adolfo kernel: [ 3380.362716]         Consumer.005c
Dec 28 13:31:32 adolfo kernel: [ 3380.362718]         Consumer.005d
Dec 28 13:31:32 adolfo kernel: [ 3380.362720]         Consumer.005e
Dec 28 13:31:32 adolfo kernel: [ 3380.362722]         Consumer.005f
Dec 28 13:31:32 adolfo kernel: [ 3380.362724]         Consumer.0060
Dec 28 13:31:32 adolfo kernel: [ 3380.362726]         Consumer.0061
Dec 28 13:31:32 adolfo kernel: [ 3380.362728]         Consumer.0062
Dec 28 13:31:32 adolfo kernel: [ 3380.362730]         Consumer.0063
Dec 28 13:31:32 adolfo kernel: [ 3380.362732]         Consumer.0064
Dec 28 13:31:32 adolfo kernel: [ 3380.362734]         Consumer.0065
Dec 28 13:31:32 adolfo kernel: [ 3380.362736]         Consumer.0066
Dec 28 13:31:32 adolfo kernel: [ 3380.362738]         Consumer.0067
Dec 28 13:31:32 adolfo kernel: [ 3380.362740]         Consumer.0068
Dec 28 13:31:32 adolfo kernel: [ 3380.362742]         Consumer.0069
Dec 28 13:31:32 adolfo kernel: [ 3380.362744]         Consumer.006a
Dec 28 13:31:32 adolfo kernel: [ 3380.362746]         Consumer.006b
Dec 28 13:31:32 adolfo kernel: [ 3380.362748]         Consumer.006c
Dec 28 13:31:32 adolfo kernel: [ 3380.362750]         Consumer.006d
Dec 28 13:31:32 adolfo kernel: [ 3380.362752]         Consumer.006e
Dec 28 13:31:32 adolfo kernel: [ 3380.362754]         Consumer.006f
Dec 28 13:31:32 adolfo kernel: [ 3380.362756]         Consumer.0070
Dec 28 13:31:32 adolfo kernel: [ 3380.362758]         Consumer.0071
Dec 28 13:31:32 adolfo kernel: [ 3380.362760]         Consumer.0072
Dec 28 13:31:32 adolfo kernel: [ 3380.362763]         Consumer.0073
Dec 28 13:31:32 adolfo kernel: [ 3380.362765]         Consumer.0074
Dec 28 13:31:32 adolfo kernel: [ 3380.362767]         Consumer.0075
Dec 28 13:31:32 adolfo kernel: [ 3380.362769]         Consumer.0076
Dec 28 13:31:32 adolfo kernel: [ 3380.362771]         Consumer.0077
Dec 28 13:31:32 adolfo kernel: [ 3380.362773]         Consumer.0078
Dec 28 13:31:32 adolfo kernel: [ 3380.362775]         Consumer.0079
Dec 28 13:31:32 adolfo kernel: [ 3380.362777]         Consumer.007a
Dec 28 13:31:32 adolfo kernel: [ 3380.362779]         Consumer.007b
Dec 28 13:31:32 adolfo kernel: [ 3380.362781]         Consumer.007c
Dec 28 13:31:32 adolfo kernel: [ 3380.362783]         Consumer.007d
Dec 28 13:31:32 adolfo kernel: [ 3380.362785]         Consumer.007e
Dec 28 13:31:32 adolfo kernel: [ 3380.362787]         Consumer.007f
Dec 28 13:31:32 adolfo kernel: [ 3380.362789]         Consumer.0080
Dec 28 13:31:32 adolfo kernel: [ 3380.362791]         Consumer.0081
Dec 28 13:31:32 adolfo kernel: [ 3380.362793]         Consumer.0082
Dec 28 13:31:32 adolfo kernel: [ 3380.362795]         Consumer.0083
Dec 28 13:31:32 adolfo kernel: [ 3380.362797]         Consumer.0084
Dec 28 13:31:32 adolfo kernel: [ 3380.362799]         Consumer.0085
Dec 28 13:31:32 adolfo kernel: [ 3380.362801]         Consumer.0086
Dec 28 13:31:32 adolfo kernel: [ 3380.362803]         Consumer.0087
Dec 28 13:31:32 adolfo kernel: [ 3380.362805]         Consumer.0088
Dec 28 13:31:32 adolfo kernel: [ 3380.362807]         Consumer.0089
Dec 28 13:31:32 adolfo kernel: [ 3380.362809]         Consumer.008a
Dec 28 13:31:32 adolfo kernel: [ 3380.362811]         Consumer.008b
Dec 28 13:31:32 adolfo kernel: [ 3380.362813]         Consumer.008c
Dec 28 13:31:32 adolfo kernel: [ 3380.362815]         Consumer.008d
Dec 28 13:31:32 adolfo kernel: [ 3380.362817]         Consumer.008e
Dec 28 13:31:32 adolfo kernel: [ 3380.362819]         Consumer.008f
Dec 28 13:31:32 adolfo kernel: [ 3380.362821]         Consumer.0090
Dec 28 13:31:32 adolfo kernel: [ 3380.362823]         Consumer.0091
Dec 28 13:31:32 adolfo kernel: [ 3380.362825]         Consumer.0092
Dec 28 13:31:32 adolfo kernel: [ 3380.362827]         Consumer.0093
Dec 28 13:31:32 adolfo kernel: [ 3380.362829]         Consumer.0094
Dec 28 13:31:32 adolfo kernel: [ 3380.362831]         Consumer.0095
Dec 28 13:31:32 adolfo kernel: [ 3380.362833]         Consumer.0096
Dec 28 13:31:32 adolfo kernel: [ 3380.362835]         Consumer.0097
Dec 28 13:31:32 adolfo kernel: [ 3380.362837]         Consumer.0098
Dec 28 13:31:32 adolfo kernel: [ 3380.362839]         Consumer.0099
Dec 28 13:31:32 adolfo kernel: [ 3380.362841]         Consumer.009a
Dec 28 13:31:32 adolfo kernel: [ 3380.362843]         Consumer.009b
Dec 28 13:31:32 adolfo kernel: [ 3380.362845]         Consumer.009c
Dec 28 13:31:32 adolfo kernel: [ 3380.362847]         Consumer.009d
Dec 28 13:31:32 adolfo kernel: [ 3380.362849]         Consumer.009e
Dec 28 13:31:32 adolfo kernel: [ 3380.362851]         Consumer.009f
Dec 28 13:31:32 adolfo kernel: [ 3380.362853]         Consumer.00a0
Dec 28 13:31:32 adolfo kernel: [ 3380.362855]         Consumer.00a1
Dec 28 13:31:32 adolfo kernel: [ 3380.362857]         Consumer.00a2
Dec 28 13:31:32 adolfo kernel: [ 3380.362859]         Consumer.00a3
Dec 28 13:31:32 adolfo kernel: [ 3380.362861]         Consumer.00a4
Dec 28 13:31:32 adolfo kernel: [ 3380.362863]         Consumer.00a5
Dec 28 13:31:32 adolfo kernel: [ 3380.362865]         Consumer.00a6
Dec 28 13:31:32 adolfo kernel: [ 3380.362867]         Consumer.00a7
Dec 28 13:31:32 adolfo kernel: [ 3380.362870]         Consumer.00a8
Dec 28 13:31:32 adolfo kernel: [ 3380.362872]         Consumer.00a9
Dec 28 13:31:32 adolfo kernel: [ 3380.362874]         Consumer.00aa
Dec 28 13:31:32 adolfo kernel: [ 3380.362876]         Consumer.00ab
Dec 28 13:31:32 adolfo kernel: [ 3380.362878]         Consumer.00ac
Dec 28 13:31:32 adolfo kernel: [ 3380.362880]         Consumer.00ad
Dec 28 13:31:32 adolfo kernel: [ 3380.362882]         Consumer.00ae
Dec 28 13:31:32 adolfo kernel: [ 3380.362884]         Consumer.00af
Dec 28 13:31:32 adolfo kernel: [ 3380.362886]         Consumer.00b0
Dec 28 13:31:32 adolfo kernel: [ 3380.362888]         Consumer.00b1
Dec 28 13:31:32 adolfo kernel: [ 3380.362890]         Consumer.00b2
Dec 28 13:31:32 adolfo kernel: [ 3380.362892]         Consumer.00b3
Dec 28 13:31:32 adolfo kernel: [ 3380.362894]         Consumer.00b4
Dec 28 13:31:32 adolfo kernel: [ 3380.362896]         Consumer.00b5
Dec 28 13:31:32 adolfo kernel: [ 3380.362898]         Consumer.00b6
Dec 28 13:31:32 adolfo kernel: [ 3380.362900]         Consumer.00b7
Dec 28 13:31:32 adolfo kernel: [ 3380.362902]         Consumer.00b8
Dec 28 13:31:32 adolfo kernel: [ 3380.362904]         Consumer.00b9
Dec 28 13:31:32 adolfo kernel: [ 3380.362906]         Consumer.00ba
Dec 28 13:31:32 adolfo kernel: [ 3380.362908]         Consumer.00bb
Dec 28 13:31:32 adolfo kernel: [ 3380.362910]         Consumer.00bc
Dec 28 13:31:32 adolfo kernel: [ 3380.362912]         Consumer.00bd
Dec 28 13:31:32 adolfo kernel: [ 3380.362914]         Consumer.00be
Dec 28 13:31:32 adolfo kernel: [ 3380.362916]         Consumer.00bf
Dec 28 13:31:32 adolfo kernel: [ 3380.362918]         Consumer.00c0
Dec 28 13:31:32 adolfo kernel: [ 3380.362920]         Consumer.00c1
Dec 28 13:31:32 adolfo kernel: [ 3380.362922]         Consumer.00c2
Dec 28 13:31:32 adolfo kernel: [ 3380.362924]         Consumer.00c3
Dec 28 13:31:32 adolfo kernel: [ 3380.362926]         Consumer.00c4
Dec 28 13:31:32 adolfo kernel: [ 3380.362928]         Consumer.00c5
Dec 28 13:31:32 adolfo kernel: [ 3380.362930]         Consumer.00c6
Dec 28 13:31:32 adolfo kernel: [ 3380.362932]         Consumer.00c7
Dec 28 13:31:32 adolfo kernel: [ 3380.362934]         Consumer.00c8
Dec 28 13:31:32 adolfo kernel: [ 3380.362936]         Consumer.00c9
Dec 28 13:31:32 adolfo kernel: [ 3380.362938]         Consumer.00ca
Dec 28 13:31:32 adolfo kernel: [ 3380.362940]         Consumer.00cb
Dec 28 13:31:32 adolfo kernel: [ 3380.362942]         Consumer.00cc
Dec 28 13:31:32 adolfo kernel: [ 3380.362944]         Consumer.00cd
Dec 28 13:31:32 adolfo kernel: [ 3380.362946]         Consumer.00ce
Dec 28 13:31:32 adolfo kernel: [ 3380.362948]         Consumer.00cf
Dec 28 13:31:32 adolfo kernel: [ 3380.362950]         Consumer.00d0
Dec 28 13:31:32 adolfo kernel: [ 3380.362952]         Consumer.00d1
Dec 28 13:31:32 adolfo kernel: [ 3380.362954]         Consumer.00d2
Dec 28 13:31:32 adolfo kernel: [ 3380.362956]         Consumer.00d3
Dec 28 13:31:32 adolfo kernel: [ 3380.362958]         Consumer.00d4
Dec 28 13:31:32 adolfo kernel: [ 3380.362960]         Consumer.00d5
Dec 28 13:31:32 adolfo kernel: [ 3380.362962]         Consumer.00d6
Dec 28 13:31:32 adolfo kernel: [ 3380.362964]         Consumer.00d7
Dec 28 13:31:32 adolfo kernel: [ 3380.362966]         Consumer.00d8
Dec 28 13:31:32 adolfo kernel: [ 3380.362968]         Consumer.00d9
Dec 28 13:31:32 adolfo kernel: [ 3380.362970]         Consumer.00da
Dec 28 13:31:32 adolfo kernel: [ 3380.362972]         Consumer.00db
Dec 28 13:31:32 adolfo kernel: [ 3380.362974]         Consumer.00dc
Dec 28 13:31:32 adolfo kernel: [ 3380.362976]         Consumer.00dd
Dec 28 13:31:32 adolfo kernel: [ 3380.362978]         Consumer.00de
Dec 28 13:31:32 adolfo kernel: [ 3380.362980]         Consumer.00df
Dec 28 13:31:32 adolfo kernel: [ 3380.362983]         Consumer.00e0
Dec 28 13:31:32 adolfo kernel: [ 3380.362985]         Consumer.00e1
Dec 28 13:31:32 adolfo kernel: [ 3380.362987]         Consumer.00e2
Dec 28 13:31:32 adolfo kernel: [ 3380.362989]         Consumer.00e3
Dec 28 13:31:32 adolfo kernel: [ 3380.362991]         Consumer.00e4
Dec 28 13:31:32 adolfo kernel: [ 3380.362993]         Consumer.00e5
Dec 28 13:31:32 adolfo kernel: [ 3380.362995]         Consumer.00e6
Dec 28 13:31:32 adolfo kernel: [ 3380.362997]         Consumer.00e7
Dec 28 13:31:32 adolfo kernel: [ 3380.362999]         Consumer.00e8
Dec 28 13:31:32 adolfo kernel: [ 3380.363001]         Consumer.00e9
Dec 28 13:31:32 adolfo kernel: [ 3380.363003]         Consumer.00ea
Dec 28 13:31:32 adolfo kernel: [ 3380.363005]         Consumer.00eb
Dec 28 13:31:32 adolfo kernel: [ 3380.363007]         Consumer.00ec
Dec 28 13:31:32 adolfo kernel: [ 3380.363009]         Consumer.00ed
Dec 28 13:31:32 adolfo kernel: [ 3380.363011]         Consumer.00ee
Dec 28 13:31:32 adolfo kernel: [ 3380.363013]         Consumer.00ef
Dec 28 13:31:32 adolfo kernel: [ 3380.363015]         Consumer.00f0
Dec 28 13:31:32 adolfo kernel: [ 3380.363017]         Consumer.00f1
Dec 28 13:31:32 adolfo kernel: [ 3380.363019]         Consumer.00f2
Dec 28 13:31:32 adolfo kernel: [ 3380.363021]         Consumer.00f3
Dec 28 13:31:32 adolfo kernel: [ 3380.363023]         Consumer.00f4
Dec 28 13:31:32 adolfo kernel: [ 3380.363025]         Consumer.00f5
Dec 28 13:31:32 adolfo kernel: [ 3380.363027]         Consumer.00f6
Dec 28 13:31:32 adolfo kernel: [ 3380.363029]         Consumer.00f7
Dec 28 13:31:32 adolfo kernel: [ 3380.363031]         Consumer.00f8
Dec 28 13:31:32 adolfo kernel: [ 3380.363033]         Consumer.00f9
Dec 28 13:31:32 adolfo kernel: [ 3380.363035]         Consumer.00fa
Dec 28 13:31:32 adolfo kernel: [ 3380.363037]         Consumer.00fb
Dec 28 13:31:32 adolfo kernel: [ 3380.363039]         Consumer.00fc
Dec 28 13:31:32 adolfo kernel: [ 3380.363041]         Consumer.00fd
Dec 28 13:31:32 adolfo kernel: [ 3380.363043]         Consumer.00fe
Dec 28 13:31:32 adolfo kernel: [ 3380.363045]         Consumer.00ff
Dec 28 13:31:32 adolfo kernel: [ 3380.363047]         Consumer.0100
Dec 28 13:31:32 adolfo kernel: [ 3380.363049]         Consumer.0101
Dec 28 13:31:32 adolfo kernel: [ 3380.363051]         Consumer.0102
Dec 28 13:31:32 adolfo kernel: [ 3380.363053]         Consumer.0103
Dec 28 13:31:32 adolfo kernel: [ 3380.363055]         Consumer.0104
Dec 28 13:31:32 adolfo kernel: [ 3380.363058]         Consumer.0105
Dec 28 13:31:32 adolfo kernel: [ 3380.363060]         Consumer.0106
Dec 28 13:31:32 adolfo kernel: [ 3380.363062]         Consumer.0107
Dec 28 13:31:32 adolfo kernel: [ 3380.363064]         Consumer.0108
Dec 28 13:31:32 adolfo kernel: [ 3380.363066]         Consumer.0109
Dec 28 13:31:32 adolfo kernel: [ 3380.363068]         Consumer.010a
Dec 28 13:31:32 adolfo kernel: [ 3380.363070]         Consumer.010b
Dec 28 13:31:32 adolfo NetworkManager: <debug> [1198855892.989131]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if0_logicaldev_input').
Dec 28 13:31:33 adolfo kernel: [ 3380.363072]         Consumer.010c
Dec 28 13:31:33 adolfo kernel: [ 3380.363074]         Consumer.010d
Dec 28 13:31:33 adolfo kernel: [ 3380.363076]         Consumer.010e
Dec 28 13:31:33 adolfo kernel: [ 3380.363078]         Consumer.010f
Dec 28 13:31:33 adolfo kernel: [ 3380.363080]         Consumer.0110
Dec 28 13:31:33 adolfo kernel: [ 3380.363082]         Consumer.0111
Dec 28 13:31:33 adolfo kernel: [ 3380.363084]         Consumer.0112
Dec 28 13:31:33 adolfo kernel: [ 3380.363086]         Consumer.0113
Dec 28 13:31:33 adolfo kernel: [ 3380.363088]         Consumer.0114
Dec 28 13:31:33 adolfo kernel: [ 3380.363090]         Consumer.0115
Dec 28 13:31:33 adolfo kernel: [ 3380.363092]         Consumer.0116
Dec 28 13:31:33 adolfo kernel: [ 3380.363094]         Consumer.0117
Dec 28 13:31:33 adolfo kernel: [ 3380.363096]         Consumer.0118
Dec 28 13:31:33 adolfo kernel: [ 3380.363098]         Consumer.0119
Dec 28 13:31:33 adolfo kernel: [ 3380.363100]         Consumer.011a
Dec 28 13:31:33 adolfo kernel: [ 3380.363102]         Consumer.011b
Dec 28 13:31:33 adolfo kernel: [ 3380.363104]         Consumer.011c
Dec 28 13:31:33 adolfo kernel: [ 3380.363106]         Consumer.011d
Dec 28 13:31:33 adolfo kernel: [ 3380.363108]         Consumer.011e
Dec 28 13:31:33 adolfo kernel: [ 3380.363110]         Consumer.011f
Dec 28 13:31:33 adolfo kernel: [ 3380.363112]         Consumer.0120
Dec 28 13:31:33 adolfo kernel: [ 3380.363114]         Consumer.0121
Dec 28 13:31:33 adolfo kernel: [ 3380.363116]         Consumer.0122
Dec 28 13:31:33 adolfo kernel: [ 3380.363118]         Consumer.0123
Dec 28 13:31:33 adolfo kernel: [ 3380.363120]         Consumer.0124
Dec 28 13:31:33 adolfo kernel: [ 3380.363122]         Consumer.0125
Dec 28 13:31:33 adolfo kernel: [ 3380.363124]         Consumer.0126
Dec 28 13:31:33 adolfo kernel: [ 3380.363126]         Consumer.0127
Dec 28 13:31:33 adolfo kernel: [ 3380.363128]         Consumer.0128
Dec 28 13:31:33 adolfo kernel: [ 3380.363130]         Consumer.0129
Dec 28 13:31:33 adolfo kernel: [ 3380.363132]         Consumer.012a
Dec 28 13:31:33 adolfo kernel: [ 3380.363135]         Consumer.012b
Dec 28 13:31:33 adolfo kernel: [ 3380.363137]         Consumer.012c
Dec 28 13:31:33 adolfo kernel: [ 3380.363139]         Consumer.012d
Dec 28 13:31:33 adolfo kernel: [ 3380.363141]         Consumer.012e
Dec 28 13:31:33 adolfo kernel: [ 3380.363143]         Consumer.012f
Dec 28 13:31:33 adolfo kernel: [ 3380.363145]         Consumer.0130
Dec 28 13:31:33 adolfo kernel: [ 3380.363147]         Consumer.0131
Dec 28 13:31:33 adolfo kernel: [ 3380.363149]         Consumer.0132
Dec 28 13:31:33 adolfo kernel: [ 3380.363151]         Consumer.0133
Dec 28 13:31:33 adolfo kernel: [ 3380.363153]         Consumer.0134
Dec 28 13:31:33 adolfo kernel: [ 3380.363155]         Consumer.0135
Dec 28 13:31:33 adolfo kernel: [ 3380.363157]         Consumer.0136
Dec 28 13:31:33 adolfo kernel: [ 3380.363159]         Consumer.0137
Dec 28 13:31:33 adolfo kernel: [ 3380.363161]         Consumer.0138
Dec 28 13:31:33 adolfo kernel: [ 3380.363163]         Consumer.0139
Dec 28 13:31:33 adolfo kernel: [ 3380.363165]         Consumer.013a
Dec 28 13:31:33 adolfo kernel: [ 3380.363167]         Consumer.013b
Dec 28 13:31:33 adolfo kernel: [ 3380.363169]         Consumer.013c
Dec 28 13:31:33 adolfo kernel: [ 3380.363171]         Consumer.013d
Dec 28 13:31:33 adolfo kernel: [ 3380.363173]         Consumer.013e
Dec 28 13:31:33 adolfo kernel: [ 3380.363175]         Consumer.013f
Dec 28 13:31:33 adolfo kernel: [ 3380.363177]         Consumer.0140
Dec 28 13:31:33 adolfo kernel: [ 3380.363179]         Consumer.0141
Dec 28 13:31:33 adolfo kernel: [ 3380.363181]         Consumer.0142
Dec 28 13:31:33 adolfo kernel: [ 3380.363183]         Consumer.0143
Dec 28 13:31:33 adolfo kernel: [ 3380.363185]         Consumer.0144
Dec 28 13:31:33 adolfo kernel: [ 3380.363187]         Consumer.0145
Dec 28 13:31:33 adolfo kernel: [ 3380.363189]         Consumer.0146
Dec 28 13:31:33 adolfo kernel: [ 3380.363191]         Consumer.0147
Dec 28 13:31:33 adolfo kernel: [ 3380.363193]         Consumer.0148
Dec 28 13:31:33 adolfo kernel: [ 3380.363195]         Consumer.0149
Dec 28 13:31:33 adolfo kernel: [ 3380.363197]         Consumer.014a
Dec 28 13:31:33 adolfo kernel: [ 3380.363199]         Consumer.014b
Dec 28 13:31:33 adolfo kernel: [ 3380.363201]         Consumer.014c
Dec 28 13:31:33 adolfo kernel: [ 3380.363203]         Consumer.014d
Dec 28 13:31:33 adolfo kernel: [ 3380.363205]         Consumer.014e
Dec 28 13:31:33 adolfo kernel: [ 3380.363207]         Consumer.014f
Dec 28 13:31:33 adolfo kernel: [ 3380.363210]         Consumer.0150
Dec 28 13:31:33 adolfo kernel: [ 3380.363212]         Consumer.0151
Dec 28 13:31:33 adolfo kernel: [ 3380.363214]         Consumer.0152
Dec 28 13:31:33 adolfo kernel: [ 3380.363216]         Consumer.0153
Dec 28 13:31:33 adolfo kernel: [ 3380.363218]         Consumer.0154
Dec 28 13:31:33 adolfo kernel: [ 3380.363220]         Consumer.0155
Dec 28 13:31:33 adolfo kernel: [ 3380.363222]         Consumer.0156
Dec 28 13:31:33 adolfo kernel: [ 3380.363224]         Consumer.0157
Dec 28 13:31:33 adolfo kernel: [ 3380.363226]         Consumer.0158
Dec 28 13:31:33 adolfo kernel: [ 3380.363228]         Consumer.0159
Dec 28 13:31:33 adolfo kernel: [ 3380.363230]         Consumer.015a
Dec 28 13:31:33 adolfo kernel: [ 3380.363232]         Consumer.015b
Dec 28 13:31:33 adolfo kernel: [ 3380.363234]         Consumer.015c
Dec 28 13:31:33 adolfo kernel: [ 3380.363236]         Consumer.015d
Dec 28 13:31:33 adolfo kernel: [ 3380.363238]         Consumer.015e
Dec 28 13:31:33 adolfo kernel: [ 3380.363240]         Consumer.015f
Dec 28 13:31:33 adolfo kernel: [ 3380.363242]         Consumer.0160
Dec 28 13:31:33 adolfo kernel: [ 3380.363244]         Consumer.0161
Dec 28 13:31:33 adolfo kernel: [ 3380.363246]         Consumer.0162
Dec 28 13:31:33 adolfo kernel: [ 3380.363248]         Consumer.0163
Dec 28 13:31:33 adolfo kernel: [ 3380.363250]         Consumer.0164
Dec 28 13:31:33 adolfo kernel: [ 3380.363252]         Consumer.0165
Dec 28 13:31:33 adolfo kernel: [ 3380.363254]         Consumer.0166
Dec 28 13:31:33 adolfo kernel: [ 3380.363256]         Consumer.0167
Dec 28 13:31:33 adolfo kernel: [ 3380.363258]         Consumer.0168
Dec 28 13:31:33 adolfo kernel: [ 3380.363260]         Consumer.0169
Dec 28 13:31:33 adolfo kernel: [ 3380.363262]         Consumer.016a
Dec 28 13:31:33 adolfo kernel: [ 3380.363264]         Consumer.016b
Dec 28 13:31:33 adolfo kernel: [ 3380.363266]         Consumer.016c
Dec 28 13:31:33 adolfo kernel: [ 3380.363268]         Consumer.016d
Dec 28 13:31:33 adolfo kernel: [ 3380.363270]         Consumer.016e
Dec 28 13:31:33 adolfo kernel: [ 3380.363272]         Consumer.016f
Dec 28 13:31:33 adolfo kernel: [ 3380.363274]         Consumer.0170
Dec 28 13:31:33 adolfo kernel: [ 3380.363276]         Consumer.0171
Dec 28 13:31:33 adolfo kernel: [ 3380.363278]         Consumer.0172
Dec 28 13:31:33 adolfo kernel: [ 3380.363280]         Consumer.0173
Dec 28 13:31:33 adolfo kernel: [ 3380.363282]         Consumer.0174
Dec 28 13:31:33 adolfo kernel: [ 3380.363285]         Consumer.0175
Dec 28 13:31:33 adolfo kernel: [ 3380.363287]         Consumer.0176
Dec 28 13:31:33 adolfo kernel: [ 3380.363289]         Consumer.0177
Dec 28 13:31:33 adolfo kernel: [ 3380.363291]         Consumer.0178
Dec 28 13:31:33 adolfo kernel: [ 3380.363293]         Consumer.0179
Dec 28 13:31:33 adolfo kernel: [ 3380.363295]         Consumer.017a
Dec 28 13:31:33 adolfo kernel: [ 3380.363297]         Consumer.017b
Dec 28 13:31:33 adolfo kernel: [ 3380.363299]         Consumer.017c
Dec 28 13:31:33 adolfo kernel: [ 3380.363301]         Consumer.017d
Dec 28 13:31:33 adolfo kernel: [ 3380.363303]         Consumer.017e
Dec 28 13:31:33 adolfo kernel: [ 3380.363305]         Consumer.017f
Dec 28 13:31:33 adolfo kernel: [ 3380.363307]         Consumer.0180
Dec 28 13:31:33 adolfo kernel: [ 3380.363309]         Consumer.0181
Dec 28 13:31:33 adolfo kernel: [ 3380.363311]         Consumer.0182
Dec 28 13:31:33 adolfo kernel: [ 3380.363313]         Consumer.0183
Dec 28 13:31:33 adolfo kernel: [ 3380.363315]         Consumer.0184
Dec 28 13:31:33 adolfo kernel: [ 3380.363317]         Consumer.0185
Dec 28 13:31:33 adolfo kernel: [ 3380.363319]         Consumer.0186
Dec 28 13:31:33 adolfo kernel: [ 3380.363321]         Consumer.0187
Dec 28 13:31:33 adolfo kernel: [ 3380.363323]         Consumer.0188
Dec 28 13:31:33 adolfo kernel: [ 3380.363325]         Consumer.0189
Dec 28 13:31:33 adolfo kernel: [ 3380.363327]         Consumer.018a
Dec 28 13:31:33 adolfo kernel: [ 3380.363329]         Consumer.018b
Dec 28 13:31:33 adolfo kernel: [ 3380.363331]         Consumer.018c
Dec 28 13:31:33 adolfo kernel: [ 3380.363333]         Consumer.018d
Dec 28 13:31:33 adolfo kernel: [ 3380.363335]         Consumer.018e
Dec 28 13:31:33 adolfo kernel: [ 3380.363337]         Consumer.018f
Dec 28 13:31:33 adolfo kernel: [ 3380.363339]         Consumer.0190
Dec 28 13:31:33 adolfo kernel: [ 3380.363341]         Consumer.0191
Dec 28 13:31:33 adolfo kernel: [ 3380.363343]         Consumer.0192
Dec 28 13:31:33 adolfo kernel: [ 3380.363345]         Consumer.0193
Dec 28 13:31:33 adolfo kernel: [ 3380.363347]         Consumer.0194
Dec 28 13:31:33 adolfo kernel: [ 3380.363349]         Consumer.0195
Dec 28 13:31:33 adolfo kernel: [ 3380.363351]         Consumer.0196
Dec 28 13:31:33 adolfo kernel: [ 3380.363353]         Consumer.0197
Dec 28 13:31:33 adolfo kernel: [ 3380.363355]         Consumer.0198
Dec 28 13:31:33 adolfo kernel: [ 3380.363357]         Consumer.0199
Dec 28 13:31:33 adolfo kernel: [ 3380.363359]         Consumer.019a
Dec 28 13:31:33 adolfo kernel: [ 3380.363362]         Consumer.019b
Dec 28 13:31:33 adolfo kernel: [ 3380.363364]         Consumer.019c
Dec 28 13:31:33 adolfo kernel: [ 3380.363366]         Consumer.019d
Dec 28 13:31:33 adolfo kernel: [ 3380.363368]         Consumer.019e
Dec 28 13:31:33 adolfo kernel: [ 3380.363370]         Consumer.019f
Dec 28 13:31:33 adolfo kernel: [ 3380.363372]         Consumer.01a0
Dec 28 13:31:33 adolfo kernel: [ 3380.363374]         Consumer.01a1
Dec 28 13:31:33 adolfo kernel: [ 3380.363376]         Consumer.01a2
Dec 28 13:31:33 adolfo kernel: [ 3380.363378]         Consumer.01a3
Dec 28 13:31:33 adolfo kernel: [ 3380.363380]         Consumer.01a4
Dec 28 13:31:33 adolfo kernel: [ 3380.363382]         Consumer.01a5
Dec 28 13:31:33 adolfo kernel: [ 3380.363384]         Consumer.01a6
Dec 28 13:31:33 adolfo kernel: [ 3380.363386]         Consumer.01a7
Dec 28 13:31:33 adolfo kernel: [ 3380.363388]         Consumer.01a8
Dec 28 13:31:33 adolfo kernel: [ 3380.363390]         Consumer.01a9
Dec 28 13:31:33 adolfo kernel: [ 3380.363392]         Consumer.01aa
Dec 28 13:31:33 adolfo kernel: [ 3380.363394]         Consumer.01ab
Dec 28 13:31:33 adolfo kernel: [ 3380.363396]         Consumer.01ac
Dec 28 13:31:33 adolfo kernel: [ 3380.363398]         Consumer.01ad
Dec 28 13:31:33 adolfo kernel: [ 3380.363400]         Consumer.01ae
Dec 28 13:31:33 adolfo kernel: [ 3380.363402]         Consumer.01af
Dec 28 13:31:33 adolfo kernel: [ 3380.363404]         Consumer.01b0
Dec 28 13:31:33 adolfo kernel: [ 3380.363406]         Consumer.01b1
Dec 28 13:31:33 adolfo kernel: [ 3380.363408]         Consumer.01b2
Dec 28 13:31:33 adolfo kernel: [ 3380.363410]         Consumer.01b3
Dec 28 13:31:33 adolfo kernel: [ 3380.363412]         Consumer.01b4
Dec 28 13:31:33 adolfo kernel: [ 3380.363414]         Consumer.01b5
Dec 28 13:31:33 adolfo kernel: [ 3380.363416]         Consumer.01b6
Dec 28 13:31:33 adolfo kernel: [ 3380.363418]         Consumer.01b7
Dec 28 13:31:33 adolfo kernel: [ 3380.363420]         Consumer.01b8
Dec 28 13:31:33 adolfo kernel: [ 3380.363422]         Consumer.01b9
Dec 28 13:31:33 adolfo kernel: [ 3380.363424]         Consumer.01ba
Dec 28 13:31:33 adolfo kernel: [ 3380.363426]         Consumer.01bb
Dec 28 13:31:33 adolfo kernel: [ 3380.363428]         Consumer.01bc
Dec 28 13:31:33 adolfo kernel: [ 3380.363430]         Consumer.01bd
Dec 28 13:31:33 adolfo kernel: [ 3380.363432]         Consumer.01be
Dec 28 13:31:33 adolfo kernel: [ 3380.363434]         Consumer.01bf
Dec 28 13:31:33 adolfo kernel: [ 3380.363436]         Consumer.01c0
Dec 28 13:31:33 adolfo kernel: [ 3380.363438]         Consumer.01c1
Dec 28 13:31:33 adolfo kernel: [ 3380.363440]         Consumer.01c2
Dec 28 13:31:33 adolfo kernel: [ 3380.363443]         Consumer.01c3
Dec 28 13:31:33 adolfo kernel: [ 3380.363445]         Consumer.01c4
Dec 28 13:31:33 adolfo kernel: [ 3380.363447]         Consumer.01c5
Dec 28 13:31:33 adolfo kernel: [ 3380.363449]         Consumer.01c6
Dec 28 13:31:33 adolfo kernel: [ 3380.363451]         Consumer.01c7
Dec 28 13:31:33 adolfo kernel: [ 3380.363453]         Consumer.01c8
Dec 28 13:31:33 adolfo kernel: [ 3380.363455]         Consumer.01c9
Dec 28 13:31:33 adolfo kernel: [ 3380.363457]         Consumer.01ca
Dec 28 13:31:33 adolfo kernel: [ 3380.363459]         Consumer.01cb
Dec 28 13:31:33 adolfo kernel: [ 3380.363461]         Consumer.01cc
Dec 28 13:31:33 adolfo kernel: [ 3380.363463]         Consumer.01cd
Dec 28 13:31:33 adolfo kernel: [ 3380.363465]         Consumer.01ce
Dec 28 13:31:33 adolfo kernel: [ 3380.363467]         Consumer.01cf
Dec 28 13:31:33 adolfo kernel: [ 3380.363469]         Consumer.01d0
Dec 28 13:31:33 adolfo kernel: [ 3380.363471]         Consumer.01d1
Dec 28 13:31:33 adolfo kernel: [ 3380.363473]         Consumer.01d2
Dec 28 13:31:33 adolfo kernel: [ 3380.363475]         Consumer.01d3
Dec 28 13:31:33 adolfo kernel: [ 3380.363477]         Consumer.01d4
Dec 28 13:31:33 adolfo kernel: [ 3380.363479]         Consumer.01d5
Dec 28 13:31:33 adolfo kernel: [ 3380.363481]         Consumer.01d6
Dec 28 13:31:33 adolfo kernel: [ 3380.363483]         Consumer.01d7
Dec 28 13:31:33 adolfo kernel: [ 3380.363485]         Consumer.01d8
Dec 28 13:31:33 adolfo kernel: [ 3380.363487]         Consumer.01d9
Dec 28 13:31:33 adolfo kernel: [ 3380.363489]         Consumer.01da
Dec 28 13:31:33 adolfo kernel: [ 3380.363491]         Consumer.01db
Dec 28 13:31:33 adolfo kernel: [ 3380.363493]         Consumer.01dc
Dec 28 13:31:33 adolfo kernel: [ 3380.363495]         Consumer.01dd
Dec 28 13:31:33 adolfo kernel: [ 3380.363497]         Consumer.01de
Dec 28 13:31:33 adolfo kernel: [ 3380.363499]         Consumer.01df
Dec 28 13:31:33 adolfo kernel: [ 3380.363501]         Consumer.01e0
Dec 28 13:31:33 adolfo kernel: [ 3380.363503]         Consumer.01e1
Dec 28 13:31:33 adolfo kernel: [ 3380.363505]         Consumer.01e2
Dec 28 13:31:33 adolfo kernel: [ 3380.363507]         Consumer.01e3
Dec 28 13:31:33 adolfo kernel: [ 3380.363509]         Consumer.01e4
Dec 28 13:31:33 adolfo kernel: [ 3380.363511]         Consumer.01e5
Dec 28 13:31:33 adolfo kernel: [ 3380.363514]         Consumer.01e6
Dec 28 13:31:33 adolfo kernel: [ 3380.363516]         Consumer.01e7
Dec 28 13:31:33 adolfo kernel: [ 3380.363518]         Consumer.01e8
Dec 28 13:31:33 adolfo kernel: [ 3380.363520]         Consumer.01e9
Dec 28 13:31:33 adolfo kernel: [ 3380.363522]         Consumer.01ea
Dec 28 13:31:33 adolfo kernel: [ 3380.363524]         Consumer.01eb
Dec 28 13:31:33 adolfo kernel: [ 3380.363526]         Consumer.01ec
Dec 28 13:31:33 adolfo kernel: [ 3380.363528]         Consumer.01ed
Dec 28 13:31:33 adolfo kernel: [ 3380.363530]         Consumer.01ee
Dec 28 13:31:33 adolfo kernel: [ 3380.363532]         Consumer.01ef
Dec 28 13:31:33 adolfo kernel: [ 3380.363534]         Consumer.01f0
Dec 28 13:31:33 adolfo kernel: [ 3380.363536]         Consumer.01f1
Dec 28 13:31:33 adolfo kernel: [ 3380.363538]         Consumer.01f2
Dec 28 13:31:33 adolfo kernel: [ 3380.363540]         Consumer.01f3
Dec 28 13:31:33 adolfo kernel: [ 3380.363542]         Consumer.01f4
Dec 28 13:31:33 adolfo kernel: [ 3380.363544]         Consumer.01f5
Dec 28 13:31:33 adolfo kernel: [ 3380.363546]         Consumer.01f6
Dec 28 13:31:33 adolfo kernel: [ 3380.363548]         Consumer.01f7
Dec 28 13:31:33 adolfo kernel: [ 3380.363550]         Consumer.01f8
Dec 28 13:31:33 adolfo kernel: [ 3380.363552]         Consumer.01f9
Dec 28 13:31:33 adolfo kernel: [ 3380.363554]         Consumer.01fa
Dec 28 13:31:33 adolfo kernel: [ 3380.363556]         Consumer.01fb
Dec 28 13:31:33 adolfo kernel: [ 3380.363558]         Consumer.01fc
Dec 28 13:31:33 adolfo kernel: [ 3380.363560]         Consumer.01fd
Dec 28 13:31:33 adolfo kernel: [ 3380.363562]         Consumer.01fe
Dec 28 13:31:33 adolfo kernel: [ 3380.363564]         Consumer.01ff
Dec 28 13:31:33 adolfo kernel: [ 3380.363566]         Consumer.0200
Dec 28 13:31:33 adolfo kernel: [ 3380.363568]         Consumer.0201
Dec 28 13:31:33 adolfo kernel: [ 3380.363570]         Consumer.0202
Dec 28 13:31:33 adolfo kernel: [ 3380.363572]         Consumer.0203
Dec 28 13:31:33 adolfo kernel: [ 3380.363574]         Consumer.0204
Dec 28 13:31:33 adolfo kernel: [ 3380.363576]         Consumer.0205
Dec 28 13:31:33 adolfo kernel: [ 3380.363578]         Consumer.0206
Dec 28 13:31:33 adolfo kernel: [ 3380.363580]         Consumer.0207
Dec 28 13:31:33 adolfo kernel: [ 3380.363582]         Consumer.0208
Dec 28 13:31:33 adolfo kernel: [ 3380.363584]         Consumer.0209
Dec 28 13:31:33 adolfo kernel: [ 3380.363586]         Consumer.020a
Dec 28 13:31:33 adolfo kernel: [ 3380.363589]         Consumer.020b
Dec 28 13:31:33 adolfo kernel: [ 3380.363591]         Consumer.020c
Dec 28 13:31:33 adolfo kernel: [ 3380.363593]         Consumer.020d
Dec 28 13:31:33 adolfo kernel: [ 3380.363595]         Consumer.020e
Dec 28 13:31:33 adolfo kernel: [ 3380.363597]         Consumer.020f
Dec 28 13:31:33 adolfo kernel: [ 3380.363599]         Consumer.0210
Dec 28 13:31:33 adolfo kernel: [ 3380.363601]         Consumer.0211
Dec 28 13:31:33 adolfo kernel: [ 3380.363603]         Consumer.0212
Dec 28 13:31:33 adolfo kernel: [ 3380.363605]         Consumer.0213
Dec 28 13:31:33 adolfo kernel: [ 3380.363607]         Consumer.0214
Dec 28 13:31:33 adolfo kernel: [ 3380.363609]         Consumer.0215
Dec 28 13:31:33 adolfo kernel: [ 3380.363611]         Consumer.0216
Dec 28 13:31:33 adolfo kernel: [ 3380.363613]         Consumer.0217
Dec 28 13:31:33 adolfo kernel: [ 3380.363615]         Consumer.0218
Dec 28 13:31:33 adolfo kernel: [ 3380.363617]         Consumer.0219
Dec 28 13:31:33 adolfo kernel: [ 3380.363619]         Consumer.021a
Dec 28 13:31:33 adolfo kernel: [ 3380.363621]         Consumer.021b
Dec 28 13:31:33 adolfo kernel: [ 3380.363623]         Consumer.021c
Dec 28 13:31:33 adolfo kernel: [ 3380.363625]         Consumer.021d
Dec 28 13:31:33 adolfo kernel: [ 3380.363627]         Consumer.021e
Dec 28 13:31:33 adolfo kernel: [ 3380.363629]         Consumer.021f
Dec 28 13:31:33 adolfo kernel: [ 3380.363631]         Consumer.0220
Dec 28 13:31:33 adolfo kernel: [ 3380.363633]         Consumer.0221
Dec 28 13:31:33 adolfo kernel: [ 3380.363635]         Consumer.0222
Dec 28 13:31:33 adolfo kernel: [ 3380.363637]         Consumer.0223
Dec 28 13:31:33 adolfo kernel: [ 3380.363639]         Consumer.0224
Dec 28 13:31:33 adolfo kernel: [ 3380.363641]         Consumer.0225
Dec 28 13:31:33 adolfo kernel: [ 3380.363643]         Consumer.0226
Dec 28 13:31:33 adolfo kernel: [ 3380.363645]         Consumer.0227
Dec 28 13:31:33 adolfo kernel: [ 3380.363647]         Consumer.0228
Dec 28 13:31:33 adolfo kernel: [ 3380.363649]         Consumer.0229
Dec 28 13:31:33 adolfo kernel: [ 3380.363651]         Consumer.022a
Dec 28 13:31:33 adolfo kernel: [ 3380.363653]         Consumer.022b
Dec 28 13:31:33 adolfo kernel: [ 3380.363655]         Consumer.022c
Dec 28 13:31:33 adolfo kernel: [ 3380.363657]         Consumer.022d
Dec 28 13:31:33 adolfo kernel: [ 3380.363659]         Consumer.022e
Dec 28 13:31:33 adolfo kernel: [ 3380.363661]         Consumer.022f
Dec 28 13:31:33 adolfo kernel: [ 3380.363664]         Consumer.0230
Dec 28 13:31:33 adolfo kernel: [ 3380.363666]         Consumer.0231
Dec 28 13:31:33 adolfo kernel: [ 3380.363668]         Consumer.0232
Dec 28 13:31:33 adolfo kernel: [ 3380.363670]         Consumer.0233
Dec 28 13:31:33 adolfo kernel: [ 3380.363672]         Consumer.0234
Dec 28 13:31:33 adolfo kernel: [ 3380.363674]         Consumer.0235
Dec 28 13:31:33 adolfo kernel: [ 3380.363676]         Consumer.0236
Dec 28 13:31:33 adolfo kernel: [ 3380.363678]         Consumer.0237
Dec 28 13:31:33 adolfo kernel: [ 3380.363680]         Consumer.HorizontalWheel
Dec 28 13:31:33 adolfo kernel: [ 3380.363682]         Consumer.0239
Dec 28 13:31:33 adolfo kernel: [ 3380.363684]         Consumer.023a
Dec 28 13:31:33 adolfo kernel: [ 3380.363686]         Consumer.023b
Dec 28 13:31:33 adolfo kernel: [ 3380.363688]         Consumer.023c
Dec 28 13:31:33 adolfo kernel: [ 3380.363690]       Logical Minimum(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363692]       Logical Maximum(572)
Dec 28 13:31:33 adolfo kernel: [ 3380.363693]       Report Size(16)
Dec 28 13:31:33 adolfo kernel: [ 3380.363694]       Report Count(1)
Dec 28 13:31:33 adolfo kernel: [ 3380.363696]       Report Offset(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363697]       Flags( Array Absolute )
Dec 28 13:31:33 adolfo kernel: [ 3380.363700]   INPUT(3)[INPUT]
Dec 28 13:31:33 adolfo kernel: [ 3380.363702]     Field(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363703]       Usage(3)
Dec 28 13:31:33 adolfo kernel: [ 3380.363704]
GenericDesktop.SystemPowerDown
Dec 28 13:31:33 adolfo kernel: [ 3380.363706]         GenericDesktop.SystemSleep
Dec 28 13:31:33 adolfo kernel: [ 3380.363708]
GenericDesktop.SystemWakeUp
Dec 28 13:31:33 adolfo kernel: [ 3380.363710]       Logical Minimum(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363712]       Logical Maximum(1)
Dec 28 13:31:33 adolfo kernel: [ 3380.363713]       Report Size(1)
Dec 28 13:31:33 adolfo kernel: [ 3380.363715]       Report Count(3)
Dec 28 13:31:33 adolfo kernel: [ 3380.363716]       Report Offset(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363717]       Flags( Variable Absolute )
Dec 28 13:31:33 adolfo kernel: [ 3380.363720]   INPUT(5)[INPUT]
Dec 28 13:31:33 adolfo kernel: [ 3380.363722]     Field(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363723]       Usage(128)
Dec 28 13:31:33 adolfo kernel: [ 3380.363725]         Keyboard.0000
Dec 28 13:31:33 adolfo kernel: [ 3380.363727]         Keyboard.0001
Dec 28 13:31:33 adolfo kernel: [ 3380.363729]         Keyboard.0002
Dec 28 13:31:33 adolfo kernel: [ 3380.363731]         Keyboard.0003
Dec 28 13:31:33 adolfo kernel: [ 3380.363733]         Keyboard.0004
Dec 28 13:31:33 adolfo kernel: [ 3380.363735]         Keyboard.0005
Dec 28 13:31:33 adolfo kernel: [ 3380.363737]         Keyboard.0006
Dec 28 13:31:33 adolfo kernel: [ 3380.363739]         Keyboard.0007
Dec 28 13:31:33 adolfo kernel: [ 3380.363741]         Keyboard.0008
Dec 28 13:31:33 adolfo kernel: [ 3380.363743]         Keyboard.0009
Dec 28 13:31:33 adolfo kernel: [ 3380.363745]         Keyboard.000a
Dec 28 13:31:33 adolfo kernel: [ 3380.363747]         Keyboard.000b
Dec 28 13:31:33 adolfo kernel: [ 3380.363749]         Keyboard.000c
Dec 28 13:31:33 adolfo kernel: [ 3380.363751]         Keyboard.000d
Dec 28 13:31:33 adolfo kernel: [ 3380.363753]         Keyboard.000e
Dec 28 13:31:33 adolfo kernel: [ 3380.363755]         Keyboard.000f
Dec 28 13:31:33 adolfo kernel: [ 3380.363757]         Keyboard.0010
Dec 28 13:31:33 adolfo kernel: [ 3380.363759]         Keyboard.0011
Dec 28 13:31:33 adolfo kernel: [ 3380.363761]         Keyboard.0012
Dec 28 13:31:33 adolfo kernel: [ 3380.363763]         Keyboard.0013
Dec 28 13:31:33 adolfo kernel: [ 3380.363764]         Keyboard.0014
Dec 28 13:31:33 adolfo kernel: [ 3380.363766]         Keyboard.0015
Dec 28 13:31:33 adolfo kernel: [ 3380.363768]         Keyboard.0016
Dec 28 13:31:33 adolfo kernel: [ 3380.363770]         Keyboard.0017
Dec 28 13:31:33 adolfo kernel: [ 3380.363772]         Keyboard.0018
Dec 28 13:31:33 adolfo kernel: [ 3380.363774]         Keyboard.0019
Dec 28 13:31:33 adolfo kernel: [ 3380.363776]         Keyboard.001a
Dec 28 13:31:33 adolfo kernel: [ 3380.363778]         Keyboard.001b
Dec 28 13:31:33 adolfo kernel: [ 3380.363780]         Keyboard.001c
Dec 28 13:31:33 adolfo kernel: [ 3380.363782]         Keyboard.001d
Dec 28 13:31:33 adolfo kernel: [ 3380.363784]         Keyboard.001e
Dec 28 13:31:33 adolfo kernel: [ 3380.363786]         Keyboard.001f
Dec 28 13:31:33 adolfo kernel: [ 3380.363788]         Keyboard.0020
Dec 28 13:31:33 adolfo kernel: [ 3380.363790]         Keyboard.0021
Dec 28 13:31:33 adolfo kernel: [ 3380.363792]         Keyboard.0022
Dec 28 13:31:33 adolfo kernel: [ 3380.363794]         Keyboard.0023
Dec 28 13:31:33 adolfo kernel: [ 3380.363796]         Keyboard.0024
Dec 28 13:31:33 adolfo kernel: [ 3380.363798]         Keyboard.0025
Dec 28 13:31:33 adolfo kernel: [ 3380.363800]         Keyboard.0026
Dec 28 13:31:33 adolfo kernel: [ 3380.363802]         Keyboard.0027
Dec 28 13:31:33 adolfo kernel: [ 3380.363804]         Keyboard.0028
Dec 28 13:31:33 adolfo kernel: [ 3380.363806]         Keyboard.0029
Dec 28 13:31:33 adolfo kernel: [ 3380.363808]         Keyboard.002a
Dec 28 13:31:33 adolfo kernel: [ 3380.363810]         Keyboard.002b
Dec 28 13:31:33 adolfo kernel: [ 3380.363812]         Keyboard.002c
Dec 28 13:31:33 adolfo kernel: [ 3380.363814]         Keyboard.002d
Dec 28 13:31:33 adolfo kernel: [ 3380.363816]         Keyboard.002e
Dec 28 13:31:33 adolfo kernel: [ 3380.363818]         Keyboard.002f
Dec 28 13:31:33 adolfo kernel: [ 3380.363820]         Keyboard.0030
Dec 28 13:31:33 adolfo kernel: [ 3380.363822]         Keyboard.0031
Dec 28 13:31:33 adolfo kernel: [ 3380.363824]         Keyboard.0032
Dec 28 13:31:33 adolfo kernel: [ 3380.363826]         Keyboard.0033
Dec 28 13:31:33 adolfo kernel: [ 3380.363828]         Keyboard.0034
Dec 28 13:31:33 adolfo kernel: [ 3380.363830]         Keyboard.0035
Dec 28 13:31:33 adolfo kernel: [ 3380.363832]         Keyboard.0036
Dec 28 13:31:33 adolfo kernel: [ 3380.363834]         Keyboard.0037
Dec 28 13:31:33 adolfo kernel: [ 3380.363836]         Keyboard.0038
Dec 28 13:31:33 adolfo kernel: [ 3380.363838]         Keyboard.0039
Dec 28 13:31:33 adolfo kernel: [ 3380.363840]         Keyboard.003a
Dec 28 13:31:33 adolfo kernel: [ 3380.363842]         Keyboard.003b
Dec 28 13:31:33 adolfo kernel: [ 3380.363844]         Keyboard.003c
Dec 28 13:31:33 adolfo kernel: [ 3380.363846]         Keyboard.003d
Dec 28 13:31:33 adolfo kernel: [ 3380.363848]         Keyboard.003e
Dec 28 13:31:33 adolfo kernel: [ 3380.363850]         Keyboard.003f
Dec 28 13:31:33 adolfo kernel: [ 3380.363852]         Keyboard.0040
Dec 28 13:31:33 adolfo kernel: [ 3380.363854]         Keyboard.0041
Dec 28 13:31:33 adolfo kernel: [ 3380.363856]         Keyboard.0042
Dec 28 13:31:33 adolfo kernel: [ 3380.363858]         Keyboard.0043
Dec 28 13:31:33 adolfo kernel: [ 3380.363860]         Keyboard.0044
Dec 28 13:31:33 adolfo kernel: [ 3380.363862]         Keyboard.0045
Dec 28 13:31:33 adolfo kernel: [ 3380.363864]         Keyboard.0046
Dec 28 13:31:33 adolfo kernel: [ 3380.363866]         Keyboard.0047
Dec 28 13:31:33 adolfo kernel: [ 3380.363868]         Keyboard.0048
Dec 28 13:31:33 adolfo NetworkManager: <debug> [1198855893.068209]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if1_logicaldev_input').
Dec 28 13:31:33 adolfo kernel: [ 3380.363870]         Keyboard.0049
Dec 28 13:31:33 adolfo kernel: [ 3380.363872]         Keyboard.004a
Dec 28 13:31:33 adolfo kernel: [ 3380.363874]         Keyboard.004b
Dec 28 13:31:33 adolfo kernel: [ 3380.363876]         Keyboard.004c
Dec 28 13:31:33 adolfo kernel: [ 3380.363878]         Keyboard.004d
Dec 28 13:31:33 adolfo kernel: [ 3380.363880]         Keyboard.004e
Dec 28 13:31:33 adolfo kernel: [ 3380.363882]         Keyboard.004f
Dec 28 13:31:33 adolfo kernel: [ 3380.363884]         Keyboard.0050
Dec 28 13:31:33 adolfo kernel: [ 3380.363886]         Keyboard.0051
Dec 28 13:31:33 adolfo kernel: [ 3380.363888]         Keyboard.0052
Dec 28 13:31:33 adolfo kernel: [ 3380.363890]         Keyboard.0053
Dec 28 13:31:33 adolfo kernel: [ 3380.363892]         Keyboard.0054
Dec 28 13:31:33 adolfo kernel: [ 3380.363894]         Keyboard.0055
Dec 28 13:31:33 adolfo kernel: [ 3380.363896]         Keyboard.0056
Dec 28 13:31:33 adolfo kernel: [ 3380.363898]         Keyboard.0057
Dec 28 13:31:33 adolfo kernel: [ 3380.363900]         Keyboard.0058
Dec 28 13:31:33 adolfo kernel: [ 3380.363902]         Keyboard.0059
Dec 28 13:31:33 adolfo kernel: [ 3380.363903]         Keyboard.005a
Dec 28 13:31:33 adolfo kernel: [ 3380.363905]         Keyboard.005b
Dec 28 13:31:33 adolfo kernel: [ 3380.363907]         Keyboard.005c
Dec 28 13:31:33 adolfo kernel: [ 3380.363909]         Keyboard.005d
Dec 28 13:31:33 adolfo kernel: [ 3380.363911]         Keyboard.005e
Dec 28 13:31:33 adolfo kernel: [ 3380.363913]         Keyboard.005f
Dec 28 13:31:33 adolfo kernel: [ 3380.363915]         Keyboard.0060
Dec 28 13:31:33 adolfo kernel: [ 3380.363917]         Keyboard.0061
Dec 28 13:31:33 adolfo kernel: [ 3380.363919]         Keyboard.0062
Dec 28 13:31:33 adolfo kernel: [ 3380.363921]         Keyboard.0063
Dec 28 13:31:33 adolfo kernel: [ 3380.363923]         Keyboard.0064
Dec 28 13:31:33 adolfo kernel: [ 3380.363925]         Keyboard.0065
Dec 28 13:31:33 adolfo kernel: [ 3380.363927]         Keyboard.0066
Dec 28 13:31:33 adolfo kernel: [ 3380.363929]         Keyboard.0067
Dec 28 13:31:33 adolfo kernel: [ 3380.363931]         Keyboard.0068
Dec 28 13:31:33 adolfo kernel: [ 3380.363933]         Keyboard.0069
Dec 28 13:31:33 adolfo kernel: [ 3380.363935]         Keyboard.006a
Dec 28 13:31:33 adolfo kernel: [ 3380.363937]         Keyboard.006b
Dec 28 13:31:33 adolfo kernel: [ 3380.363939]         Keyboard.006c
Dec 28 13:31:33 adolfo kernel: [ 3380.363941]         Keyboard.006d
Dec 28 13:31:33 adolfo kernel: [ 3380.363943]         Keyboard.006e
Dec 28 13:31:33 adolfo kernel: [ 3380.363945]         Keyboard.006f
Dec 28 13:31:33 adolfo kernel: [ 3380.363947]         Keyboard.0070
Dec 28 13:31:33 adolfo kernel: [ 3380.363949]         Keyboard.0071
Dec 28 13:31:33 adolfo kernel: [ 3380.363951]         Keyboard.0072
Dec 28 13:31:33 adolfo kernel: [ 3380.363953]         Keyboard.0073
Dec 28 13:31:33 adolfo kernel: [ 3380.363955]         Keyboard.0074
Dec 28 13:31:33 adolfo kernel: [ 3380.363957]         Keyboard.0075
Dec 28 13:31:33 adolfo kernel: [ 3380.363959]         Keyboard.0076
Dec 28 13:31:33 adolfo kernel: [ 3380.363961]         Keyboard.0077
Dec 28 13:31:33 adolfo kernel: [ 3380.363963]         Keyboard.0078
Dec 28 13:31:33 adolfo kernel: [ 3380.363965]         Keyboard.0079
Dec 28 13:31:33 adolfo kernel: [ 3380.363967]         Keyboard.007a
Dec 28 13:31:33 adolfo kernel: [ 3380.363969]         Keyboard.007b
Dec 28 13:31:33 adolfo kernel: [ 3380.363971]         Keyboard.007c
Dec 28 13:31:33 adolfo kernel: [ 3380.363973]         Keyboard.007d
Dec 28 13:31:33 adolfo kernel: [ 3380.363975]         Keyboard.007e
Dec 28 13:31:33 adolfo kernel: [ 3380.363977]         Keyboard.007f
Dec 28 13:31:33 adolfo kernel: [ 3380.363979]       Logical Minimum(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363980]       Logical Maximum(127)
Dec 28 13:31:33 adolfo kernel: [ 3380.363982]       Report Size(8)
Dec 28 13:31:33 adolfo kernel: [ 3380.363983]       Report Count(2)
Dec 28 13:31:33 adolfo kernel: [ 3380.363985]       Report Offset(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363986]       Flags( Array Absolute )
Dec 28 13:31:33 adolfo kernel: [ 3380.363989]   INPUT(6)[INPUT]
Dec 28 13:31:33 adolfo kernel: [ 3380.363991]     Field(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.363992]       Usage(256)
Dec 28 13:31:33 adolfo kernel: [ 3380.363993]         ffbc.0000
Dec 28 13:31:33 adolfo kernel: [ 3380.363997]         ffbc.0001
Dec 28 13:31:33 adolfo kernel: [ 3380.364000]         ffbc.0002
Dec 28 13:31:33 adolfo kernel: [ 3380.364003]         ffbc.0003
Dec 28 13:31:33 adolfo kernel: [ 3380.364005]         ffbc.0004
Dec 28 13:31:33 adolfo kernel: [ 3380.364008]         ffbc.0005
Dec 28 13:31:33 adolfo kernel: [ 3380.364011]         ffbc.0006
Dec 28 13:31:33 adolfo kernel: [ 3380.364014]         ffbc.0007
Dec 28 13:31:33 adolfo kernel: [ 3380.364016]         ffbc.0008
Dec 28 13:31:33 adolfo kernel: [ 3380.364019]         ffbc.0009
Dec 28 13:31:33 adolfo kernel: [ 3380.364022]         ffbc.000a
Dec 28 13:31:33 adolfo kernel: [ 3380.364025]         ffbc.000b
Dec 28 13:31:33 adolfo kernel: [ 3380.364027]         ffbc.000c
Dec 28 13:31:33 adolfo kernel: [ 3380.364030]         ffbc.000d
Dec 28 13:31:33 adolfo kernel: [ 3380.364033]         ffbc.000e
Dec 28 13:31:33 adolfo kernel: [ 3380.364036]         ffbc.000f
Dec 28 13:31:33 adolfo kernel: [ 3380.364038]         ffbc.0010
Dec 28 13:31:33 adolfo kernel: [ 3380.364041]         ffbc.0011
Dec 28 13:31:33 adolfo kernel: [ 3380.364044]         ffbc.0012
Dec 28 13:31:33 adolfo kernel: [ 3380.364046]         ffbc.0013
Dec 28 13:31:33 adolfo kernel: [ 3380.364049]         ffbc.0014
Dec 28 13:31:33 adolfo kernel: [ 3380.364052]         ffbc.0015
Dec 28 13:31:33 adolfo kernel: [ 3380.364055]         ffbc.0016
Dec 28 13:31:33 adolfo kernel: [ 3380.364057]         ffbc.0017
Dec 28 13:31:33 adolfo kernel: [ 3380.364060]         ffbc.0018
Dec 28 13:31:33 adolfo kernel: [ 3380.364063]         ffbc.0019
Dec 28 13:31:33 adolfo kernel: [ 3380.364066]         ffbc.001a
Dec 28 13:31:33 adolfo kernel: [ 3380.364068]         ffbc.001b
Dec 28 13:31:33 adolfo kernel: [ 3380.364071]         ffbc.001c
Dec 28 13:31:33 adolfo kernel: [ 3380.364074]         ffbc.001d
Dec 28 13:31:33 adolfo kernel: [ 3380.364077]         ffbc.001e
Dec 28 13:31:33 adolfo kernel: [ 3380.364079]         ffbc.001f
Dec 28 13:31:33 adolfo kernel: [ 3380.364082]         ffbc.0020
Dec 28 13:31:33 adolfo kernel: [ 3380.364085]         ffbc.0021
Dec 28 13:31:33 adolfo kernel: [ 3380.364087]         ffbc.0022
Dec 28 13:31:33 adolfo kernel: [ 3380.364090]         ffbc.0023
Dec 28 13:31:33 adolfo kernel: [ 3380.364093]         ffbc.0024
Dec 28 13:31:33 adolfo kernel: [ 3380.364096]         ffbc.0025
Dec 28 13:31:33 adolfo kernel: [ 3380.364098]         ffbc.0026
Dec 28 13:31:33 adolfo kernel: [ 3380.364101]         ffbc.0027
Dec 28 13:31:33 adolfo kernel: [ 3380.364104]         ffbc.0028
Dec 28 13:31:33 adolfo kernel: [ 3380.364107]         ffbc.0029
Dec 28 13:31:33 adolfo kernel: [ 3380.364109]         ffbc.002a
Dec 28 13:31:33 adolfo kernel: [ 3380.364112]         ffbc.002b
Dec 28 13:31:33 adolfo kernel: [ 3380.364115]         ffbc.002c
Dec 28 13:31:33 adolfo kernel: [ 3380.364118]         ffbc.002d
Dec 28 13:31:33 adolfo kernel: [ 3380.364120]         ffbc.002e
Dec 28 13:31:33 adolfo kernel: [ 3380.364123]         ffbc.002f
Dec 28 13:31:33 adolfo kernel: [ 3380.364126]         ffbc.0030
Dec 28 13:31:33 adolfo kernel: [ 3380.364129]         ffbc.0031
Dec 28 13:31:33 adolfo kernel: [ 3380.364131]         ffbc.0032
Dec 28 13:31:33 adolfo kernel: [ 3380.364134]         ffbc.0033
Dec 28 13:31:33 adolfo kernel: [ 3380.364137]         ffbc.0034
Dec 28 13:31:33 adolfo kernel: [ 3380.364140]         ffbc.0035
Dec 28 13:31:33 adolfo kernel: [ 3380.364142]         ffbc.0036
Dec 28 13:31:33 adolfo kernel: [ 3380.364145]         ffbc.0037
Dec 28 13:31:33 adolfo kernel: [ 3380.364148]         ffbc.0038
Dec 28 13:31:33 adolfo kernel: [ 3380.364150]         ffbc.0039
Dec 28 13:31:33 adolfo kernel: [ 3380.364153]         ffbc.003a
Dec 28 13:31:33 adolfo kernel: [ 3380.364156]         ffbc.003b
Dec 28 13:31:33 adolfo kernel: [ 3380.364159]         ffbc.003c
Dec 28 13:31:33 adolfo kernel: [ 3380.364161]         ffbc.003d
Dec 28 13:31:33 adolfo kernel: [ 3380.364164]         ffbc.003e
Dec 28 13:31:33 adolfo kernel: [ 3380.364167]         ffbc.003f
Dec 28 13:31:33 adolfo kernel: [ 3380.364170]         ffbc.0040
Dec 28 13:31:33 adolfo kernel: [ 3380.364172]         ffbc.0041
Dec 28 13:31:33 adolfo kernel: [ 3380.364175]         ffbc.0042
Dec 28 13:31:33 adolfo kernel: [ 3380.364178]         ffbc.0043
Dec 28 13:31:33 adolfo kernel: [ 3380.364181]         ffbc.0044
Dec 28 13:31:33 adolfo kernel: [ 3380.364183]         ffbc.0045
Dec 28 13:31:33 adolfo kernel: [ 3380.364186]         ffbc.0046
Dec 28 13:31:33 adolfo kernel: [ 3380.364189]         ffbc.0047
Dec 28 13:31:33 adolfo kernel: [ 3380.364192]         ffbc.0048
Dec 28 13:31:33 adolfo kernel: [ 3380.364194]         ffbc.0049
Dec 28 13:31:33 adolfo kernel: [ 3380.364197]         ffbc.004a
Dec 28 13:31:33 adolfo kernel: [ 3380.364200]         ffbc.004b
Dec 28 13:31:33 adolfo kernel: [ 3380.364202]         ffbc.004c
Dec 28 13:31:33 adolfo kernel: [ 3380.364205]         ffbc.004d
Dec 28 13:31:33 adolfo kernel: [ 3380.364208]         ffbc.004e
Dec 28 13:31:33 adolfo kernel: [ 3380.364211]         ffbc.004f
Dec 28 13:31:33 adolfo kernel: [ 3380.364213]         ffbc.0050
Dec 28 13:31:33 adolfo kernel: [ 3380.364216]         ffbc.0051
Dec 28 13:31:33 adolfo kernel: [ 3380.364219]         ffbc.0052
Dec 28 13:31:33 adolfo kernel: [ 3380.364222]         ffbc.0053
Dec 28 13:31:33 adolfo kernel: [ 3380.364224]         ffbc.0054
Dec 28 13:31:33 adolfo kernel: [ 3380.364227]         ffbc.0055
Dec 28 13:31:33 adolfo kernel: [ 3380.364230]         ffbc.0056
Dec 28 13:31:33 adolfo kernel: [ 3380.364233]         ffbc.0057
Dec 28 13:31:33 adolfo kernel: [ 3380.364235]         ffbc.0058
Dec 28 13:31:33 adolfo kernel: [ 3380.364238]         ffbc.0059
Dec 28 13:31:33 adolfo kernel: [ 3380.364241]         ffbc.005a
Dec 28 13:31:33 adolfo kernel: [ 3380.364244]         ffbc.005b
Dec 28 13:31:33 adolfo kernel: [ 3380.364246]         ffbc.005c
Dec 28 13:31:33 adolfo kernel: [ 3380.364249]         ffbc.005d
Dec 28 13:31:33 adolfo kernel: [ 3380.364252]         ffbc.005e
Dec 28 13:31:33 adolfo kernel: [ 3380.364255]         ffbc.005f
Dec 28 13:31:33 adolfo kernel: [ 3380.364263]         ffbc.0060
Dec 28 13:31:33 adolfo kernel: [ 3380.364266]         ffbc.0061
Dec 28 13:31:33 adolfo kernel: [ 3380.364268]         ffbc.0062
Dec 28 13:31:33 adolfo kernel: [ 3380.364271]         ffbc.0063
Dec 28 13:31:33 adolfo kernel: [ 3380.364274]         ffbc.0064
Dec 28 13:31:33 adolfo kernel: [ 3380.364277]         ffbc.0065
Dec 28 13:31:33 adolfo kernel: [ 3380.364279]         ffbc.0066
Dec 28 13:31:33 adolfo kernel: [ 3380.364282]         ffbc.0067
Dec 28 13:31:33 adolfo kernel: [ 3380.364285]         ffbc.0068
Dec 28 13:31:33 adolfo kernel: [ 3380.364287]         ffbc.0069
Dec 28 13:31:33 adolfo kernel: [ 3380.364290]         ffbc.006a
Dec 28 13:31:33 adolfo kernel: [ 3380.364293]         ffbc.006b
Dec 28 13:31:33 adolfo kernel: [ 3380.364296]         ffbc.006c
Dec 28 13:31:33 adolfo kernel: [ 3380.364299]         ffbc.006d
Dec 28 13:31:33 adolfo kernel: [ 3380.364301]         ffbc.006e
Dec 28 13:31:33 adolfo kernel: [ 3380.364304]         ffbc.006f
Dec 28 13:31:33 adolfo kernel: [ 3380.364307]         ffbc.0070
Dec 28 13:31:33 adolfo kernel: [ 3380.364309]         ffbc.0071
Dec 28 13:31:33 adolfo kernel: [ 3380.364312]         ffbc.0072
Dec 28 13:31:33 adolfo kernel: [ 3380.364315]         ffbc.0073
Dec 28 13:31:33 adolfo kernel: [ 3380.364318]         ffbc.0074
Dec 28 13:31:33 adolfo kernel: [ 3380.364320]         ffbc.0075
Dec 28 13:31:33 adolfo kernel: [ 3380.364323]         ffbc.0076
Dec 28 13:31:33 adolfo kernel: [ 3380.364326]         ffbc.0077
Dec 28 13:31:33 adolfo kernel: [ 3380.364329]         ffbc.0078
Dec 28 13:31:33 adolfo kernel: [ 3380.364331]         ffbc.0079
Dec 28 13:31:33 adolfo kernel: [ 3380.364334]         ffbc.007a
Dec 28 13:31:33 adolfo kernel: [ 3380.364337]         ffbc.007b
Dec 28 13:31:33 adolfo kernel: [ 3380.364340]         ffbc.007c
Dec 28 13:31:33 adolfo kernel: [ 3380.364342]         ffbc.007d
Dec 28 13:31:33 adolfo kernel: [ 3380.364345]         ffbc.007e
Dec 28 13:31:33 adolfo kernel: [ 3380.364348]         ffbc.007f
Dec 28 13:31:33 adolfo kernel: [ 3380.364350]         ffbc.0080
Dec 28 13:31:33 adolfo kernel: [ 3380.364353]         ffbc.0081
Dec 28 13:31:33 adolfo kernel: [ 3380.364356]         ffbc.0082
Dec 28 13:31:33 adolfo kernel: [ 3380.364359]         ffbc.0083
Dec 28 13:31:33 adolfo kernel: [ 3380.364361]         ffbc.0084
Dec 28 13:31:33 adolfo kernel: [ 3380.364364]         ffbc.0085
Dec 28 13:31:33 adolfo kernel: [ 3380.364367]         ffbc.0086
Dec 28 13:31:33 adolfo kernel: [ 3380.364370]         ffbc.0087
Dec 28 13:31:33 adolfo kernel: [ 3380.364372]         ffbc.0088
Dec 28 13:31:33 adolfo kernel: [ 3380.364375]         ffbc.0089
Dec 28 13:31:33 adolfo kernel: [ 3380.364378]         ffbc.008a
Dec 28 13:31:33 adolfo kernel: [ 3380.364381]         ffbc.008b
Dec 28 13:31:33 adolfo kernel: [ 3380.364383]         ffbc.008c
Dec 28 13:31:33 adolfo kernel: [ 3380.364386]         ffbc.008d
Dec 28 13:31:33 adolfo kernel: [ 3380.364389]         ffbc.008e
Dec 28 13:31:33 adolfo kernel: [ 3380.364392]         ffbc.008f
Dec 28 13:31:33 adolfo kernel: [ 3380.364394]         ffbc.0090
Dec 28 13:31:33 adolfo kernel: [ 3380.364397]         ffbc.0091
Dec 28 13:31:33 adolfo kernel: [ 3380.364400]         ffbc.0092
Dec 28 13:31:33 adolfo kernel: [ 3380.364402]         ffbc.0093
Dec 28 13:31:33 adolfo kernel: [ 3380.364405]         ffbc.0094
Dec 28 13:31:33 adolfo kernel: [ 3380.364408]         ffbc.0095
Dec 28 13:31:33 adolfo kernel: [ 3380.364411]         ffbc.0096
Dec 28 13:31:33 adolfo kernel: [ 3380.364413]         ffbc.0097
Dec 28 13:31:33 adolfo kernel: [ 3380.364416]         ffbc.0098
Dec 28 13:31:33 adolfo kernel: [ 3380.364419]         ffbc.0099
Dec 28 13:31:33 adolfo kernel: [ 3380.364422]         ffbc.009a
Dec 28 13:31:33 adolfo kernel: [ 3380.364424]         ffbc.009b
Dec 28 13:31:33 adolfo kernel: [ 3380.364427]         ffbc.009c
Dec 28 13:31:33 adolfo kernel: [ 3380.364430]         ffbc.009d
Dec 28 13:31:33 adolfo kernel: [ 3380.364433]         ffbc.009e
Dec 28 13:31:33 adolfo kernel: [ 3380.364435]         ffbc.009f
Dec 28 13:31:33 adolfo kernel: [ 3380.364438]         ffbc.00a0
Dec 28 13:31:33 adolfo kernel: [ 3380.364441]         ffbc.00a1
Dec 28 13:31:33 adolfo kernel: [ 3380.364444]         ffbc.00a2
Dec 28 13:31:33 adolfo kernel: [ 3380.364446]         ffbc.00a3
Dec 28 13:31:33 adolfo kernel: [ 3380.364449]         ffbc.00a4
Dec 28 13:31:33 adolfo kernel: [ 3380.364452]         ffbc.00a5
Dec 28 13:31:33 adolfo kernel: [ 3380.364455]         ffbc.00a6
Dec 28 13:31:33 adolfo kernel: [ 3380.364457]         ffbc.00a7
Dec 28 13:31:33 adolfo kernel: [ 3380.364460]         ffbc.00a8
Dec 28 13:31:33 adolfo kernel: [ 3380.364463]         ffbc.00a9
Dec 28 13:31:33 adolfo kernel: [ 3380.364465]         ffbc.00aa
Dec 28 13:31:33 adolfo kernel: [ 3380.364468]         ffbc.00ab
Dec 28 13:31:33 adolfo kernel: [ 3380.364471]         ffbc.00ac
Dec 28 13:31:33 adolfo kernel: [ 3380.364474]         ffbc.00ad
Dec 28 13:31:33 adolfo kernel: [ 3380.364477]         ffbc.00ae
Dec 28 13:31:33 adolfo kernel: [ 3380.364479]         ffbc.00af
Dec 28 13:31:33 adolfo kernel: [ 3380.364482]         ffbc.00b0
Dec 28 13:31:33 adolfo kernel: [ 3380.364485]         ffbc.00b1
Dec 28 13:31:33 adolfo kernel: [ 3380.364487]         ffbc.00b2
Dec 28 13:31:33 adolfo kernel: [ 3380.364490]         ffbc.00b3
Dec 28 13:31:33 adolfo kernel: [ 3380.364493]         ffbc.00b4
Dec 28 13:31:33 adolfo kernel: [ 3380.364496]         ffbc.00b5
Dec 28 13:31:33 adolfo kernel: [ 3380.364498]         ffbc.00b6
Dec 28 13:31:33 adolfo kernel: [ 3380.364501]         ffbc.00b7
Dec 28 13:31:33 adolfo kernel: [ 3380.364504]         ffbc.00b8
Dec 28 13:31:33 adolfo kernel: [ 3380.364507]         ffbc.00b9
Dec 28 13:31:33 adolfo kernel: [ 3380.364509]         ffbc.00ba
Dec 28 13:31:33 adolfo kernel: [ 3380.364512]         ffbc.00bb
Dec 28 13:31:33 adolfo kernel: [ 3380.364515]         ffbc.00bc
Dec 28 13:31:33 adolfo kernel: [ 3380.364518]         ffbc.00bd
Dec 28 13:31:33 adolfo kernel: [ 3380.364520]         ffbc.00be
Dec 28 13:31:33 adolfo kernel: [ 3380.364523]         ffbc.00bf
Dec 28 13:31:33 adolfo kernel: [ 3380.364526]         ffbc.00c0
Dec 28 13:31:33 adolfo kernel: [ 3380.364528]         ffbc.00c1
Dec 28 13:31:33 adolfo kernel: [ 3380.364531]         ffbc.00c2
Dec 28 13:31:33 adolfo kernel: [ 3380.364534]         ffbc.00c3
Dec 28 13:31:33 adolfo kernel: [ 3380.364537]         ffbc.00c4
Dec 28 13:31:33 adolfo kernel: [ 3380.364539]         ffbc.00c5
Dec 28 13:31:33 adolfo kernel: [ 3380.364542]         ffbc.00c6
Dec 28 13:31:33 adolfo kernel: [ 3380.364545]         ffbc.00c7
Dec 28 13:31:33 adolfo kernel: [ 3380.364548]         ffbc.00c8
Dec 28 13:31:33 adolfo kernel: [ 3380.364550]         ffbc.00c9
Dec 28 13:31:33 adolfo kernel: [ 3380.364553]         ffbc.00ca
Dec 28 13:31:33 adolfo kernel: [ 3380.364556]         ffbc.00cb
Dec 28 13:31:33 adolfo kernel: [ 3380.364559]         ffbc.00cc
Dec 28 13:31:33 adolfo kernel: [ 3380.364561]         ffbc.00cd
Dec 28 13:31:33 adolfo kernel: [ 3380.364564]         ffbc.00ce
Dec 28 13:31:33 adolfo kernel: [ 3380.364567]         ffbc.00cf
Dec 28 13:31:33 adolfo kernel: [ 3380.364570]         ffbc.00d0
Dec 28 13:31:33 adolfo kernel: [ 3380.364572]         ffbc.00d1
Dec 28 13:31:33 adolfo kernel: [ 3380.364575]         ffbc.00d2
Dec 28 13:31:33 adolfo kernel: [ 3380.364578]         ffbc.00d3
Dec 28 13:31:33 adolfo kernel: [ 3380.364581]         ffbc.00d4
Dec 28 13:31:33 adolfo kernel: [ 3380.364583]         ffbc.00d5
Dec 28 13:31:33 adolfo kernel: [ 3380.364586]         ffbc.00d6
Dec 28 13:31:33 adolfo kernel: [ 3380.364589]         ffbc.00d7
Dec 28 13:31:33 adolfo kernel: [ 3380.364591]         ffbc.00d8
Dec 28 13:31:33 adolfo kernel: [ 3380.364594]         ffbc.00d9
Dec 28 13:31:33 adolfo kernel: [ 3380.364597]         ffbc.00da
Dec 28 13:31:33 adolfo kernel: [ 3380.364600]         ffbc.00db
Dec 28 13:31:33 adolfo kernel: [ 3380.364602]         ffbc.00dc
Dec 28 13:31:33 adolfo kernel: [ 3380.364605]         ffbc.00dd
Dec 28 13:31:33 adolfo kernel: [ 3380.364608]         ffbc.00de
Dec 28 13:31:33 adolfo kernel: [ 3380.364611]         ffbc.00df
Dec 28 13:31:33 adolfo kernel: [ 3380.364613]         ffbc.00e0
Dec 28 13:31:33 adolfo kernel: [ 3380.364616]         ffbc.00e1
Dec 28 13:31:33 adolfo kernel: [ 3380.364619]         ffbc.00e2
Dec 28 13:31:33 adolfo kernel: [ 3380.364622]         ffbc.00e3
Dec 28 13:31:33 adolfo kernel: [ 3380.364624]         ffbc.00e4
Dec 28 13:31:33 adolfo kernel: [ 3380.364627]         ffbc.00e5
Dec 28 13:31:33 adolfo kernel: [ 3380.364630]         ffbc.00e6
Dec 28 13:31:33 adolfo kernel: [ 3380.364633]         ffbc.00e7
Dec 28 13:31:33 adolfo kernel: [ 3380.364635]         ffbc.00e8
Dec 28 13:31:33 adolfo kernel: [ 3380.364638]         ffbc.00e9
Dec 28 13:31:33 adolfo kernel: [ 3380.364641]         ffbc.00ea
Dec 28 13:31:33 adolfo kernel: [ 3380.364643]         ffbc.00eb
Dec 28 13:31:33 adolfo kernel: [ 3380.364646]         ffbc.00ec
Dec 28 13:31:33 adolfo kernel: [ 3380.364649]         ffbc.00ed
Dec 28 13:31:33 adolfo kernel: [ 3380.364652]         ffbc.00ee
Dec 28 13:31:33 adolfo kernel: [ 3380.364654]         ffbc.00ef
Dec 28 13:31:33 adolfo kernel: [ 3380.364657]         ffbc.00f0
Dec 28 13:31:33 adolfo kernel: [ 3380.364660]         ffbc.00f1
Dec 28 13:31:33 adolfo kernel: [ 3380.364663]         ffbc.00f2
Dec 28 13:31:33 adolfo kernel: [ 3380.364665]         ffbc.00f3
Dec 28 13:31:33 adolfo kernel: [ 3380.364668]         ffbc.00f4
Dec 28 13:31:33 adolfo kernel: [ 3380.364671]         ffbc.00f5
Dec 28 13:31:33 adolfo kernel: [ 3380.364674]         ffbc.00f6
Dec 28 13:31:33 adolfo kernel: [ 3380.364676]         ffbc.00f7
Dec 28 13:31:33 adolfo kernel: [ 3380.364679]         ffbc.00f8
Dec 28 13:31:33 adolfo kernel: [ 3380.364682]         ffbc.00f9
Dec 28 13:31:33 adolfo kernel: [ 3380.364684]         ffbc.00fa
Dec 28 13:31:33 adolfo kernel: [ 3380.364687]         ffbc.00fb
Dec 28 13:31:33 adolfo kernel: [ 3380.364690]         ffbc.00fc
Dec 28 13:31:33 adolfo kernel: [ 3380.364693]         ffbc.00fd
Dec 28 13:31:33 adolfo kernel: [ 3380.364695]         ffbc.00fe
Dec 28 13:31:33 adolfo kernel: [ 3380.364698]         ffbc.00ff
Dec 28 13:31:33 adolfo kernel: [ 3380.364701]       Logical Minimum(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.364702]       Logical Maximum(127)
Dec 28 13:31:33 adolfo kernel: [ 3380.364704]       Report Size(8)
Dec 28 13:31:33 adolfo kernel: [ 3380.364705]       Report Count(2)
Dec 28 13:31:33 adolfo kernel: [ 3380.364707]       Report Offset(0)
Dec 28 13:31:33 adolfo kernel: [ 3380.364708]       Flags( Array Absolute )
Dec 28 13:31:33 adolfo kernel: [ 3380.364714] drivers/hid/hid-input.c:
Mapping: Button.0001 ---> Key.LeftBtn
Dec 28 13:31:33 adolfo kernel: [ 3380.364719] drivers/hid/hid-input.c:
Mapping: Button.0002 ---> Key.RightBtn
Dec 28 13:31:33 adolfo kernel: [ 3380.364722] drivers/hid/hid-input.c:
Mapping: Button.0003 ---> Key.MiddleBtn
Dec 28 13:31:33 adolfo kernel: [ 3380.364725] drivers/hid/hid-input.c:
Mapping: Button.0004 ---> Key.SideBtn
Dec 28 13:31:33 adolfo kernel: [ 3380.364765] drivers/hid/hid-input.c:
Mapping: Button.0005 ---> Key.ExtraBtn
Dec 28 13:31:33 adolfo kernel: [ 3380.364768] drivers/hid/hid-input.c:
Mapping: GenericDesktop.X ---> Relative.X
Dec 28 13:31:33 adolfo kernel: [ 3380.364772] drivers/hid/hid-input.c:
Mapping: GenericDesktop.Y ---> Relative.Y
Dec 28 13:31:33 adolfo kernel: [ 3380.364775] drivers/hid/hid-input.c:
Mapping: GenericDesktop.Wheel ---> Relative.Wheel
Dec 28 13:31:33 adolfo kernel: [ 3380.364778] drivers/hid/hid-input.c:
Mapping: Consumer.0000 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364781] drivers/hid/hid-input.c:
Mapping: Consumer.0001 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364784] drivers/hid/hid-input.c:
Mapping: Consumer.0002 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364787] drivers/hid/hid-input.c:
Mapping: Consumer.0003 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364790] drivers/hid/hid-input.c:
Mapping: Consumer.0004 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364793] drivers/hid/hid-input.c:
Mapping: Consumer.0005 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364796] drivers/hid/hid-input.c:
Mapping: Consumer.0006 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364799] drivers/hid/hid-input.c:
Mapping: Consumer.0007 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364802] drivers/hid/hid-input.c:
Mapping: Consumer.0008 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364805] drivers/hid/hid-input.c:
Mapping: Consumer.0009 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364808] drivers/hid/hid-input.c:
Mapping: Consumer.000a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364811] drivers/hid/hid-input.c:
Mapping: Consumer.000b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364814] drivers/hid/hid-input.c:
Mapping: Consumer.000c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364817] drivers/hid/hid-input.c:
Mapping: Consumer.000d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364820] drivers/hid/hid-input.c:
Mapping: Consumer.000e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364822] drivers/hid/hid-input.c:
Mapping: Consumer.000f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364825] drivers/hid/hid-input.c:
Mapping: Consumer.0010 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364828] drivers/hid/hid-input.c:
Mapping: Consumer.0011 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364831] drivers/hid/hid-input.c:
Mapping: Consumer.0012 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364834] drivers/hid/hid-input.c:
Mapping: Consumer.0013 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364837] drivers/hid/hid-input.c:
Mapping: Consumer.0014 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364840] drivers/hid/hid-input.c:
Mapping: Consumer.0015 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364843] drivers/hid/hid-input.c:
Mapping: Consumer.0016 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364846] drivers/hid/hid-input.c:
Mapping: Consumer.0017 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364849] drivers/hid/hid-input.c:
Mapping: Consumer.0018 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364852] drivers/hid/hid-input.c:
Mapping: Consumer.0019 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364855] drivers/hid/hid-input.c:
Mapping: Consumer.001a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364858] drivers/hid/hid-input.c:
Mapping: Consumer.001b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364861] drivers/hid/hid-input.c:
Mapping: Consumer.001c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364864] drivers/hid/hid-input.c:
Mapping: Consumer.001d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364866] drivers/hid/hid-input.c:
Mapping: Consumer.001e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364869] drivers/hid/hid-input.c:
Mapping: Consumer.001f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364872] drivers/hid/hid-input.c:
Mapping: Consumer.0020 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364875] drivers/hid/hid-input.c:
Mapping: Consumer.0021 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364878] drivers/hid/hid-input.c:
Mapping: Consumer.0022 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364881] drivers/hid/hid-input.c:
Mapping: Consumer.0023 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364884] drivers/hid/hid-input.c:
Mapping: Consumer.0024 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364887] drivers/hid/hid-input.c:
Mapping: Consumer.0025 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364890] drivers/hid/hid-input.c:
Mapping: Consumer.0026 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364893] drivers/hid/hid-input.c:
Mapping: Consumer.0027 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364896] drivers/hid/hid-input.c:
Mapping: Consumer.0028 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364898] drivers/hid/hid-input.c:
Mapping: Consumer.0029 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364902] drivers/hid/hid-input.c:
Mapping: Consumer.002a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364904] drivers/hid/hid-input.c:
Mapping: Consumer.002b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364907] drivers/hid/hid-input.c:
Mapping: Consumer.002c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364910] drivers/hid/hid-input.c:
Mapping: Consumer.002d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364913] drivers/hid/hid-input.c:
Mapping: Consumer.002e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364916] drivers/hid/hid-input.c:
Mapping: Consumer.002f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364919] drivers/hid/hid-input.c:
Mapping: Consumer.0030 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364922] drivers/hid/hid-input.c:
Mapping: Consumer.0031 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364925] drivers/hid/hid-input.c:
Mapping: Consumer.0032 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364928] drivers/hid/hid-input.c:
Mapping: Consumer.0033 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364931] drivers/hid/hid-input.c:
Mapping: Consumer.0034 ---> Key.Sleep
Dec 28 13:31:33 adolfo kernel: [ 3380.364934] drivers/hid/hid-input.c:
Mapping: Consumer.0035 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364937] drivers/hid/hid-input.c:
Mapping: Consumer.0036 ---> Key.Btn0
Dec 28 13:31:33 adolfo kernel: [ 3380.364941] drivers/hid/hid-input.c:
Mapping: Consumer.0037 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364944] drivers/hid/hid-input.c:
Mapping: Consumer.0038 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364946] drivers/hid/hid-input.c:
Mapping: Consumer.0039 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364949] drivers/hid/hid-input.c:
Mapping: Consumer.003a ---> Key.Sound
Dec 28 13:31:33 adolfo kernel: [ 3380.364953] drivers/hid/hid-input.c:
Mapping: Consumer.003b ---> Key.Camera
Dec 28 13:31:33 adolfo kernel: [ 3380.364956] drivers/hid/hid-input.c:
Mapping: Consumer.003c ---> Key.Documents
Dec 28 13:31:33 adolfo kernel: [ 3380.364960] drivers/hid/hid-input.c:
Mapping: Consumer.003d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364963] drivers/hid/hid-input.c:
Mapping: Consumer.003e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364966] drivers/hid/hid-input.c:
Mapping: Consumer.003f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364969] drivers/hid/hid-input.c:
Mapping: Consumer.0040 ---> Key.Menu
Dec 28 13:31:33 adolfo kernel: [ 3380.364972] drivers/hid/hid-input.c:
Mapping: Consumer.0041 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364975] drivers/hid/hid-input.c:
Mapping: Consumer.0042 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364978] drivers/hid/hid-input.c:
Mapping: Consumer.0043 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364981] drivers/hid/hid-input.c:
Mapping: Consumer.0044 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364984] drivers/hid/hid-input.c:
Mapping: Consumer.0045 ---> Key.Radio
Dec 28 13:31:33 adolfo kernel: [ 3380.364987] drivers/hid/hid-input.c:
Mapping: Consumer.0046 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364990] drivers/hid/hid-input.c:
Mapping: Consumer.0047 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364993] drivers/hid/hid-input.c:
Mapping: Consumer.0048 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364996] drivers/hid/hid-input.c:
Mapping: Consumer.0049 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.364999] drivers/hid/hid-input.c:
Mapping: Consumer.004a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365002] drivers/hid/hid-input.c:
Mapping: Consumer.004b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365005] drivers/hid/hid-input.c:
Mapping: Consumer.004c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365008] drivers/hid/hid-input.c:
Mapping: Consumer.004d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365011] drivers/hid/hid-input.c:
Mapping: Consumer.004e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365014] drivers/hid/hid-input.c:
Mapping: Consumer.004f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365017] drivers/hid/hid-input.c:
Mapping: Consumer.0050 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365020] drivers/hid/hid-input.c:
Mapping: Consumer.0051 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365023] drivers/hid/hid-input.c:
Mapping: Consumer.0052 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365026] drivers/hid/hid-input.c:
Mapping: Consumer.0053 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365029] drivers/hid/hid-input.c:
Mapping: Consumer.0054 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365032] drivers/hid/hid-input.c:
Mapping: Consumer.0055 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365035] drivers/hid/hid-input.c:
Mapping: Consumer.0056 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365038] drivers/hid/hid-input.c:
Mapping: Consumer.0057 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365041] drivers/hid/hid-input.c:
Mapping: Consumer.0058 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365043] drivers/hid/hid-input.c:
Mapping: Consumer.0059 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365046] drivers/hid/hid-input.c:
Mapping: Consumer.005a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365049] drivers/hid/hid-input.c:
Mapping: Consumer.005b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365052] drivers/hid/hid-input.c:
Mapping: Consumer.005c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365055] drivers/hid/hid-input.c:
Mapping: Consumer.005d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365058] drivers/hid/hid-input.c:
Mapping: Consumer.005e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365061] drivers/hid/hid-input.c:
Mapping: Consumer.005f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365064] drivers/hid/hid-input.c:
Mapping: Consumer.0060 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365067] drivers/hid/hid-input.c:
Mapping: Consumer.0061 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365070] drivers/hid/hid-input.c:
Mapping: Consumer.0062 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365073] drivers/hid/hid-input.c:
Mapping: Consumer.0063 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365076] drivers/hid/hid-input.c:
Mapping: Consumer.0064 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365079] drivers/hid/hid-input.c:
Mapping: Consumer.0065 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365082] drivers/hid/hid-input.c:
Mapping: Consumer.0066 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365085] drivers/hid/hid-input.c:
Mapping: Consumer.0067 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365088] drivers/hid/hid-input.c:
Mapping: Consumer.0068 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365091] drivers/hid/hid-input.c:
Mapping: Consumer.0069 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365094] drivers/hid/hid-input.c:
Mapping: Consumer.006a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365097] drivers/hid/hid-input.c:
Mapping: Consumer.006b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365100] drivers/hid/hid-input.c:
Mapping: Consumer.006c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365103] drivers/hid/hid-input.c:
Mapping: Consumer.006d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365106] drivers/hid/hid-input.c:
Mapping: Consumer.006e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365108] drivers/hid/hid-input.c:
Mapping: Consumer.006f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365111] drivers/hid/hid-input.c:
Mapping: Consumer.0070 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365114] drivers/hid/hid-input.c:
Mapping: Consumer.0071 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365117] drivers/hid/hid-input.c:
Mapping: Consumer.0072 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365120] drivers/hid/hid-input.c:
Mapping: Consumer.0073 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365123] drivers/hid/hid-input.c:
Mapping: Consumer.0074 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365126] drivers/hid/hid-input.c:
Mapping: Consumer.0075 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365129] drivers/hid/hid-input.c:
Mapping: Consumer.0076 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365132] drivers/hid/hid-input.c:
Mapping: Consumer.0077 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365135] drivers/hid/hid-input.c:
Mapping: Consumer.0078 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365138] drivers/hid/hid-input.c:
Mapping: Consumer.0079 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365141] drivers/hid/hid-input.c:
Mapping: Consumer.007a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365144] drivers/hid/hid-input.c:
Mapping: Consumer.007b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365147] drivers/hid/hid-input.c:
Mapping: Consumer.007c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365150] drivers/hid/hid-input.c:
Mapping: Consumer.007d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365153] drivers/hid/hid-input.c:
Mapping: Consumer.007e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365156] drivers/hid/hid-input.c:
Mapping: Consumer.007f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365159] drivers/hid/hid-input.c:
Mapping: Consumer.0080 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365161] drivers/hid/hid-input.c:
Mapping: Consumer.0081 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365164] drivers/hid/hid-input.c:
Mapping: Consumer.0082 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365167] drivers/hid/hid-input.c:
Mapping: Consumer.0083 ---> Key.Last
Dec 28 13:31:33 adolfo kernel: [ 3380.365171] drivers/hid/hid-input.c:
Mapping: Consumer.0084 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365174] drivers/hid/hid-input.c:
Mapping: Consumer.0085 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365177] drivers/hid/hid-input.c:
Mapping: Consumer.0086 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365180] drivers/hid/hid-input.c:
Mapping: Consumer.0087 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365182] drivers/hid/hid-input.c:
Mapping: Consumer.0088 ---> Key.PC
Dec 28 13:31:33 adolfo kernel: [ 3380.365186] drivers/hid/hid-input.c:
Mapping: Consumer.0089 ---> Key.TV
Dec 28 13:31:33 adolfo kernel: [ 3380.365189] drivers/hid/hid-input.c:
Mapping: Consumer.008a ---> Key.WWW
Dec 28 13:31:33 adolfo kernel: [ 3380.365193] drivers/hid/hid-input.c:
Mapping: Consumer.008b ---> Key.DVD
Dec 28 13:31:33 adolfo kernel: [ 3380.365196] drivers/hid/hid-input.c:
Mapping: Consumer.008c ---> Key.Phone
Dec 28 13:31:33 adolfo kernel: [ 3380.365199] drivers/hid/hid-input.c:
Mapping: Consumer.008d ---> Key.Program
Dec 28 13:31:33 adolfo kernel: [ 3380.365203] drivers/hid/hid-input.c:
Mapping: Consumer.008e ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365206] drivers/hid/hid-input.c:
Mapping: Consumer.008f ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365209] drivers/hid/hid-input.c:
Mapping: Consumer.0090 ---> Key.Memo
Dec 28 13:31:33 adolfo kernel: [ 3380.365212] drivers/hid/hid-input.c:
Mapping: Consumer.0091 ---> Key.CD
Dec 28 13:31:33 adolfo kernel: [ 3380.365216] drivers/hid/hid-input.c:
Mapping: Consumer.0092 ---> Key.VCR
Dec 28 13:31:33 adolfo kernel: [ 3380.365219] drivers/hid/hid-input.c:
Mapping: Consumer.0093 ---> Key.Tuner
Dec 28 13:31:33 adolfo kernel: [ 3380.365222] drivers/hid/hid-input.c:
Mapping: Consumer.0094 ---> Key.Exit
Dec 28 13:31:33 adolfo kernel: [ 3380.365226] drivers/hid/hid-input.c:
Mapping: Consumer.0095 ---> Key.Help
Dec 28 13:31:33 adolfo kernel: [ 3380.365229] drivers/hid/hid-input.c:
Mapping: Consumer.0096 ---> Key.Tape
Dec 28 13:31:33 adolfo kernel: [ 3380.365232] drivers/hid/hid-input.c:
Mapping: Consumer.0097 ---> Key.TV2
Dec 28 13:31:33 adolfo kernel: [ 3380.365236] drivers/hid/hid-input.c:
Mapping: Consumer.0098 ---> Key.Sat
Dec 28 13:31:33 adolfo kernel: [ 3380.365239] drivers/hid/hid-input.c:
Mapping: Consumer.0099 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365242] drivers/hid/hid-input.c:
Mapping: Consumer.009a ---> Key.PVR
Dec 28 13:31:33 adolfo kernel: [ 3380.365245] drivers/hid/hid-input.c:
Mapping: Consumer.009b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365248] drivers/hid/hid-input.c:
Mapping: Consumer.009c ---> Key.ChannelUp
Dec 28 13:31:33 adolfo kernel: [ 3380.365251] drivers/hid/hid-input.c:
Mapping: Consumer.009d ---> Key.ChannelDown
Dec 28 13:31:33 adolfo kernel: [ 3380.365255] drivers/hid/hid-input.c:
Mapping: Consumer.009e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365258] drivers/hid/hid-input.c:
Mapping: Consumer.009f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365261] drivers/hid/hid-input.c:
Mapping: Consumer.00a0 ---> Key.VCR2
Dec 28 13:31:33 adolfo kernel: [ 3380.365264] drivers/hid/hid-input.c:
Mapping: Consumer.00a1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365267] drivers/hid/hid-input.c:
Mapping: Consumer.00a2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365270] drivers/hid/hid-input.c:
Mapping: Consumer.00a3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365273] drivers/hid/hid-input.c:
Mapping: Consumer.00a4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365276] drivers/hid/hid-input.c:
Mapping: Consumer.00a5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365279] drivers/hid/hid-input.c:
Mapping: Consumer.00a6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365282] drivers/hid/hid-input.c:
Mapping: Consumer.00a7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365285] drivers/hid/hid-input.c:
Mapping: Consumer.00a8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365288] drivers/hid/hid-input.c:
Mapping: Consumer.00a9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365291] drivers/hid/hid-input.c:
Mapping: Consumer.00aa ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365294] drivers/hid/hid-input.c:
Mapping: Consumer.00ab ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365297] drivers/hid/hid-input.c:
Mapping: Consumer.00ac ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365300] drivers/hid/hid-input.c:
Mapping: Consumer.00ad ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365302] drivers/hid/hid-input.c:
Mapping: Consumer.00ae ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365305] drivers/hid/hid-input.c:
Mapping: Consumer.00af ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365308] drivers/hid/hid-input.c:
Mapping: Consumer.00b0 ---> Key.Play
Dec 28 13:31:33 adolfo kernel: [ 3380.365312] drivers/hid/hid-input.c:
Mapping: Consumer.00b1 ---> Key.Pause
Dec 28 13:31:33 adolfo kernel: [ 3380.365315] drivers/hid/hid-input.c:
Mapping: Consumer.00b2 ---> Key.Record
Dec 28 13:31:33 adolfo kernel: [ 3380.365318] drivers/hid/hid-input.c:
Mapping: Consumer.00b3 ---> Key.FastForward
Dec 28 13:31:33 adolfo kernel: [ 3380.365321] drivers/hid/hid-input.c:
Mapping: Consumer.00b4 ---> Key.Rewind
Dec 28 13:31:33 adolfo kernel: [ 3380.365325] drivers/hid/hid-input.c:
Mapping: Consumer.00b5 ---> Key.NextSong
Dec 28 13:31:33 adolfo kernel: [ 3380.365328] drivers/hid/hid-input.c:
Mapping: Consumer.00b6 ---> Key.PreviousSong
Dec 28 13:31:33 adolfo kernel: [ 3380.365331] drivers/hid/hid-input.c:
Mapping: Consumer.00b7 ---> Key.StopCD
Dec 28 13:31:33 adolfo kernel: [ 3380.365335] drivers/hid/hid-input.c:
Mapping: Consumer.00b8 ---> Key.EjectCD
Dec 28 13:31:33 adolfo kernel: [ 3380.365338] drivers/hid/hid-input.c:
Mapping: Consumer.00b9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365341] drivers/hid/hid-input.c:
Mapping: Consumer.00ba ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365344] drivers/hid/hid-input.c:
Mapping: Consumer.00bb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365347] drivers/hid/hid-input.c:
Mapping: Consumer.00bc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365350] drivers/hid/hid-input.c:
Mapping: Consumer.00bd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365353] drivers/hid/hid-input.c:
Mapping: Consumer.00be ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365356] drivers/hid/hid-input.c:
Mapping: Consumer.00bf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365359] drivers/hid/hid-input.c:
Mapping: Consumer.00c0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365362] drivers/hid/hid-input.c:
Mapping: Consumer.00c1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365364] drivers/hid/hid-input.c:
Mapping: Consumer.00c2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365367] drivers/hid/hid-input.c:
Mapping: Consumer.00c3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365370] drivers/hid/hid-input.c:
Mapping: Consumer.00c4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365373] drivers/hid/hid-input.c:
Mapping: Consumer.00c5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365376] drivers/hid/hid-input.c:
Mapping: Consumer.00c6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365379] drivers/hid/hid-input.c:
Mapping: Consumer.00c7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365382] drivers/hid/hid-input.c:
Mapping: Consumer.00c8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365385] drivers/hid/hid-input.c:
Mapping: Consumer.00c9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365388] drivers/hid/hid-input.c:
Mapping: Consumer.00ca ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365391] drivers/hid/hid-input.c:
Mapping: Consumer.00cb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365394] drivers/hid/hid-input.c:
Mapping: Consumer.00cc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365397] drivers/hid/hid-input.c:
Mapping: Consumer.00cd ---> Key.PlayPause
Dec 28 13:31:33 adolfo kernel: [ 3380.365400] drivers/hid/hid-input.c:
Mapping: Consumer.00ce ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365403] drivers/hid/hid-input.c:
Mapping: Consumer.00cf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365406] drivers/hid/hid-input.c:
Mapping: Consumer.00d0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365409] drivers/hid/hid-input.c:
Mapping: Consumer.00d1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365412] drivers/hid/hid-input.c:
Mapping: Consumer.00d2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365414] drivers/hid/hid-input.c:
Mapping: Consumer.00d3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365417] drivers/hid/hid-input.c:
Mapping: Consumer.00d4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365420] drivers/hid/hid-input.c:
Mapping: Consumer.00d5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365423] drivers/hid/hid-input.c:
Mapping: Consumer.00d6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365426] drivers/hid/hid-input.c:
Mapping: Consumer.00d7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365429] drivers/hid/hid-input.c:
Mapping: Consumer.00d8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365432] drivers/hid/hid-input.c:
Mapping: Consumer.00d9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365435] drivers/hid/hid-input.c:
Mapping: Consumer.00da ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365438] drivers/hid/hid-input.c:
Mapping: Consumer.00db ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365441] drivers/hid/hid-input.c:
Mapping: Consumer.00dc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365444] drivers/hid/hid-input.c:
Mapping: Consumer.00dd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365447] drivers/hid/hid-input.c:
Mapping: Consumer.00de ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365449] drivers/hid/hid-input.c:
Mapping: Consumer.00df ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365452] drivers/hid/hid-input.c:
Mapping: Consumer.00e0 ---> Absolute.Volume
Dec 28 13:31:33 adolfo kernel: [ 3380.365456] drivers/hid/hid-input.c:
Mapping: Consumer.00e1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365459] drivers/hid/hid-input.c:
Mapping: Consumer.00e2 ---> Key.Mute
Dec 28 13:31:33 adolfo kernel: [ 3380.365462] drivers/hid/hid-input.c:
Mapping: Consumer.00e3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365465] drivers/hid/hid-input.c:
Mapping: Consumer.00e4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365468] drivers/hid/hid-input.c:
Mapping: Consumer.00e5 ---> Key.BassBoost
Dec 28 13:31:33 adolfo kernel: [ 3380.365471] drivers/hid/hid-input.c:
Mapping: Consumer.00e6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365474] drivers/hid/hid-input.c:
Mapping: Consumer.00e7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365477] drivers/hid/hid-input.c:
Mapping: Consumer.00e8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365480] drivers/hid/hid-input.c:
Mapping: Consumer.00e9 ---> Key.VolumeUp
Dec 28 13:31:33 adolfo kernel: [ 3380.365483] drivers/hid/hid-input.c:
Mapping: Consumer.00ea ---> Key.VolumeDown
Dec 28 13:31:33 adolfo kernel: [ 3380.365487] drivers/hid/hid-input.c:
Mapping: Consumer.00eb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365490] drivers/hid/hid-input.c:
Mapping: Consumer.00ec ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365492] drivers/hid/hid-input.c:
Mapping: Consumer.00ed ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365495] drivers/hid/hid-input.c:
Mapping: Consumer.00ee ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365498] drivers/hid/hid-input.c:
Mapping: Consumer.00ef ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365501] drivers/hid/hid-input.c:
Mapping: Consumer.00f0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365504] drivers/hid/hid-input.c:
Mapping: Consumer.00f1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365507] drivers/hid/hid-input.c:
Mapping: Consumer.00f2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365510] drivers/hid/hid-input.c:
Mapping: Consumer.00f3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365513] drivers/hid/hid-input.c:
Mapping: Consumer.00f4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365516] drivers/hid/hid-input.c:
Mapping: Consumer.00f5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365519] drivers/hid/hid-input.c:
Mapping: Consumer.00f6 ---> Key.Next
Dec 28 13:31:33 adolfo kernel: [ 3380.365522] drivers/hid/hid-input.c:
Mapping: Consumer.00f7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365525] drivers/hid/hid-input.c:
Mapping: Consumer.00f8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365528] drivers/hid/hid-input.c:
Mapping: Consumer.00f9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365531] drivers/hid/hid-input.c:
Mapping: Consumer.00fa ---> Key.Back
Dec 28 13:31:33 adolfo kernel: [ 3380.365534] drivers/hid/hid-input.c:
Mapping: Consumer.00fb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365537] drivers/hid/hid-input.c:
Mapping: Consumer.00fc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365540] drivers/hid/hid-input.c:
Mapping: Consumer.00fd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365543] drivers/hid/hid-input.c:
Mapping: Consumer.00fe ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365546] drivers/hid/hid-input.c:
Mapping: Consumer.00ff ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365549] drivers/hid/hid-input.c:
Mapping: Consumer.0100 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365552] drivers/hid/hid-input.c:
Mapping: Consumer.0101 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365555] drivers/hid/hid-input.c:
Mapping: Consumer.0102 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365557] drivers/hid/hid-input.c:
Mapping: Consumer.0103 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365560] drivers/hid/hid-input.c:
Mapping: Consumer.0104 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365563] drivers/hid/hid-input.c:
Mapping: Consumer.0105 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365566] drivers/hid/hid-input.c:
Mapping: Consumer.0106 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365569] drivers/hid/hid-input.c:
Mapping: Consumer.0107 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365572] drivers/hid/hid-input.c:
Mapping: Consumer.0108 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365575] drivers/hid/hid-input.c:
Mapping: Consumer.0109 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365578] drivers/hid/hid-input.c:
Mapping: Consumer.010a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365581] drivers/hid/hid-input.c:
Mapping: Consumer.010b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365584] drivers/hid/hid-input.c:
Mapping: Consumer.010c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365587] drivers/hid/hid-input.c:
Mapping: Consumer.010d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365590] drivers/hid/hid-input.c:
Mapping: Consumer.010e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365593] drivers/hid/hid-input.c:
Mapping: Consumer.010f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365595] drivers/hid/hid-input.c:
Mapping: Consumer.0110 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365598] drivers/hid/hid-input.c:
Mapping: Consumer.0111 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365601] drivers/hid/hid-input.c:
Mapping: Consumer.0112 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365604] drivers/hid/hid-input.c:
Mapping: Consumer.0113 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365607] drivers/hid/hid-input.c:
Mapping: Consumer.0114 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365610] drivers/hid/hid-input.c:
Mapping: Consumer.0115 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365613] drivers/hid/hid-input.c:
Mapping: Consumer.0116 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365616] drivers/hid/hid-input.c:
Mapping: Consumer.0117 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365619] drivers/hid/hid-input.c:
Mapping: Consumer.0118 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365622] drivers/hid/hid-input.c:
Mapping: Consumer.0119 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365625] drivers/hid/hid-input.c:
Mapping: Consumer.011a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365628] drivers/hid/hid-input.c:
Mapping: Consumer.011b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365630] drivers/hid/hid-input.c:
Mapping: Consumer.011c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365633] drivers/hid/hid-input.c:
Mapping: Consumer.011d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365636] drivers/hid/hid-input.c:
Mapping: Consumer.011e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365639] drivers/hid/hid-input.c:
Mapping: Consumer.011f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365642] drivers/hid/hid-input.c:
Mapping: Consumer.0120 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365645] drivers/hid/hid-input.c:
Mapping: Consumer.0121 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365648] drivers/hid/hid-input.c:
Mapping: Consumer.0122 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365651] drivers/hid/hid-input.c:
Mapping: Consumer.0123 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365654] drivers/hid/hid-input.c:
Mapping: Consumer.0124 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365657] drivers/hid/hid-input.c:
Mapping: Consumer.0125 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365660] drivers/hid/hid-input.c:
Mapping: Consumer.0126 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365663] drivers/hid/hid-input.c:
Mapping: Consumer.0127 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365665] drivers/hid/hid-input.c:
Mapping: Consumer.0128 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365668] drivers/hid/hid-input.c:
Mapping: Consumer.0129 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365671] drivers/hid/hid-input.c:
Mapping: Consumer.012a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365674] drivers/hid/hid-input.c:
Mapping: Consumer.012b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365677] drivers/hid/hid-input.c:
Mapping: Consumer.012c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365680] drivers/hid/hid-input.c:
Mapping: Consumer.012d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365683] drivers/hid/hid-input.c:
Mapping: Consumer.012e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365686] drivers/hid/hid-input.c:
Mapping: Consumer.012f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365689] drivers/hid/hid-input.c:
Mapping: Consumer.0130 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365692] drivers/hid/hid-input.c:
Mapping: Consumer.0131 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365695] drivers/hid/hid-input.c:
Mapping: Consumer.0132 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365698] drivers/hid/hid-input.c:
Mapping: Consumer.0133 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365701] drivers/hid/hid-input.c:
Mapping: Consumer.0134 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365703] drivers/hid/hid-input.c:
Mapping: Consumer.0135 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365706] drivers/hid/hid-input.c:
Mapping: Consumer.0136 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365709] drivers/hid/hid-input.c:
Mapping: Consumer.0137 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365712] drivers/hid/hid-input.c:
Mapping: Consumer.0138 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365715] drivers/hid/hid-input.c:
Mapping: Consumer.0139 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365718] drivers/hid/hid-input.c:
Mapping: Consumer.013a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365721] drivers/hid/hid-input.c:
Mapping: Consumer.013b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365724] drivers/hid/hid-input.c:
Mapping: Consumer.013c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365727] drivers/hid/hid-input.c:
Mapping: Consumer.013d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365730] drivers/hid/hid-input.c:
Mapping: Consumer.013e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365733] drivers/hid/hid-input.c:
Mapping: Consumer.013f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365735] drivers/hid/hid-input.c:
Mapping: Consumer.0140 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365738] drivers/hid/hid-input.c:
Mapping: Consumer.0141 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365741] drivers/hid/hid-input.c:
Mapping: Consumer.0142 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365744] drivers/hid/hid-input.c:
Mapping: Consumer.0143 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365747] drivers/hid/hid-input.c:
Mapping: Consumer.0144 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365750] drivers/hid/hid-input.c:
Mapping: Consumer.0145 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365753] drivers/hid/hid-input.c:
Mapping: Consumer.0146 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365756] drivers/hid/hid-input.c:
Mapping: Consumer.0147 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365759] drivers/hid/hid-input.c:
Mapping: Consumer.0148 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365762] drivers/hid/hid-input.c:
Mapping: Consumer.0149 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365765] drivers/hid/hid-input.c:
Mapping: Consumer.014a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365768] drivers/hid/hid-input.c:
Mapping: Consumer.014b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365770] drivers/hid/hid-input.c:
Mapping: Consumer.014c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365773] drivers/hid/hid-input.c:
Mapping: Consumer.014d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365776] drivers/hid/hid-input.c:
Mapping: Consumer.014e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365779] drivers/hid/hid-input.c:
Mapping: Consumer.014f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365782] drivers/hid/hid-input.c:
Mapping: Consumer.0150 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365785] drivers/hid/hid-input.c:
Mapping: Consumer.0151 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365788] drivers/hid/hid-input.c:
Mapping: Consumer.0152 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365791] drivers/hid/hid-input.c:
Mapping: Consumer.0153 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365794] drivers/hid/hid-input.c:
Mapping: Consumer.0154 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365797] drivers/hid/hid-input.c:
Mapping: Consumer.0155 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365800] drivers/hid/hid-input.c:
Mapping: Consumer.0156 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365803] drivers/hid/hid-input.c:
Mapping: Consumer.0157 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365805] drivers/hid/hid-input.c:
Mapping: Consumer.0158 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365808] drivers/hid/hid-input.c:
Mapping: Consumer.0159 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365811] drivers/hid/hid-input.c:
Mapping: Consumer.015a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365814] drivers/hid/hid-input.c:
Mapping: Consumer.015b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365817] drivers/hid/hid-input.c:
Mapping: Consumer.015c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365820] drivers/hid/hid-input.c:
Mapping: Consumer.015d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365823] drivers/hid/hid-input.c:
Mapping: Consumer.015e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365826] drivers/hid/hid-input.c:
Mapping: Consumer.015f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365829] drivers/hid/hid-input.c:
Mapping: Consumer.0160 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365832] drivers/hid/hid-input.c:
Mapping: Consumer.0161 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365835] drivers/hid/hid-input.c:
Mapping: Consumer.0162 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365838] drivers/hid/hid-input.c:
Mapping: Consumer.0163 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365840] drivers/hid/hid-input.c:
Mapping: Consumer.0164 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365843] drivers/hid/hid-input.c:
Mapping: Consumer.0165 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365846] drivers/hid/hid-input.c:
Mapping: Consumer.0166 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365849] drivers/hid/hid-input.c:
Mapping: Consumer.0167 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365852] drivers/hid/hid-input.c:
Mapping: Consumer.0168 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365855] drivers/hid/hid-input.c:
Mapping: Consumer.0169 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365858] drivers/hid/hid-input.c:
Mapping: Consumer.016a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365861] drivers/hid/hid-input.c:
Mapping: Consumer.016b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365864] drivers/hid/hid-input.c:
Mapping: Consumer.016c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365867] drivers/hid/hid-input.c:
Mapping: Consumer.016d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365870] drivers/hid/hid-input.c:
Mapping: Consumer.016e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365873] drivers/hid/hid-input.c:
Mapping: Consumer.016f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365876] drivers/hid/hid-input.c:
Mapping: Consumer.0170 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365878] drivers/hid/hid-input.c:
Mapping: Consumer.0171 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365881] drivers/hid/hid-input.c:
Mapping: Consumer.0172 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365884] drivers/hid/hid-input.c:
Mapping: Consumer.0173 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365887] drivers/hid/hid-input.c:
Mapping: Consumer.0174 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365890] drivers/hid/hid-input.c:
Mapping: Consumer.0175 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365893] drivers/hid/hid-input.c:
Mapping: Consumer.0176 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365896] drivers/hid/hid-input.c:
Mapping: Consumer.0177 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365899] drivers/hid/hid-input.c:
Mapping: Consumer.0178 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365902] drivers/hid/hid-input.c:
Mapping: Consumer.0179 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365905] drivers/hid/hid-input.c:
Mapping: Consumer.017a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365908] drivers/hid/hid-input.c:
Mapping: Consumer.017b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365911] drivers/hid/hid-input.c:
Mapping: Consumer.017c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365914] drivers/hid/hid-input.c:
Mapping: Consumer.017d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365916] drivers/hid/hid-input.c:
Mapping: Consumer.017e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365919] drivers/hid/hid-input.c:
Mapping: Consumer.017f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365922] drivers/hid/hid-input.c:
Mapping: Consumer.0180 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365925] drivers/hid/hid-input.c:
Mapping: Consumer.0181 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365928] drivers/hid/hid-input.c:
Mapping: Consumer.0182 ---> Key.Bookmarks
Dec 28 13:31:33 adolfo kernel: [ 3380.365931] drivers/hid/hid-input.c:
Mapping: Consumer.0183 ---> Key.Config
Dec 28 13:31:33 adolfo kernel: [ 3380.365935] drivers/hid/hid-input.c:
Mapping: Consumer.0184 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365938] drivers/hid/hid-input.c:
Mapping: Consumer.0185 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365941] drivers/hid/hid-input.c:
Mapping: Consumer.0186 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365944] drivers/hid/hid-input.c:
Mapping: Consumer.0187 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365948] drivers/hid/hid-input.c:
Mapping: Consumer.0188 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365951] drivers/hid/hid-input.c:
Mapping: Consumer.0189 ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365954] drivers/hid/hid-input.c:
Mapping: Consumer.018a ---> Key.Mail
Dec 28 13:31:33 adolfo kernel: [ 3380.365957] drivers/hid/hid-input.c:
Mapping: Consumer.018b ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365960] drivers/hid/hid-input.c:
Mapping: Consumer.018c ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365964] drivers/hid/hid-input.c:
Mapping: Consumer.018d ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.365967] drivers/hid/hid-input.c:
Mapping: Consumer.018e ---> Key.Calendar
Dec 28 13:31:33 adolfo kernel: [ 3380.365970] drivers/hid/hid-input.c:
Mapping: Consumer.018f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365973] drivers/hid/hid-input.c:
Mapping: Consumer.0190 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365976] drivers/hid/hid-input.c:
Mapping: Consumer.0191 ---> Key.Finance
Dec 28 13:31:33 adolfo kernel: [ 3380.365979] drivers/hid/hid-input.c:
Mapping: Consumer.0192 ---> Key.Calc
Dec 28 13:31:33 adolfo kernel: [ 3380.365983] drivers/hid/hid-input.c:
Mapping: Consumer.0193 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365985] drivers/hid/hid-input.c:
Mapping: Consumer.0194 ---> Key.File
Dec 28 13:31:33 adolfo kernel: [ 3380.365989] drivers/hid/hid-input.c:
Mapping: Consumer.0195 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365992] drivers/hid/hid-input.c:
Mapping: Consumer.0196 ---> Key.WWW
Dec 28 13:31:33 adolfo kernel: [ 3380.365995] drivers/hid/hid-input.c:
Mapping: Consumer.0197 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.365998] drivers/hid/hid-input.c:
Mapping: Consumer.0198 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366001] drivers/hid/hid-input.c:
Mapping: Consumer.0199 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366004] drivers/hid/hid-input.c:
Mapping: Consumer.019a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366007] drivers/hid/hid-input.c:
Mapping: Consumer.019b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366010] drivers/hid/hid-input.c:
Mapping: Consumer.019c ---> Key.Logoff
Dec 28 13:31:33 adolfo kernel: [ 3380.366013] drivers/hid/hid-input.c:
Mapping: Consumer.019d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366016] drivers/hid/hid-input.c:
Mapping: Consumer.019e ---> Key.Coffee
Dec 28 13:31:33 adolfo kernel: [ 3380.366019] drivers/hid/hid-input.c:
Mapping: Consumer.019f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366022] drivers/hid/hid-input.c:
Mapping: Consumer.01a0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366025] drivers/hid/hid-input.c:
Mapping: Consumer.01a1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366028] drivers/hid/hid-input.c:
Mapping: Consumer.01a2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366031] drivers/hid/hid-input.c:
Mapping: Consumer.01a3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366034] drivers/hid/hid-input.c:
Mapping: Consumer.01a4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366037] drivers/hid/hid-input.c:
Mapping: Consumer.01a5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366040] drivers/hid/hid-input.c:
Mapping: Consumer.01a6 ---> Key.Help
Dec 28 13:31:33 adolfo kernel: [ 3380.366043] drivers/hid/hid-input.c:
Mapping: Consumer.01a7 ---> Key.Documents
Dec 28 13:31:33 adolfo kernel: [ 3380.366046] drivers/hid/hid-input.c:
Mapping: Consumer.01a8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366049] drivers/hid/hid-input.c:
Mapping: Consumer.01a9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366052] drivers/hid/hid-input.c:
Mapping: Consumer.01aa ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366055] drivers/hid/hid-input.c:
Mapping: Consumer.01ab ---> Key.SpellCheck
Dec 28 13:31:33 adolfo kernel: [ 3380.366058] drivers/hid/hid-input.c:
Mapping: Consumer.01ac ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366061] drivers/hid/hid-input.c:
Mapping: Consumer.01ad ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366064] drivers/hid/hid-input.c:
Mapping: Consumer.01ae ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366067] drivers/hid/hid-input.c:
Mapping: Consumer.01af ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366070] drivers/hid/hid-input.c:
Mapping: Consumer.01b0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366073] drivers/hid/hid-input.c:
Mapping: Consumer.01b1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366076] drivers/hid/hid-input.c:
Mapping: Consumer.01b2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366079] drivers/hid/hid-input.c:
Mapping: Consumer.01b3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366082] drivers/hid/hid-input.c:
Mapping: Consumer.01b4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366085] drivers/hid/hid-input.c:
Mapping: Consumer.01b5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366088] drivers/hid/hid-input.c:
Mapping: Consumer.01b6 ---> Key.Media
Dec 28 13:31:33 adolfo kernel: [ 3380.366091] drivers/hid/hid-input.c:
Mapping: Consumer.01b7 ---> Key.Sound
Dec 28 13:31:33 adolfo kernel: [ 3380.366094] drivers/hid/hid-input.c:
Mapping: Consumer.01b8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366097] drivers/hid/hid-input.c:
Mapping: Consumer.01b9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366100] drivers/hid/hid-input.c:
Mapping: Consumer.01ba ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366103] drivers/hid/hid-input.c:
Mapping: Consumer.01bb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366106] drivers/hid/hid-input.c:
Mapping: Consumer.01bc ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.366109] drivers/hid/hid-input.c:
Mapping: Consumer.01bd ---> Key.Info
Dec 28 13:31:33 adolfo kernel: [ 3380.366112] drivers/hid/hid-input.c:
Mapping: Consumer.01be ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366116] drivers/hid/hid-input.c:
Mapping: Consumer.01bf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366118] drivers/hid/hid-input.c:
Mapping: Consumer.01c0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366121] drivers/hid/hid-input.c:
Mapping: Consumer.01c1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366124] drivers/hid/hid-input.c:
Mapping: Consumer.01c2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366127] drivers/hid/hid-input.c:
Mapping: Consumer.01c3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366130] drivers/hid/hid-input.c:
Mapping: Consumer.01c4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366133] drivers/hid/hid-input.c:
Mapping: Consumer.01c5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366136] drivers/hid/hid-input.c:
Mapping: Consumer.01c6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366139] drivers/hid/hid-input.c:
Mapping: Consumer.01c7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366142] drivers/hid/hid-input.c:
Mapping: Consumer.01c8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366145] drivers/hid/hid-input.c:
Mapping: Consumer.01c9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366148] drivers/hid/hid-input.c:
Mapping: Consumer.01ca ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366151] drivers/hid/hid-input.c:
Mapping: Consumer.01cb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366153] drivers/hid/hid-input.c:
Mapping: Consumer.01cc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366156] drivers/hid/hid-input.c:
Mapping: Consumer.01cd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366159] drivers/hid/hid-input.c:
Mapping: Consumer.01ce ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366162] drivers/hid/hid-input.c:
Mapping: Consumer.01cf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366165] drivers/hid/hid-input.c:
Mapping: Consumer.01d0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366168] drivers/hid/hid-input.c:
Mapping: Consumer.01d1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366171] drivers/hid/hid-input.c:
Mapping: Consumer.01d2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366174] drivers/hid/hid-input.c:
Mapping: Consumer.01d3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366177] drivers/hid/hid-input.c:
Mapping: Consumer.01d4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366180] drivers/hid/hid-input.c:
Mapping: Consumer.01d5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366183] drivers/hid/hid-input.c:
Mapping: Consumer.01d6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366186] drivers/hid/hid-input.c:
Mapping: Consumer.01d7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366189] drivers/hid/hid-input.c:
Mapping: Consumer.01d8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366191] drivers/hid/hid-input.c:
Mapping: Consumer.01d9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366194] drivers/hid/hid-input.c:
Mapping: Consumer.01da ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366197] drivers/hid/hid-input.c:
Mapping: Consumer.01db ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366200] drivers/hid/hid-input.c:
Mapping: Consumer.01dc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366203] drivers/hid/hid-input.c:
Mapping: Consumer.01dd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366206] drivers/hid/hid-input.c:
Mapping: Consumer.01de ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366209] drivers/hid/hid-input.c:
Mapping: Consumer.01df ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366212] drivers/hid/hid-input.c:
Mapping: Consumer.01e0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366215] drivers/hid/hid-input.c:
Mapping: Consumer.01e1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366218] drivers/hid/hid-input.c:
Mapping: Consumer.01e2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366221] drivers/hid/hid-input.c:
Mapping: Consumer.01e3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366224] drivers/hid/hid-input.c:
Mapping: Consumer.01e4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366226] drivers/hid/hid-input.c:
Mapping: Consumer.01e5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366229] drivers/hid/hid-input.c:
Mapping: Consumer.01e6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366232] drivers/hid/hid-input.c:
Mapping: Consumer.01e7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366235] drivers/hid/hid-input.c:
Mapping: Consumer.01e8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366238] drivers/hid/hid-input.c:
Mapping: Consumer.01e9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366241] drivers/hid/hid-input.c:
Mapping: Consumer.01ea ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366244] drivers/hid/hid-input.c:
Mapping: Consumer.01eb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366247] drivers/hid/hid-input.c:
Mapping: Consumer.01ec ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366250] drivers/hid/hid-input.c:
Mapping: Consumer.01ed ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366253] drivers/hid/hid-input.c:
Mapping: Consumer.01ee ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366256] drivers/hid/hid-input.c:
Mapping: Consumer.01ef ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366259] drivers/hid/hid-input.c:
Mapping: Consumer.01f0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366261] drivers/hid/hid-input.c:
Mapping: Consumer.01f1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366264] drivers/hid/hid-input.c:
Mapping: Consumer.01f2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366267] drivers/hid/hid-input.c:
Mapping: Consumer.01f3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366270] drivers/hid/hid-input.c:
Mapping: Consumer.01f4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366273] drivers/hid/hid-input.c:
Mapping: Consumer.01f5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366276] drivers/hid/hid-input.c:
Mapping: Consumer.01f6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366279] drivers/hid/hid-input.c:
Mapping: Consumer.01f7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366282] drivers/hid/hid-input.c:
Mapping: Consumer.01f8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366285] drivers/hid/hid-input.c:
Mapping: Consumer.01f9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366288] drivers/hid/hid-input.c:
Mapping: Consumer.01fa ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366291] drivers/hid/hid-input.c:
Mapping: Consumer.01fb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366294] drivers/hid/hid-input.c:
Mapping: Consumer.01fc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366296] drivers/hid/hid-input.c:
Mapping: Consumer.01fd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366299] drivers/hid/hid-input.c:
Mapping: Consumer.01fe ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366302] drivers/hid/hid-input.c:
Mapping: Consumer.01ff ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366305] drivers/hid/hid-input.c:
Mapping: Consumer.0200 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366308] drivers/hid/hid-input.c:
Mapping: Consumer.0201 ---> Key.New
Dec 28 13:31:33 adolfo kernel: [ 3380.366311] drivers/hid/hid-input.c:
Mapping: Consumer.0202 ---> Key.Open
Dec 28 13:31:33 adolfo kernel: [ 3380.366315] drivers/hid/hid-input.c:
Mapping: Consumer.0203 ---> Key.Close
Dec 28 13:31:33 adolfo kernel: [ 3380.366318] drivers/hid/hid-input.c:
Mapping: Consumer.0204 ---> Key.Exit
Dec 28 13:31:33 adolfo kernel: [ 3380.366321] drivers/hid/hid-input.c:
Mapping: Consumer.0205 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366324] drivers/hid/hid-input.c:
Mapping: Consumer.0206 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366327] drivers/hid/hid-input.c:
Mapping: Consumer.0207 ---> Key.Save
Dec 28 13:31:33 adolfo kernel: [ 3380.366330] drivers/hid/hid-input.c:
Mapping: Consumer.0208 ---> Key.Print
Dec 28 13:31:33 adolfo kernel: [ 3380.366333] drivers/hid/hid-input.c:
Mapping: Consumer.0209 ---> Key.Props
Dec 28 13:31:33 adolfo kernel: [ 3380.366337] drivers/hid/hid-input.c:
Mapping: Consumer.020a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366340] drivers/hid/hid-input.c:
Mapping: Consumer.020b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366343] drivers/hid/hid-input.c:
Mapping: Consumer.020c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366345] drivers/hid/hid-input.c:
Mapping: Consumer.020d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366348] drivers/hid/hid-input.c:
Mapping: Consumer.020e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366351] drivers/hid/hid-input.c:
Mapping: Consumer.020f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366354] drivers/hid/hid-input.c:
Mapping: Consumer.0210 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366357] drivers/hid/hid-input.c:
Mapping: Consumer.0211 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366360] drivers/hid/hid-input.c:
Mapping: Consumer.0212 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366363] drivers/hid/hid-input.c:
Mapping: Consumer.0213 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366366] drivers/hid/hid-input.c:
Mapping: Consumer.0214 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366369] drivers/hid/hid-input.c:
Mapping: Consumer.0215 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366372] drivers/hid/hid-input.c:
Mapping: Consumer.0216 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366375] drivers/hid/hid-input.c:
Mapping: Consumer.0217 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366378] drivers/hid/hid-input.c:
Mapping: Consumer.0218 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366380] drivers/hid/hid-input.c:
Mapping: Consumer.0219 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366383] drivers/hid/hid-input.c:
Mapping: Consumer.021a ---> Key.Undo
Dec 28 13:31:33 adolfo kernel: [ 3380.366387] drivers/hid/hid-input.c:
Mapping: Consumer.021b ---> Key.Copy
Dec 28 13:31:33 adolfo kernel: [ 3380.366390] drivers/hid/hid-input.c:
Mapping: Consumer.021c ---> Key.Cut
Dec 28 13:31:33 adolfo kernel: [ 3380.366393] drivers/hid/hid-input.c:
Mapping: Consumer.021d ---> Key.Paste
Dec 28 13:31:33 adolfo kernel: [ 3380.366396] drivers/hid/hid-input.c:
Mapping: Consumer.021e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366399] drivers/hid/hid-input.c:
Mapping: Consumer.021f ---> Key.Find
Dec 28 13:31:33 adolfo kernel: [ 3380.366403] drivers/hid/hid-input.c:
Mapping: Consumer.0220 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366406] drivers/hid/hid-input.c:
Mapping: Consumer.0221 ---> Key.Search
Dec 28 13:31:33 adolfo kernel: [ 3380.366409] drivers/hid/hid-input.c:
Mapping: Consumer.0222 ---> Key.Goto
Dec 28 13:31:33 adolfo kernel: [ 3380.366412] drivers/hid/hid-input.c:
Mapping: Consumer.0223 ---> Key.HomePage
Dec 28 13:31:33 adolfo kernel: [ 3380.366415] drivers/hid/hid-input.c:
Mapping: Consumer.0224 ---> Key.Back
Dec 28 13:31:33 adolfo kernel: [ 3380.366418] drivers/hid/hid-input.c:
Mapping: Consumer.0225 ---> Key.Forward
Dec 28 13:31:33 adolfo kernel: [ 3380.366422] drivers/hid/hid-input.c:
Mapping: Consumer.0226 ---> Key.Stop
Dec 28 13:31:33 adolfo kernel: [ 3380.366425] drivers/hid/hid-input.c:
Mapping: Consumer.0227 ---> Key.Refresh
Dec 28 13:31:33 adolfo kernel: [ 3380.366428] drivers/hid/hid-input.c:
Mapping: Consumer.0228 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366431] drivers/hid/hid-input.c:
Mapping: Consumer.0229 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366434] drivers/hid/hid-input.c:
Mapping: Consumer.022a ---> Key.Bookmarks
Dec 28 13:31:33 adolfo kernel: [ 3380.366437] drivers/hid/hid-input.c:
Mapping: Consumer.022b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366440] drivers/hid/hid-input.c:
Mapping: Consumer.022c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366443] drivers/hid/hid-input.c:
Mapping: Consumer.022d ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.366446] drivers/hid/hid-input.c:
Mapping: Consumer.022e ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.366449] drivers/hid/hid-input.c:
Mapping: Consumer.022f ---> Key.?
Dec 28 13:31:33 adolfo kernel: [ 3380.366453] drivers/hid/hid-input.c:
Mapping: Consumer.0230 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366456] drivers/hid/hid-input.c:
Mapping: Consumer.0231 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366458] drivers/hid/hid-input.c:
Mapping: Consumer.0232 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366461] drivers/hid/hid-input.c:
Mapping: Consumer.0233 ---> Key.ScrollUp
Dec 28 13:31:33 adolfo kernel: [ 3380.366465] drivers/hid/hid-input.c:
Mapping: Consumer.0234 ---> Key.ScrollDown
Dec 28 13:31:33 adolfo kernel: [ 3380.366468] drivers/hid/hid-input.c:
Mapping: Consumer.0235 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366471] drivers/hid/hid-input.c:
Mapping: Consumer.0236 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366474] drivers/hid/hid-input.c:
Mapping: Consumer.0237 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366477] drivers/hid/hid-input.c:
Mapping: Consumer.HorizontalWheel ---> Relative.HWheel
Dec 28 13:31:33 adolfo kernel: [ 3380.366480] drivers/hid/hid-input.c:
Mapping: Consumer.0239 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366483] drivers/hid/hid-input.c:
Mapping: Consumer.023a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366486] drivers/hid/hid-input.c:
Mapping: Consumer.023b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366489] drivers/hid/hid-input.c:
Mapping: Consumer.023c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366492] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemPowerDown ---> Key.Power
Dec 28 13:31:33 adolfo kernel: [ 3380.366495] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemSleep ---> Key.Sleep
Dec 28 13:31:33 adolfo kernel: [ 3380.366499] drivers/hid/hid-input.c:
Mapping: GenericDesktop.SystemWakeUp ---> Key.WakeUp
Dec 28 13:31:33 adolfo kernel: [ 3380.366502] drivers/hid/hid-input.c:
Mapping: Keyboard.0000 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366505] drivers/hid/hid-input.c:
Mapping: Keyboard.0001 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366508] drivers/hid/hid-input.c:
Mapping: Keyboard.0002 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366511] drivers/hid/hid-input.c:
Mapping: Keyboard.0003 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366514] drivers/hid/hid-input.c:
Mapping: Keyboard.0004 ---> Key.A
Dec 28 13:31:33 adolfo kernel: [ 3380.366517] drivers/hid/hid-input.c:
Mapping: Keyboard.0005 ---> Key.B
Dec 28 13:31:33 adolfo kernel: [ 3380.366520] drivers/hid/hid-input.c:
Mapping: Keyboard.0006 ---> Key.C
Dec 28 13:31:33 adolfo kernel: [ 3380.366523] drivers/hid/hid-input.c:
Mapping: Keyboard.0007 ---> Key.D
Dec 28 13:31:33 adolfo kernel: [ 3380.366526] drivers/hid/hid-input.c:
Mapping: Keyboard.0008 ---> Key.E
Dec 28 13:31:33 adolfo kernel: [ 3380.366530] drivers/hid/hid-input.c:
Mapping: Keyboard.0009 ---> Key.F
Dec 28 13:31:33 adolfo kernel: [ 3380.366533] drivers/hid/hid-input.c:
Mapping: Keyboard.000a ---> Key.G
Dec 28 13:31:33 adolfo kernel: [ 3380.366536] drivers/hid/hid-input.c:
Mapping: Keyboard.000b ---> Key.H
Dec 28 13:31:33 adolfo kernel: [ 3380.366539] drivers/hid/hid-input.c:
Mapping: Keyboard.000c ---> Key.I
Dec 28 13:31:33 adolfo kernel: [ 3380.366542] drivers/hid/hid-input.c:
Mapping: Keyboard.000d ---> Key.J
Dec 28 13:31:33 adolfo kernel: [ 3380.366545] drivers/hid/hid-input.c:
Mapping: Keyboard.000e ---> Key.K
Dec 28 13:31:33 adolfo kernel: [ 3380.366548] drivers/hid/hid-input.c:
Mapping: Keyboard.000f ---> Key.L
Dec 28 13:31:33 adolfo kernel: [ 3380.366551] drivers/hid/hid-input.c:
Mapping: Keyboard.0010 ---> Key.M
Dec 28 13:31:33 adolfo kernel: [ 3380.366554] drivers/hid/hid-input.c:
Mapping: Keyboard.0011 ---> Key.N
Dec 28 13:31:33 adolfo kernel: [ 3380.366557] drivers/hid/hid-input.c:
Mapping: Keyboard.0012 ---> Key.O
Dec 28 13:31:33 adolfo kernel: [ 3380.366560] drivers/hid/hid-input.c:
Mapping: Keyboard.0013 ---> Key.P
Dec 28 13:31:33 adolfo kernel: [ 3380.366563] drivers/hid/hid-input.c:
Mapping: Keyboard.0014 ---> Key.Q
Dec 28 13:31:33 adolfo kernel: [ 3380.366567] drivers/hid/hid-input.c:
Mapping: Keyboard.0015 ---> Key.R
Dec 28 13:31:33 adolfo kernel: [ 3380.366570] drivers/hid/hid-input.c:
Mapping: Keyboard.0016 ---> Key.S
Dec 28 13:31:33 adolfo kernel: [ 3380.366573] drivers/hid/hid-input.c:
Mapping: Keyboard.0017 ---> Key.T
Dec 28 13:31:33 adolfo kernel: [ 3380.366576] drivers/hid/hid-input.c:
Mapping: Keyboard.0018 ---> Key.U
Dec 28 13:31:33 adolfo kernel: [ 3380.366579] drivers/hid/hid-input.c:
Mapping: Keyboard.0019 ---> Key.V
Dec 28 13:31:33 adolfo kernel: [ 3380.366582] drivers/hid/hid-input.c:
Mapping: Keyboard.001a ---> Key.W
Dec 28 13:31:33 adolfo kernel: [ 3380.366585] drivers/hid/hid-input.c:
Mapping: Keyboard.001b ---> Key.X
Dec 28 13:31:33 adolfo kernel: [ 3380.366588] drivers/hid/hid-input.c:
Mapping: Keyboard.001c ---> Key.Y
Dec 28 13:31:33 adolfo kernel: [ 3380.366591] drivers/hid/hid-input.c:
Mapping: Keyboard.001d ---> Key.Z
Dec 28 13:31:33 adolfo kernel: [ 3380.366594] drivers/hid/hid-input.c:
Mapping: Keyboard.001e ---> Key.1
Dec 28 13:31:33 adolfo kernel: [ 3380.366597] drivers/hid/hid-input.c:
Mapping: Keyboard.001f ---> Key.2
Dec 28 13:31:33 adolfo kernel: [ 3380.366600] drivers/hid/hid-input.c:
Mapping: Keyboard.0020 ---> Key.3
Dec 28 13:31:33 adolfo kernel: [ 3380.366604] drivers/hid/hid-input.c:
Mapping: Keyboard.0021 ---> Key.4
Dec 28 13:31:33 adolfo kernel: [ 3380.366607] drivers/hid/hid-input.c:
Mapping: Keyboard.0022 ---> Key.5
Dec 28 13:31:33 adolfo kernel: [ 3380.366610] drivers/hid/hid-input.c:
Mapping: Keyboard.0023 ---> Key.6
Dec 28 13:31:33 adolfo kernel: [ 3380.366613] drivers/hid/hid-input.c:
Mapping: Keyboard.0024 ---> Key.7
Dec 28 13:31:33 adolfo kernel: [ 3380.366616] drivers/hid/hid-input.c:
Mapping: Keyboard.0025 ---> Key.8
Dec 28 13:31:33 adolfo kernel: [ 3380.366619] drivers/hid/hid-input.c:
Mapping: Keyboard.0026 ---> Key.9
Dec 28 13:31:33 adolfo kernel: [ 3380.366622] drivers/hid/hid-input.c:
Mapping: Keyboard.0027 ---> Key.0
Dec 28 13:31:33 adolfo kernel: [ 3380.366625] drivers/hid/hid-input.c:
Mapping: Keyboard.0028 ---> Key.Enter
Dec 28 13:31:33 adolfo kernel: [ 3380.366628] drivers/hid/hid-input.c:
Mapping: Keyboard.0029 ---> Key.Esc
Dec 28 13:31:33 adolfo kernel: [ 3380.366632] drivers/hid/hid-input.c:
Mapping: Keyboard.002a ---> Key.Backspace
Dec 28 13:31:33 adolfo kernel: [ 3380.366635] drivers/hid/hid-input.c:
Mapping: Keyboard.002b ---> Key.Tab
Dec 28 13:31:33 adolfo kernel: [ 3380.366638] drivers/hid/hid-input.c:
Mapping: Keyboard.002c ---> Key.Space
Dec 28 13:31:33 adolfo kernel: [ 3380.366641] drivers/hid/hid-input.c:
Mapping: Keyboard.002d ---> Key.Minus
Dec 28 13:31:33 adolfo kernel: [ 3380.366644] drivers/hid/hid-input.c:
Mapping: Keyboard.002e ---> Key.Equal
Dec 28 13:31:33 adolfo kernel: [ 3380.366647] drivers/hid/hid-input.c:
Mapping: Keyboard.002f ---> Key.LeftBrace
Dec 28 13:31:33 adolfo kernel: [ 3380.366650] drivers/hid/hid-input.c:
Mapping: Keyboard.0030 ---> Key.RightBrace
Dec 28 13:31:33 adolfo kernel: [ 3380.366654] drivers/hid/hid-input.c:
Mapping: Keyboard.0031 ---> Key.BackSlash
Dec 28 13:31:33 adolfo kernel: [ 3380.366657] drivers/hid/hid-input.c:
Mapping: Keyboard.0032 ---> Key.BackSlash
Dec 28 13:31:33 adolfo kernel: [ 3380.366660] drivers/hid/hid-input.c:
Mapping: Keyboard.0033 ---> Key.Semicolon
Dec 28 13:31:33 adolfo kernel: [ 3380.366663] drivers/hid/hid-input.c:
Mapping: Keyboard.0034 ---> Key.Apostrophe
Dec 28 13:31:33 adolfo kernel: [ 3380.366667] drivers/hid/hid-input.c:
Mapping: Keyboard.0035 ---> Key.Grave
Dec 28 13:31:33 adolfo kernel: [ 3380.366670] drivers/hid/hid-input.c:
Mapping: Keyboard.0036 ---> Key.Comma
Dec 28 13:31:33 adolfo kernel: [ 3380.366673] drivers/hid/hid-input.c:
Mapping: Keyboard.0037 ---> Key.Dot
Dec 28 13:31:33 adolfo kernel: [ 3380.366676] drivers/hid/hid-input.c:
Mapping: Keyboard.0038 ---> Key.Slash
Dec 28 13:31:33 adolfo kernel: [ 3380.366679] drivers/hid/hid-input.c:
Mapping: Keyboard.0039 ---> Key.CapsLock
Dec 28 13:31:33 adolfo kernel: [ 3380.366682] drivers/hid/hid-input.c:
Mapping: Keyboard.003a ---> Key.F1
Dec 28 13:31:33 adolfo kernel: [ 3380.366685] drivers/hid/hid-input.c:
Mapping: Keyboard.003b ---> Key.F2
Dec 28 13:31:33 adolfo kernel: [ 3380.366689] drivers/hid/hid-input.c:
Mapping: Keyboard.003c ---> Key.F3
Dec 28 13:31:33 adolfo kernel: [ 3380.366692] drivers/hid/hid-input.c:
Mapping: Keyboard.003d ---> Key.F4
Dec 28 13:31:33 adolfo kernel: [ 3380.366695] drivers/hid/hid-input.c:
Mapping: Keyboard.003e ---> Key.F5
Dec 28 13:31:33 adolfo kernel: [ 3380.366698] drivers/hid/hid-input.c:
Mapping: Keyboard.003f ---> Key.F6
Dec 28 13:31:33 adolfo kernel: [ 3380.366701] drivers/hid/hid-input.c:
Mapping: Keyboard.0040 ---> Key.F7
Dec 28 13:31:33 adolfo kernel: [ 3380.366704] drivers/hid/hid-input.c:
Mapping: Keyboard.0041 ---> Key.F8
Dec 28 13:31:33 adolfo kernel: [ 3380.366707] drivers/hid/hid-input.c:
Mapping: Keyboard.0042 ---> Key.F9
Dec 28 13:31:33 adolfo kernel: [ 3380.366710] drivers/hid/hid-input.c:
Mapping: Keyboard.0043 ---> Key.F10
Dec 28 13:31:33 adolfo kernel: [ 3380.366713] drivers/hid/hid-input.c:
Mapping: Keyboard.0044 ---> Key.F11
Dec 28 13:31:33 adolfo kernel: [ 3380.366717] drivers/hid/hid-input.c:
Mapping: Keyboard.0045 ---> Key.F12
Dec 28 13:31:33 adolfo kernel: [ 3380.366720] drivers/hid/hid-input.c:
Mapping: Keyboard.0046 ---> Key.SysRq
Dec 28 13:31:33 adolfo kernel: [ 3380.366723] drivers/hid/hid-input.c:
Mapping: Keyboard.0047 ---> Key.ScrollLock
Dec 28 13:31:33 adolfo kernel: [ 3380.366726] drivers/hid/hid-input.c:
Mapping: Keyboard.0048 ---> Key.Pause
Dec 28 13:31:33 adolfo kernel: [ 3380.366729] drivers/hid/hid-input.c:
Mapping: Keyboard.0049 ---> Key.Insert
Dec 28 13:31:33 adolfo kernel: [ 3380.366732] drivers/hid/hid-input.c:
Mapping: Keyboard.004a ---> Key.Home
Dec 28 13:31:33 adolfo kernel: [ 3380.366736] drivers/hid/hid-input.c:
Mapping: Keyboard.004b ---> Key.PageUp
Dec 28 13:31:33 adolfo kernel: [ 3380.366739] drivers/hid/hid-input.c:
Mapping: Keyboard.004c ---> Key.Delete
Dec 28 13:31:33 adolfo kernel: [ 3380.366742] drivers/hid/hid-input.c:
Mapping: Keyboard.004d ---> Key.End
Dec 28 13:31:33 adolfo kernel: [ 3380.366745] drivers/hid/hid-input.c:
Mapping: Keyboard.004e ---> Key.PageDown
Dec 28 13:31:33 adolfo kernel: [ 3380.366748] drivers/hid/hid-input.c:
Mapping: Keyboard.004f ---> Key.Right
Dec 28 13:31:33 adolfo kernel: [ 3380.366751] drivers/hid/hid-input.c:
Mapping: Keyboard.0050 ---> Key.Left
Dec 28 13:31:33 adolfo kernel: [ 3380.366754] drivers/hid/hid-input.c:
Mapping: Keyboard.0051 ---> Key.Down
Dec 28 13:31:33 adolfo kernel: [ 3380.366758] drivers/hid/hid-input.c:
Mapping: Keyboard.0052 ---> Key.Up
Dec 28 13:31:33 adolfo kernel: [ 3380.366761] drivers/hid/hid-input.c:
Mapping: Keyboard.0053 ---> Key.NumLock
Dec 28 13:31:33 adolfo kernel: [ 3380.366764] drivers/hid/hid-input.c:
Mapping: Keyboard.0054 ---> Key.KPSlash
Dec 28 13:31:33 adolfo kernel: [ 3380.366767] drivers/hid/hid-input.c:
Mapping: Keyboard.0055 ---> Key.KPAsterisk
Dec 28 13:31:33 adolfo kernel: [ 3380.366770] drivers/hid/hid-input.c:
Mapping: Keyboard.0056 ---> Key.KPMinus
Dec 28 13:31:33 adolfo kernel: [ 3380.366773] drivers/hid/hid-input.c:
Mapping: Keyboard.0057 ---> Key.KPPlus
Dec 28 13:31:33 adolfo kernel: [ 3380.366777] drivers/hid/hid-input.c:
Mapping: Keyboard.0058 ---> Key.KPEnter
Dec 28 13:31:33 adolfo kernel: [ 3380.366780] drivers/hid/hid-input.c:
Mapping: Keyboard.0059 ---> Key.KP1
Dec 28 13:31:33 adolfo kernel: [ 3380.366783] drivers/hid/hid-input.c:
Mapping: Keyboard.005a ---> Key.KP2
Dec 28 13:31:33 adolfo kernel: [ 3380.366786] drivers/hid/hid-input.c:
Mapping: Keyboard.005b ---> Key.KP3
Dec 28 13:31:33 adolfo kernel: [ 3380.366789] drivers/hid/hid-input.c:
Mapping: Keyboard.005c ---> Key.KP4
Dec 28 13:31:33 adolfo kernel: [ 3380.366792] drivers/hid/hid-input.c:
Mapping: Keyboard.005d ---> Key.KP5
Dec 28 13:31:33 adolfo kernel: [ 3380.366795] drivers/hid/hid-input.c:
Mapping: Keyboard.005e ---> Key.KP6
Dec 28 13:31:33 adolfo kernel: [ 3380.366798] drivers/hid/hid-input.c:
Mapping: Keyboard.005f ---> Key.KP7
Dec 28 13:31:33 adolfo kernel: [ 3380.366802] drivers/hid/hid-input.c:
Mapping: Keyboard.0060 ---> Key.KP8
Dec 28 13:31:33 adolfo kernel: [ 3380.366805] drivers/hid/hid-input.c:
Mapping: Keyboard.0061 ---> Key.KP9
Dec 28 13:31:33 adolfo kernel: [ 3380.366808] drivers/hid/hid-input.c:
Mapping: Keyboard.0062 ---> Key.KP0
Dec 28 13:31:33 adolfo kernel: [ 3380.366811] drivers/hid/hid-input.c:
Mapping: Keyboard.0063 ---> Key.KPDot
Dec 28 13:31:33 adolfo kernel: [ 3380.366814] drivers/hid/hid-input.c:
Mapping: Keyboard.0064 ---> Key.102nd
Dec 28 13:31:33 adolfo kernel: [ 3380.366817] drivers/hid/hid-input.c:
Mapping: Keyboard.0065 ---> Key.Compose
Dec 28 13:31:33 adolfo kernel: [ 3380.366820] drivers/hid/hid-input.c:
Mapping: Keyboard.0066 ---> Key.Power
Dec 28 13:31:33 adolfo kernel: [ 3380.366824] drivers/hid/hid-input.c:
Mapping: Keyboard.0067 ---> Key.KPEqual
Dec 28 13:31:33 adolfo kernel: [ 3380.366827] drivers/hid/hid-input.c:
Mapping: Keyboard.0068 ---> Key.F13
Dec 28 13:31:33 adolfo kernel: [ 3380.366830] drivers/hid/hid-input.c:
Mapping: Keyboard.0069 ---> Key.F14
Dec 28 13:31:33 adolfo kernel: [ 3380.366833] drivers/hid/hid-input.c:
Mapping: Keyboard.006a ---> Key.F15
Dec 28 13:31:33 adolfo kernel: [ 3380.366836] drivers/hid/hid-input.c:
Mapping: Keyboard.006b ---> Key.F16
Dec 28 13:31:33 adolfo kernel: [ 3380.366839] drivers/hid/hid-input.c:
Mapping: Keyboard.006c ---> Key.F17
Dec 28 13:31:33 adolfo kernel: [ 3380.366842] drivers/hid/hid-input.c:
Mapping: Keyboard.006d ---> Key.F18
Dec 28 13:31:33 adolfo kernel: [ 3380.366845] drivers/hid/hid-input.c:
Mapping: Keyboard.006e ---> Key.F19
Dec 28 13:31:33 adolfo kernel: [ 3380.366849] drivers/hid/hid-input.c:
Mapping: Keyboard.006f ---> Key.F20
Dec 28 13:31:33 adolfo kernel: [ 3380.366852] drivers/hid/hid-input.c:
Mapping: Keyboard.0070 ---> Key.F21
Dec 28 13:31:33 adolfo kernel: [ 3380.366855] drivers/hid/hid-input.c:
Mapping: Keyboard.0071 ---> Key.F22
Dec 28 13:31:33 adolfo kernel: [ 3380.366858] drivers/hid/hid-input.c:
Mapping: Keyboard.0072 ---> Key.F23
Dec 28 13:31:33 adolfo kernel: [ 3380.366861] drivers/hid/hid-input.c:
Mapping: Keyboard.0073 ---> Key.F24
Dec 28 13:31:33 adolfo kernel: [ 3380.366864] drivers/hid/hid-input.c:
Mapping: Keyboard.0074 ---> Key.Open
Dec 28 13:31:33 adolfo kernel: [ 3380.366867] drivers/hid/hid-input.c:
Mapping: Keyboard.0075 ---> Key.Help
Dec 28 13:31:33 adolfo kernel: [ 3380.366870] drivers/hid/hid-input.c:
Mapping: Keyboard.0076 ---> Key.Props
Dec 28 13:31:33 adolfo kernel: [ 3380.366874] drivers/hid/hid-input.c:
Mapping: Keyboard.0077 ---> Key.Front
Dec 28 13:31:33 adolfo kernel: [ 3380.366877] drivers/hid/hid-input.c:
Mapping: Keyboard.0078 ---> Key.Stop
Dec 28 13:31:33 adolfo kernel: [ 3380.366880] drivers/hid/hid-input.c:
Mapping: Keyboard.0079 ---> Key.Again
Dec 28 13:31:33 adolfo kernel: [ 3380.366883] drivers/hid/hid-input.c:
Mapping: Keyboard.007a ---> Key.Undo
Dec 28 13:31:33 adolfo kernel: [ 3380.366886] drivers/hid/hid-input.c:
Mapping: Keyboard.007b ---> Key.Cut
Dec 28 13:31:33 adolfo kernel: [ 3380.366889] drivers/hid/hid-input.c:
Mapping: Keyboard.007c ---> Key.Copy
Dec 28 13:31:33 adolfo kernel: [ 3380.366892] drivers/hid/hid-input.c:
Mapping: Keyboard.007d ---> Key.Paste
Dec 28 13:31:33 adolfo kernel: [ 3380.366896] drivers/hid/hid-input.c:
Mapping: Keyboard.007e ---> Key.Find
Dec 28 13:31:33 adolfo kernel: [ 3380.366899] drivers/hid/hid-input.c:
Mapping: Keyboard.007f ---> Key.Mute
Dec 28 13:31:33 adolfo kernel: [ 3380.366902] drivers/hid/hid-input.c:
Mapping: ffbc.0000 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366906] drivers/hid/hid-input.c:
Mapping: ffbc.0001 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366909] drivers/hid/hid-input.c:
Mapping: ffbc.0002 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366913] drivers/hid/hid-input.c:
Mapping: ffbc.0003 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366916] drivers/hid/hid-input.c:
Mapping: ffbc.0004 ---> Key.Again
Dec 28 13:31:33 adolfo kernel: [ 3380.366921] drivers/hid/hid-input.c:
Mapping: ffbc.0005 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366924] drivers/hid/hid-input.c:
Mapping: ffbc.0006 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366928] drivers/hid/hid-input.c:
Mapping: ffbc.0007 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366931] drivers/hid/hid-input.c:
Mapping: ffbc.0008 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366935] drivers/hid/hid-input.c:
Mapping: ffbc.0009 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366939] drivers/hid/hid-input.c:
Mapping: ffbc.000a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366942] drivers/hid/hid-input.c:
Mapping: ffbc.000b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366946] drivers/hid/hid-input.c:
Mapping: ffbc.000c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366949] drivers/hid/hid-input.c:
Mapping: ffbc.000d ---> Key.Home
Dec 28 13:31:33 adolfo kernel: [ 3380.366953] drivers/hid/hid-input.c:
Mapping: ffbc.000e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366957] drivers/hid/hid-input.c:
Mapping: ffbc.000f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366961] drivers/hid/hid-input.c:
Mapping: ffbc.0010 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366964] drivers/hid/hid-input.c:
Mapping: ffbc.0011 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366968] drivers/hid/hid-input.c:
Mapping: ffbc.0012 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366972] drivers/hid/hid-input.c:
Mapping: ffbc.0013 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366975] drivers/hid/hid-input.c:
Mapping: ffbc.0014 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366979] drivers/hid/hid-input.c:
Mapping: ffbc.0015 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366982] drivers/hid/hid-input.c:
Mapping: ffbc.0016 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366986] drivers/hid/hid-input.c:
Mapping: ffbc.0017 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366990] drivers/hid/hid-input.c:
Mapping: ffbc.0018 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366993] drivers/hid/hid-input.c:
Mapping: ffbc.0019 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.366997] drivers/hid/hid-input.c:
Mapping: ffbc.001a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367001] drivers/hid/hid-input.c:
Mapping: ffbc.001b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367004] drivers/hid/hid-input.c:
Mapping: ffbc.001c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367008] drivers/hid/hid-input.c:
Mapping: ffbc.001d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367011] drivers/hid/hid-input.c:
Mapping: ffbc.001e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367015] drivers/hid/hid-input.c:
Mapping: ffbc.001f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367019] drivers/hid/hid-input.c:
Mapping: ffbc.0020 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367022] drivers/hid/hid-input.c:
Mapping: ffbc.0021 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367026] drivers/hid/hid-input.c:
Mapping: ffbc.0022 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367030] drivers/hid/hid-input.c:
Mapping: ffbc.0023 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367033] drivers/hid/hid-input.c:
Mapping: ffbc.0024 ---> Key.Shuffle
Dec 28 13:31:33 adolfo kernel: [ 3380.367037] drivers/hid/hid-input.c:
Mapping: ffbc.0025 ---> Key.TV
Dec 28 13:31:33 adolfo kernel: [ 3380.367041] drivers/hid/hid-input.c:
Mapping: ffbc.0026 ---> Key.Menu
Dec 28 13:31:33 adolfo kernel: [ 3380.367045] drivers/hid/hid-input.c:
Mapping: ffbc.0027 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367049] drivers/hid/hid-input.c:
Mapping: ffbc.0028 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367052] drivers/hid/hid-input.c:
Mapping: ffbc.0029 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367056] drivers/hid/hid-input.c:
Mapping: ffbc.002a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367060] drivers/hid/hid-input.c:
Mapping: ffbc.002b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367063] drivers/hid/hid-input.c:
Mapping: ffbc.002c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367067] drivers/hid/hid-input.c:
Mapping: ffbc.002d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367070] drivers/hid/hid-input.c:
Mapping: ffbc.002e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367074] drivers/hid/hid-input.c:
Mapping: ffbc.002f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367078] drivers/hid/hid-input.c:
Mapping: ffbc.0030 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367081] drivers/hid/hid-input.c:
Mapping: ffbc.0031 ---> Key.Audio
Dec 28 13:31:33 adolfo kernel: [ 3380.367085] drivers/hid/hid-input.c:
Mapping: ffbc.0032 ---> Key.Text
Dec 28 13:31:33 adolfo kernel: [ 3380.367089] drivers/hid/hid-input.c:
Mapping: ffbc.0033 ---> Key.Last
Dec 28 13:31:33 adolfo kernel: [ 3380.367093] drivers/hid/hid-input.c:
Mapping: ffbc.0034 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367097] drivers/hid/hid-input.c:
Mapping: ffbc.0035 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367100] drivers/hid/hid-input.c:
Mapping: ffbc.0036 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367104] drivers/hid/hid-input.c:
Mapping: ffbc.0037 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367108] drivers/hid/hid-input.c:
Mapping: ffbc.0038 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367111] drivers/hid/hid-input.c:
Mapping: ffbc.0039 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367115] drivers/hid/hid-input.c:
Mapping: ffbc.003a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367119] drivers/hid/hid-input.c:
Mapping: ffbc.003b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367122] drivers/hid/hid-input.c:
Mapping: ffbc.003c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367126] drivers/hid/hid-input.c:
Mapping: ffbc.003d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367130] drivers/hid/hid-input.c:
Mapping: ffbc.003e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367133] drivers/hid/hid-input.c:
Mapping: ffbc.003f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367137] drivers/hid/hid-input.c:
Mapping: ffbc.0040 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367140] drivers/hid/hid-input.c:
Mapping: ffbc.0041 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367144] drivers/hid/hid-input.c:
Mapping: ffbc.0042 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367148] drivers/hid/hid-input.c:
Mapping: ffbc.0043 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367151] drivers/hid/hid-input.c:
Mapping: ffbc.0044 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367155] drivers/hid/hid-input.c:
Mapping: ffbc.0045 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367159] drivers/hid/hid-input.c:
Mapping: ffbc.0046 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367162] drivers/hid/hid-input.c:
Mapping: ffbc.0047 ---> Key.MP3
Dec 28 13:31:33 adolfo kernel: [ 3380.367166] drivers/hid/hid-input.c:
Mapping: ffbc.0048 ---> Key.DVD
Dec 28 13:31:33 adolfo kernel: [ 3380.367170] drivers/hid/hid-input.c:
Mapping: ffbc.0049 ---> Key.Media
Dec 28 13:31:33 adolfo kernel: [ 3380.367174] drivers/hid/hid-input.c:
Mapping: ffbc.004a ---> Key.Video
Dec 28 13:31:33 adolfo kernel: [ 3380.367178] drivers/hid/hid-input.c:
Mapping: ffbc.004b ---> Key.Angle
Dec 28 13:31:33 adolfo kernel: [ 3380.367182] drivers/hid/hid-input.c:
Mapping: ffbc.004c ---> Key.Language
Dec 28 13:31:33 adolfo kernel: [ 3380.367186] drivers/hid/hid-input.c:
Mapping: ffbc.004d ---> Key.Subtitle
Dec 28 13:31:33 adolfo kernel: [ 3380.367190] drivers/hid/hid-input.c:
Mapping: ffbc.004e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367194] drivers/hid/hid-input.c:
Mapping: ffbc.004f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367197] drivers/hid/hid-input.c:
Mapping: ffbc.0050 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367201] drivers/hid/hid-input.c:
Mapping: ffbc.0051 ---> Key.Red
Dec 28 13:31:33 adolfo kernel: [ 3380.367205] drivers/hid/hid-input.c:
Mapping: ffbc.0052 ---> Key.Close
Dec 28 13:31:33 adolfo kernel: [ 3380.367209] drivers/hid/hid-input.c:
Mapping: ffbc.0053 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367212] drivers/hid/hid-input.c:
Mapping: ffbc.0054 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367216] drivers/hid/hid-input.c:
Mapping: ffbc.0055 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367220] drivers/hid/hid-input.c:
Mapping: ffbc.0056 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367223] drivers/hid/hid-input.c:
Mapping: ffbc.0057 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367227] drivers/hid/hid-input.c:
Mapping: ffbc.0058 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367230] drivers/hid/hid-input.c:
Mapping: ffbc.0059 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367234] drivers/hid/hid-input.c:
Mapping: ffbc.005a ---> Key.Text
Dec 28 13:31:33 adolfo kernel: [ 3380.367238] drivers/hid/hid-input.c:
Mapping: ffbc.005b ---> Key.Red
Dec 28 13:31:33 adolfo kernel: [ 3380.367242] drivers/hid/hid-input.c:
Mapping: ffbc.005c ---> Key.Green
Dec 28 13:31:33 adolfo kernel: [ 3380.367246] drivers/hid/hid-input.c:
Mapping: ffbc.005d ---> Key.Yellow
Dec 28 13:31:33 adolfo kernel: [ 3380.367250] drivers/hid/hid-input.c:
Mapping: ffbc.005e ---> Key.Blue
Dec 28 13:31:33 adolfo kernel: [ 3380.367254] drivers/hid/hid-input.c:
Mapping: ffbc.005f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367257] drivers/hid/hid-input.c:
Mapping: ffbc.0060 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367261] drivers/hid/hid-input.c:
Mapping: ffbc.0061 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367264] drivers/hid/hid-input.c:
Mapping: ffbc.0062 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367268] drivers/hid/hid-input.c:
Mapping: ffbc.0063 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367272] drivers/hid/hid-input.c:
Mapping: ffbc.0064 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367275] drivers/hid/hid-input.c:
Mapping: ffbc.0065 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367279] drivers/hid/hid-input.c:
Mapping: ffbc.0066 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367283] drivers/hid/hid-input.c:
Mapping: ffbc.0067 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367286] drivers/hid/hid-input.c:
Mapping: ffbc.0068 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367290] drivers/hid/hid-input.c:
Mapping: ffbc.0069 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367293] drivers/hid/hid-input.c:
Mapping: ffbc.006a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367297] drivers/hid/hid-input.c:
Mapping: ffbc.006b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367301] drivers/hid/hid-input.c:
Mapping: ffbc.006c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367304] drivers/hid/hid-input.c:
Mapping: ffbc.006d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367308] drivers/hid/hid-input.c:
Mapping: ffbc.006e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367312] drivers/hid/hid-input.c:
Mapping: ffbc.006f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367315] drivers/hid/hid-input.c:
Mapping: ffbc.0070 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367319] drivers/hid/hid-input.c:
Mapping: ffbc.0071 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367322] drivers/hid/hid-input.c:
Mapping: ffbc.0072 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367326] drivers/hid/hid-input.c:
Mapping: ffbc.0073 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367330] drivers/hid/hid-input.c:
Mapping: ffbc.0074 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367333] drivers/hid/hid-input.c:
Mapping: ffbc.0075 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367337] drivers/hid/hid-input.c:
Mapping: ffbc.0076 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367341] drivers/hid/hid-input.c:
Mapping: ffbc.0077 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367344] drivers/hid/hid-input.c:
Mapping: ffbc.0078 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367348] drivers/hid/hid-input.c:
Mapping: ffbc.0079 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367351] drivers/hid/hid-input.c:
Mapping: ffbc.007a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367355] drivers/hid/hid-input.c:
Mapping: ffbc.007b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367359] drivers/hid/hid-input.c:
Mapping: ffbc.007c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367362] drivers/hid/hid-input.c:
Mapping: ffbc.007d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367366] drivers/hid/hid-input.c:
Mapping: ffbc.007e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367370] drivers/hid/hid-input.c:
Mapping: ffbc.007f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367373] drivers/hid/hid-input.c:
Mapping: ffbc.0080 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367377] drivers/hid/hid-input.c:
Mapping: ffbc.0081 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367381] drivers/hid/hid-input.c:
Mapping: ffbc.0082 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367384] drivers/hid/hid-input.c:
Mapping: ffbc.0083 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367388] drivers/hid/hid-input.c:
Mapping: ffbc.0084 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367391] drivers/hid/hid-input.c:
Mapping: ffbc.0085 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367395] drivers/hid/hid-input.c:
Mapping: ffbc.0086 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367399] drivers/hid/hid-input.c:
Mapping: ffbc.0087 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367402] drivers/hid/hid-input.c:
Mapping: ffbc.0088 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367406] drivers/hid/hid-input.c:
Mapping: ffbc.0089 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367409] drivers/hid/hid-input.c:
Mapping: ffbc.008a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367413] drivers/hid/hid-input.c:
Mapping: ffbc.008b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367417] drivers/hid/hid-input.c:
Mapping: ffbc.008c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367420] drivers/hid/hid-input.c:
Mapping: ffbc.008d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367424] drivers/hid/hid-input.c:
Mapping: ffbc.008e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367428] drivers/hid/hid-input.c:
Mapping: ffbc.008f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367431] drivers/hid/hid-input.c:
Mapping: ffbc.0090 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367435] drivers/hid/hid-input.c:
Mapping: ffbc.0091 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367438] drivers/hid/hid-input.c:
Mapping: ffbc.0092 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367442] drivers/hid/hid-input.c:
Mapping: ffbc.0093 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367446] drivers/hid/hid-input.c:
Mapping: ffbc.0094 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367449] drivers/hid/hid-input.c:
Mapping: ffbc.0095 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367453] drivers/hid/hid-input.c:
Mapping: ffbc.0096 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367457] drivers/hid/hid-input.c:
Mapping: ffbc.0097 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367460] drivers/hid/hid-input.c:
Mapping: ffbc.0098 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367464] drivers/hid/hid-input.c:
Mapping: ffbc.0099 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367467] drivers/hid/hid-input.c:
Mapping: ffbc.009a ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367471] drivers/hid/hid-input.c:
Mapping: ffbc.009b ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367475] drivers/hid/hid-input.c:
Mapping: ffbc.009c ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367478] drivers/hid/hid-input.c:
Mapping: ffbc.009d ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367482] drivers/hid/hid-input.c:
Mapping: ffbc.009e ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367486] drivers/hid/hid-input.c:
Mapping: ffbc.009f ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367489] drivers/hid/hid-input.c:
Mapping: ffbc.00a0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367493] drivers/hid/hid-input.c:
Mapping: ffbc.00a1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367496] drivers/hid/hid-input.c:
Mapping: ffbc.00a2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367500] drivers/hid/hid-input.c:
Mapping: ffbc.00a3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367504] drivers/hid/hid-input.c:
Mapping: ffbc.00a4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367507] drivers/hid/hid-input.c:
Mapping: ffbc.00a5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367511] drivers/hid/hid-input.c:
Mapping: ffbc.00a6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367515] drivers/hid/hid-input.c:
Mapping: ffbc.00a7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367518] drivers/hid/hid-input.c:
Mapping: ffbc.00a8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367522] drivers/hid/hid-input.c:
Mapping: ffbc.00a9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367525] drivers/hid/hid-input.c:
Mapping: ffbc.00aa ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367529] drivers/hid/hid-input.c:
Mapping: ffbc.00ab ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367533] drivers/hid/hid-input.c:
Mapping: ffbc.00ac ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367536] drivers/hid/hid-input.c:
Mapping: ffbc.00ad ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367540] drivers/hid/hid-input.c:
Mapping: ffbc.00ae ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367544] drivers/hid/hid-input.c:
Mapping: ffbc.00af ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367547] drivers/hid/hid-input.c:
Mapping: ffbc.00b0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367551] drivers/hid/hid-input.c:
Mapping: ffbc.00b1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367555] drivers/hid/hid-input.c:
Mapping: ffbc.00b2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367558] drivers/hid/hid-input.c:
Mapping: ffbc.00b3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367562] drivers/hid/hid-input.c:
Mapping: ffbc.00b4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367565] drivers/hid/hid-input.c:
Mapping: ffbc.00b5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367569] drivers/hid/hid-input.c:
Mapping: ffbc.00b6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367573] drivers/hid/hid-input.c:
Mapping: ffbc.00b7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367576] drivers/hid/hid-input.c:
Mapping: ffbc.00b8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367580] drivers/hid/hid-input.c:
Mapping: ffbc.00b9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367583] drivers/hid/hid-input.c:
Mapping: ffbc.00ba ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367587] drivers/hid/hid-input.c:
Mapping: ffbc.00bb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367591] drivers/hid/hid-input.c:
Mapping: ffbc.00bc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367594] drivers/hid/hid-input.c:
Mapping: ffbc.00bd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367598] drivers/hid/hid-input.c:
Mapping: ffbc.00be ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367602] drivers/hid/hid-input.c:
Mapping: ffbc.00bf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367605] drivers/hid/hid-input.c:
Mapping: ffbc.00c0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367609] drivers/hid/hid-input.c:
Mapping: ffbc.00c1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367613] drivers/hid/hid-input.c:
Mapping: ffbc.00c2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367616] drivers/hid/hid-input.c:
Mapping: ffbc.00c3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367620] drivers/hid/hid-input.c:
Mapping: ffbc.00c4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367623] drivers/hid/hid-input.c:
Mapping: ffbc.00c5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367627] drivers/hid/hid-input.c:
Mapping: ffbc.00c6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367631] drivers/hid/hid-input.c:
Mapping: ffbc.00c7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367634] drivers/hid/hid-input.c:
Mapping: ffbc.00c8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367638] drivers/hid/hid-input.c:
Mapping: ffbc.00c9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367641] drivers/hid/hid-input.c:
Mapping: ffbc.00ca ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367645] drivers/hid/hid-input.c:
Mapping: ffbc.00cb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367649] drivers/hid/hid-input.c:
Mapping: ffbc.00cc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367652] drivers/hid/hid-input.c:
Mapping: ffbc.00cd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367656] drivers/hid/hid-input.c:
Mapping: ffbc.00ce ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367660] drivers/hid/hid-input.c:
Mapping: ffbc.00cf ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367663] drivers/hid/hid-input.c:
Mapping: ffbc.00d0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367667] drivers/hid/hid-input.c:
Mapping: ffbc.00d1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367670] drivers/hid/hid-input.c:
Mapping: ffbc.00d2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367674] drivers/hid/hid-input.c:
Mapping: ffbc.00d3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367678] drivers/hid/hid-input.c:
Mapping: ffbc.00d4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367681] drivers/hid/hid-input.c:
Mapping: ffbc.00d5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367685] drivers/hid/hid-input.c:
Mapping: ffbc.00d6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367688] drivers/hid/hid-input.c:
Mapping: ffbc.00d7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367692] drivers/hid/hid-input.c:
Mapping: ffbc.00d8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367696] drivers/hid/hid-input.c:
Mapping: ffbc.00d9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367699] drivers/hid/hid-input.c:
Mapping: ffbc.00da ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367703] drivers/hid/hid-input.c:
Mapping: ffbc.00db ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367707] drivers/hid/hid-input.c:
Mapping: ffbc.00dc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367710] drivers/hid/hid-input.c:
Mapping: ffbc.00dd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367714] drivers/hid/hid-input.c:
Mapping: ffbc.00de ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367717] drivers/hid/hid-input.c:
Mapping: ffbc.00df ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367721] drivers/hid/hid-input.c:
Mapping: ffbc.00e0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367725] drivers/hid/hid-input.c:
Mapping: ffbc.00e1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367728] drivers/hid/hid-input.c:
Mapping: ffbc.00e2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367732] drivers/hid/hid-input.c:
Mapping: ffbc.00e3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367736] drivers/hid/hid-input.c:
Mapping: ffbc.00e4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367739] drivers/hid/hid-input.c:
Mapping: ffbc.00e5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367743] drivers/hid/hid-input.c:
Mapping: ffbc.00e6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367746] drivers/hid/hid-input.c:
Mapping: ffbc.00e7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367750] drivers/hid/hid-input.c:
Mapping: ffbc.00e8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367754] drivers/hid/hid-input.c:
Mapping: ffbc.00e9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367757] drivers/hid/hid-input.c:
Mapping: ffbc.00ea ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367761] drivers/hid/hid-input.c:
Mapping: ffbc.00eb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367765] drivers/hid/hid-input.c:
Mapping: ffbc.00ec ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367768] drivers/hid/hid-input.c:
Mapping: ffbc.00ed ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367772] drivers/hid/hid-input.c:
Mapping: ffbc.00ee ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367775] drivers/hid/hid-input.c:
Mapping: ffbc.00ef ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367779] drivers/hid/hid-input.c:
Mapping: ffbc.00f0 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367783] drivers/hid/hid-input.c:
Mapping: ffbc.00f1 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367786] drivers/hid/hid-input.c:
Mapping: ffbc.00f2 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367790] drivers/hid/hid-input.c:
Mapping: ffbc.00f3 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367794] drivers/hid/hid-input.c:
Mapping: ffbc.00f4 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367797] drivers/hid/hid-input.c:
Mapping: ffbc.00f5 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367801] drivers/hid/hid-input.c:
Mapping: ffbc.00f6 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367805] drivers/hid/hid-input.c:
Mapping: ffbc.00f7 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367808] drivers/hid/hid-input.c:
Mapping: ffbc.00f8 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367812] drivers/hid/hid-input.c:
Mapping: ffbc.00f9 ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367815] drivers/hid/hid-input.c:
Mapping: ffbc.00fa ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367819] drivers/hid/hid-input.c:
Mapping: ffbc.00fb ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367823] drivers/hid/hid-input.c:
Mapping: ffbc.00fc ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367826] drivers/hid/hid-input.c:
Mapping: ffbc.00fd ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367830] drivers/hid/hid-input.c:
Mapping: ffbc.00fe ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367834] drivers/hid/hid-input.c:
Mapping: ffbc.00ff ---> IGNORED
Dec 28 13:31:33 adolfo kernel: [ 3380.367911] input: Gyration Gyration
RF Technology Receiver as
/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.1/input/input25
Dec 28 13:31:33 adolfo kernel: [ 3380.424220] evbug.c: Connected
device: "Gyration Gyration RF Technology Receiver",
usb-0000:00:02.0-9/input1
Dec 28 13:31:33 adolfo kernel: [ 3380.424276] input,hiddev97,hidraw4:
USB HID v1.20 Mouse [Gyration Gyration RF Technology Receiver] on
usb-0000:00:02.0-9

#######################
"0" Key
#######################

Dec 28 13:31:44 adolfo kernel: [ 3392.665916] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:44 adolfo kernel: [ 3392.665922] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:31:44 adolfo kernel: [ 3392.665929] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665935] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665937] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665940] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665943] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665945] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665948] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665950] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:44 adolfo kernel: [ 3392.665953] hid-debug: input Keyboard.0027 = 1
Dec 28 13:31:44 adolfo kernel: [ 3392.665963] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:44 adolfo kernel: [ 3392.665970] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:31:44 adolfo kernel: [ 3392.665973] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865768] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:45 adolfo kernel: [ 3392.865774] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:31:45 adolfo kernel: [ 3392.865781] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865786] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865789] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865791] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865794] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865796] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865799] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865801] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865805] hid-debug: input Keyboard.0027 = 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865813] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:45 adolfo kernel: [ 3392.865819] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:31:45 adolfo kernel: [ 3392.865823] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0

#######################
"TV" Key
#######################

Dec 28 13:31:50 adolfo kernel: [ 3398.582532] drivers/hid/hid-core.c:
report (size 3) (numbered)
Dec 28 13:31:50 adolfo kernel: [ 3398.582538] drivers/hid/hid-core.c:
report 6 (size 2) =  00 00

#######################
"0" Key
#######################

Dec 28 13:31:53 adolfo kernel: [ 3401.227575] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:53 adolfo kernel: [ 3401.227581] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:31:53 adolfo kernel: [ 3401.227587] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227593] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227596] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227598] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227601] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227603] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227606] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227608] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.227612] hid-debug: input Keyboard.0027 = 1
Dec 28 13:31:53 adolfo kernel: [ 3401.227621] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:53 adolfo kernel: [ 3401.227628] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:31:53 adolfo kernel: [ 3401.227631] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379462] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:53 adolfo kernel: [ 3401.379468] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:31:53 adolfo kernel: [ 3401.379474] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379480] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379483] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379485] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379488] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379490] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379493] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379495] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379498] hid-debug: input Keyboard.0027 = 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379507] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:53 adolfo kernel: [ 3401.379513] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:31:53 adolfo kernel: [ 3401.379517] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0

#######################
"SETUP MENU" Key (no output)
#######################

#######################
"0" Key
#######################

Dec 28 13:31:58 adolfo kernel: [ 3405.848152] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:58 adolfo kernel: [ 3405.848158] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:31:58 adolfo kernel: [ 3405.848165] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848170] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848173] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848176] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848178] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848180] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848183] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848185] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:58 adolfo kernel: [ 3405.848189] hid-debug: input Keyboard.0027 = 1
Dec 28 13:31:58 adolfo kernel: [ 3405.848197] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:58 adolfo kernel: [ 3405.848204] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:31:58 adolfo kernel: [ 3405.848207] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048004] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:31:58 adolfo kernel: [ 3406.048010] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:31:58 adolfo kernel: [ 3406.048017] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048022] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048025] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048027] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048030] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048032] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048035] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048037] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048040] hid-debug: input Keyboard.0027 = 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048049] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:31:58 adolfo kernel: [ 3406.048056] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:31:58 adolfo kernel: [ 3406.048060] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0

#######################
"LAST" Key(no output)
#######################

#######################
"0" Key
#######################

Dec 28 13:32:02 adolfo kernel: [ 3410.436752] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:02 adolfo kernel: [ 3410.436758] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:32:02 adolfo kernel: [ 3410.436765] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436771] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436773] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436776] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436778] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436781] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436783] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436786] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.436789] hid-debug: input Keyboard.0027 = 1
Dec 28 13:32:02 adolfo kernel: [ 3410.436798] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:02 adolfo kernel: [ 3410.436805] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:32:02 adolfo kernel: [ 3410.436808] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628611] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:02 adolfo kernel: [ 3410.628617] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:32:02 adolfo kernel: [ 3410.628623] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628629] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628631] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628634] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628636] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628639] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628641] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628644] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628647] hid-debug: input Keyboard.0027 = 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628656] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:02 adolfo kernel: [ 3410.628662] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:32:02 adolfo kernel: [ 3410.628665] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0

#######################
"INPUT" Key (no output)
#######################

#######################
"0" Key
#######################

Dec 28 13:32:07 adolfo kernel: [ 3415.081313] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:07 adolfo kernel: [ 3415.081319] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:32:07 adolfo kernel: [ 3415.081325] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081331] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081333] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081336] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081339] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081341] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081344] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081346] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.081349] hid-debug: input Keyboard.0027 = 1
Dec 28 13:32:07 adolfo kernel: [ 3415.081358] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:07 adolfo kernel: [ 3415.081366] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:32:07 adolfo kernel: [ 3415.081369] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281165] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:07 adolfo kernel: [ 3415.281171] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:32:07 adolfo kernel: [ 3415.281177] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281182] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281185] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281188] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281190] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281193] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281198] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281201] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281204] hid-debug: input Keyboard.0027 = 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281213] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:07 adolfo kernel: [ 3415.281220] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:32:07 adolfo kernel: [ 3415.281223] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0

#######################
"POWER" Key
#######################

Dec 28 13:32:12 adolfo kernel: [ 3419.782830] drivers/hid/hid-core.c:
report (size 2) (numbered)
Dec 28 13:32:12 adolfo kernel: [ 3419.782836] drivers/hid/hid-core.c:
report 3 (size 1) =  82
Dec 28 13:32:12 adolfo kernel: [ 3419.782842] hid-debug: input
GenericDesktop.SystemPowerDown = 0
Dec 28 13:32:12 adolfo kernel: [ 3419.782847] hid-debug: input
GenericDesktop.SystemSleep = 1
Dec 28 13:32:12 adolfo kernel: [ 3419.782856] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 4, Code: 4, Value: 65666
Dec 28 13:32:12 adolfo kernel: [ 3419.782864] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3419.782866] hid-debug: input
GenericDesktop.SystemWakeUp = 0
Dec 28 13:32:12 adolfo kernel: [ 3419.782872] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 0
Dec 28 13:32:12 adolfo kernel: [ 3420.032899] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.032906] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.068869] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.068876] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.104839] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.104846] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.140811] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.140818] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.176783] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.176790] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.212754] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.212762] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.248726] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.248733] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.284698] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.284705] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.320669] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.320676] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.356640] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.356647] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.392612] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.392619] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.428584] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.428591] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.464555] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.464562] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.500527] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.500534] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.536499] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.536506] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.572470] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.572477] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.608441] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.608448] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.644413] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.644420] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:12 adolfo kernel: [ 3420.680384] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:12 adolfo kernel: [ 3420.680392] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.716356] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.716364] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.752327] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.752334] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.788300] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.788307] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.824272] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.824280] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.860242] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.860249] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.896216] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.896223] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.932186] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.932193] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3420.968156] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3420.968164] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.004130] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.004137] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.040100] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.040107] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.076072] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.076079] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.112043] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.112051] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.148015] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.148022] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.183987] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.183995] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.219958] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.219965] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.255929] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.255936] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.291901] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.291908] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.327872] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.327879] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.363844] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.363851] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.399815] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.399822] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.435787] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.435794] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.471759] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.471766] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.507730] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.507737] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.543700] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.543707] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.579674] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.579681] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.615645] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.615652] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:13 adolfo kernel: [ 3421.651617] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:13 adolfo kernel: [ 3421.651624] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.687589] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.687596] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.723560] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.723567] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.759532] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.759539] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.795503] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.795511] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.831475] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.831482] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.867445] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.867452] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.903418] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.903425] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.939389] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.939396] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3421.975361] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3421.975368] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.011332] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.011339] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.047304] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.047311] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.083275] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.083281] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.119246] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.119254] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.155218] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.155225] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.191190] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.191197] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.227161] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.227168] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.263132] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.263139] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.299104] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.299111] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.335076] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.335083] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.371047] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.371054] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.407019] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.407026] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.442990] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.442998] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.478962] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.478969] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.514934] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.514941] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.550906] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.550913] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.586877] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.586884] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.622848] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.622856] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:14 adolfo kernel: [ 3422.658819] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:14 adolfo kernel: [ 3422.658826] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.694790] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.694798] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.730762] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.730770] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.766734] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.766741] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.802705] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.802713] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.838677] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.838685] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.874649] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.874656] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.910620] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.910627] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.946591] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.946599] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3422.982564] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3422.982571] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.018536] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.018543] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.054507] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.054514] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.090478] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.090485] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.126449] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.126456] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.162421] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.162428] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.198393] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.198400] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.234364] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.234372] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.270336] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.270343] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.306307] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.306315] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.342282] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.342290] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.378252] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.378259] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.414222] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.414230] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.450194] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.450201] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.486166] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.486174] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.522136] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.522143] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.558109] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.558116] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.594079] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.594087] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.630061] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.630068] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:15 adolfo kernel: [ 3423.666026] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:15 adolfo kernel: [ 3423.666033] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.701995] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.702002] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.737966] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.737974] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.773938] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.773945] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.809908] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.809915] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.845902] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.845909] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.881852] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.881860] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.917825] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.917832] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.953796] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.953804] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3423.989768] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3423.989775] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.025739] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.025746] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.061711] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.061718] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.097682] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.097689] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.133654] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.133661] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.169624] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.169631] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.205597] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.205605] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.241568] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.241575] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.277540] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.277547] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.313511] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.313518] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.349482] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.349490] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.385455] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.385462] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.421426] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.421433] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.457397] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.457405] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.493368] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.493375] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.529340] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.529348] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.565312] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.565319] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.601283] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.601290] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.637255] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.637263] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:16 adolfo kernel: [ 3424.673226] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:16 adolfo kernel: [ 3424.673233] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.709199] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.709206] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.745169] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.745177] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.781142] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.781150] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.817114] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.817121] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.853084] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.853091] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1

#######################
"0" Key
#######################

Dec 28 13:32:17 adolfo kernel: [ 3424.858071] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:17 adolfo kernel: [ 3424.858079] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 27 00 00 00 00
Dec 28 13:32:17 adolfo kernel: [ 3424.858085] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858091] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858094] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858097] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858099] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858102] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858104] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858107] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:17 adolfo kernel: [ 3424.858110] hid-debug: input Keyboard.0027 = 1
Dec 28 13:32:17 adolfo kernel: [ 3424.858120] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:17 adolfo kernel: [ 3424.858127] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.858131] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:32:17 adolfo kernel: [ 3424.889057] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.889064] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.925027] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.925034] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.960999] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.961006] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3424.996971] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3424.996979] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.032942] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.032949] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.049927] drivers/hid/hid-core.c:
report (size 8) (numbered)
Dec 28 13:32:17 adolfo kernel: [ 3425.049935] drivers/hid/hid-core.c:
report 1 (size 7) =  00 00 00 00 00 00 00
Dec 28 13:32:17 adolfo kernel: [ 3425.049941] hid-debug: input Keyboard.00e0 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049947] hid-debug: input Keyboard.00e1 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049950] hid-debug: input Keyboard.00e2 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049953] hid-debug: input Keyboard.00e3 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049955] hid-debug: input Keyboard.00e4 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049958] hid-debug: input Keyboard.00e5 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049960] hid-debug: input Keyboard.00e6 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049963] hid-debug: input Keyboard.00e7 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049966] hid-debug: input Keyboard.0027 = 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049976] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 4, Code: 4, Value: 458791
Dec 28 13:32:17 adolfo kernel: [ 3425.049982] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 1, Code: 11, Value: 0
Dec 28 13:32:17 adolfo kernel: [ 3425.049986] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 0
Dec 28 13:32:17 adolfo kernel: [ 3425.068910] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.068915] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.104886] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.104893] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.140857] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.140864] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.176829] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.176837] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.212800] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.212807] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.248772] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.248779] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.284743] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.284750] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.320715] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.320722] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.356687] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.356694] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.392658] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.392665] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.428629] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.428636] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.464601] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.464608] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.500571] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.500578] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.536544] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.536551] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.572515] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.572522] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.608487] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.608494] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:17 adolfo kernel: [ 3425.644460] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:17 adolfo kernel: [ 3425.644467] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.680430] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.680437] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.716403] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.716411] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.752373] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.752380] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.788345] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.788352] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.824318] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.824326] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.860287] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.860294] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.896260] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.896267] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.932230] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.932238] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3425.968203] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3425.968210] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.004175] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.004182] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.040146] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.040152] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.076118] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.076125] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.112089] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.112096] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.148061] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.148068] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.184032] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.184039] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.220004] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.220011] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.255975] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.255981] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.291946] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.291954] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.327918] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.327925] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.363889] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.363897] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.399861] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.399868] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.435833] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.435840] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.471805] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.471813] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.507776] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.507783] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.543747] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.543754] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.579720] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.579727] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.615690] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.615697] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:18 adolfo kernel: [ 3426.651661] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:18 adolfo kernel: [ 3426.651668] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.687633] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.687640] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.723605] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.723612] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.759577] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.759584] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.795548] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.795555] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.831520] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.831527] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.867492] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.867499] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.903463] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.903470] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.939434] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.939441] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3426.975406] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3426.975413] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.011378] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.011385] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.047350] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.047357] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.083321] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.083328] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.119292] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.119299] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.155264] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.155271] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.191235] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.191242] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.227207] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.227214] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.263178] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.263185] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.299150] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.299157] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.335121] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.335128] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.371093] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.371100] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.407064] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.407071] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.443035] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.443043] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.479008] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.479015] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.514979] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.514986] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.550951] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.550958] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.586922] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.586929] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.622904] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.622911] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:19 adolfo kernel: [ 3427.658866] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:19 adolfo kernel: [ 3427.658873] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.694836] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.694844] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.730808] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.730815] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.766780] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.766787] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.802750] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.802757] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.838722] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.838729] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.874694] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.874701] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.910666] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.910673] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.946637] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.946645] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3427.982609] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3427.982617] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.018581] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.018589] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.054552] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.054559] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.090524] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.090531] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.126496] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.126503] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.162470] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.162477] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.198438] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.198445] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.234410] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.234417] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.270381] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.270388] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.306353] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.306360] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.342323] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.342330] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.378297] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.378304] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.414268] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.414274] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.450239] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.450246] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.486212] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.486219] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.522183] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.522190] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.558154] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.558160] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.594125] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.594132] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.630097] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.630104] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:20 adolfo kernel: [ 3428.666068] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:20 adolfo kernel: [ 3428.666075] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.702040] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.702047] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.738011] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.738018] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.773984] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.773991] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.809957] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.809964] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.845926] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.845933] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.881898] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.881905] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.917869] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.917877] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.953841] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.953849] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3428.989814] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3428.989822] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.025785] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.025792] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.061756] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.061763] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.097727] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.097734] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.133699] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.133706] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.169671] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.169678] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.205642] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.205650] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.241614] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.241621] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.277585] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.277592] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.313557] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.313564] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.349529] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.349535] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.385499] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.385507] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.421472] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.421479] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.457444] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.457451] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.493414] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.493421] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.529386] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.529393] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.565358] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.565365] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.601329] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.601336] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.637304] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.637312] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:21 adolfo kernel: [ 3429.673272] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:21 adolfo kernel: [ 3429.673279] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.709244] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.709251] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.745215] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.745223] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.781187] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.781195] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.817160] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.817167] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.853128] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.853135] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.889101] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.889109] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.925073] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.925081] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.961045] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.961052] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3429.997017] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3429.997025] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.032988] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.032995] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.068959] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.068966] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.104930] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.104938] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.140902] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.140909] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.176874] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.176882] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.212845] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.212852] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.248817] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.248824] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.284789] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.284796] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.320760] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.320768] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1

#######################
DISCONNECT
#######################

Dec 28 13:32:22 adolfo kernel: [ 3430.356418] usb 2-9: USB disconnect,
address 12
Dec 28 13:32:22 adolfo kernel: [ 3430.356732] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.356737] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.358509] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input0, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.368788] hald-addon-keyb[9630]
general protection eip:b7dda39c esp:bfbe74a8 error:0
Dec 28 13:32:22 adolfo NetworkManager: <debug> [1198855942.696224]
nm_hal_device_removed(): Device removed (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if0_logicaldev_input').
Dec 28 13:32:22 adolfo kernel: [ 3430.384713] evbug.c: Disconnected
device: usb-0000:00:02.0-9/input0
Dec 28 13:32:22 adolfo kernel: [ 3430.392701] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 2
Dec 28 13:32:22 adolfo kernel: [ 3430.392706] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo kernel: [ 3430.397589] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 1, Code: 142, Value: 0
Dec 28 13:32:22 adolfo kernel: [ 3430.397599] evbug.c: Event. Dev:
usb-0000:00:02.0-9/input1, Type: 0, Code: 0, Value: 1
Dec 28 13:32:22 adolfo NetworkManager: <debug> [1198855942.729543]
nm_hal_device_removed(): Device removed (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if0').
Dec 28 13:32:22 adolfo NetworkManager: <debug> [1198855942.755136]
nm_hal_device_removed(): Device removed (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if1_logicaldev_input').
Dec 28 13:32:22 adolfo kernel: [ 3430.440672] evbug.c: Disconnected
device: usb-0000:00:02.0-9/input1
Dec 28 13:32:22 adolfo NetworkManager: <debug> [1198855942.785495]
nm_hal_device_removed(): Device removed (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial_if1').
Dec 28 13:32:22 adolfo NetworkManager: <debug> [1198855942.791032]
nm_hal_device_removed(): Device removed (hal udi is
'/org/freedesktop/Hal/devices/usb_device_c16_2_noserial').
---------------------
End log

Thank you,
Adolfo
