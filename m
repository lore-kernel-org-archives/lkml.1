Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZDBQpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZDBQpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZDBQpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:45:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZDBQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:45:04 -0400
Date: Thu, 2 Apr 2009 18:44:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: fix build error when CONFIG_K8_NB=n
Message-ID: <20090402164439.GA7385@elte.hu>
References: <20090402170432.9bc4fbf8.sfr@canb.auug.org.au> <49D4D9E5.2060705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4D9E5.2060705@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build error when CONFIG_K8_NB=n:
> 
> arch/x86/mm/built-in.o:(.bss+0x5c0): multiple definition of `k8_northbridges'
> arch/x86/kernel/built-in.o:(.bss+0x18c8): first defined here

Thanks for the report, this is a known bug.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/x86/include/asm/k8.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20090402.orig/arch/x86/include/asm/k8.h
> +++ linux-next-20090402/arch/x86/include/asm/k8.h
> @@ -9,7 +9,7 @@ extern int early_is_k8_nb(u32 value);
>  #ifdef CONFIG_K8_NB
>  extern struct pci_dev **k8_northbridges;
>  #else
> -struct pci_dev **k8_northbridges;
> +static struct pci_dev **k8_northbridges;

This might fix the build but the change does something rather 
broken: there's now a new 'k8_northbridges' local variable array in 
each file that includes k8.h - that's wrong. We dont put static 
locals into include files that get included into several .c files, 
ever.

The real fix would be to not export k8_northbridges[] from k8.c, but 
to introduce a node_to_k8_northbridge() helper that returns a struct 
pci_dev. In the !CONFIG_K8_NB case this would be an inlne in k8.h 
that always returns NULL.

Anyway - just today i mailed about this this topic to Mark and 
Andreas about this build breakage (i have triggered it too), so 
there should be a resolution soon, either in form of a fix or in 
form of a revert.

Thanks,

	Ingo
