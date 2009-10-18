Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZJRVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZJRVkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZJRVky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 17:40:54 -0400
Received: from lucidpixels.com ([75.144.35.66]:35836 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZJRVkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 17:40:53 -0400
Date: Sun, 18 Oct 2009 17:40:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: nut-upsuser@lists.alioth.debian.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <Pine.LNX.4.44L0.0910181640090.18952-100000@netrider.rowland.org>
Message-ID: <alpine.DEB.2.00.0910181732550.4761@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910181640090.18952-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Oct 2009, Alan Stern wrote:

> On Sun, 18 Oct 2009, Justin Piszcz wrote:
>
>>>> I have included debugging logs-- see below, is this a nut or kernel/USB
>>>> subsystem issue?
>>>>
>>>> Robert/Nut User List--
>>>>
>>>> Looks like the data goes stale, please let me know if any more
>>>> logs/debugging is required, is this a kernel/usb problem or a nut issue? I
>>>> recall a change in the USB subsystem a few kernel versions back caused a
>>>> different issue (on a different UPS, but nevertheless it was kernel
>>>> related).
>>>
>>
>> The details+logs are here (previous e-mail did not go through, too large for
>> the list):
>> wget http://home.comcast.net/~jpiszcz/20091014/nut-problem.txt
>>
>> For now I have disabled nut-- is there any more debugging that I can do to
>> help find/solve the problem?  Also cc'ing linux-usb & linux-kernel on this
>> one.
>
> You could collect a usbmon trace showing the problem.  For
> instructions, see the kernel source file Documentation/usb/usbmon.txt.
>
> It might also help to provide the dmesg log from a kernel built with
> CONFIG_USB_DEBUG enabled.
>
> Alan Stern
>

Thanks Alan,

I have performed all of the steps you recommended, there is also a bug in
the docs, the directory seems to be different, or at least if you have
everything compiled into the kernel and not using modules.

wget http://home.comcast.net/~jpiszcz/20091018/1.mon.out
wget http://home.comcast.net/~jpiszcz/20091018/2.6.31.4-dmesg-after.txt
wget http://home.comcast.net/~jpiszcz/20091018/2.6.31.4-dmesg-usb-debug2.txt
wget http://home.comcast.net/~jpiszcz/20091018/2.6.31.4-dmesg-usb-debug.txt

Steps from the USB documentation:

# mount -t debugfs none_debugs /sys/kernel/debug
#

The kernel documentation is outdated:

# ls /sys/kernel/debug/usbmon
0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
#

The directory is: 
# ls /sys/kernel/debug/usb/usbmon
0s  0u  1s  1t  1u  2s  2t  2u

Capture all output:
cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out

Start nut:
# /etc/init.d/nut start
Starting Network UPS Tools: upsdrvctl upsd upsmon.

Within ~20-30 seconds it already broke:
============================================================================
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 17:22 ...

Communications with UPS apc@localhost lost 
============================================================================
I waited another 20-30 seconds:
============================================================================
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 17:23 ...

Communications with UPS apc@localhost established 
============================================================================
Then a few seconds later:
============================================================================
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 17:23 ...

Communications with UPS apc@localhost lost 
============================================================================

# /etc/init.d/nut stop
Stopping Network UPS Tools: upsdrvctl upsd upsmon.

# control-c
# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out

# ls -l /tmp/1.mon.out
-rw-r--r-- 1 root root 88354 2009-10-18 17:24 /tmp/1.mon.out

# dmesg > /tmp/2.6.31.4-dmesg-after.txt

Text from dmesg-after.txt of interest:

[    9.245770] 0000:04:00.0: eth2: 10/100 speed: disabling TSO
[   35.448243] usb usb1: uevent
[   35.448271] usb 1-0:1.0: uevent
[   35.448303] usb 1-1: uevent
[   35.448333] usb 1-1.1: uevent
[   35.448361] usb 1-1.1.1: uevent
[   35.448388] usb 1-1.1.1:1.0: uevent
[   35.448543] usb 1-1.1.1:1.1: uevent
[   35.448698] usb 1-1.1.2: uevent
[   35.448727] usb 1-1.1.2:1.0: uevent
[   35.448915] usb 1-1.1:1.0: uevent
[   35.448939] usb 1-1:1.0: uevent
[   35.449737] usb usb2: uevent
[   35.449764] usb 2-0:1.0: uevent
[   35.449788] usb 2-1: uevent
[   35.449816] usb 2-1.6: uevent
[   35.449843] usb 2-1.6:1.0: uevent
[   35.449866] usb 2-1.6:1.1: uevent
[   35.449890] usb 2-1.7: uevent
[   35.449917] usb 2-1.7:1.0: uevent
[   35.450018] usb 2-1:1.0: uevent
[   35.631602] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 2 [1/2 us]
[   35.661556] usb 2-1: clear tt buffer port 7, a4 ep0 t00080e42
[   38.095486] usb 1-1.1.2: link qh8-0601/ffff8800cf0086c0 start 5 [1/2 us]
[  203.323838] usb 2-1: clear tt buffer port 7, a4 ep0 t00080e42
[  203.344727] usbhid 2-1.7:1.0: disconnect by usbfs
[  203.344744] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 2 [1/2 us]
[  203.344754] ehci_hcd 0000:00:1d.0: shutdown urb ffff88022d921540 ep1in-intr
[  203.344772] drivers/usb/core/file.c: removing 96 minor
[  204.144370] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  204.395021] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  204.395386] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  204.395389] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  204.487841] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  206.396322] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  206.396328] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  206.407416] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  208.397531] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  208.397537] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  208.454951] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  210.397943] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  210.397950] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  210.438499] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  212.398246] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  212.398252] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  212.422050] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  214.398555] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  214.398560] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  214.405607] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  216.398863] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  216.398869] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  216.453142] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  218.399177] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  218.399183] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  218.436710] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  220.399484] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  220.399489] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  220.420256] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  222.399787] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  222.399793] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  222.403809] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  224.400095] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  224.400101] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  224.451340] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  226.400405] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  226.400410] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  226.434901] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  228.400717] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  228.400723] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  228.418457] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  230.401025] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  230.401031] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  230.402020] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  232.401339] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  232.401341] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  232.449547] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 3 [1/2 us]
[  232.490278] usb 2-1: clear tt buffer port 7, a4 ep0 t00080e42
[  290.428240] usb 2-1: clear tt buffer port 7, a4 ep0 t00080e42
[  290.454378] usbfs 2-1.7:1.0: disconnect by usbfs
[  290.671011] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 4 [1/2 us]
[  290.677315] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 4 [1/2 us]
[  292.410579] ehci_hcd 0000:00:1d.0: reused qh ffff8800cf00c3c0 schedule
[  292.410585] usb 2-1.7: link qh64-0601/ffff8800cf00c3c0 start 4 [1/2 us]
[  292.469048] usb 2-1.7: unlink qh64-0601/ffff8800cf00c3c0 start 4 [1/2 us]
[  292.473781] usb 2-1: clear tt buffer port 7, a4 ep0 t00080e42

A snippet from 1.mon.out:

ffff88022bee2380 341311138 S Ci:2:004:0 s 80 06 0300 0000 00ff 255 <
ffff88022bee2380 341312510 C Ci:2:004:0 0 4 = 04030904
ffff88022bee2380 341312515 S Ci:2:004:0 s 80 06 0302 0409 00ff 255 <
ffff88022bee2380 341331883 C Ci:2:004:0 0 30 = 1e033800 42003000 38003200 32005200 33003400 34003700 35002000 2000
ffff88022bee2380 343276840 S Ci:2:004:0 s 80 06 0300 0000 00ff 255 <
ffff88022bee2380 343282777 C Ci:2:004:0 0 4 = 04030904
ffff88022bee2380 343282783 S Ci:2:004:0 s 80 06 0303 0409 00ff 255 <
ffff88022bee2380 343293150 C Ci:2:004:0 0 52 = 34034100 6d006500 72006900 63006100 6e002000 50006f00 77006500 72002000
ffff88022bee2380 343293157 S Ci:2:004:0 s 80 06 0300 0000 00ff 255 <
ffff88022bee2380 343295400 C Ci:2:004:0 0 4 = 04030904
ffff88022bee2380 343295406 S Ci:2:004:0 s 80 06 0301 0409 00ff 255 <
ffff88022bee2380 343312151 C Ci:2:004:0 0 90 = 5a034200 61006300 6b002d00 55005000 53002000 52005300 20003100 35003000
ffff88022bee2380 343312157 S Ci:2:004:0 s 80 06 0300 0000 00ff 255 <
ffff88022bee2380 343316151 C Ci:2:004:0 0 4 = 04030904
ffff88022bee2380 343316155 S Ci:2:004:0 s 80 06 0302 0409 00ff 255 <
ffff88022bee2380 343335654 C Ci:2:004:0 0 30 = 1e033800 42003000 38003200 32005200 33003400 34003700 35002000 2000
ffff88022bee2380 345277876 S Ci:2:004:0 s 80 06 0300 0000 00ff 255 <
ffff88022bee2380 345283673 C Ci:2:004:0 0 4 = 04030904
ffff88022bee2380 345283681 S Ci:2:004:0 s 80 06 0303 0409 00ff 255 <
ffff88022bee2380 345294172 C Ci:2:004:0 0 52 = 34034100 6d006500 72006900 63006100 6e002000 50006f00 77006500 72002000

Please let me know if this helps.

Justin.

