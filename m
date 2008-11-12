Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYKLAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYKLAok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYKLA1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:12 -0500
Received: from kroah.org ([198.145.64.141]:42708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbYKLA1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:27:05 -0500
Date: Tue, 11 Nov 2008 16:24:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Sesterhenn <snakebyte@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 47/49] hfsplus: check read_mapping_page() return value
	(CVE-2008-4934)
Message-ID: <20081112002433.GV10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hfsplus-check-read_mapping_page-return-value.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sesterhenn <snakebyte@gmx.de>

commit 649f1ee6c705aab644035a7998d7b574193a598a upstream.

While testing more corrupted images with hfsplus, i came across
one which triggered the following bug:

[15840.675016] BUG: unable to handle kernel paging request at fffffffb
[15840.675016] IP: [<c0116a4f>] kmap+0x15/0x56
[15840.675016] *pde = 00008067 *pte = 00000000
[15840.675016] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[15840.675016] Modules linked in:
[15840.675016]
[15840.675016] Pid: 11575, comm: ln Not tainted (2.6.27-rc4-00123-gd3ee1b4-dirty #29)
[15840.675016] EIP: 0060:[<c0116a4f>] EFLAGS: 00010202 CPU: 0
[15840.675016] EIP is at kmap+0x15/0x56
[15840.675016] EAX: 00000246 EBX: fffffffb ECX: 00000000 EDX: cab919c0
[15840.675016] ESI: 000007dd EDI: cab0bcf4 EBP: cab0bc98 ESP: cab0bc94
[15840.675016]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[15840.675016] Process ln (pid: 11575, ti=cab0b000 task=cab919c0 task.ti=cab0b000)
[15840.675016] Stack: 00000000 cab0bcdc c0231cfb 00000000 cab0bce0 00000800 ca9290c0 fffffffb
[15840.675016]        cab145d0 cab919c0 cab15998 22222222 22222222 22222222 00000001 cab15960
[15840.675016]        000007dd cab0bcf4 cab0bd04 c022cb3a cab0bcf4 cab15a6c ca9290c0 00000000
[15840.675016] Call Trace:
[15840.675016]  [<c0231cfb>] ? hfsplus_block_allocate+0x6f/0x2d3
[15840.675016]  [<c022cb3a>] ? hfsplus_file_extend+0xc4/0x1db
[15840.675016]  [<c022ce41>] ? hfsplus_get_block+0x8c/0x19d
[15840.675016]  [<c06adde4>] ? sub_preempt_count+0x9d/0xab
[15840.675016]  [<c019ece6>] ? __block_prepare_write+0x147/0x311
[15840.675016]  [<c0161934>] ? __grab_cache_page+0x52/0x73
[15840.675016]  [<c019ef4f>] ? block_write_begin+0x79/0xd5
[15840.675016]  [<c022cdb5>] ? hfsplus_get_block+0x0/0x19d
[15840.675016]  [<c019f22a>] ? cont_write_begin+0x27f/0x2af
[15840.675016]  [<c022cdb5>] ? hfsplus_get_block+0x0/0x19d
[15840.675016]  [<c0139ebe>] ? tick_program_event+0x28/0x4c
[15840.675016]  [<c013bd35>] ? trace_hardirqs_off+0xb/0xd
[15840.675016]  [<c022b723>] ? hfsplus_write_begin+0x2d/0x32
[15840.675016]  [<c022cdb5>] ? hfsplus_get_block+0x0/0x19d
[15840.675016]  [<c0161988>] ? pagecache_write_begin+0x33/0x107
[15840.675016]  [<c01879e5>] ? __page_symlink+0x3c/0xae
[15840.675016]  [<c019ad34>] ? __mark_inode_dirty+0x12f/0x137
[15840.675016]  [<c0187a70>] ? page_symlink+0x19/0x1e
[15840.675016]  [<c022e6eb>] ? hfsplus_symlink+0x41/0xa6
[15840.675016]  [<c01886a9>] ? vfs_symlink+0x99/0x101
[15840.675016]  [<c018a2f6>] ? sys_symlinkat+0x6b/0xad
[15840.675016]  [<c018a348>] ? sys_symlink+0x10/0x12
[15840.675016]  [<c01038bd>] ? sysenter_do_call+0x12/0x31
[15840.675016]  =======================
[15840.675016] Code: 00 00 75 10 83 3d 88 2f ec c0 02 75 07 89 d0 e8 12 56 05 00 5d c3 55 ba 06 00 00 00 89 e5 53 89 c3 b8 3d eb 7e c0 e8 16 74 00 00 <8b> 03 c1 e8 1e 69 c0 d8 02 00 00 05 b8 69 8e c0 2b 80 c4 02 00
[15840.675016] EIP: [<c0116a4f>] kmap+0x15/0x56 SS:ESP 0068:cab0bc94
[15840.675016] ---[ end trace 4fea40dad6b70e5f ]---

This happens because the return value of read_mapping_page() is passed on
to kmap unchecked.  The bug is triggered after the first
read_mapping_page() in hfsplus_block_allocate(), this patch fixes all
three usages in this functions but leaves the ones further down in the
file unchanged.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfsplus/bitmap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/hfsplus/bitmap.c
+++ b/fs/hfsplus/bitmap.c
@@ -32,6 +32,10 @@ int hfsplus_block_allocate(struct super_
 	mutex_lock(&HFSPLUS_SB(sb).alloc_file->i_mutex);
 	mapping = HFSPLUS_SB(sb).alloc_file->i_mapping;
 	page = read_mapping_page(mapping, offset / PAGE_CACHE_BITS, NULL);
+	if (IS_ERR(page)) {
+		start = size;
+		goto out;
+	}
 	pptr = kmap(page);
 	curr = pptr + (offset & (PAGE_CACHE_BITS - 1)) / 32;
 	i = offset % 32;
@@ -73,6 +77,10 @@ int hfsplus_block_allocate(struct super_
 			break;
 		page = read_mapping_page(mapping, offset / PAGE_CACHE_BITS,
 					 NULL);
+		if (IS_ERR(page)) {
+			start = size;
+			goto out;
+		}
 		curr = pptr = kmap(page);
 		if ((size ^ offset) / PAGE_CACHE_BITS)
 			end = pptr + PAGE_CACHE_BITS / 32;
@@ -120,6 +128,10 @@ found:
 		offset += PAGE_CACHE_BITS;
 		page = read_mapping_page(mapping, offset / PAGE_CACHE_BITS,
 					 NULL);
+		if (IS_ERR(page)) {
+			start = size;
+			goto out;
+		}
 		pptr = kmap(page);
 		curr = pptr;
 		end = pptr + PAGE_CACHE_BITS / 32;

-- 
