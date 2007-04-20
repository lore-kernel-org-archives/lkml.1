Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbXDTE2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbXDTE2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXDTE2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:28:47 -0400
Received: from mail.suse.de ([195.135.220.2]:45564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXDTE2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:28:46 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Date: Fri, 20 Apr 2007 14:28:19 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17960.16739.870487.497750@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: SLUB: kmem_cache_destroy doesn't - version 2.
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi again,
 I recently noticed that my slub-enabled kernel won't let me stop
and restart the NFS server.   It stops fine but on restart
it returns -ENOMEM.

It turns out that this is because kmem_cache_create is failing
because the name already exists in sysfs.

fs/nfsd/nfs4state creates 4 kmem_caches.
Two of them get shared:

  /sys/slab/nfsd4_files -> ../slab/eventpoll_pwq
  /sys/slab/nfsd4_stateids -> ../slab/kmalloc-128

When kmem_cache_destroy is called, the alias count is reduced
properly, but the alias symlink does not get removed.  So when we
try to create those caches again, it fails.

Not sure how best to fix this one.... kmem_cache_destroy currently
doesn't know which alias is being destroyed.

NeilBrown
