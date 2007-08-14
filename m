Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXHNHuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXHNHuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXHNHqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55406 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXHNHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:18 -0400
Date: Tue, 14 Aug 2007 00:29:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 07/12] powerpc: Fix size check for hugetlbfs
Message-ID: <20070814072918.GG15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-size-check-for-hugetlbfs.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

My "slices" address space management code that was added in 2.6.22
implementation of get_unmapped_area() doesn't properly check that the
size is a multiple of the requested page size. This allows userland to
create VMAs that aren't a multiple of the huge page size with hugetlbfs
(since hugetlbfs entirely relies on get_unmapped_area() to do that
checking) which leads to a kernel BUG() when such areas are torn down.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/slice.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -405,6 +405,8 @@ unsigned long slice_get_unmapped_area(un
 
 	if (len > mm->task_size)
 		return -ENOMEM;
+	if (len & ((1ul << pshift) - 1))
+		return -EINVAL;
 	if (fixed && (addr & ((1ul << pshift) - 1)))
 		return -EINVAL;
 	if (fixed && addr > (mm->task_size - len))

-- 
