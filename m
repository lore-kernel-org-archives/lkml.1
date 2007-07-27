Return-Path: <linux-kernel-owner+w=401wt.eu-S1764742AbXG0MjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764742AbXG0MjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbXG0MjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:39:10 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59573 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXG0MjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:39:08 -0400
Date: Fri, 27 Jul 2007 05:36:57 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org, oprofile-list@lists.sourceforge.net,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: [PATCH] make Oprofile call shutdown() only once per session
Message-ID: <20070727123657.GB9828@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Oprofile: call model->shutdown() only once to avoid calling release_ev*() multiple times
    
    signed-off-by: Stephane Eranian <eranian@hpl.hp.com>

diff --git a/arch/i386/oprofile/nmi_int.c b/arch/i386/oprofile/nmi_int.c
index 11b7a51..2d0eeac 100644
--- a/arch/i386/oprofile/nmi_int.c
+++ b/arch/i386/oprofile/nmi_int.c
@@ -269,7 +269,6 @@ static void nmi_cpu_shutdown(void * dummy)
 	apic_write(APIC_LVTPC, saved_lvtpc[cpu]);
 	apic_write(APIC_LVTERR, v);
 	nmi_restore_registers(msrs);
-	model->shutdown(msrs);
 }
 
  
@@ -278,6 +277,7 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	model->shutdown(cpu_msrs);
 	free_msrs();
 }
 
