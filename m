Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbZFXS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbZFXS53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbZFXS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:57:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760451AbZFXS5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:57:08 -0400
Date: Wed, 24 Jun 2009 17:41:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 0/2] do_wait() wakeup optimization
Message-ID: <20090624154151.GC23848@redhat.com>
References: <20090622170432.GA4895@redhat.com> <93ad5f3f0906230955x357ff9evc334d4a5c6def20@mail.gmail.com> <20090623143054.GA10069@redhat.com> <93ad5f3f0906240953v3b328f9bxca51cd9d3838d05c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ad5f3f0906240953v3b328f9bxca51cd9d3838d05c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Ratan Nalumasu wrote:
>
> On Tue, Jun 23, 2009 at 7:30 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 06/23, Ratan Nalumasu wrote:
> > >
> > > Yes, it is something we really need. The specific case I have (hundreds
> > of
> > > NTPL threads in a program, and each thread managing a child process), the
> > > CPU load is >99% with NTPL threads, near 0% with the patch
> >                                                    ^^^^^^^^^
> >
> > Thanks. Did you test this patch, or do you mean the previous one?
> >
>
> Sorry, I meant the previous patch. I realize that there are more steps to
> take before we get to a complete solution.

I think Roland has already showed us the necessary step.

I'd like to think a bit more before sending this patch, but any chance you
can test these 2 patches + "3/2" below?

Oleg.

--- WAIT/kernel/exit.c~	2009-06-22 18:55:08.000000000 +0200
+++ WAIT/kernel/exit.c	2009-06-24 17:32:03.000000000 +0200
@@ -1569,6 +1569,9 @@ static int child_wait_callback(wait_queu
 	if (!eligible_child(wo, p))
 		return 0;
 
+	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
+		return 0;
+
 	return default_wake_function(wait, mode, sync, key);
 }
 

