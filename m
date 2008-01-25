Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYAYUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYAYUiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYAYUin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:38:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYAYUim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:38:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86: i387 fpregs_set convert_to_fxsr
In-Reply-To: Siddha, Suresh B's message of  Friday, 25 January 2008 10:04:06 -0800 <20080125180406.GB5342@linux-os.sc.intel.com>
References: <20080125014059.GA5342@linux-os.sc.intel.com>
	<20080125015933.587DF26F9FD@magilla.localdomain>
	<20080125180406.GB5342@linux-os.sc.intel.com>
X-Windows: a mistake carried out to perfection.
Message-Id: <20080125203809.02C2C26F9FD@magilla.localdomain>
Date: Fri, 25 Jan 2008 12:38:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 24, 2008 at 05:59:33PM -0800, Roland McGrath wrote:
> > +	if (pos > 0 || count < sizeof(env))
> > +		convert_from_fxsr(&env, target);
> 
> Well, is the generic regset code enforce the need for this now? Can we
> disallow the usage cases where the user passes smaller target buffer
> size or requests data from in between. We were disallowing such usage
> scenarios before, isn't it?

It's true that there was before no way to touch only part of the FPU state
via ptrace.  The user_regset interface genericizes access to every regset
to permit partial access, subject to the size and align fields.  Access to
some part of the data is certainly of use for some regsets, like the
general registers and TLS, which always have exposed means to touch just
one chunk (e.g. PTRACE_POKEUSR, PTRACE_SET_THREAD_AREA).  It's a very
worthwhile thing that we have a uniform interface for all the regsets,
so I certainly would not change that.  

It could fit into the user_regset interface as now defined, to set .n = 1,
.size = whole for the FPU regset, so that all partial access is officially
invalid.  But it is easy enough to support partial access in fact, and for
the common case (xfpregs) there is no overhead or complexity to it at all.
Some new user of the user_regset interfaces very well might have a use for
fetching or touching just one FP register, so why rule it out a priori?


Thanks,
Roland
