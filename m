Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYCEOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYCEOhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYCEOhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:37:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYCEOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:37:03 -0500
Date: Wed, 5 Mar 2008 15:36:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] i386: fix merge mistake in i387.c
Message-ID: <20080305143634.GB16477@elte.hu>
References: <47CE6952.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE6952.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jan Beulich <jbeulich@novell.com> wrote:

> convert_fxsr_to_user() in 2.6.24's i387_32.c did this, and 
> convert_to_fxsr() also does the inverse, so I assume it's an oversight 
> that it is no longer being done.

thanks Jan, applied.

> -	env->fcs = fxsave->fcs;
> +	env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);

we encode it this way because there's no space for the 'FPU Last 
Instruction Opcode' (->fop) field in the legacy user_i387_ia32_struct 
that ptrace PTRACE_GETFPREGS/PTRACE_SETFPREGS uses.

it's probably pure legacy - i'd be surprised if any user-space relied on 
the FPU Last Opcode in any way. But indeed we used to do it previously 
so the most conservative thing is to preserve that piece of information.

FXRESTORE ignores the FOP field so the "restore" direction is 
meaningless:

    fxsave->fop = (u16) ((u32) env->fcs >> 16);

	Ingo
