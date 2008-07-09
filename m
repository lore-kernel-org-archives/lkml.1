Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYGILWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYGILWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYGILV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:21:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYGILV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:21:57 -0400
Date: Wed, 9 Jul 2008 13:21:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [patch] xen64: fix !HVC_XEN build dependency (was: Re: [PATCH 00
	of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709112133.GA4947@elte.hu>
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709111219.GA24874@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another small build problem that -tip testing exposed, with this config:

  http://redhat.com/~mingo/misc/config-Wed_Jul__9_13_02_55_CEST_2008.bad

find the fix below.

	Ingo

------------------->
commit 615ec52c1c85f7bbbcced89761fcd89b2115865d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 13:15:03 2008 +0200

    xen64: fix !HVC_XEN build dependency
    
    fix:
    
    arch/x86/xen/built-in.o: In function `set_page_prot':
    enlighten.c:(.text+0x111d): undefined reference to `xen_raw_printk'
    arch/x86/xen/built-in.o: In function `xen_start_kernel':
    : undefined reference to `xen_raw_console_write'
    arch/x86/xen/built-in.o: In function `xen_start_kernel':
    : undefined reference to `xen_raw_console_write'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/xen/hvc-console.h b/include/xen/hvc-console.h
index 98b79bc..c3adde3 100644
--- a/include/xen/hvc-console.h
+++ b/include/xen/hvc-console.h
@@ -5,11 +5,12 @@ extern struct console xenboot_console;
 
 #ifdef CONFIG_HVC_XEN
 void xen_console_resume(void);
+void xen_raw_console_write(const char *str);
+void xen_raw_printk(const char *fmt, ...);
 #else
 static inline void xen_console_resume(void) { }
+static inline void xen_raw_console_write(const char *str) { }
+static inline void xen_raw_printk(const char *fmt, ...) { }
 #endif
 
-void xen_raw_console_write(const char *str);
-void xen_raw_printk(const char *fmt, ...);
-
 #endif	/* XEN_HVC_CONSOLE_H */
