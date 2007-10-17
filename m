Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXJQJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXJQJex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXJQJep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:34:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59020 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbXJQJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:34:44 -0400
Date: Wed, 17 Oct 2007 18:36:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-mm1
Message-Id: <20071017183626.70bdd13e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 11:10:23 +0200 (CEST)
Jiri Kosina <jikos@jikos.cz> wrote:
> Hi,
> 
> hm, I guess this is probably due to pie-randomization patch, right? (could 
> you please try reverting it, to see whether things get back to normal).
> 
> Oh well, this causes more trouble that I have ever imagined ... I will 
> look into it, thanks a lot for the report. Andrew, please drop this one 
> again, I will fix it up.
> 
Maybe this can be fix.

Thanks,
-Kame

==
ia32 on x86_64 seems to be handled as it is.

 arch/x86_64/mm/mmap.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: devel-2.6.23-mm1/arch/x86_64/mm/mmap.c
===================================================================
--- devel-2.6.23-mm1.orig/arch/x86_64/mm/mmap.c
+++ devel-2.6.23-mm1/arch/x86_64/mm/mmap.c
@@ -54,13 +54,17 @@ static inline unsigned long mmap_base(vo
 	return TASK_SIZE - (gap & PAGE_MASK);
 }
 
-static inline int mmap_is_legacy(void)
+static inline int mmap_is_32(void)
 {
 #ifdef CONFIG_IA32_EMULATION
 	if (test_thread_flag(TIF_IA32))
 		return 1;
 #endif
+	return 0;
+}
 
+static inline int mmap_is_legacy(void)
+{
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
@@ -89,7 +93,12 @@ void arch_pick_mmap_layout(struct mm_str
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
-	if (mmap_is_legacy()) {
+	if (mmap_is_32()) {
+#ifdef CONFIG_IA32_EMULATION
+		/* ia32_pick_mmap_layout has its own. */
+		return ia32_pick_mmap_layout(mm);
+#endif
+	} else if(mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 		mm->unmap_area = arch_unmap_area;

