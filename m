Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYHFRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYHFRnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYHFRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:43:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34295 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYHFRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:43:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <No> <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
Date: Wed, 06 Aug 2008 10:37:54 -0700
In-Reply-To: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Wed, 6 Aug 2008 01:38:24 -0700")
Message-ID: <m1hc9yjb7x.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2416]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> Please check dyn_array support for x86
> v3: split changing to nr_irqs to small patches
>     fix checkpatch error
>     reorder the patch sequence to make dyn_array support go at first
>         so could use that with arrays other than NR_IRQS
> v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
>     so could use 32 init, and init more if needed.
>
> now: x86 32bit: have CONFIG_HAVE_DYN_ARRAY
>      x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ
>
> left:
> a. hook irq_2_iommu to irq_desc ?
> b. expand /proc/interrupts to process > nr_irqs
> c. expand to use irq > nr_irqs for msi
>
> notes: may break some arch compling...

It looks like you might possibly be iterating to something usable.
Breaking architectures is not acceptable however.

My suggestion for a non-breaking path:
- Kill NR_IRQS in then generic code.
  With Alan's serial patch and my kstat patch it looks like we have
  the worst of that.

- Introduce get_irq_desc and the functions or function modifications
  that pass a struct irq_desc * into the genirq code.

  Although I absolutely hate the name get_irq_desc as it implies we are
  reference counting something and need a corresponding put_irq_desc.
  Since the lifetime rules don't require that.  Please just call the
  function irq_desc().

- Update arch/x86 to do everything interesting with irq_desc pointers.

- Start dynamically allocating irq_desc and irq_cfg.

Eric

