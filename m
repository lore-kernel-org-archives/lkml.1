Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbXCNQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbXCNQ0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXCNQ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:26:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:2205 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbXCNQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZMrXr4iOM7Gslgq0ZQRbMuv2Xa4ESzsJayQRrGHa5tHPqn/wKXgRfknhp7Fpeyn40FuzAHHoe28ARK8Ic+rHSzzubTFi/dvWfRihbq43YHbm1HzHv9OjHC9sgx4+Qna8gIFxjDY9CBvjSGNJ3mAoc9c3RzGDn31Jl4D3u+S/3qA=
Message-ID: <b647ffbd0703140926v1aa861alecd1a2eb4c6d0f5d@mail.gmail.com>
Date: Wed, 14 Mar 2007 17:26:07 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [BUG: kernel/irq/proc.c] unprotected iteration over the IRQ action list in name_unique()
Cc: mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

1-st issue:  unprotected iteration over the IRQ action list in name_unique()


the racing sequences:

[ 1 ]  request_irq() -> setup_irq() -> register_handler_proc() ->
name_unique() -> iterate over the action list (*)

setup_irq() releases a desc->lock before calling register_handler_proc().

[ 2 ]  free_irq() -> delete some element while (*) is still in progress -> bum!

something like this should make it safe :

--- kernel/irq/proc-old.c       2007-03-14 16:34:52.828981000 +0100
+++ kernel/irq/proc.c   2007-03-14 16:59:47.236950000 +0100
@@ -66,11 +66,18 @@ static int name_unique(unsigned int irq,
 {
        struct irq_desc *desc = irq_desc + irq;
        struct irqaction *action;
+       unsigned long flags;
+
+       spin_lock_irqsave(&desc->lock, flags);

        for (action = desc->action ; action; action = action->next)
                if ((action != new_action) && action->name &&
-                               !strcmp(new_action->name, action->name))
+                               !strcmp(new_action->name, action->name)) {
+                       spin_unlock_irqrestore(&desc->lock, flags);
                        return 0;
+               }
+
+       spin_unlock_irqrestore(&desc->lock, flags);
        return 1;
 }


2-nd issue:  now it's about register_irq_proc() which is also called
by setup_irq().

register_irq_proc() is called for all descriptors for which

(irq_desc[irq].chip == &no_irq_chip) != 0           (*)

at startup time from init_irq_proc().

Let's suppose (*) is not true for some desc at startup and changes at
some point later.

If so, register_irq_proc() takes effect being called from setup_irq().

Now let's suppose request_irq() is called on 2 cpus for the same
interrupt line and both end up in (%) below

[ request_irq() -> setup_irq() -> register_irq_proc() ]

void register_irq_proc(unsigned int irq)
{
        char name [MAX_NAMELEN];

        if (!root_irq_dir ||
                (irq_desc[irq].chip == &no_irq_chip) ||
                        irq_desc[irq].dir)
                return;

            (%)  <=== both are here

        memset(name, 0, MAX_NAMELEN);
        sprintf(name, "%d", irq);

        /* create /proc/irq/1234 */
        irq_desc[irq].dir = proc_mkdir(name, root_irq_dir);
...

Both will try to initialize "irq_desc[irq].dir" and "smp_affinity"
entry... Not bum, but a possible leak indeed.


TIA,

-- 
Best regards,
Dmitry Adamushko
