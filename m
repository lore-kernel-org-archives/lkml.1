Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYFSJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYFSJOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYFSJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:14:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54042 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYFSJOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:14:01 -0400
Date: Thu, 19 Jun 2008 11:13:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Byron Bradley <byron.bbradley@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Hua Zhong <hzhong@gmail.com>
Subject: Re: 2.6.26-rc5-mm3
Message-ID: <20080619091337.GA15228@elte.hu>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <alpine.DEB.1.00.0806130006490.14928@gamma> <1213811751.11203.73.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213811751.11203.73.camel@localhost.localdomain>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> 
> On Fri, 2008-06-13 at 00:32 +0100, Byron Bradley wrote:
> > Looks like x86 and ARM both fail to boot if PROFILE_LIKELY, FTRACE and 
> > DYNAMIC_FTRACE are selected. If any one of those three are disabled it 
> > boots (or fails in some other way which I'm looking at now). The serial 
> > console output from both machines when they fail to boot is below, let me 
> > know if there is any other information I can provide.
> 
> I was able to reproduce a hang on x86 with those options. The patch
> below is a potential fix. I think we don't want to trace
> do_check_likely(), since the ftrace internals might use likely/unlikely
> macro's which will just cause recursion back to do_check_likely()..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  lib/likely_prof.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.25/lib/likely_prof.c
> ===================================================================
> --- linux-2.6.25.orig/lib/likely_prof.c
> +++ linux-2.6.25/lib/likely_prof.c
> @@ -22,7 +22,7 @@
>  
>  static struct likeliness *likeliness_head;
>  
> -int do_check_likely(struct likeliness *likeliness, unsigned int ret)
> +int notrace do_check_likely(struct likeliness *likeliness, unsigned int ret)

the better fix would be to add likely_prof.o to this list of exceptions 
in lib/Makefile:

 ifdef CONFIG_FTRACE
 # Do not profile string.o, since it may be used in early boot or vdso
 CFLAGS_REMOVE_string.o = -pg
 # Also do not profile any debug utilities
 CFLAGS_REMOVE_spinlock_debug.o = -pg
 CFLAGS_REMOVE_list_debug.o = -pg
 CFLAGS_REMOVE_debugobjects.o = -pg
 endif

instead of adding notrace to the source.

	Ingo
