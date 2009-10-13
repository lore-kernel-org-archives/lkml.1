Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbZJMUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbZJMUWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZJMUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:22:46 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:51060 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZJMUWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:22:45 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: 2.6.32-rc4 ipw2200: oops on missing firmware
References: <87hbu3h023.fsf@tac.ki.iif.hu>
	<200910131855.25878.elendil@planet.nl>
Date: Tue, 13 Oct 2009 22:22:06 +0200
In-Reply-To: <200910131855.25878.elendil@planet.nl> (Frans Pop's message of
	"Tue, 13 Oct 2009 18:55:24 +0200")
Message-ID: <873a5n59jl.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> writes:

> Adding relevant CCs.

Thanks.  Meanwhile I checked that the ipw2200 module can indeed be
removed and reinserted into the running system without problems,
here's the relevant part of dmesg:

[ 5837.082811] ipw2200: Firmware error detected.  Restarting.
[ 5840.507981] ipw2200: Firmware error detected.  Restarting.
[ 5886.248174] ipw2200 0000:02:02.0: PCI INT A disabled
[ 5919.283775] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[ 5919.283782] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[ 5919.283879] ipw2200 0000:02:02.0: PCI INT A -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
[ 5919.285697] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[ 5919.285771] ipw2200 0000:02:02.0: firmware: requesting ipw2200-bss.fw
[ 5919.466323] ipw2200: Detected geography ZZR (14 802.11bg channels, 0 802.11a channels)
[ 5919.477923] udev: renamed network interface eth0 to wlan
[ 5982.543067] ipw2200: Firmware error detected.  Restarting.
[ 5985.850947] ipw2200: Firmware error detected.  Restarting.
[ 5989.170633] ipw2200: Firmware error detected.  Restarting.
[ 5992.479084] ipw2200: Firmware error detected.  Restarting.
[ 5995.786495] ipw2200: Firmware error detected.  Restarting.
[ 5999.099022] ipw2200: Firmware error detected.  Restarting.
[ 6003.193188] QoS Error need to parse QOS_PARAMETER IE
[ 6029.106407] ipw2200: Firmware error detected.  Restarting.
[ 6032.415272] ipw2200: Firmware error detected.  Restarting.

Yes, I continuously get firmware errors, and occasionally the QoS
error.  I'm using firmware version 3.1, but these are probably
irrelevant for this bug report.

> Original message follows.
> ==============
> Hi,
>
> See the screenshot at http://apt.niif.hu/ipw_oops.png.  During bootup,
> initramfs-tools tried to load the ipw2200 module, but nobody fed it
> the necessary firmware, so request_firmware timed out and the module
> unload cleanup oopsed in device_pm_remove:
>
> void device_pm_remove(struct device *dev)
> {
>         pr_debug("PM: Removing info for %s:%s\n",
>                  dev->bus ? dev->bus->name : "No Bus",
>                  kobject_name(&dev->kobj));
>         mutex_lock(&dpm_list_mtx);
>         list_del_init(&dev->power.entry);
>         mutex_unlock(&dpm_list_mtx);
>         pm_runtime_remove(dev);
> }
>
> 00000a0a <device_pm_remove>:
>  a0a:   55                      push   %ebp
>  a0b:   89 e5                   mov    %esp,%ebp
>  a0d:   53                      push   %ebx
>  a0e:   89 c3                   mov    %eax,%ebx
>  a10:   b8 08 00 00 00          mov    $0x8,%eax
>  a15:   e8 fc ff ff ff          call   a16 <device_pm_remove+0xc>
>  a1a:   8d 4b 5c                lea    0x5c(%ebx),%ecx
>  a1d:   8b 53 5c                mov    0x5c(%ebx),%edx
>  a20:   8b 43 60                mov    0x60(%ebx),%eax
>  a23:   89 42 04                mov    %eax,0x4(%edx)
>  a26:   89 10                   mov    %edx,(%eax)
>  a28:   89 4b 5c                mov    %ecx,0x5c(%ebx)
>  a2b:   89 4b 60                mov    %ecx,0x60(%ebx)
>  a2e:   b8 08 00 00 00          mov    $0x8,%eax
>  a33:   e8 fc ff ff ff          call   a34 <device_pm_remove+0x2a>
>  a38:   89 d8                   mov    %ebx,%eax
>  a3a:   e8 fc ff ff ff          call   a3b <device_pm_remove+0x31>
>  a3f:   5b                      pop    %ebx
>  a40:   5d                      pop    %ebp
>  a41:   c3                      ret    
>
> The offending IP translates to line a23, so the problem is edx being 0
> at that point.  I'm not sure which struct device field has offset
> 0x5c, maybe power, but I'm lost at this point anyway.
>
> I don't know whether it's a new bug or not, never did such insane
> things previously.  rmmod ipw2200 definitely worked under 2.6.31, and
> it's possible that it works under 2.6.32-rc4 too, I forgot to check
> that (but will do so tonight).
>
> --
> Regards,
> Feri.
