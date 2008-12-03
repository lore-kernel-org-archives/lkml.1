Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYLCUMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYLCUMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYLCTye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:34 -0500
Received: from kroah.org ([198.145.64.141]:60296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753722AbYLCTya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:30 -0500
Date: Wed, 3 Dec 2008 11:52:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Jeremy Kerr <jk@ozlabs.org>
Subject: [patch 057/104] powerpc/spufs: Fix spinning in spufs_ps_fault on
	signal
Message-ID: <20081203195250.GF8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-spufs-fix-spinning-in-spufs_ps_fault-on-signal.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Kerr <jk@ozlabs.org>

commit 606572634c3faa5b32a8fc430266e6e9d78d2179 upstream.

Currently, we can end up in an infinite loop if we get a signal
while the kernel has faulted in spufs_ps_fault. Eg:

 alarm(1);

 write(fd, some_spu_psmap_register_address, 4);

- the write's copy_from_user will fault on the ps mapping, and
signal_pending will be non-zero. Because returning from the fault
handler will never clear TIF_SIGPENDING, so we'll just keep faulting,
resulting in an unkillable process using 100% of CPU.

This change returns VM_FAULT_SIGBUS if there's a fatal signal pending,
letting us escape the loop.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/cell/spufs/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -390,6 +390,9 @@ static int spufs_ps_fault(struct vm_area
 	if (offset >= ps_size)
 		return VM_FAULT_SIGBUS;
 
+	if (fatal_signal_pending(current))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Because we release the mmap_sem, the context may be destroyed while
 	 * we're in spu_wait. Grab an extra reference so it isn't destroyed

