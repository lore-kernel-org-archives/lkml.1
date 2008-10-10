Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYJJKZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYJJKZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYJJKZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:25:33 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:37520 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYJJKZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:25:32 -0400
X-Greylist: delayed 1392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 06:25:31 EDT
Date: Fri, 10 Oct 2008 12:02:00 +0200
From: Vegard Nossum <vegardno@ifi.uio.no>
To: Dave Airlie <airlied@redhat.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: fix leak of uninitialized data to userspace
Message-ID: <20081010100200.GA752@thuin.ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 094ED6AC1A89E9802DAC967C34A0C8FA35B3D0E4
X-UiO-SPAM-Test: remote_host: 129.240.72.42 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 256 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f2e1569413900fa3ce5dad571e1a24d31307ab75 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegardno@thuin.ifi.uio.no>
Date: Fri, 10 Oct 2008 11:50:57 +0200
Subject: [PATCH] drm: fix leak of uninitialized data to userspace

On Fri, Oct 10, 2008 at 10:54 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>
> [  175.375036] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f65d2294)
> [  175.375049] 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
> [  175.375096]  i i i i i i i i i i i i i i i i i u u u u u u u u u u u u u u u
> [  175.375137]                                          ^
> [  175.375142]
> [  175.375148] Pid: 2288, comm: Xorg Not tainted (2.6.27-tipskw-00069-g37cb0b7-dirty #81) 900
> [  175.375155] EIP: 0060:[<c020d283>] EFLAGS: 00003246 CPU: 0
> [  175.375169] EIP is at __copy_to_user_ll+0x43/0x60
> [  175.375174] EAX: 00000000 EBX: 00000028 ECX: 00000005 EDX: f65d2280
> [  175.375180] ESI: f65d2294 EDI: 086cb6b4 EBP: f631bef4 ESP: c055bd68
> [  175.375186]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  175.375191] CR0: 8005003b CR2: f67c1c44 CR3: 36368000 CR4: 000006c0
> [  175.375197] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  175.375202] DR6: ffff4ff0 DR7: 00000400
> [  175.375206]  [<c020d6f3>] copy_to_user+0x43/0x60
> [  175.375214]  [<c028df28>] drm_getunique+0x38/0x50
> [  175.375224]  [<c028d329>] drm_ioctl+0x1b9/0x2f0
> [  175.375231]  [<c0188a07>] vfs_ioctl+0x67/0x70
> [  175.375239]  [<c0188a6c>] do_vfs_ioctl+0x5c/0x270
> [  175.375246]  [<c0188cbe>] sys_ioctl+0x3e/0x60
> [  175.375253]  [<c010336d>] sysenter_do_call+0x12/0x35
> [  175.375261]  [<ffffffff>] 0xffffffff

The hexdump decodes to:

vegardno@thuin ~ $ ./a.out 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
pci:0000:00:02.0<0><167>l<8><8><0><0><0><0><167>l<8><14><0><0><0>

...so drm_getunique() is trying to copy some uninitialized data to
userspace. The ECX register contains the number of words that are
left to copy -- so there are 5 * 4 = 20 bytes left. The offset of the
first uninitialized byte (counting from the start of the string) is
also 20 (i.e. 0xf65d2294&((1 << 5)-1) == 20). So somebody tried to
copy 40 bytes when the string was only 19 long.

In drm_set_busid() we have this code:

        dev->unique_len = 40;
        dev->unique = drm_alloc(dev->unique_len + 1, DRM_MEM_DRIVER);
	...
        len = snprintf(dev->unique, dev->unique_len, "pci:%04x:%02x:%02x.%d",

...so it seems that dev->unique is never updated to reflect the
actual length of the string. The remaining bytes (20 in this case)
are random uninitialized bytes that are copied into userspace.

This patch fixes the problem by setting dev->unique_len after the
snprintf().

Completely untested.

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Vegard Nossum <vegardno@thuin.ifi.uio.no>
---
 drivers/gpu/drm/drm_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 16829fb..480225b 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -144,6 +144,7 @@ static int drm_set_busid(struct drm_device * dev)
 
 	if (len > dev->unique_len)
 		DRM_ERROR("Unique buffer overflowed\n");
+	dev->unique_len = len + 1;
 
 	dev->devname =
 	    drm_alloc(strlen(dev->driver->pci_driver.name) + dev->unique_len +
-- 
1.5.6.4

