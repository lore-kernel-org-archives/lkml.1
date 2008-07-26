Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYGZKKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYGZKKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYGZKJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:09:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYGZKJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:09:53 -0400
Date: Sat, 26 Jul 2008 12:09:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/24] OProfile: Enable IBS for AMD CPUs
Message-ID: <20080726100937.GI25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-18-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-18-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> +	/* default values, can be overwritten by model */
> +	ops->create_files = nmi_create_files;
> +	ops->setup = nmi_setup;
> +	ops->shutdown = nmi_shutdown;
> +	ops->start = nmi_start;
> +	ops->stop = nmi_stop;
> +	ops->cpu_type = cpu_type;

i know you are moving existing code around, but sill it helps 
readability if you align these vertically too, like:

> +	/* default values, can be overwritten by model */
> +	ops->create_files	= nmi_create_files;
> +	ops->setup		= nmi_setup;
> +	ops->shutdown		= nmi_shutdown;
> +	ops->start		= nmi_start;
> +	ops->stop		= nmi_stop;
> +	ops->cpu_type		= cpu_type;

if i look at the aligned variant during review, i can see it immediately 
that it's fine and that left and right matches up conceptually. I can 
also see it, without having to look anywhere else, that ->cpu_type is 
special.

> @@ -482,11 +494,15 @@ static int setup_ibs_files(struct super_block * sb, struct dentry * root)
>  
>  static int op_amd_init(struct oprofile_operations *ops)
>  {
> +	setup_ibs();
> +	create_arch_files = ops->create_files;
> +	ops->create_files = setup_ibs_files;
>  	return 0;

the (non-)locking might be a bit racy here: the oprofilefs entries are 
set up first in setup_ibs() and made visible before you override them. 
oprofilefs entries should be made visible at the very last step, when 
all pointers are at their final versions and are stable already.

	Ingo
