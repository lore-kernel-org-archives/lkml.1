Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYLAWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYLAWq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYLAWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:46:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:57606 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYLAWqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:46:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:cc:content-type:content-transfer-encoding;
        b=ap1nA+K+WcTMBm/fA8vfm3VcycuAQC2Tz2TjUf1ZyZIbN40EHfo+oqV5TREakFf/TA
         W1rG/JfzVG5ZKMjUk2kCuERJ0reDOm+Oe8ayQ0YZmxBhLl4HIow+Zr5Zj2iIzjMrAoHs
         mrbVaOl70tv+LnjKzLpqjit7Xel0AhSZOgpkw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Subject: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Date: Mon, 1 Dec 2008 23:42:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128-dirty; KDE/4.1.3; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812012342.32575.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

After Fedora 9 -> Fedora 10 upgrade vanilla kernels which previously
worked fine (next-20081128 and next-20081121) started to hang randomly
on my Pentium M / 855PM / RV350 laptop.  Since (surprisingly) stock
Fedora kernel (2.6.27.5-117.fc10.i686) was not affected I got the idea
that either userspace changes uncovered some kernel regression or some
Fedora specific patch must be fixing the issue.  Unfortunately vanilla
2.6.27 also freezed so after the usual pain caused by hitting bunch of
unrelated problems [1] it turned out that drm-modesetting-radeon.patch
is the magic patch and CONFIG_DRM_RADEON_KMS is the magic change.  With
the patch and enabling the option next-20081128 works stable again...

Since the following error gets logged by kernel:

[drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
[drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.

and it also seems that system is more responsive now (it was kind of
sluggish previously) my draft theory is that F9 -> F10 triggered some
AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
but I'll leave figuring this up to the more knowledgeable people... ;)

Thanks,
Bart

PS1 full dmesg, config and lspci outputs are here:
http://www.kernel.org/pub/linux/kernel/people/bart/f9_to_f10_grind/

PS2 drm set mode reporting looks quite weird sometimes, i.e.:

...
[drm] LVDS-8: set mode �Տ�� d                                                   
[drm] bios LVDS_GEN_CNTL: 0x30ff24                                              
...

[1] some Fedora patches make quilt trip (quilt push applies whole patch
but quilt pop only removes a part of it) since they aggregate multiple
changes to a single file, execshield patch causes oops with my kernel
config and depmod run for a Fedora kernel config's build triggered OOM
kill (512M on this machine and yes, I was happily running without swap)
