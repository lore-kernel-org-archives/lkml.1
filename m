Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXDKMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXDKMuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXDKMuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:50:50 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:59669 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXDKMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:50:49 -0400
Date: Wed, 11 Apr 2007 14:26:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-Id: <20070411142643.bb80522a.dada1@cosmosbay.com>
In-Reply-To: <461CCD94.6010507@ru.mvista.com>
References: <461A4C1E.3070309@ru.mvista.com>
	<20070410102111.923b92a9.dada1@cosmosbay.com>
	<461CCD94.6010507@ru.mvista.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 15:59:16 +0400
Maxim Uvarov <muvarov@ru.mvista.com> wrote:

> Thanks Eric, I's really better. I have done changes. Do you have any 
> others objections now?
> All is in attached perf_stat.patch.

Hi Maxim

I know *nothing* about powerpc assembly, but I think there is a problem :

Index: linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/entry_64.S
+++ linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
@@ -115,6 +115,11 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISER
 	addi	r9,r1,STACK_FRAME_OVERHEAD
 #endif
 	clrrdi	r11,r1,THREAD_SHIFT
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	lwz r10,TI_SYSC_CNT(r11)
+	addi r10,r10,1
+	stw r10,TI_SYSC_CNT(r11)
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	ld	r10,TI_FLAGS(r11)
 	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace

sysc_cnt being an 'unsigned long', its a 64 bits long integer...
So you probably need ld/std instructions instead of lwz/stw

