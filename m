Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZKRPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZKRPal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZKRPak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:30:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbZKRPaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:30:39 -0500
Date: Wed, 18 Nov 2009 07:29:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Slaby <jslaby@novell.com>
cc: jirislaby@gmail.com, Ingo Molnar <mingo@elte.hu>, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, marcin.slusarz@gmail.com,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH 09/16] MM: use ACCESS_ONCE for rlimits
In-Reply-To: <1258555922-2064-9-git-send-email-jslaby@novell.com>
Message-ID: <alpine.LFD.2.01.0911180721440.4644@localhost.localdomain>
References: <4B040A03.2020508@gmail.com> <1258555922-2064-9-git-send-email-jslaby@novell.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hate these patches, but not because they start using ACCESS_ONCE() per 
se, but because they turn an already much too complex expression into the 
ExpressionFromHell(tm).

The fact that you had to split a single expression over multiple lines in 
multiple places should really have made you realize that something is 
wrong.

So I really would suggest that rather than this kind of mess:

On Wed, 18 Nov 2009, Jiri Slaby wrote:
>
> -	unsigned long limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
> +	unsigned long limit = ACCESS_ONCE(current->signal->
> +			rlim[RLIMIT_FSIZE].rlim_cur);

into something more like

	static inline unsigned long tsk_get_rlimit(struct task_struct *tsk, int limit)
	{
		return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
	}

	static inline unsigned long get_rlimit(int limit)
	{
		return tsk_get_rlimit(current, limit);
	}

and then instead of adding ACCESS_ONCE() to many places that are already 
ugly, you'd have made the above kind of expression be

	unsigned long limit = get_rlimit(RLIMIG_FSIZE);

instead.

Doesn't that look saner?

Yeah, yeah, there's a few places that actually take the address of 
'tsk->signal->rlim' and do this all by hand, so you'd not get rid of all 
of these things and it's not a matter of wrapping things in some new fancy 
abstraction layer, but at least you'd get rid of the overly complex 
expressions that span multiple lines.

With that, I'd probably like the series a whole lot better.

Which is not to say that I'm entirely convinced about get/setprlimit() in 
the first place, but that's a whole different issue.

		Linus
