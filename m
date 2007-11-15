Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXKOGNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXKOGNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXKOGKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36524 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbXKOGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:46 -0500
Date: Wed, 14 Nov 2007 22:09:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 08/13] splice: fix double kunmap() in vmsplice copy path
Message-ID: <20071115060942.GI7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="splice-fix-double-kunmap-in-vmsplice-copy-path.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

patch 6866bef40d06f7c2baac3a855b1917a8ca75456c in mainline.

The out label should not include the unmap, the only way to jump
there already has unmapped the source.

00002000
       f7c21a00 00000000 00000000 c0489036 00018e32 00000002 00000000
00001000
Call Trace:
 [<c0487dd9>] pipe_to_user+0xca/0xd3
 [<c0488233>] __splice_from_pipe+0x53/0x1bd
 [<c0454947>] ------------[ cut here ]------------
filemap_fault+0x221/0x380
 [<c0487d0f>] pipe_to_user+0x0/0xd3
 [<c0489036>] sys_vmsplice+0x3b7/0x422
 [<c045ec3f>] kernel BUG at mm/highmem.c:206!
handle_mm_fault+0x4d5/0x8eb
 [<c041ed5b>] kmap_atomic+0x1c/0x20
 [<c045d33d>] unmap_vmas+0x3d1/0x584
 [<c045f717>] free_pgtables+0x90/0xa0
 [<c041d84b>] pgd_dtor+0x0/0x1
 [<c044d665>] audit_syscall_exit+0x2aa/0x2c6
 [<c0407817>] do_syscall_trace+0x124/0x169
 [<c0404df2>] syscall_call+0x7/0xb
 =======================
Code: 2d 00 d0 5b 00 25 00 00 e0 ff 29 invalid opcode: 0000 [#1]
c2 89 d0 c1 e8 0c 8b 14 85 a0 6c 7c c0 4a 85 d2 89 14 85 a0 6c 7c c0 74 07
31 c9 4a 75 15 eb 04 <0f> 0b eb fe 31 c9 81 3d 78 38 6d c0 78 38 6d c0 0f
95 c1 b0 01
EIP: [<c045bbc3>] kunmap_high+0x51/0x8e SS:ESP 0068:f5960df0
SMP
Modules linked in: netconsole autofs4 hidp nfs lockd nfs_acl rfcomm l2cap
bluetooth sunrpc ipv6 ib_iser rdma_cm ib_cm iw_cmib_sa ib_mad ib_core
ib_addr iscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_multipath
dm_mod video output sbs batteryac parport_pc lp parport sg i2c_piix4
i2c_core floppy cfi_probe gen_probe scb2_flash mtd chipreg tg3 e1000 button
ide_cd serio_raw cdrom aic7xxx scsi_transport_spi sd_mod scsi_mod ext3 jbd
ehci_hcd ohci_hcd uhci_hcd
CPU:    3
EIP:    0060:[<c045bbc3>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23 #1)
EIP is at kunmap_high+0x51/0x8e

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1390,10 +1390,10 @@ static int pipe_to_user(struct pipe_inod
 	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
 		ret = -EFAULT;
 
+	buf->ops->unmap(pipe, buf, src);
 out:
 	if (ret > 0)
 		sd->u.userptr += ret;
-	buf->ops->unmap(pipe, buf, src);
 	return ret;
 }
 

-- 
