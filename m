Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYJOSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYJOSxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYJOSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:53:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31459 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYJOSxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=XI0dGpf4hFG+AkYG3E7xqj5zdO8YjWn1+pDMimZUcV5zUVrtf23tuv1TrYU6HJXVA6
         6b7Frg4lj6zmqwI6/hCH01WTNls/9ZIycl3pCC2tCNpn8UXWMFZ7opcjdrj6+5puehml
         R5bHzzN7CiHyOZC/KR6/9AEHSxOFMsL3lpBog=
Message-ID: <48F63C4E.3070103@tuffmail.co.uk>
Date: Wed, 15 Oct 2008 19:54:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo
 stress test
References: <gbiduj$9p3$1@ger.gmane.org> <200810151417.14661.laurent.pinchart@skynet.be> <48F61DA1.6060504@tuffmail.co.uk> <200810152017.47347.laurent.pinchart@skynet.be>
In-Reply-To: <200810152017.47347.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Alan,
>
> On Wednesday 15 October 2008, Alan Jenkins wrote:
>   
>> Laurent Pinchart wrote:
>>     
>>> Hi Alan,
>>>
>>> On Friday 26 September 2008, Alan Jenkins wrote:
>>>       
>>>> This is is on v2.6.27-rc6.  I originally saw it on todays -tip tree.
>>>>
>>>> # while true; do modprobe uvcvideo; modprobe -r uvcvideo; done
>>>>
>>>> After a few tens of cycles, modprobe gets stuck in "D" state, and the
>>>> following backtrace appears:
>>>>         
>>> [snip]
>>>
>>> I can't reproduce the issue here on 2.6.27. Could you please test that
>>> version ?
>>>       
>> Sure... still happens.
>>     
>
> I had secretly hoped it would have disapearred :-)
>
>   
>> If you look at the trace, it happens as "hald-probe-video" opens the
>> video device.  This is from Ubuntu 8.04.  Possibly it's significant that
>> I use the camera first, to make sure it works (I use Kopete, the
>> settings dialogue includes a video test).
>>     
>
> The NULL pointer (or rather 0x00000030 pointer) dereference happens in 
> video_open:
>
>         file->f_op = fops_get(vfl->fops);
>         if (file->f_op->open)
>                 err = file->f_op->open(inode, file);
>
> file->f_op ends up being NULL. Either vfl->fops is NULL to begin with, or 
> fops_get failed to get a reference to the file_operations structure.
>
> I'd be surprised if vfl->fops was NULL. To rule out that case, can you add a 
> BUG_ON(vfl->fops == NULL) before the call to fops_get ?
>
> I'm not too familiar with the module loader, but a quick look at the code 
> shows that the module could be marked as being unloaded (MODULE_STATE_GOING) 
> before its exit function is called. If this is the case video_open would 
> still be called, as the video device would still be registered, but fops_get 
> would fail in try_module_get and return a NULL pointer. It seems the pointer 
> returned by fops_get should be tested in video_open.
>
> I've CC'ed the v4l maintainer to get his opinion on this.
>   

I put one before and one after

134    BUG_ON(vfl->fops == NULL);
135    file->f_op = fops_get(vfl->fops);
136    BUG_ON(file->f_op == NULL);

and the second one triggered

[  245.379990] ------------[ cut here ]------------
[  245.379990] kernel BUG at drivers/media/video/v4l2-dev.c:136!
[  245.379990] invalid opcode: 0000 [#1]
[  245.379990] Modules linked in: uvcvideo(-) compat_ioctl32 videodev 
v4l1_compat aes_i586 aes_generic af_packet i915 drm cpufreq_userspace 
cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table 
cpufreq_conservative wmi sbs sbshc ip6t_LOG nf_conntrack_ipv6 ipt_LOG 
xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter 
ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat 
nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables 
x_tables dm_crypt dm_mod fuse joydev arc4 ecb crypto_blkcipher ath5k 
mac80211 led_class cfg80211 psmouse serio_raw sg snd_hda_intel 
ata_generic snd_pcm_oss snd_mixer_oss snd_pcm shpchp pci_hotplug 
snd_timer snd_page_alloc snd_hwdep intel_agp agpgart video output 
battery ac eeepc_laptop backlight button evdev uhci_hcd ehci_hcd 
usb_storage libusual usbcore pcspkr thermal processor fan [last 
unloaded: v4l1_compat]
[  245.379990]
[  245.379990] Pid: 11686, comm: hald-probe-vide Not tainted 
(2.6.27eeepc #62)
[  245.379990] EIP: 0060:[<e024f3f2>] EFLAGS: 00010246 CPU: 0
[  245.379990] EIP is at video_open+0x8f/0xee [videodev]
[  245.379990] EAX: e03fbf40 EBX: e02529dc ECX: 00000000 EDX: d1d20e00
[  245.379990] ESI: d1f33780 EDI: ffffffed EBP: de4e182c ESP: d1fade98
[  245.379990]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  245.379990] Process hald-probe-vide (pid: 11686, ti=d1fac000 
task=d8e73810 task.ti=d1fac000)
[  245.379990] Stack: 00000000 d1f20540 00000000 de4e182c c01604e6 
d1f33780 00000000 d1f33780
[  245.379990]        de4e182c d1fadf14 c0160406 c015d36d deae2580 
d22c8600 d1fadf14 d1f33780
[  245.379990]        d1fadf14 00008001 c015d471 d1f33780 00000000 
00000000 d1fadf14 c016692e
[  245.379990] Call Trace:
[  245.379990]  [<c01604e6>] chrdev_open+0xe0/0xf6
[  245.379990]  [<c0160406>] chrdev_open+0x0/0xf6
[  245.379990]  [<c015d36d>] __dentry_open+0xf2/0x1da
[  245.379990]  [<c015d471>] nameidata_to_filp+0x1c/0x2c
[  245.379990]  [<c016692e>] do_filp_open+0x343/0x61e
[  245.379990]  [<c014e1ad>] handle_mm_fault+0x27d/0x528
[  245.379990]  [<c016df2d>] alloc_fd+0x46/0xad
[  245.379990]  [<c015d1a8>] do_sys_open+0x3f/0xb3
[  245.379990]  [<c015d260>] sys_open+0x1e/0x23
[  245.379990]  [<c01035c1>] sysenter_do_call+0x12/0x21
[  245.379990]  [<c0280000>] xfrm_state_find+0x3bb/0x4b1
[  245.379990]  =======================
[  245.379990] Code: 74 77 8b 02 8b 5e 10 85 c0 75 04 0f 0b eb fe 8b 00 
85 c0 74 0d 31 c9 83 38 02 74 08 ff 80 40 01 00 00 8b 0a 85 c9 89 4e 10 
75 04 <0f> 0b eb fe 8b 49 30 31 ff 85 c9 74 36 89 f2 89 e8 ff d1 85 c0
[  245.379990] EIP: [<e024f3f2>] video_open+0x8f/0xee [videodev] SS:ESP 
0068:d1fade98
[  245.379990] ---[ end trace 2385a52acb7b9557 ]---

