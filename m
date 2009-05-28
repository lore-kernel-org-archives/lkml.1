Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZE1H7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZE1H7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZE1H72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:59:28 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:39934 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZE1H71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:59:27 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jonathan Corbet <corbet@lwn.net>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
Date: Thu, 28 May 2009 09:59:00 +0200
In-Reply-To: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de> (Jan Scholz's
	message of "Mon, 25 May 2009 17:44:17 +0200")
Message-ID: <87prdt3bgb.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Scholz <scholz@fias.uni-frankfurt.de> writes:

> Hi,
>
> On my PowerBook6,5 (iBook G4) the trackpad does not show up on the
> adb-bus after resuming from suspend to ram. This happens in roughly 50%
> of the resume cycles.
> Affected kernel versions: v2.6.30_rc1 through _rc7

I bisected the regression and found the first bad commit to be:
2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
"PM: Rework handling of interrupts during suspend-resume"

To those of you I cc'ed: sorry for the noise, but you were the ones that
get_maintainers.pl spit out when asking for *adb*-files.

In addition to the diff of the lshal output I posted before, here is the
diff in the output of lsadb:

--- lsadb-ok.out	2009-05-28 08:53:09.000000000 +0200
+++ lsadb-notouchpad.out	2009-05-28 08:55:59.000000000 +0200
@@ -1,35 +1,24 @@
 
 Devices connected to the ADB-Bus: (PMU: 12)
 
   D R  raw data                  decoded data
 -------------------------------------------------------------------------------------
   2.3: [62 c4]                   Encode Device
                                  Apple Macintosh PowerBook G3 Keyboard (ISO layout)
                                  Exceptional Event enabled
                                  Service Request enabled
     2: [ff ff]                   Qualifier: (not all must be supported)
                                   Fn-key   Delete   Caps-Lock   Reset      Control 
                                   Shift    Option   Apple       Num-Lock   Scroll-Lock 
                                   Scroll-Lock-LED   Caps-Lock-LED   Num-Lock-LED 
     1: [05 01]                   Special keys need Fn Key
     0: 
 
-  3.3: [23 04]                   Relative-Position Device
-                                 Extended Mouse Protokoll 
-                                 Exceptional Event disabled
-                                 Service Request enabled
-    2: [08 48 03 00 00 00 00 00]
-    1: [74 70 61 64 01 90 03 04] Mouse type:   tpad
-                                 resolution:   400 dpi
-                                 Device class: Trackpad
-                                 buttons:      4
-    0: 
-
   7.3: [67 1f]                   Misc. Device
                                  Powerbook G3 (Pismo) Button Device 
                                  Exceptional Event enabled
                                  Service Request enabled
     2: 
     1: 
     0:  

>
> Here is a diff of the output of lshal before and after the trackpad vanished:
>
> --- lshal-ok.out	2009-05-25 17:00:28.000000000 +0200
> +++ lshal-notouchpad.out	2009-05-25 17:04:42.000000000 +0200
> @@ -1,5 +1,5 @@
>  
> -Dumping 81 device(s) from the Global Device List:
> +Dumping 80 device(s) from the Global Device List:
>  -------------------------------------------------
>  udi = '/org/freedesktop/Hal/devices/computer'
>    info.addons = {'hald-addon-cpufreq'} (string list)
> @@ -95,21 +95,6 @@
>    linux.subsystem = 'input'  (string)
>    linux.sysfs_path = '/sys/devices/virtual/input/input4/event4'  (string)
>  
> -udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'
> -  info.capabilities = {'input', 'input.mouse'} (string list)
> -  info.category = 'input'  (string)
> -  info.parent = '/org/freedesktop/Hal/devices/computer'  (string)
> -  info.product = 'ADB mouse'  (string)
> -  info.subsystem = 'input'  (string)
> -  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'  (string)
> -  input.device = '/dev/input/event3'  (string)
> -  input.product = 'ADB mouse'  (string)
> -  input.x11_driver = 'evdev'  (string)
> -  linux.device_file = '/dev/input/event3'  (string)
> -  linux.hotplug_type = 2  (0x2)  (int)
> -  linux.subsystem = 'input'  (string)
> -  linux.sysfs_path = '/sys/devices/virtual/input/input3/event3'  (string)
> -
>  udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_1'
>    info.addons.singleton = {'hald-addon-input'} (string list)
>    info.capabilities = {'input', 'input.keys', 'button'} (string list)
> @@ -1820,6 +1805,6 @@
>    pci.vendor_id = 4203  (0x106b)  (int)
>  
>  
> -Dumped 81 device(s) from the Global Device List.
> +Dumped 80 device(s) from the Global Device List.
>  ------------------------------------------------
>
> Please let me know if you need more info.
>
> Regards, 
>  Jan Scholz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Jan Scholz                                ____  ____    __    ___ 
                                          ( ___)(_  _)  /__\  / __)
 Frankfurt Institute for Advanced Studies  )__)  _)(_  /(__)\ \__ \
                                          (__)  (____)(__)(__)(___/
 Goethe Universitaet Frankfurt
 Ruth-Moufang-Str. 1                             Tel. 069-798-47534
 60438 Frankfurt am Main
