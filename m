Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbYBGAXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbYBGAXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbYBFX71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:46458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbYBFX7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:23 -0500
Date: Wed, 6 Feb 2008 15:53:58 -0800
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
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>, maximilian attems <max@stro.at>
Subject: [patch 56/73] VM/Security: add security hook to do_brk
	(CVE-2007-6434)
Message-ID: <20080206235358.GE13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vm-security-add-security-hook-to-do_brk.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Eric Paris <eparis@redhat.com>

patch ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5 in mainline.

VM/Security: add security hook to do_brk

Given a specifically crafted binary do_brk() can be used to get low pages
available in userspace virtual memory and can thus be used to circumvent
the mmap_min_addr low memory protection.  Add security checks in do_brk().

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1938,6 +1938,10 @@ unsigned long do_brk(unsigned long addr,
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
+	error = security_file_mmap(0, 0, 0, 0, addr, 1);
+	if (error)
+		return error;
+
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = arch_mmap_check(addr, len, flags);

-- 
