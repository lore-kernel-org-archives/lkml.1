Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYDYH1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYDYH1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbYDYH0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:26:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39020
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbYDYH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:26:36 -0400
Date: Fri, 25 Apr 2008 00:26:36 -0700 (PDT)
Message-Id: <20080425.002636.250010462.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: seraph@xs4all.nl, akpm@linux-foundation.org, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SPARC64] INO problem Re: [Bug 10273] New: Sun GEM (PCI) -
 network device doesn't work
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080402182655.GA2739@ami.dom.local>
References: <20080317143624.da313311.akpm@linux-foundation.org>
	<20080402182655.GA2739@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 2 Apr 2008 20:26:55 +0200

> Nice work Jos! I forward it to the author and the lists.

I haven't forgotten about this bug report, in fact I did some
investigation and thinking about it.

I think the case being triggered in the new code is IRQ_DISABLED.

If this is the problem, I suspect that what needs to happen is that
when we re-enable the interrupt we have to forcefully hit the clear
register to put it back into transmit state.  Otherwise it can
get stuck.

Please give this patch a try (this is against 2.6.23, which is the
version you reported the bug against, let me know if another version
is more convenient).

Thanks!

diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index 2395609..98b68d2 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -313,6 +313,8 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 			 IMAP_AID_SAFARI | IMAP_NID_SAFARI);
 		val |= tid | IMAP_VALID;
 		upa_writeq(val, imap);
+
+		upa_writeq(ICLR_IDLE, data->iclr);
 	}
 }
 
