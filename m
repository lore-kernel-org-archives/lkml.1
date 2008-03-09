Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYCIVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYCIVQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCIVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:16:29 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:39420 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYCIVQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:16:29 -0400
Date: Sun, 9 Mar 2008 22:16:24 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: bruno.roussel@free.fr
cc: LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org, jikos@jikos.cz
Subject: Re: possible recursive locking detected
In-Reply-To: <1205082504.47d41988f0db5@imp.free.fr>
Message-ID: <alpine.DEB.1.00.0803092215010.5349@sheep.housecafe.de>
References: <1205082504.47d41988f0db5@imp.free.fr>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, bruno.roussel@free.fr wrote:
> I have this report in dmesg :
>
> saa7146_vv: saa7146 (0): registered device video0 [v4l2]
> saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> DVB: registering new adapter (Hauppauge WinTV-NOVA-T usb2)
> dvb-usb: MAC address: 00:0d:fe:00:00:00
> DVB: registering frontend 1 (DiBcom 3000MC/P)...
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.24.2-1mdv #1
> ---------------------------------------------

Hm, strange: a similiar looking issue has been reported back in 2006, it
even comes with a patch: http://lkml.org/lkml/2006/10/14/38

..but I cannot tell if the patch made it into mainline. I've Cc'ed the i2c
folks, maybe they can tell what's going on here.

C.

> modprobe/2082 is trying to acquire lock:
> (&adap->bus_lock){--..}, at: [<eeed4133>] i2c_transfer+0x2c/0x4b [i2c_core]
>
> but task is already holding lock:
> (&adap->bus_lock){--..}, at: [<eeed4133>] i2c_transfer+0x2c/0x4b [i2c_core]
>
> other info that might help us debug this:
> 1 lock held by modprobe/2082:
> #0:  (&adap->bus_lock){--..}, at: [<eeed4133>] i2c_transfer+0x2c/0x4b
> [i2c_core]
>
> stack backtrace:
> Pid: 2082, comm: modprobe Not tainted 2.6.24.2-1mdv #1
> [<c01054c2>] show_trace_log_lvl+0x1a/0x2f
> [<c0105ccf>] show_trace+0x12/0x14
> [<c0105fd7>] dump_stack+0x6a/0x70
> [<c0139e5b>] __lock_acquire+0x16b/0xc32
> [<c013ad80>] lock_acquire+0x70/0x92
> [<c02c937f>] mutex_lock_nested+0xf9/0x2a4
> [<eeed4133>] i2c_transfer+0x2c/0x4b [i2c_core]
> [<eef611fb>] dibx000_i2c_gated_tuner_xfer+0x172/0x18c [dibx000_common]
> [<eeed4140>] i2c_transfer+0x39/0x4b [i2c_core]
> [<eefbc17c>] mt2060_readreg+0x48/0x68 [mt2060]
> [<eefbc486>] mt2060_attach+0x49/0x1ef [mt2060]
> [<eefa3527>] dibusb_dib3000mc_tuner_attach+0x145/0x1fb [dvb_usb_dibusb_common]
> [<eef83c49>] dvb_usb_adapter_frontend_init+0xc4/0xe8 [dvb_usb]
> [<eef837aa>] dvb_usb_device_init+0x3e8/0x4ce [dvb_usb]
> [<eef7f01c>] nova_t_probe+0x1c/0x1e [dvb_usb_nova_t_usb2]
> [<eeeb1f51>] usb_probe_interface+0xd5/0x112 [usbcore]
> [<c02420bb>] driver_probe_device+0xca/0x14d
> [<c0242225>] __driver_attach+0x4a/0x7f
> [<c024164f>] bus_for_each_dev+0x38/0x5a
> [<c0241f25>] driver_attach+0x19/0x1b
> [<c0241966>] bus_add_driver+0x76/0x194
> [<c02423dd>] driver_register+0x67/0x6c
> [<eeeb1ae7>] usb_register_driver+0x7e/0xe5 [usbcore]
> [<eef8d01b>] nova_t_module_init+0x1b/0x38 [dvb_usb_nova_t_usb2]
> [<c0140e78>] sys_init_module+0x12c6/0x1394
> [<c0103e12>] sysenter_past_esp+0x6b/0xc9
> =======================
> input: IR-receiver inside an USB DVB receiver as /class/input/input2
> dvb-usb: schedule remote query interval to 100 msecs.
> dvb-usb: Hauppauge WinTV-NOVA-T usb2 successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_nova_t_usb2
> DVB: registering frontend 0 (ST STV0299 DVB-S)...
> input: DVB on-card IR receiver as /class/input/input3
> dvb-ttpci: found av7110-0.
> --

-- 
BOFH excuse #274:

It was OK before you touched it.
