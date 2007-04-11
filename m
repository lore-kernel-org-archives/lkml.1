Return-Path: <linux-kernel-owner+w=401wt.eu-S1161375AbXDKW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375AbXDKW5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161384AbXDKW4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:56:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55868 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161375AbXDKWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:53 -0400
Date: Wed, 11 Apr 2007 15:53:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       nickpiggin@yahoo.com.au, bapper@mvista.com, bapper@piratehaven.org,
       dhowells@redhat.com, hugh@veritas.com
Subject: [patch 30/31] fix page leak during core dump
Message-ID: <20070411225304.GE24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-page-leak-during-core-dump.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian Pomerantz <bapper@piratehaven.org>

When the dump cannot occur most likely because of a full file system and
the page to be written is the zero page, the call to page_cache_release()
is missed.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_elf.c       |    5 ++++-
 fs/binfmt_elf_fdpic.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, str
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(addr)) {
-					DUMP_SEEK(PAGE_SIZE);
+					if (!dump_seek(file, PAGE_SIZE)) {
+						page_cache_release(page);
+						goto end_coredump;
+					}
 				} else {
 					void *kaddr;
 					flush_cache_page(vma, addr,
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1473,8 +1473,8 @@ static int elf_fdpic_dump_segments(struc
 				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else if (page == ZERO_PAGE(addr)) {
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 				page_cache_release(page);
+				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else {
 				void *kaddr;

-- 
