Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYHAUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYHAUxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYHAUxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:53:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37621 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYHAUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:53:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
Date: Fri, 01 Aug 2008 13:46:11 -0700
In-Reply-To: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Fri, 1 Aug 2008 02:37:28 -0700")
Message-ID: <m1iqukwjjg.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1616]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> Please check dyn_array support for x86

YH you have not addressed any of my core concerns and this exceeds my review limit.
Unfortunately I don't feel like this is a productive process.

My core concerns are:
- You have not separated out and separately pushed the regression patch.  So that we can
  fix the current rc release.  Simply tuning NR_IRQS is all I feel comfortable with for
  fixing things in the post merge window period.

- The generic code has no business with dealing with NR_IRQS sized arrays.
  Since we don't have a generic problem I don't see why we should have a generic dyn_array solution.

- The dyn_array infrastructure does not provide for per numa node allocation of
  irq_desc structures, limiting NUMA scalability.

- You appear to be papering over problems instead of digging in and actually fixing them.

YH  Here is what I was suggesting when the topic of killing NR_IRQs came up a week or so
ago.
http://lkml.org/lkml/2008/7/10/439
http://lkml.org/lkml/2008/7/10/532

Which essentially boils down to:
- Removing NR_IRQS from the non-irq infrastructure code.
- Add a config option for architectures that are not going to use an array
- In the genirq code have a lookup function that goes from irq number to irq_desc *.

The rest we should be able to handle in a arch dependent fashion.

When we are done we should be able to create a stable irq number for msi interrupts
that is something like:  bus:dev:fun:vector_no which is 8+5+3+12=28 bits long.

Eric
