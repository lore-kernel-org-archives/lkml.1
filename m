Return-Path: <linux-kernel-owner+w=401wt.eu-S936380AbXFGBrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936380AbXFGBrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936216AbXFGBr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:47:27 -0400
Received: from ns.suse.de ([195.135.220.2]:52557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935991AbXFGBrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:47:25 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 7 Jun 2007 11:47:00 +1000
Message-Id: <1070607014700.27322@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 002 of 2] Make sure readv stops reading when it hits end-of-file.
References: <20070607114043.26967.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The do_loop_readv_writev implementation of readv breaks out of the
loop as soon as a single read request didn't fill it's buffer:
		if (nr != len)
			break;

The generic_file_aio_read version doesn't.  So if it hits EOF
before the end of the list of buffers, it will try again on the next
buffer.  If the file was extended in the mean time, this will
produce a bad result.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/mm/filemap.c ./mm/filemap.c
--- .prev/mm/filemap.c	2007-06-07 11:34:24.000000000 +1000
+++ ./mm/filemap.c	2007-06-07 11:39:35.000000000 +1000
@@ -1206,6 +1206,8 @@ generic_file_aio_read(struct kiocb *iocb
 				retval = retval ?: desc.error;
 				break;
 			}
+			if (desc.count > 0)
+				break;
 		}
 	}
 out:
