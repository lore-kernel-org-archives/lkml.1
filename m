Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZH0SWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZH0SWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZH0SWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:22:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:14815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZH0SWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:22:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,287,1249282800"; 
   d="scan'208";a="545354049"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Amerigo Wang'" <amwang@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Neil Horman'" <nhorman@redhat.com>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'kamezawa.hiroyu@jp.fujitsu.com'" <kamezawa.hiroyu@jp.fujitsu.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Michael Ellerman'" <michael@ellerman.id.au>,
       "'M. Mohan Kumar'" <mohan@in.ibm.com>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'bernhard.walle@gmx.de'" <bernhard.walle@gmx.de>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Anton Vorontsov'" <avorontsov@ru.mvista.com>
Date: Thu, 27 Aug 2009 11:22:21 -0700
Subject: RE: [Patch 6/8] powerpc: implement crashkernel=auto
Thread-Topic: [Patch 6/8] powerpc: implement crashkernel=auto
Thread-Index: AcomxNp0T6IBrtDlSNKirmeeQDLgoAAfkamQ
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B949E7CB@orsmsx505.amr.corp.intel.com>
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
 <20090827031909.4534.24859.sendpatchset@localhost.localdomain>
In-Reply-To: <20090827031909.4534.24859.sendpatchset@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>--- linux-2.6.orig/arch/powerpc/include/asm/kexec.h
>+++ linux-2.6/arch/powerpc/include/asm/kexec.h
>@@ -39,6 +39,45 @@ typedef void (*crash_shutdown_t)(void);
>
> #ifdef CONFIG_KEXEC
>
>+#ifdef CONFIG_KEXEC_AUTO_RESERVE
>+
>+#ifndef KEXEC_AUTO_THRESHOLD
>+#define KEXEC_AUTO_THRESHOLD (1ULL<<31) /* 2G */
>+#endif
>+
>+#ifndef arch_default_crash_base
>+static inline
>+unsigned long long arch_default_crash_base(void)
>+{
>+	return KDUMP_KERNELBASE;
>+}
You don't want inline here either.

>+#define arch_default_crash_base arch_default_crash_base
>+#endif
>+
>+#ifndef arch_default_crash_size
>+static inline
>+unsigned long long arch_default_crash_size(unsigned long long total_size)
>+{

Ditto.

>+	if (total_size < KEXEC_AUTO_THRESHOLD)
>+		return 0;
>+	if (total_size < (1ULL<<32))
>+		return 1ULL<<27;
>+	else {
>+#ifdef CONFIG_64BIT
>+		if (total_size > (1ULL<<37)) /* 128G */
>+			return 1ULL<<32; /* 4G */
>+		return 1ULL<<ilog2(roundup(total_size/32, 1ULL<<21));
>+#else
>+		return 1ULL<<28;
>+#endif
>+	}
>+}
>+#define arch_default_crash_size arch_default_crash_size
>+#endif
>+
>+#endif
>+#include <asm-generic/kexec.h>
>+
> /*
>  * This function is responsible for capturing register states if coming
>  * via panic or invoking dump using sysrq-trigger.
