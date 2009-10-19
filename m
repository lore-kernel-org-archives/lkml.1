Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZJSTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZJSTcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZJSTcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:32:17 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38730 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbZJSTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:32:16 -0400
Date: Mon, 19 Oct 2009 21:30:58 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
Message-ID: <20091019193058.GA29613@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
 <20091019073358.GE17960@elte.hu>
 <20091019080239.GB25783@Chamillionaire.breakpoint.cc>
 <20091019180810.3CB751E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091019180810.3CB751E@magilla.sf.frob.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath | 2009-10-19 11:08:10 [-0700]:

>AFAICT all you want is the following, and I'm not sure it requires all that
>much explanation.  I've probably missed some subtlety.

>Thanks,
>Roland
>
>--- a/include/linux/sched.h
>+++ b/include/linux/sched.h
>@@ -2090,7 +2090,13 @@ static inline int is_si_special(const struct siginfo *info)
> 
> static inline int on_sig_stack(unsigned long sp)
> {
>-	return (sp - current->sas_ss_sp < current->sas_ss_size);
>+#ifdef CONFIG_STACK_GROWSUP
>+	return sp >= current->sas_ss_sp &&
>+		sp - current->sas_ss_sp < current->sas_ss_size;

CONFIG_STACK_GROWSUP is wrong: If your stack grows up and sp ==
sas_ss_sp + size than you are using the last entry in your sig stack
which will be not recognized correctly. The case where sp == sas_ss_sp
is also not detected correctly but this should not happen in real life.

>+#else
>+	return sp > current->sas_ss_sp &&
>+		sp - current->sas_ss_sp <= current->sas_ss_size;
>+#endif
That is the PRE case which is the only relevant since we don't have any
POST architectures. The check here produces the same results as my
variant so it is okay :)
So you prefer the smaller patch with comments around it?
> }
> 

Sebastian
