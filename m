Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYDVSRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYDVSRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYDVSRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:17:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:45339 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYDVSRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:17:02 -0400
Message-ID: <480E2B69.8040606@windriver.com>
Date: Tue, 22 Apr 2008 13:16:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: i386 single-step vs int $0x80 issues
References: <20080416023650.E3CBDEFFEA@magilla.localdomain>	<480CD658.6030801@windriver.com> <20080421212543.15E1F26F8F0@magilla.localdomain>
In-Reply-To: <20080421212543.15E1F26F8F0@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 18:16:10.0251 (UTC) FILETIME=[F0DA9DB0:01C8A4A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Certainly I am interested in making all the cases work correctly.  The
>> failure behavior was observed on an SMP system.  I re-tested to
>> confirm the problem was still there.
> 
> Please help me reproduce this problem on the old code.  I have not been
> able to see it.  You didn't say whether it was intermittent, nor give any
> more details here.
> 
> 
> Thanks,
> Roland
> 


It took some further time to understand what is closer to the source
of the problem.  Previously I had just bisected backwards until ptrace
started working again because I knew it had broken between 2.6.14 and
2.6.21.  The test case provided in the patch I submitted either always
fails or always succeeds.  I had a particular machine and file system
that it always failed on.  I reduced the configuration to UP i386 with
a file system that was using full kernel auditing.

It turns out that it is the _TIF_SYSCALL_AUDIT interaction in entry.S
is more likely the culprit here.  This flag was getting turned on as a
result of using kernel/user space auditing.  I found that you can turn
off CONFIG_AUDIT and use the patch below to "simulate" the same
circumstance.  Then you should be able to observe the same failure I
saw directly with a vanilla 2.6.21 i386 kernel.


diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
diff --git a/kernel/fork.c b/kernel/fork.c
index 6af959c..fb47ab9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1154,6 +1154,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifdef TIF_SYSCALL_EMU
        clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
 #endif
+       /* HACK to always turn on syscall auditing */
+       set_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
+       /* end HACK to simulate auditing */
 
        /* Our parent execution domain becomes current domain
           These must match for thread signalling to apply */


Let me know if you need further details, and it certainly means some
further testing is in order against your newer patch.  I am also
interested in what test cases fail that you mentioned in your original
e-mail on this topic.

Thanks,
Jason.
