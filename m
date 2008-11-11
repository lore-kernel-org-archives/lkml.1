Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYKKWQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYKKWQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYKKWQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:16:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:3269 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYKKWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:16:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=JMOysr/MrxULE/9hVVX/CxztdSKEf5h1x1wqjjuJnHNqD1Y7A/64CH+iyCT1NghVsj
         hjxFsWN6VzyDBdhS9Nvj2M5zZHsP98ZMdhCQ2mbZwL4W163fdqvL4Un7ygQEXh/w5tjR
         aVcsGvG6fTOb1jBHlF756lMz4L3o3BmaQPNP4=
Date: Tue, 11 Nov 2008 23:17:25 +0100
To: Dave Airlie <airlied@redhat.com>, Greg KH <greg@kroah.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] drm: fix leak of uninitialized data to userspace #2
Message-ID: <20081111221725.GA4131@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First patch had an additional problem in case snprintf() wanted to
write a string longer than the buffer and returned a large value.
Most likely this would never ever hit, but we can handle it by only
setting the actual length when we _didn't_ try to overflow the
buffer.

Secondly, the snprintf() won't ever write more than the given
number of bytes given, so allocating + 1 bytes isn't ever going to
do anything useful.

Thirdly, we also need to check whether snprintf() returned
>= unique_len. The buffer was also too small if snprintf() returns
== unique_len. snprintf() will always ensure that the result is
properly null-terminated, except in the case where the buffer is
NULL or the buffer size is zero (can never happen here).

It is also a bit suspicious that this function's return value is
never checked, and that we don't free the first allocation if the
second one fails. But maybe it's ok, didn't really check.

I encourage careful review of this patch, as my first attempt was
invalid without me noticing or anybody else saying a thing (or was
that why it was never pushed to mainline?) :-(

(And the original code was obviously in error to begin with.)


Vegard

PS: Feel free to move any/all of this text into commit message if
patch is deemed worthy of inclusion. I just wanted to make the new
info stand out.


>From f1035aa2e85a3908b311beea44c1c32f1135cfd1 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 11 Nov 2008 22:38:06 +0100
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

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Vegard Nossum <vegardno@thuin.ifi.uio.no>
---
 drivers/gpu/drm/drm_ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 16829fb..7212c38 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -133,7 +133,7 @@ static int drm_set_busid(struct drm_device * dev)
 		return 0;
 
 	dev->unique_len = 40;
-	dev->unique = drm_alloc(dev->unique_len + 1, DRM_MEM_DRIVER);
+	dev->unique = drm_alloc(dev->unique_len, DRM_MEM_DRIVER);
 	if (dev->unique == NULL)
 		return -ENOMEM;
 
@@ -142,8 +142,10 @@ static int drm_set_busid(struct drm_device * dev)
 		       PCI_SLOT(dev->pdev->devfn),
 		       PCI_FUNC(dev->pdev->devfn));
 
-	if (len > dev->unique_len)
+	if (len >= dev->unique_len)
 		DRM_ERROR("Unique buffer overflowed\n");
+	else
+		dev->unique_len = len;
 
 	dev->devname =
 	    drm_alloc(strlen(dev->driver->pci_driver.name) + dev->unique_len +
-- 
1.5.6.5

