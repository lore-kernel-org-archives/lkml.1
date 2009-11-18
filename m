Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZKRS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZKRS4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbZKRS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:56:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:42582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268AbZKRS4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:56:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,766,1249282800"; 
   d="scan'208";a="213047684"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiri Slaby <jslaby@novell.com>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "marcin.slusarz@gmail.com" <marcin.slusarz@gmail.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Wed, 18 Nov 2009 10:56:19 -0800
Subject: RE: [PATCH 03/16] IA64: use ACCESS_ONCE for rlimits
Thread-Topic: [PATCH 03/16] IA64: use ACCESS_ONCE for rlimits
Thread-Index: AcpoX748BhaLfwa1R2m2jZryl28ORQAIDTug
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E38E71DD@orsmsx505.amr.corp.intel.com>
References: <4B040A03.2020508@gmail.com>
 <1258555922-2064-3-git-send-email-jslaby@novell.com>
In-Reply-To: <1258555922-2064-3-git-send-email-jslaby@novell.com>
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

> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.

-	if (size > task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+	if (size > ACCESS_ONCE(task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur))

I don't see how this helps.  If someone else is changing limits while
we are looking at them, then there is a race.  We either get the old
or the new value.  Using ACCESS_ONCE (which on ia64 forces a "volatile"
access, which will make the compiler generate "ld.acq" rather than a
plain "ld") won't make any difference to this race.

Please explain what issue you see with the current code.

-Tony

