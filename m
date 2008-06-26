Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbYFZTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbYFZTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYFZTDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:03:09 -0400
Received: from gw.goop.org ([64.81.55.164]:41974 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYFZTDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:03:07 -0400
Message-ID: <4863E7D9.7090307@goop.org>
Date: Thu, 26 Jun 2008 12:02:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu>
In-Reply-To: <20080626105722.GA12640@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> that fixed the build but now we've got a boot crash with this config:
>
>  time.c: Detected 2010.304 MHz processor.
>  spurious 8259A interrupt: IRQ7.
>  BUG: unable to handle kernel NULL pointer dereference at  0000000000000000
>  IP: [<0000000000000000>]
>  PGD 0
>  Thread overran stack, or stack corrupted
>  Oops: 0010 [1] SMP
>  CPU 0
>   

I don't know if this will fix this bug, but it's definitely a bugfix.  
It was trashing random pages by overwriting them with pagetables...

Subject: x86_64: memory mapping: don't trash large pmd mapping

Don't trash a large pmd's data when mapping physical memory.
This is a bugfix for "x86_64: adjust mapping of physical pagetables
to work with Xen".

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -311,7 +311,8 @@
 		}
 
 		if (pmd_val(*pmd)) {
-			phys_pte_update(pmd, address, end);
+			if (!pmd_large(*pmd))
+				phys_pte_update(pmd, address, end);
 			continue;
 		}
 


