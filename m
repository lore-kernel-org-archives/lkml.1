Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYFUVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYFUVze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYFUVz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:55:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:49287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYFUVz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=WscpXVW1HacRtpA+KicaXKl7dGb+fbh12q18h6hZC+8ERueNnibS6J8moWqztBI4Cg
         0sixeLke4Rw5+1g0rAgoUoBWCnfvXm6G7zqOMQSTuwIRmQ6hmqS/fl1pmRkBJEbd7jPr
         isdxQVRYQSrqs++JbDrvKWW1gjFMn4rbieiLo=
Date: Sat, 21 Jun 2008 23:55:18 +0200
To: Ingo Molnar <mingo@elte.hu>, Philippe Elie <phil.el@wanadoo.fr>
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
Message-ID: <20080621215518.GA5715@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621182805.GA27417@damson.getinternet.no>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does this look correct? I didn't really play with preemption before, but
as far as I can tell, this is the right thing to do.

I don't really get why model->shutdown(msrs) is done only for one of the
CPUs, but my patch assumes that this is correct. (If that had been done
from inside nmi_shutdown() for each CPU, we wouldn't have had to get the
cpu var, and not needed to disable preemption.)

Please comment :-)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 21 Jun 2008 23:44:19 +0200
Subject: [PATCH] x86/oprofile: disable preemption in nmi_shutdown

    BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/27301
    caller is nmi_shutdown+0x11/0x60
    Pid: 27301, comm: oprofiled Not tainted 2.6.26-rc7 #25
     [<c028a90d>] debug_smp_processor_id+0xbd/0xc0
     [<c045fba1>] nmi_shutdown+0x11/0x60
     [<c045dd4a>] oprofile_shutdown+0x2a/0x60

Note that we don't need this for the other functions, since they are all
called with on_each_cpu() (which disables preemption for us anyway).

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/oprofile/nmi_int.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cc48d3f..4a177b4 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -269,12 +269,16 @@ static void nmi_cpu_shutdown(void *dummy)
 
 static void nmi_shutdown(void)
 {
-	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs;
+
+	preempt_disable();
+	msrs = &__get_cpu_var(cpu_msrs);
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
 	model->shutdown(msrs);
 	free_msrs();
+	preempt_enable();
 }
 
 static void nmi_cpu_start(void *dummy)
-- 
1.5.4.1

