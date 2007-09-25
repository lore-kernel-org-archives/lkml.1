Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXIYTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXIYTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXIYTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:46:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXIYTqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:46:25 -0400
Date: Tue, 25 Sep 2007 12:45:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [patch 5/7] Use extended crashkernel command line on ppc64
Message-Id: <20070925124534.b9da41a2.akpm@linux-foundation.org>
In-Reply-To: <20070925182259.398924232@strauss.suse.de>
References: <20070925182257.900701776@strauss.suse.de>
	<20070925182259.398924232@strauss.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 20:23:02 +0200 Bernhard Walle <bwalle@suse.de> wrote:

> This patch adapts the ppc64 code to use the generic parse_crashkernel()
> function introduced in the generic patch of that series.
> 
> 

I really don't like to see patches get a wholesale replacement, especially
when they've been looked at by a few people and have had some testing, etc.
It's not possible to see what changed and people need to re-review stuff
they've already reviewed, etc.

So I almost always undo this mess, turn the patches back into incremental
ones, see what pops out.

This patch is actually:


diff -puN arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update arch/powerpc/kernel/machine_kexec.c
--- a/arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update
+++ a/arch/powerpc/kernel/machine_kexec.c
@@ -63,7 +63,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void __init reserve_crashkernel(void)
 {
-	unsigned long long crash_size = 0, crash_base;
+	unsigned long long crash_size, crash_base;
 	int ret;
 
 	/* this is necessary because of lmb_phys_mem_size() */
_


which I suspect will now create a compiler warning.


	unsigned long long crash_size, crash_base;
	int ret;

	/* this is necessary because of lmb_phys_mem_size() */
	lmb_analyze();

	/* use common parsing */
	ret = parse_crashkernel(boot_command_line, lmb_phys_mem_size(),
			&crash_size, &crash_base);
	if (ret == 0 && crash_size > 0) {
		if (crash_base == 0)
			crash_base = KDUMP_KERNELBASE;
		crashk_res.start = crash_base;
	} else {
		/* handle the device tree */
		crash_size = crashk_res.end - crashk_res.start + 1;
	}

	if (crash_size == 0)
		return;

If so, the use of uninitialized_var() would be better than the unneeded
initialization-to-zero.

