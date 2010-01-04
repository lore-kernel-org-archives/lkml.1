Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767Ab0ADTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0ADTay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541Ab0ADTaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:30:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0ADTaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:30:52 -0500
Date: Mon, 4 Jan 2010 20:30:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: caiqian@redhat.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
	results on s390x)
Message-ID: <20100104193044.GB21146@redhat.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20100104155225.GA16650@redhat.com> <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com> <20100104181412.GA21146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104181412.GA21146@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Oleg Nesterov wrote:
>
> IOW. I think this problem is minor and probably can be ignored,

Or may be not...

Even if the child is not killed by SIGTRAP, it can get a lot of
unnecessary traps.

To verify, I did another trivial patch (below), and the test
case from 6580807da14c423f0d0a708108e6df6ebc8bc83d does trigger
a lot of "false step" printks.

Hmm. And sometimes there is nothing in dmesg, but the test-case
needs a lot of time to complete. "taskset -c" seems to always
trigger printk's. Magic.

Oleg.

--- arch/s390/kernel/traps.c~	2009-12-22 10:41:52.909174198 -0500
+++ arch/s390/kernel/traps.c	2010-01-04 13:19:51.038187586 -0500
@@ -384,6 +384,8 @@ void __kprobes do_single_step(struct pt_
 	}
 	if (tracehook_consider_fatal_signal(current, SIGTRAP))
 		force_sig(SIGTRAP, current);
+	else
+		printk("false step\n");
 }
 
 static void default_trap_handler(struct pt_regs * regs, long interruption_code)

