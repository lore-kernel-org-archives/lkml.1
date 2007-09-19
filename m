Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXISLcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXISLcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbXISLcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:32:46 -0400
Received: from tech.netart.pl ([85.128.128.114]:33966 "EHLO tech.serwery.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbXISLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:32:45 -0400
X-Greylist: delayed 2328 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 07:32:44 EDT
Date: Wed, 19 Sep 2007 12:53:53 +0200
From: NetArt - Grzegorz Nosek <grzegorz.nosek@netart.pl>
To: linux-kernel@vger.kernel.org
Subject: NFS + coredump OOPS
Message-ID: <20070919105353.GA7392@tech.serwery.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

[please keep CC'd]

This oops report comes from 2.6.18.5, so it may have been fixed in a
newer release, but I'm reporting nevertheless. OTOH, the (possibly)
relevant code looks unchanged.

The background is _probably_ attempting a core dump of a process,
whose backing binary file is accessible via NFS.

My understanding of the issue follows.

After creating a list of pages to read, __do_page_cache_readahead calls
(indirectly) mapping->a_ops->readpages, which must empty the list of
pages passed to it (as asserted by the BUG_ON). However, nfs_readpages
may return early in a few cases:

	if (NFS_STALE(inode))
		goto out;

	if (filp == NULL) {
		desc.ctx = nfs_find_open_context(inode, NULL, FMODE_READ);
		if (desc.ctx == NULL)
			return -EBADF;
	} else
		desc.ctx = get_nfs_open_context((struct nfs_open_context *)
				filp->private_data);

I'd guess that the inode had gone stale (the process ran for quite
some time), so nfs_readpages returned without even touching the list.
Boom.

Taking a SWAG, I'd guess a missing
file->f_dentry->d_op->d_revalidate() in
fs/exec.c::do_core_dump(), but d_revalidate needs a nameidata
structure, which do_core_dump() doesn't seem to have at hand.

Best regards,
 Grzegorz Nosek

[16249868.626066] ------------[ cut here ]------------
[16249868.684345] kernel BUG at mm/readahead.c:314!
[16249868.739565] invalid opcode: 0000 [#1]
[16249868.786480] SMP
[16249868.811703] Modules linked in: xt_tcpudp iptable_nat ip_nat smbfs cls_u32 sch_sfq sch_htb xt_mark ipt_account xt_helper iptable_mangle xt_MARK xt_multiport ipt_LOG xt_limit iptable_filter ip_conntrack_ftp ip_conntrack xfs dm_mod ipmi_devintf ipmi_si ipmi_watchdog ipmi_msghandler softdog ip_tables x_tables nfsd exportfs tg3
[16249869.159639] CPU:    0
[16249869.159640] EIP:    0060:[<c0143546>]    Not tainted VLI
[16249869.159641] EFLAGS: 00010212   (2.6.18.5-na1.4 #1)
[16249869.318036] EIP is at __do_page_cache_readahead+0xb4/0x212
[16249869.386750] eax: ffffff8c   ebx: c01c5399   ecx: 00000000   edx: d2ac3c20
[16249869.471039] esi: 00000003   edi: 00000002   ebp: d2ac3c34   esp: d2ac3bc0
[16249869.555330] ds: 007b   es: 007b   ss: 0068
[16249869.607439] Process clamscan (pid: 13406, ti=d2ac2000 task=e8ebf190 task.ti=d2ac2000)
[16249869.702108] Stack: 00000002 c9c33c60 c9c33c54 00000126 f28e8900 c9c33c50 c3792904 000002db
[16249869.805908]        00001000 00000000 d2ac3c68 c013f85b 00002000 00000000 d2ac3d1c 00000000
[16249869.909706]        00001000 d0a67000 00000200 00000001 d2ac3c90 d2ac3c88 d2ac3cd4 d2ac2000
[16249870.013503] Call Trace:
[16249870.047964]  [<c0103c23>] show_stack_log_lvl+0xa8/0xe5
[16249870.112527]  [<c0103dff>] show_registers+0x19f/0x22f
[16249870.175014]  [<c0104308>] die+0x132/0x2de
[16249870.226081]  [<c034c8c1>] do_trap+0x76/0xa1
[16249870.279225]  [<c01049b7>] do_invalid_op+0x97/0xa1
[16249870.338596]  [<c0103641>] error_code+0x39/0x40
[16249870.394854]  [<c014375e>] do_page_cache_readahead+0x3d/0x51
[16249870.464711]  [<c013ed2f>] filemap_nopage+0x15e/0x3a4
[16249870.527197]  [<c014a8f5>] __handle_mm_fault+0x198/0xb69
[16249870.592799]  [<c014b385>] get_user_pages+0xbf/0x31c
[16249870.654248]  [<c0185a3a>] elf_core_dump+0x9aa/0xcf0
[16249870.715695]  [<c01647e5>] do_coredump+0x5c2/0x5f5
[16249870.775070]  [<c0126832>] get_signal_to_deliver+0x340/0x403
[16249870.844925]  [<c010255e>] do_notify_resume+0x19f/0x6c5
[16249870.909489]  [<c0102c2a>] work_notifysig+0x13/0x19
[16249870.969897] Code: 4d a0 f0 ff 41 10 fb 85 ff 74 18 8b 41 38 8b 58 14 85 db 74 20 89 3c 24 8d 4d ec 8b 55 a0 8b 45 9c ff d3 8d 55 ec 3b 55 ec 74 9a <0f> 0b 3a 01 8b 95 37 c0 eb 90 c7 45 ac 00 00 00 00 c745 b0 00
[16249871.205111] EIP: [<c0143546>] __do_page_cache_readahead+0xb4/0x212 SS:ESP 0068:d2ac3bc0

