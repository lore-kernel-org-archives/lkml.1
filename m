Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbXEQCGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbXEQCGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbXEQCGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:06:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754789AbXEQCGX (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:06:23 -0400
Date: Thu, 17 May 2007 12:06:00 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com
Subject: Re: 2.6.22-rc1-mm1
Message-ID: <20070517020600.GS85884050@sgi.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516094133.bec04e65.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:41:33AM -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 18:24:44 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > Andrew Morton napisał(a):
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> > > 
> > 
> > Almost every time when I try to run this script I hit a bug. I'm wondering why...
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/test_mount_fs.sh
> > 
> > [ 6666.713016] kernel BUG at /home/devel/linux-mm/include/linux/mm.h:288!
> 
> static inline int put_page_testzero(struct page *page)
> {
> 	VM_BUG_ON(atomic_read(&page->_count) == 0);
> 	return atomic_dec_and_test(&page->_count);
> }

I haven't seen that one. I expect that it will be the noaddr buffer allocation
changes that have triggered this...

> > [ 6666.719690] invalid opcode: 0000 [#1]
> > [ 6666.723397] PREEMPT SMP
> > [ 6666.725999] Modules linked in: xfs loop pktgen ipt_MASQUERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd soundcore intel_agp agpgart snd_page_alloc i2c_i801 ide_cd cdrom rtc unix
> > [ 6666.776026] CPU:    0
> > [ 6666.776027] EIP:    0060:[<c01693ec>]    Not tainted VLI
> > [ 6666.776028] EFLAGS: 00010202   (2.6.22-rc1-mm1 #3)
> > [ 6666.788519] EIP is at put_page+0x44/0xee
> > [ 6666.792491] eax: 00000001   ebx: c549f728   ecx: c04b27e0   edx: 00000001
> > [ 6666.799345] esi: 00000000   edi: 00000080   ebp: d067e9e0   esp: d067e9c8
> > [ 6666.806208] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > [ 6666.812104] Process mount (pid: 9419, ti=d067e000 task=d00a4070 task.ti=d067e000)
> > [ 6666.819486] Stack: d8980180 00000080 d067e9f0 d8980180 00000000 00000080 d067e9f0 fdc8eda3
> > [ 6666.828103]        fffffffc d8980180 d067ea20 fdc8f7ff fdc9b425 fdc96e5c 00080000 00000000
> > [ 6666.836635]        c549dfd0 00000200 ffffffff cd44b8e0 00002160 cd44b8e0 d067ea30 fdc78937
> > [ 6666.845253] Call Trace:
> > [ 6666.847939]  [<fdc8eda3>] xfs_buf_free+0x41/0x61 [xfs]
> > [ 6666.853247]  [<fdc8f7ff>] xfs_buf_get_noaddr+0x10c/0x118 [xfs]
> > [ 6666.859231]  [<fdc78937>] xlog_get_bp+0x65/0x69 [xfs]

Yeah - that trace implies a memory allocation failure when allocating
log buffer pages and the cleanup looks like it does a double free
of the pages that got allocated. Patch attached below that should fix
this problem.

> > [ 6667.271984] XFS: Filesystem loop1 has duplicate UUID - can't mount
> >
> > ...
> >
> > [ 6670.074487] XFS: Filesystem loop1 has duplicate UUID - can't mount
> > [ 6670.240395] XFS: Filesystem loop1 has duplicate UUID - can't mount
> > [ 6670.350305] XFS: Filesystem loop1 has duplicate UUID - can't mount
> > [ 6670.458773] XFS: Filesystem loop1 has duplicate UUID - can't mount

I assume that the thread doing the mount got killed by the BUG and so the
normal error handling path on log mount failure was not executed and hence the
uuid for the filesystem never got removed from the table used to detect
multiple mounts of the same filesystem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_buf.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-05-11 16:03:26.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-05-17 11:53:40.293585132 +1000
@@ -323,9 +323,16 @@ xfs_buf_free(
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			if (bp->b_flags & _XBF_PAGE_CACHE)
+			/* handle noaddr allocation failure case */
+			if (!page)
+				break;
+
+			if (bp->b_flags & _XBF_PAGE_CACHE) {
 				ASSERT(!PagePrivate(page));
-			page_cache_release(page);
+				page_cache_release(page);
+			} else {
+				__free_page(page);
+			}
 		}
 		_xfs_buf_free_pages(bp);
 	}
@@ -766,6 +773,8 @@ xfs_buf_get_noaddr(
 		goto fail;
 	_xfs_buf_initialize(bp, target, 0, len, 0);
 
+	bp->b_flags |= _XBF_PAGES;
+
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
 		goto fail_free_buf;
@@ -773,15 +782,14 @@ xfs_buf_get_noaddr(
 	for (i = 0; i < page_count; i++) {
 		bp->b_pages[i] = alloc_page(GFP_KERNEL);
 		if (!bp->b_pages[i])
-			goto fail_free_mem;
+			goto fail_free_buf;
 	}
-	bp->b_flags |= _XBF_PAGES;
 
 	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
 	if (unlikely(error)) {
 		printk(KERN_WARNING "%s: failed to map pages\n",
 				__FUNCTION__);
-		goto fail_free_mem;
+		goto fail_free_buf;
 	}
 
 	xfs_buf_unlock(bp);
@@ -789,9 +797,6 @@ xfs_buf_get_noaddr(
 	XB_TRACE(bp, "no_daddr", len);
 	return bp;
 
- fail_free_mem:
-	while (--i >= 0)
-		__free_page(bp->b_pages[i]);
  fail_free_buf:
 	xfs_buf_free(bp);
  fail:
