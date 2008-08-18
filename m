Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYHRRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYHRRwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYHRRwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:52:34 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50969 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYHRRwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:52:33 -0400
Message-ID: <48A9AFA7.8080508@freescale.com>
Date: Mon, 18 Aug 2008 12:21:43 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>	<48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
In-Reply-To: <20080818154746.GA26835@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>         asm volatile (
>                 "1: lwz         %1, 0(%2)\n"
>                 "   cmpw        %1, %5\n"
>                 "   bne         2f\n"
>                 "   stwu        %3, 0(%2)\n"
>                 "2:\n"
>                 ".section .fixup, \"ax\"\n"
>                 "3:     li %0, 1\n"
>                 "       b 2b\n"
>                 ".previous\n"
>                 ".section __ex_table,\"a\"\n"
>                 _ASM_ALIGN "\n"
>                 _ASM_PTR "1b, 3b\n"
>                 ".previous"
>                 : "=r"(faulted), "=r"(replaced)
>                 : "r"(ip), "r"(new),
>                   "0"(faulted), "r"(old)
>                 : "memory");

Some (most likely unrelated) nits in the above inline asm:

Should use a "b" constraint for %2, or you could get r0.  Or, use an "m" 
constraint with %U2%X2 after the lwz/stw.  Why stwu with an offset of 
zero, BTW?

%1 also needs to be an early clobber.

-Scott
