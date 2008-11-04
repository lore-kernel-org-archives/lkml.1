Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYKDXkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYKDXkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYKDXiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:47274 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbYKDXiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:03 -0500
Date: Tue, 4 Nov 2008 15:31:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Ravikiran Thirumalai <kiran@scalex86.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 09/57] x86: fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081104233115.GJ659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-dev-mem-mmap-breakage-when-pat-is-disabled.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ravikiran G Thirumalai <kiran@scalex86.org>

commit 9e41bff2708e420e61e6b89a54c15232857069b1 upstream

Impact: allow /dev/mem mmaps on non-PAT CPUs/platforms

Fix mmap to /dev/mem when CONFIG_X86_PAT is off and CONFIG_STRICT_DEVMEM is
off

mmap to /dev/mem on kernel memory has been failing since the
introduction of PAT (CONFIG_STRICT_DEVMEM=n case).   Seems like
the check to avoid cache aliasing with PAT is kicking in even
when PAT is disabled. The bug seems to have crept in 2.6.26.

This patch makes sure that the mmap to regular
kernel memory succeeds if CONFIG_STRICT_DEVMEM=n and
PAT is disabled, and the checks to avoid cache aliasing
still happens if PAT is enabled.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Tested-by: Tim Sirianni <tim@scalemp.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pat.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -403,12 +403,16 @@ static inline int range_is_allowed(unsig
 	return 1;
 }
 #else
+/* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
 	u64 to = from + size;
 	u64 cursor = from;
 
+	if (!pat_enabled)
+		return 1;
+
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
 			printk(KERN_INFO

-- 
