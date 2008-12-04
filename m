Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYLDT60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYLDT60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLDT6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:58:16 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:8934 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYLDT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=npFJ3TZmXi2RnkMwpQiJvSQl8hAgJpYCqNlPhns3/tYtGLBEam6XFFi8kbaVXQ1JhV
         Xq1XAkZv92sfYDdBAJx8etcuYZHBwiS6i2TzYQRBYicNJmsnarOOUgAF3pkee75ivFuE
         uKNt6pySQbJiaeyuLqn2spqItcCDgRtUH2yeI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Date: Thu, 4 Dec 2008 20:55:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Benny Amorsen <benny+usenet@amorsen.dk>
References: <200812012342.32575.bzolnier@gmail.com> <200812031510.52685.bzolnier@gmail.com> <200812040107.36616.bzolnier@gmail.com>
In-Reply-To: <200812040107.36616.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042055.13731.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 03 December 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 02 December 2008, Dave Airlie wrote:
> > > On Tue, Dec 2, 2008 at 8:42 AM, Bartlomiej Zolnierkiewicz
> > > <bzolnier@gmail.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > After Fedora 9 -> Fedora 10 upgrade vanilla kernels which previously
> > > > worked fine (next-20081128 and next-20081121) started to hang randomly
> > > > on my Pentium M / 855PM / RV350 laptop.  Since (surprisingly) stock
> > > > Fedora kernel (2.6.27.5-117.fc10.i686) was not affected I got the idea
> > > > that either userspace changes uncovered some kernel regression or some
> > > > Fedora specific patch must be fixing the issue.  Unfortunately vanilla
> > > > 2.6.27 also freezed so after the usual pain caused by hitting bunch of
> > > > unrelated problems [1] it turned out that drm-modesetting-radeon.patch
> > > > is the magic patch and CONFIG_DRM_RADEON_KMS is the magic change.  With
> > > > the patch and enabling the option next-20081128 works stable again...
> > > >
> > > > Since the following error gets logged by kernel:
> > > >
> > > > [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
> > > > [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.
> > > >
> > > > and it also seems that system is more responsive now (it was kind of
> > > > sluggish previously) my draft theory is that F9 -> F10 triggered some
> > > > AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
> > > > but I'll leave figuring this up to the more knowledgeable people... ;)
> > > 
> > > Well KMS is a purely Fedora thing, and enabling it completely avoids
> > > the old driver codepaths so
> > > while it might fix it, its more by accident than design.
> > > 
> > > I'm trying to track down the rv3xx hangs with hpa at the moment as he
> > > sees them also, something in
> > >  the 2.6.26->2.6.27 timeframe. I'm hoping running the 2.6.26 drm on
> > > the 2.6.27 will help narrow it down.
> > > 
> > > Bisecting 2.6.26->2.6.27 might also help.
> > 
> > It could be a different issue.  I tried 2.6.26, 2.6.25 and 2.6.24
> > and they all hang (they all worked fine with Fedora 9)...
> > 
> > I will try some older kernels but I start thinking that the xorg's ati
> > driver update is the main cause (xorg-x11-drv-ati-6.8.0-19.fc9.i386.rpm
> > -> xorg-x11-drv-ati-6.9.0-54.fc10.i386.rpm).
> 
> I just went straight to trying downgrading the driver and the older driver
> indeed works fine.  Then I tried to narrow down the problem and the lucky
> winner this time is the cute (== undocumented and unsigned-off) patch
> called radeon-6.9.0-remove-limit-heuristics.patch.  The newer driver with
> only this patch reverted fixes hangs for vanilla kernels and drm errors
> for Fedora kernel.  Also performance problems that I've noticed in the
> meantime (slower playback of 720p videos, sluggish window scrolling in
> kmail) are completely gone.  That being said I'm not entirely sure whether

I was too quick here -- performance problems are still present with
_Fedora_ kernel.

Reassuming: what I currently need to do to get my gfx working properly
with F10 is reverting radeon-6.9.0-remove-limit-heuristics.patch from
xorg-x11-drv-ati and using vanilla kernel instead of Fedora's one.

> PS Since I was busy with debugging the problem I haven't noticed that you
> have released the new driver package (xorg-x11-drv-ati-6.9.0-59.fc10),
> however since it still contains the patch in question I don't think that
> it would help (anyway I'll test it tomorrow, I'm too tired now)...

It didn't help (as expected).

To add more fun I'm getting following DRM oops with next-2008120[3,4]:

BUG: unable to handle kernel NULL pointer dereference at 00000144
IP: [<e0900741>] drm_addmap_core+0x548/0x561 [drm]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
Modules linked in: radeon(+) drm lib80211_crypt_tkip xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 acerhk cpufreq_ondemand binfmt_misc snd_intel8x0m snd_intel8x0 snd_ac97_codec snd_seq_dummy ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd ipw2200 libipw soundcore snd_page_alloc uhci_hcd lib80211 parport_pc parport ehci_hcd

Pid: 1741, comm: modprobe Not tainted (2.6.28-rc7-next-20081204 #267) Extensa 2900
EIP: 0060:[<e0900741>] EFLAGS: 00213202 CPU: 0
EIP is at drm_addmap_core+0x548/0x561 [drm]
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: d9c11400
ESI: d9f56900 EDI: d9cd57c0 EBP: e0010000 ESP: d9ee8ea4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1741, ti=d9ee8000 task=d9cbd470 task.ti=d9ee8000)
Stack:
 d9cd57c0 00010000 d9c11400 00000002 d9c11420 d9cd57c8 d9c114d4 d9c114d4
 d9c114e0 00010000 d9ee8eec d9c11000 d9c11344 d9c11400 e09007c2 00000001
 00000082 d9ee8eec d9ee8ef4 00010000 e0a1774c 00000001 00000082 d9c11340
Call Trace:
 [<e09007c2>] drm_addmap+0x14/0x2e [drm]
 [<e0a1774c>] radeon_driver_load+0xef/0x15a [radeon]
 [<e0904f43>] drm_get_dev+0x240/0x4ab [drm]
 [<c01e48af>] kobject_get+0xf/0x13
 [<e09015ed>] drm_init+0x5a/0x89 [drm]
 [<e08a8000>] radeon_init+0x0/0x14 [radeon]
 [<c010112c>] _stext+0x44/0x108
 [<c01430a8>] sys_init_module+0x87/0x174
 [<c0102eb1>] sysenter_do_call+0x12/0x25
 [<c0310000>] rwsem_down_failed_common+0x7f/0x16a
Code: ea a0 df eb 35 8b 3c 24 8b 47 10 c7 47 1c 00 00 00 00 c1 e0 0c 89 47 18 8b 44 24 10 e8 30 ea a0 df 8b 54 24 08 8b 82 b0 02 00 00 <8b> 80 44 01 00 00 89 47 20 8b 4c 24 44 89 39 83 c4 28 89 d8 5b 
EIP: [<e0900741>] drm_addmap_core+0x548/0x561 [drm] SS:ESP 0068:d9ee8ea4
---[ end trace 06bac8f3f2edd26f ]---

which I think may be caused by:

commit c2f29f764c0daa0084674d4a463e7158ac5c4dc4
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 28 14:22:24 2008 +1000

    drm: move to kref per-master structures.

however I haven't verified it yet.

Thanks,
Bart
