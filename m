Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZEYDz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZEYDz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZEYDzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:55:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36920 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZEYDzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:55:00 -0400
Date: Mon, 25 May 2009 05:54:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/17] x86: add io_apic_ops to allow interception
Message-ID: <20090525035446.GC9396@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <1242170724-13349-3-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242170724-13349-3-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Xen dom0 needs to paravirtualize IO operations to the IO APIC, so add
> a io_apic_ops for it to intercept.  Do this as ops structure because
> there's at least some chance that another paravirtualized environment
> may want to intercept these.
> 
> [Impact: indirect IO APIC access via io_apic_ops]
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/io_apic.h |    9 +++++++
>  arch/x86/kernel/apic/io_apic.c |   50 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 56 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index 9d826e4..8cbfe73 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -21,6 +21,15 @@
>  #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
>  #define IO_APIC_REDIR_MASKED		(1 << 16)
>  
> +struct io_apic_ops {
> +	void (*init)(void);
> +	unsigned int (*read)(unsigned int apic, unsigned int reg);
> +	void (*write)(unsigned int apic, unsigned int reg, unsigned int value);
> +	void (*modify)(unsigned int apic, unsigned int reg, unsigned int value);
> +};
> +
> +void __init set_io_apic_ops(const struct io_apic_ops *);

ok, could you please turn the whole IO-APIC code into a driver 
framework? I.e. all IO-APIC calls outside of 
arch/x86/kernel/apic/io_apic.c should be to some io_apic-> method.

The advantage will be a proper abstraction for all IO-APIC details - 
not just a minimalistic one for Xen's need.

Also, please name it 'struct io_apic' - similar to the 'struct apic' 
naming we have for the local APIC driver structure.

Thanks,

	Ingo
