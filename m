Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132Ab0ARWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0ARWUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852Ab0ARWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:20:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50119 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0ARWUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:20:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B54DE8C.6020502@s5r6.in-berlin.de>
Date: Mon, 18 Jan 2010 23:19:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Press NumLock -> panic in hidinput_find_field
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday I updated a rarely used PC from 2.6.32 to 2.6.33-rc4.  Today
this PC panicked when I attempted to switch on NumLock on a USB
keyboard.  There was X11 in the foreground.  I believe I had pressed
NumLock once or twice before at a text console.  Except for my dangerous
keypress, there was no other discernible activity of the system at that
moment (no active IO to disk, net, sound...).

One or two minutes before this happened, I ran a test with the
experimental firewire-net driver and had an unreliable connection over
it due to a funky hub.  This caused numerous log messages from
firewire-net about missing 1394 ACKs, but I believe it did not corrupt
the kernel or something.  (Also, this box had no firewire driver that
interacts with the input subsystem.)  Nevertheless, I mention this
detail in case that it turns out to be difficult to reproduce the
hiinput_find_field issue.

Luckily I had netconsole active at the time, so here is the crash log.
(Extra linebreaks were apparently inserted by netconsole or the remote
syslogd.)

BUG: unable to handle kernel
paging: request
at: 2a359669
IP:
hidinput_find_field+0x2a/0x79
*pde: = 00000000

Oops: 0000 [#1]
PREEMPT:
SMP:
DEBUG_PAGEALLOC:

last: sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:03:03.0/fw1/units
Modules: linked in:
firewire_net:
firewire_ohci:
firewire_core:
netconsole:
nfs:
lockd:
sunrpc:
i915:
drm_kms_helper:
drm:
i2c_algo_bit:
snd_hda_codec_idt:
snd_hda_intel:
snd_hda_codec:
snd_pcm:
snd_timer:
applesmc:
rtc:
led_class:
input_polldev:
snd:
i2c_i801:
sky2:
sg:
video:
backlight:
snd_page_alloc:
thermal:
output:
button:


Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.33-rc4 #2 Mac-F4208EC8/Macmini1,1
EIP: 0060:[<c11b4f94>] EFLAGS: 00010046 CPU: 0
EIP: is at hidinput_find_field+0x2a/0x79
EAX: f70d1e90 EBX: 2a359659 ECX: 00000000 EDX: 00000011
ESI: f55dadf0 EDI: 00000000 EBP: f70d1e78 ESP: f70d1e5c
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process: ksoftirqd/0 (pid: 4, ti=f70d0000 task=f70bd6e8 task.ti=f70d0000)
Stack:
00000000:
00000011:
c14f7ebc:
f625d440:
f5578000:
f62c4000:
00000011:
f70d1ea0:

kernel:
c11bcc85:
f70d1e90:
00000000:
f625d000:
f55787d4:
2a359659:
00000003:
f5578000:

kernel:
00000000:
f70d1ed0:
c11a792d:
00000001:
00000000:
00000000:
c133d4cc:
f5578000:

Call: Trace:
? usb_hidinput_input_event+0x64/0xe4
? input_handle_event+0x33c/0x35a
? usb_hidinput_input_event+0x0/0xe4
? input_inject_event+0x71/0x9e
? kbd_update_leds_helper+0x47/0x72
? input_handler_for_each_handle+0x45/0x83
? kbd_update_leds_helper+0x0/0x72
? kbd_bh+0x8b/0x98
? tasklet_action+0x8d/0xe0
? __do_softirq+0x8b/0x10a
? do_softirq+0x2b/0x43
? run_ksoftirqd+0x74/0x15a
? run_ksoftirqd+0x0/0x15a
? kthread+0x61/0x66
? kthread+0x0/0x66
? kernel_thread_helper+0x6/0x1a
Code:
c3:
55:
89:
e5:
57:
56:
53:
83:
ec:
10:
89:
55:
e8:
89:
4d:
e4:
8b:
b0:
40:
04:
00:
00:
05:
40:
04:
00:
00:
89:
45:
f0:
eb:
3e:
8b:
5c:
be:
10:
8b:
45:
08:
31:
c9:
89:
18:
syslog-ng[4117]: Error processing log message: <8b>
53:
10:
89:
55:
ec:
eb:
1b:
89:
ca:
c1:
e2:
04:
03:
53:
0c:
0f:
b6:
42:
0a:
3b:

EIP: [<c11b4f94>]
hidinput_find_field+0x2a/0x79:
SS: ESP 0068:f70d1e5c
CR2: 000000002a359669
---: end trace e9e7f394224a915e ]---
Kernel: panic - not syncing: Fatal exception in interrupt
Pid: 4, comm: ksoftirqd/0 Tainted: G	  D    2.6.33-rc4 #2
Call: Trace:
? printk+0xf/0x15
panic+0x43/0xf2
oops_end+0x6e/0x7c
no_context+0x114/0x11e
__bad_area_nosemaphore+0x139/0x141
? __lock_acquire+0x1479/0x1488
bad_area_nosemaphore+0xd/0x10
do_page_fault+0x131/0x29f
? do_page_fault+0x0/0x29f
error_code+0x6b/0x70
? do_page_fault+0x0/0x29f
? hidinput_find_field+0x2a/0x79
usb_hidinput_input_event+0x64/0xe4
input_handle_event+0x33c/0x35a
? usb_hidinput_input_event+0x0/0xe4
input_inject_event+0x71/0x9e
kbd_update_leds_helper+0x47/0x72
input_handler_for_each_handle+0x45/0x83
? kbd_update_leds_helper+0x0/0x72
kbd_bh+0x8b/0x98
tasklet_action+0x8d/0xe0
__do_softirq+0x8b/0x10a
do_softirq+0x2b/0x43
run_ksoftirqd+0x74/0x15a
? run_ksoftirqd+0x0/0x15a
kthread+0x61/0x66
? kthread+0x0/0x66
kernel_thread_helper+0x6/0x1a
------------: cut here ]------------
WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x22/0x45()
Hardware: name: Macmini1,1
Modules: linked in:
firewire_net:
firewire_ohci:
firewire_core:
netconsole:
nfs:
lockd:
sunrpc:
i915:
drm_kms_helper:
drm:
i2c_algo_bit:
snd_hda_codec_idt:
snd_hda_intel:
snd_hda_codec:
snd_pcm:
snd_timer:
applesmc:
rtc:
led_class:
input_polldev:
snd:
i2c_i801:
sky2:
sg:
video:
backlight:
snd_page_alloc:
thermal:
output:
button:

Pid: 4, comm: ksoftirqd/0 Tainted: G	  D    2.6.33-rc4 #2
Call: Trace:
warn_slowpath_common+0x60/0x90
warn_slowpath_null+0xd/0x10
native_smp_send_reschedule+0x22/0x45
resched_task+0x5b/0x5f
resched_cpu+0x5d/0x6d
scheduler_tick+0x157/0x1f1
update_process_times+0x37/0x43
tick_sched_timer+0x6c/0x90
? tick_sched_timer+0x0/0x90
__run_hrtimer+0x54/0x82
hrtimer_interrupt+0xd2/0x1ee
smp_apic_timer_interrupt+0x69/0x7c
apic_timer_interrupt+0x2f/0x34
? _raw_spin_unlock_irqrestore+0x2f/0x58
? panic+0xd0/0xf2
? panic+0xd3/0xf2
oops_end+0x6e/0x7c
no_context+0x114/0x11e
__bad_area_nosemaphore+0x139/0x141
? __lock_acquire+0x1479/0x1488
bad_area_nosemaphore+0xd/0x10
do_page_fault+0x131/0x29f
? do_page_fault+0x0/0x29f
error_code+0x6b/0x70
? do_page_fault+0x0/0x29f
? hidinput_find_field+0x2a/0x79
usb_hidinput_input_event+0x64/0xe4
input_handle_event+0x33c/0x35a
? usb_hidinput_input_event+0x0/0xe4
input_inject_event+0x71/0x9e
kbd_update_leds_helper+0x47/0x72
input_handler_for_each_handle+0x45/0x83
? kbd_update_leds_helper+0x0/0x72
kbd_bh+0x8b/0x98
tasklet_action+0x8d/0xe0
__do_softirq+0x8b/0x10a
do_softirq+0x2b/0x43
run_ksoftirqd+0x74/0x15a
? run_ksoftirqd+0x0/0x15a
kthread+0x61/0x66
? kthread+0x0/0x66
kernel_thread_helper+0x6/0x1a
---: end trace e9e7f394224a915f ]---


Just in case that it might be important:

$ grep CONFIG_INPUT .config
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set
CONFIG_INPUT_KEYBOARD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

-- 
Stefan Richter
-=====-==-=- ---= =--=-
http://arcgraph.de/sr/
