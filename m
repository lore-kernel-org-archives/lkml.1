Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYD2ReI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYD2ReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbYD2RWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:43735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065AbYD2RWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:20 -0400
Date: Tue, 29 Apr 2008 10:19:21 -0700
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
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [35/37] alpha: unbreak OSF/1 (a.out) binaries
Message-ID: <20080429171921.GJ14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alpha-unbreak-osf-1-binaries.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

commit 2444e56b0c08e6f3e3877583841a1213e3263d98 upstream


OSF/1 brk(2) was broken by following one-liner in sys_brk()
(commit 4cc6028d4040f95cdb590a87db478b42b8be0508):

-	if (brk < mm->end_code)
+	if (brk < mm->start_brk)
		goto out;

The problem is that osf_set_program_attributes()
does update mm->end_code, but not mm->start_brk,
which still contains inappropriate value left from
binary loader, so brk() always fails.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/osf_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -75,6 +75,7 @@ osf_set_program_attributes(unsigned long
 	lock_kernel();
 	mm = current->mm;
 	mm->end_code = bss_start + bss_len;
+	mm->start_brk = bss_start + bss_len;
 	mm->brk = bss_start + bss_len;
 #if 0
 	printk("set_program_attributes(%lx %lx %lx %lx)\n",

-- 
