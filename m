Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbZG3Qht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbZG3Qht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZG3Qhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:37:48 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:53382 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZG3Qhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:37:47 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [RFC] Uni-processor interrupt state preservation.
Date: Thu, 30 Jul 2009 11:37:18 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301137.22035.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/up.c - -

int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
                                int wait)
{
        unsigned long flags;

        WARN_ON(cpu != 0);

        local_irq_save(flags);
        (func)(info);
        local_irq_restore(flags);

        return 0;
}

It **looks** reasonable - - 
but:

.L2:
#APP
        # ul native_save_fl(void)
        pushf ; pop %ebx
        # native_irq_disable(void)
        cli
#NO_APP
#(insn:TI 29 27 30 (set (reg:SI 0 ax [ info ])
#        (reg/v/f:SI 4 si [orig:62 info ] [62])) 34 {*movsi_1} (insn_list:REG_DEP_TRUE 27 (nil))
#    (expr_list:REG_DEAD (reg/v/f:SI 4 si [orig:62 info ] [62])
#        (nil)))
        movl    %esi, %eax      # 29    *movsi_1/1      [length = 2]
#(call_insn:TI 30 29 43 (call (mem:QI (reg/v/f:SI 5 di [orig:61 func ] [61]) [0 S1 A8])
#        (const_int 0 [0x0])) 386 {*call_1} (insn_list:REG_DEP_TRUE 29 (insn_list:REG_DEP_TRUE 27 (nil)))
#    (expr_list:REG_DEAD (reg:SI 0 ax [ info ])
#        (expr_list:REG_DEAD (reg/v/f:SI 5 di [orig:61 func ] [61])
#            (nil)))
#    (expr_list:REG_DEP_TRUE (use (reg:SI 0 ax [ info ]))
#        (nil)))
        call    *%edi   # 30    *call_1 [length = 2]
#APP
        # native_restore_fl(ul flags)
        push %ebx ; popf
#NO_APP

Just how is the interrupt state (in ebx) supposed to be preserved across the function call?
(assembly comments where added in macros, just to clarify where this is coming from.)

Mike
