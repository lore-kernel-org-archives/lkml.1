Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYCVF0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYCVF0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 01:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYCVF0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 01:26:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbYCVF0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 01:26:33 -0400
Date: Fri, 21 Mar 2008 22:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Message-Id: <20080321222606.16407d74.akpm@linux-foundation.org>
In-Reply-To: <200803220226.35552.rjw@sisk.pl>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de>
	<200803220226.35552.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 02:26:34 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, 21 of March 2008, Christian Kujau wrote:
> > Hi,
> 
> Hi,
> 
> > while attempting to test the patch which should fix the dm-crypt hang[0], 
> > I applied the diff to -rc6. After rebooting I increased disk i/o and 
> > shortly after the box rebooted - I noticed this earlier with -rc5 too, but 
> > had no debug messages at hand. Well, the box is running again and tar(1) 
> > is reading with 32MB/s for some time now - but is not rebooting, which is 
> > good :)
> > (I changed kernel.panic and kernel.panic_on_oops to zero).
> > However, it's printing stuff like this:
> 
> This looks worrisome (some experts added to the CC list).
> 
> > [ 2632.423419] ------------[ cut here ]------------
> > [ 2632.423762] kernel BUG at fs/sysfs/file.c:89!
> > [ 2632.424089] invalid opcode: 0000 [#1] 
> > [ 2632.424398] Modules linked in: sha256_generic act_police sch_ingress cls_u32 sch_sfq sch_cbq ipt_ULOG x_tables nfsd lockd nfs_acl auth_rpcgss exportfs tun sunrpc fuse twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid usb_storage zd1211rw firmware_class mac80211 i2c_nforce2 snd_intel8x0 snd_ac97_codec i2c_core cfg80211 ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc
> > [ 2632.426407] 
> > [ 2632.426651] Pid: 10297, comm: tar Not tainted (2.6.25-rc6 #3)
> > [ 2632.427019] EIP: 0060:[<c01a8add>] EFLAGS: 00010212 CPU: 0
> > [ 2632.427386] EIP is at sysfs_read_file+0xdd/0xf0
> > [ 2632.427717] EAX: 00000001 EBX: f5691f00 ECX: 00000003 EDX: f7ca1e70
> > [ 2632.428100] ESI: 00001000 EDI: f7ca1ed0 EBP: f5691f14 ESP: f6f3ff54
> > [ 2632.428482]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > [ 2632.428758] Process tar (pid: 10297, ti=f6f3f000 task=f6290d60 task.ti=f6f3f000)
> > [ 2632.428921] Stack: c0164ff7 f5ca6000 00001000 0866ce00 c0550d50 f7d8fab8 f776b180 0866ce00 
> > [ 2632.429174]        c01a8a00 00001000 c016868d f6f3ffa0 00000003 f776b180 fffffff7 0866ce00 
> > [ 2632.429430]        f6f3f000 c0168a91 f6f3ffa0 00000000 00000000 00000000 00000003 00001000 
> > [ 2632.429688] Call Trace:
> > [ 2632.429884]  [<c0164ff7>] kmem_cache_free+0xa7/0xf0
> > [ 2632.430023]  [<c01a8a00>] sysfs_read_file+0x0/0xf0
> > [ 2632.430159]  [<c016868d>] vfs_read+0x9d/0x140
> > [ 2632.430333]  [<c0168a91>] sys_read+0x41/0x70
> > [ 2632.430657]  [<c0102dee>] sysenter_past_esp+0x5f/0xa5
> > [ 2632.431006]  =======================
> > [ 2632.431308] Code: 18 89 f0 5b 5e 5f 5d c3 be ed ff ff ff eb e8 b8 d0 00 00 00 be f4 ff ff ff e8 e0 31 fa ff 85 c0 89 43 0c 0f 85 6d ff ff ff eb cc <0f> 0b 90 eb fd 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 83 ec 
> > [ 2632.432467] EIP: [<c01a8add>] sysfs_read_file+0xdd/0xf0 SS:ESP 0068:f6f3ff54
> > [ 2632.432630] ---[ end trace 9959fa4f11f46a8e ]---
> > 
> > Please see the full dmesg and .config: http://nerdbynature.de/bits/2.6.25-rc6/

Is MD (ie: raid) in use?

If so, the below (already merged) patch should fix this crash.

If this patch does not fix it then please apply this debug patch:

http://userweb.kernel.org/~akpm/mmotm/broken-out/gregkh-driver-driver-core-debug-for-bad-dev_attr_show-return-value.patch

then rerun the test.

Greg/Kay:

- why is this BUG_ON now triggering for people?

- we're killing people's machines.  Can we switch it to a
  WARN_ON()+fix-up-the-mess?


From: NeilBrown <neilb@suse.de>

Exposing the binary blob which is the md 'super-block' via sysfs
doesn't really fit with the sysfs model, and since commit

   8118a859dc7abd873193986c77a8d9bdb877adc8

it doesn't actually work at all (as the size of the blob is often one page).

(akpm: as in, fs/sysfs/file.c:fill_read_buffer() goes BUG)

So just remove it altogether.  It isn't really useful.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/md/md.c~md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array drivers/md/md.c
--- a/drivers/md/md.c~md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array
+++ a/drivers/md/md.c
@@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_stat
 __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
 
 static ssize_t
-super_show(mdk_rdev_t *rdev, char *page)
-{
-	if (rdev->sb_loaded && rdev->sb_size) {
-		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
-		return rdev->sb_size;
-	} else
-		return 0;
-}
-static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
-
-static ssize_t
 errors_show(mdk_rdev_t *rdev, char *page)
 {
 	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
@@ -2060,7 +2049,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
-	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
_

