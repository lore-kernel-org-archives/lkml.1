Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYJOSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYJOSRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYJOSRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:17:39 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:31450 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbYJOSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:17:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsBABLP9UhR8Vqu/2dsb2JhbAAIwhCBaw
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo stress test
Date: Wed, 15 Oct 2008 20:17:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <gbiduj$9p3$1@ger.gmane.org> <200810151417.14661.laurent.pinchart@skynet.be> <48F61DA1.6060504@tuffmail.co.uk>
In-Reply-To: <48F61DA1.6060504@tuffmail.co.uk>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152017.47347.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wednesday 15 October 2008, Alan Jenkins wrote:
> Laurent Pinchart wrote:
> > Hi Alan,
> >
> > On Friday 26 September 2008, Alan Jenkins wrote:
> >> This is is on v2.6.27-rc6.  I originally saw it on todays -tip tree.
> >>
> >> # while true; do modprobe uvcvideo; modprobe -r uvcvideo; done
> >>
> >> After a few tens of cycles, modprobe gets stuck in "D" state, and the
> >> following backtrace appears:
> >
> > [snip]
> >
> > I can't reproduce the issue here on 2.6.27. Could you please test that
> > version ?
>
> Sure... still happens.

I had secretly hoped it would have disapearred :-)

> If you look at the trace, it happens as "hald-probe-video" opens the
> video device.  This is from Ubuntu 8.04.  Possibly it's significant that
> I use the camera first, to make sure it works (I use Kopete, the
> settings dialogue includes a video test).

The NULL pointer (or rather 0x00000030 pointer) dereference happens in 
video_open:

        file->f_op = fops_get(vfl->fops);
        if (file->f_op->open)
                err = file->f_op->open(inode, file);

file->f_op ends up being NULL. Either vfl->fops is NULL to begin with, or 
fops_get failed to get a reference to the file_operations structure.

I'd be surprised if vfl->fops was NULL. To rule out that case, can you add a 
BUG_ON(vfl->fops == NULL) before the call to fops_get ?

I'm not too familiar with the module loader, but a quick look at the code 
shows that the module could be marked as being unloaded (MODULE_STATE_GOING) 
before its exit function is called. If this is the case video_open would 
still be called, as the video device would still be registered, but fops_get 
would fail in try_module_get and return a NULL pointer. It seems the pointer 
returned by fops_get should be tested in video_open.

I've CC'ed the v4l maintainer to get his opinion on this.

> [  267.056655] input: UVC Camera (eb1a:2761) as /class/input/input59
> [  267.069990] usbcore: registered new interface driver uvcvideo
> [  267.069990] USB Video Class driver (v0.1.0)
> [  267.299989] usbcore: deregistering interface driver uvcvideo
> [  267.336656] Linux video capture interface: v2.00
> [  267.349981] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
> [  267.353317] input: UVC Camera (eb1a:2761) as /class/input/input60
> [  267.363324] usbcore: registered new interface driver uvcvideo
> [  267.363324] USB Video Class driver (v0.1.0)
> [  267.373325] BUG: unable to handle kernel NULL pointer dereference at
> 00000030
> [  267.373325] IP: [<e03e13ec>] :videodev:video_open+0x8b/0xe4
> [  267.373325] *pdpt = 0000000011ebc001 *pde = 0000000000000000
> [  267.373325] Oops: 0000 [#1]
> [  267.373325] Modules linked in: uvcvideo(-) compat_ioctl32 videodev
> v4l1_compat aes_i586 aes_generic af_packet i915 drm cpufreq_userspace
> cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table
> cpufreq_conservative wmi sbs sbshc ip6t_LOG nf_conntrack_ipv6 ipt_LOG
> xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter
> ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
> nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables
> x_tables dm_crypt dm_mod fuse joydev arc4 ecb crypto_blkcipher ath5k
> mac80211 led_class sg cfg80211 psmouse serio_raw snd_hda_intel
> snd_pcm_oss snd_mixer_oss ata_generic snd_pcm snd_timer snd_page_alloc
> snd_hwdep shpchp pci_hotplug intel_agp agpgart video output battery ac
> eeepc_laptop backlight button evdev uhci_hcd ehci_hcd usb_storage
> libusual pcspkr usbcore thermal processor fan [last unloaded: v4l1_compat]
> [  267.373325]
> [  267.373325] Pid: 7709, comm: hald-probe-vide Not tainted (2.6.27eeepc
> #61)
> [  267.373325] EIP: 0060:[<e03e13ec>] EFLAGS: 00010246 CPU: 0
> [  267.373325] EIP is at video_open+0x8b/0xe4 [videodev]
> [  267.373325] EAX: 00000000 EBX: e03e49d0 ECX: e03e1361 EDX: d1e6c000
> [  267.373325] ESI: d1ea5c80 EDI: 00000000 EBP: debf41ec ESP: d1efde98
> [  267.373325]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  267.373325] Process hald-probe-vide (pid: 7709, ti=d1efc000
> task=d1c586e0 task.ti=d1efc000)
> [  267.373325] Stack: 00000000 df1e17c0 00000000 debf41ec c01604e6
> d1ea5c80 00000000 d1ea5c80
> [  267.373325]        debf41ec d1efdf14 c0160406 c015d36d deae0580
> def61700 d1efdf14 d1ea5c80
> [  267.373325]        d1efdf14 00008001 c015d471 d1ea5c80 00000000
> 00000000 d1efdf14 c016692e
> [  267.373325] Call Trace:
> [  267.373325]  [<c01604e6>] chrdev_open+0xe0/0xf6
> [  267.373325]  [<c0160406>] chrdev_open+0x0/0xf6
> [  267.373325]  [<c015d36d>] __dentry_open+0xf2/0x1da
> [  267.373325]  [<c015d471>] nameidata_to_filp+0x1c/0x2c
> [  267.373325]  [<c016692e>] do_filp_open+0x343/0x61e
> [  267.373325]  [<c014e1ad>] handle_mm_fault+0x27d/0x528
> [  267.373325]  [<c016df2d>] alloc_fd+0x46/0xad
> [  267.373325]  [<c015d1a8>] do_sys_open+0x3f/0xb3
> [  267.373325]  [<c015d260>] sys_open+0x1e/0x23
> [  267.373325]  [<c01035c1>] sysenter_do_call+0x12/0x21
> [  267.373325]  [<c0280000>] xfrm_state_find+0x3bb/0x4b1
> [  267.373325]  =======================
> [  267.373325] Code: c4 0c 85 d2 74 6d 8b 02 8b 5e 10 85 c0 74 15 8b 00
> 85 c0 74 0b 83 38 02 74 0a ff 80 40 01 00 00 8b 02 eb 02 31 c0 89 46 10
> 31 ff <8b> 48 30 85 c9 74 36 89 f2 89 e8 ff d1 85 c0 89 c7 74 2a 8b 46
> [  267.373325] EIP: [<e03e13ec>] video_open+0x8b/0xe4 [videodev] SS:ESP
> 0068:d1efde98
> [  267.373325] ---[ end trace 1a1a7d2a0a55bf75 ]---
> [  267.379201] usbcore: deregistering interface driver uvcvideo

Best regards,

Laurent Pinchart
