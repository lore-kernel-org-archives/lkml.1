Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZGVUDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZGVUDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZGVUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:03:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39679 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZGVUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=skAePklddlu2TKA6cf1vWIDX0UQelRn5qAPuaQp/vbSLKZ0hjVU7jmWmIP5NcawCLX
         aQGn4iXhCs3O2PgpRx1b7huNMmrKqmCEodwcoZD9ekzc4LiVuV0SV93yWwGSsOibM1Hh
         8+vMjttEIEhd/2QZp/AOFP9pLcPCueYQSIn+U=
MIME-Version: 1.0
Date: Wed, 22 Jul 2009 21:02:57 +0100
Message-ID: <c6b1100b0907221302l330ad3dfx494c943426b97eef@mail.gmail.com>
Subject: 2.6.31-rc3-current-git+ build failure
From: Chris Clayton <chris2553@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a git pull about 20 minutes ago (that would be about 20:30 here
in UK) th eresultant kernel fails to build with the message:@

kernel/irq/manage.c: In function 'irq_thread_check_affinity':
kernel/irq/manage.c:475: error: 'struct irq_desc' has no member named 'affinity'
make[2]: *** [kernel/irq/manage.o] Error 1
make[1]: *** [kernel/irq] Error 2
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

I believe this is caused by commit:

591d2fb02ea80472d846c0b8507007806bdd69cc

genirq: Delegate irq affinity setting to the irq thread

irq_set_thread_affinity() calls set_cpus_allowed_ptr() which might
sleep, but irq_set_thread_affinity() is called with desc->lock held
and can be called from hard interrupt context as well. The code has
another bug as it does not hold a ref on the task struct as required
by set_cpus_allowed_ptr().

Just set the IRQTF_AFFINITY bit in action->thread_flags. The next time
the thread runs it migrates itself. Solves all of the above problems
nicely.

Add kerneldoc to irq_set_thread_affinity() while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The patch introduces an access to the affinity field of struct
irq_desc. Unfortunately the field is included only if CONFIG_SMP is
defined.

OK, I know enough to figure out the problem, but not enough to fix it :-(

Regards

Chris


-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
