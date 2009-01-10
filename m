Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZAJXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZAJXMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAJXMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:12:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZAJXL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:11:58 -0500
Date: Sun, 11 Jan 2009 00:11:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
Message-ID: <20090110231127.GK17917@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-9-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-9-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +#define err_printk(dev, format, arg...) do {			\
> +		error_count += 1;				\
> +		if (show_all_errors || show_num_errors > 0) {	\
> +			WARN(1, "%s %s: " format,		\
> +			     dev_driver_string(dev),		\
> +			     dev_name(dev) , ## arg);		\
> +		}						\
> +		if (!show_all_errors && show_num_errors > 0)	\
> +			show_num_errors -= 1;			\

Note that the arithmetics here is SMP-unsafe: we only hold the hash bucket 
so if two errors hit at once on two CPUs then the error tracking variables 
can be accessed at once.

I'd suggest a simple global lock for this error case (taken inside the 
hash bucket lock), to be on the safe side.

Also, please dont use a macro for this - printk details can be passed in 
to helper inlines/functions too.

	Ingo
