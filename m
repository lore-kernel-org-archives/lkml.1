Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbXLJFuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbXLJFuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 00:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXLJFua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 00:50:30 -0500
Received: from www.tglx.de ([62.245.132.106]:60455 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXLJFu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 00:50:29 -0500
Date: Mon, 10 Dec 2007 11:19:50 +0530 (IST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>  <20071208191330.GA21186@elte.hu>  <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>  <20071208194211.GA579@elte.hu>  <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
  <20071208201137.GA13451@elte.hu>  <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>  <20071208125144.734e9f81@laptopd505.fenrus.org>  <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>  <82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
 <82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007, Parag Warudkar wrote:

> On Dec 8, 2007 6:12 PM, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> > No problems after disabling CONFIG_HIGHRES_TIMERS , CONFIG_CPU_IDLE
> > and CONFIG_NO_HZ.
> >
> > I will try enabling them one by one - HRT, NOHZ and CPU_IDLE last -
> > that way we can at least tell what is required to be hit with this
> > problem.
> 
> Looks like CPU_IDLE=y is necessary for the problem to show up.
> With CPU_IDLE=n HRT+NO_HZ+TICK_ONESHOT does not give soft lockup problems.
> (Actually with HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=y  I do see short
> freezes on ssh - when I cannot type anything for may be a second even
> under 100% idle. But Soft Lock up doesnt show up in dmesg with this
> configuration.)

Can you please apply the patch below ? It prints out the internal
state of the clockevents/timer system when the softlockup is detected.

Thanks,

	tglx

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 11df812..82f1a05 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -118,6 +118,7 @@ void softlockup_tick(void)
 		show_regs(regs);
 	else
 		dump_stack();
+	sysrq_timer_list_show();
 	spin_unlock(&print_lock);
 }
 
