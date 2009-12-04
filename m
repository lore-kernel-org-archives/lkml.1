Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZLDJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZLDJVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZLDJVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:21:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37242 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZLDJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=siGiABWNO50G5pu0Pll9mtxZ01E2yIhDFuYjsz9xYITmBrfnjCQebYxYQbGky3UX2g
         aPPSNOkqNRx5hlriCFfT54uhMu7ov3gws7ziZvV4UYQKrN3ukSh9gkDa8mO8veLnRb9F
         hcu1iTllFsB2Ye4cGy9HS4wjsfymL/Rli9seM=
Date: Fri, 4 Dec 2009 11:21:19 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: x86@kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: x86: Is 'volatile' necessary for readb/writeb and friends?
Message-ID: <20091204092119.GA9707@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

x86 memory-mapped IO register accessors cast the memory mapped address
parameter to a one with the 'volatile' type qualifier. For example, here
is readb() after cpp processing

--> arch/x86/include/asm/io.h:

static inline unsigned char readb(const volatile void __iomem *addr) {
	unsigned char ret;
	asm volatile("movb %1, %0"
		     :"=q" (ret)
		     :"m" (*(volatile unsigned char __force *)addr)
		     :"memory");
        return ret;
}

I wonder if the volatile qualifiers in the parameter above and at the asm
statement operand were strictly necessary, or just added for extra safety.

AFAIK, the asm statement already functions as a compiler barrier, and the
compiler won't 'optimize' the statement away due to the 'asm volatile' part,
so shouldn't things be safe without those volatile qualifiers?

The only red-herring I found in the gcc manual was the fact that the
"volatile asm instruction can be moved relative to other code, including
across jump instructions."

I wonder if this was the reason a volatile-type data dependency was added
to the mov{b,w,l,q} asm statements; not to reorder the asm instruction
around non-memory-accessing instructions (we already have a barrier).

Thank you!

-- 
Darwish
