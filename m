Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXIYMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXIYMJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXIYMJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:09:33 -0400
Received: from mail0.scram.de ([78.47.204.202]:42099 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXIYMJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:09:32 -0400
X-Spam-Score: -3.868
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F8FA5F.3050907@scram.de>
Date: Tue, 25 Sep 2007 14:09:03 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com> <46F7EE95.1040509@scram.de> <46F80049.2030509@freescale.com>
In-Reply-To: <46F80049.2030509@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,
> Yikes.  Please don't change cpm_uart_cpm1.h, as it's correct for 
> arch/powerpc, and there are numerous other places that assume cpmp is 
> virtual (including in the very same function that assigns it a 
> physical address).

I'm still not convinced cpm_uart_cpm1.h is correct:

pinfo->rx_bd_base and pinfo->tx_bd_base are both initialized with an 
address obtained by cpm_dpram_addr(). In both ppc and powerpc, this is 
an address relative to dpram_vbase in commproc.c

In cpm_uart_core.c, the operation "pinfo->rx_bd_base - DPRAM_BASE" is 
used to calculate the DPRAM offset. So DPRAM_BASE must be relative to 
dpram_vbase in commproc.c as well. However, cpm_uart_cpm1.h uses cpmp in 
commproc.c to initialize DPRAM_BASE.

On ARCH=ppc, cpmp is a physical address with 1:1 virtual mapping ("well 
known address"). On ARC=powerpc, this is an address obtained by 
ioremap(), however it's a different ioremap() call than dpram_vbase is 
obtained from, so noone can guarantee
cpmp is always the same as dpram_vbase even on ARCH=powerpc.

To me, it looks like setting DPRAM_BASE to cpm_dpram_addr(0) is the fix 
as it makes the DPRAM offset a defined result.

Thanks,
Jochen

