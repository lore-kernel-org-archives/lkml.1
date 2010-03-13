Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935951Ab0CMA6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:58:15 -0500
Received: from kroah.org ([198.145.64.141]:46803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935346Ab0CMAbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:12 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.563353093@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [038/145] sparc64: Fix sun4u execute bit check in TSB I-TLB load.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 1f474646fdc36b457606bbcd6a3592e6cbd31ac4 ]

Thanks to testcase and report from Brad Spengler:

--------------------
#include <stdio.h>

typedef int (* _wee)(void);

int main(void)
{
        char buf[8] = { '\x81', '\xc7', '\xe0', '\x08', '\x81', '\xe8',
                        '\x00', '\x00' };
        _wee wee;
        printf("%p\n", &buf);
        wee = (_wee)&buf;
        wee();

        return 0;
}
--------------------

TSB I-tlb load code tries to use andcc to check the _PAGE_EXEC_4U bit,
but that's bit 12 so it gets sign extended all the way up to bit 63
and the test nearly always passes as a result.

Use sethi to fix the bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/tsb.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/tsb.S
+++ b/arch/sparc/kernel/tsb.S
@@ -191,10 +191,12 @@ tsb_dtlb_load:
 
 tsb_itlb_load:
 	/* Executable bit must be set.  */
-661:	andcc		%g5, _PAGE_EXEC_4U, %g0
-	.section	.sun4v_1insn_patch, "ax"
+661:	sethi		%hi(_PAGE_EXEC_4U), %g4
+	andcc		%g5, %g4, %g0
+	.section	.sun4v_2insn_patch, "ax"
 	.word		661b
 	andcc		%g5, _PAGE_EXEC_4V, %g0
+	nop
 	.previous
 
 	be,pn		%xcc, tsb_do_fault


