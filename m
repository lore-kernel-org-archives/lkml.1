Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbXFTXYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbXFTXYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXFTXYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:24:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32808 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXFTXYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:24:44 -0400
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 20 Jun 2007 16:21:07 -0700
Message-Id: <1182381667.2701.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Kprobes fundamntally disagrees with DEBUG_RODATA, there's no point in 
> "working around it". Better just admit it.

that's wrong. KPROBE fundamentally disagrees with TEXT being read only,
which is a 2.6.22 new "feature".. and a buggy one at that.


the real fix would be something like this instead:

--- linux-2.6.22-rc5/arch/x86_64/mm/init.c.org	2007-06-21 04:20:10.000000000 -0700
+++ linux-2.6.22-rc5/arch/x86_64/mm/init.c	2007-06-21 04:21:01.000000000 -0700
@@ -605,6 +605,11 @@ void mark_rodata_ro(void)
 	if (num_possible_cpus() > 1)
 		start = (unsigned long)_etext;
 #endif
+
+#ifdef CONFIG_KPROBES
+	start = (unsigned long)_etext;
+#endif
+	
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;


