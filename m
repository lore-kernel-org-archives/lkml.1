Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZFAOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZFAOVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZFAOVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:21:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZFAOVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:21:03 -0400
Date: Mon, 1 Jun 2009 10:21:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
Message-ID: <20090601142104.GA15907@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just notice the following error from gcc 4.4:

arch/x86/kernel/tsc.c: In function 'time_cpufreq_notifier':
arch/x86/kernel/tsc.c:634: warning: 'dummy' may be used uninitialized in this function

dummy is only used in the following way in this function:

	lpj = &dummy;

and then dummy might be overriden in the following odd way:

	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
#ifdef CONFIG_SMP
		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
#else
	lpj = &boot_cpu_data.loops_per_jiffy;
#endif

and then is used in

	if (!ref_freq) {
		ref_freq = freq->old;
		loops_per_jiffy_ref = *lpj;
		tsc_khz_ref = tsc_khz;
	}

to me that looks like it can indeed be used unitialized for the case
where we do have CONFIG_SMP set, freq->flags & CPUFREQ_CONST_LOOPS is
true and ref_freq is false.

Can that case actually happen?
