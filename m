Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562Ab0ASIqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0ASIqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518Ab0ASIqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:46:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab0ASIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:46:30 -0500
Subject: Re: [PATCH 1/3] perf_event: fix race in
 perf_swevent_get_recursion_context()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B5508AF.1080302@cn.fujitsu.com>
References: <4B54654A.4090601@cn.fujitsu.com>
	 <20100118164128.GI10364@nowhere>  <4B5508AF.1080302@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:46:17 +0100
Message-ID: <1263890777.4283.638.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 09:19 +0800, Xiao Guangrong wrote:
> 
> 
> It's because hard-irq(we can handle interruption with interruption enabled)
> and NMI are nested, for example:
> 
> int perf_swevent_get_recursion_context(void)
> {
>         ......
>         if (cpuctx->recursion[rctx]) {
>                 put_cpu_var(perf_cpu_context);
>                 return -1;
>         }
> 
>         /*
>          * Another interruption handler/NMI will re-enter there if it
>          * happed, it make the recursion value chaotic
>          */
>         cpuctx->recursion[rctx]++;
>         ......
> } 

This doesn't make any sense at all, if IRQs are nested (bad bad bad)
then it will still end up with the same recursion context and detect
that recursion and bail on the nested one. So what's the problem?

NMIs are not allowed to nest, ever.

