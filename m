Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXIEPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXIEPNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXIEPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:13:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbXIEPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:13:24 -0400
Date: Wed, 5 Sep 2007 08:12:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1
Message-Id: <20070905081207.1d8a0e05.akpm@linux-foundation.org>
In-Reply-To: <26495.1189003060@turing-police.cc.vt.edu>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<26495.1189003060@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 05 Sep 2007 10:37:40 -0400 Valdis.Kletnieks@vt.edu wrote:
> On Fri, 31 Aug 2007 21:58:22 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> 
> (Warning - if discussion of binary modules bothers you, hit delete now..)

It's legitimate.  That change was supposed to be a no-op.

Thanks for reporting.

> Dell Latitude D840, x86_64 kernel
> 
> memory-controller-memory-accounting-v7.patch causes the NVidia graphics driver
> to go into a soft-lockup:

(is it not a bit weird from a namin POV that we have
mem_container_charge(page, mm) and mem_container_uncharge_page(page)?)


> BUG: soft lockup - CPU#0 stuck for 11s! [X:2733]
> CPU 0:
> Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack nfnetlink ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables vmnet(P)(U) vmmon(U) sha256 aes fan container bay acpi_cpufreq nvram arc4 ecb pcmcia iwl3945 firmware_class yenta_socket nvidia(P)(U) mac80211 iTCO_wdt rsrc_nonstatic iTCO_vendor_support ohci1394 watchdog_core ieee1394 watchdog_dev pcmcia_core cfg80211 video thermal output button battery processor ac intel_agp rtc

Seems to me that there's a missing pte_unmap_lock() in insert_page().

Also, a hunk in do_anonymous_page() is indented one tabstop too far, which
makes me suspect that patch(1) might have put it in the wrong place. 
Balbir, can you please check that?

diff -puN mm/memory.c~memory-controller-memory-accounting-v7-fix mm/memory.c
--- a/mm/memory.c~memory-controller-memory-accounting-v7-fix
+++ a/mm/memory.c
@@ -1135,7 +1135,7 @@ static int insert_page(struct mm_struct 
 {
 	int retval;
 	pte_t *pte;
-	spinlock_t *ptl;  
+	spinlock_t *ptl;
 
 	retval = mem_container_charge(page, mm);
 	if (retval)
@@ -1160,6 +1160,7 @@ static int insert_page(struct mm_struct 
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
 	retval = 0;
+	pte_unmap_unlock(pte, ptl);
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
@@ -2184,8 +2185,8 @@ static int do_anonymous_page(struct mm_s
 	if (!page)
 		goto oom;
 
-		if (mem_container_charge(page, mm))
-			goto oom_free_page;
+	if (mem_container_charge(page, mm))
+		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_

