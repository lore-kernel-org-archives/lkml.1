Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZABOnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZABOnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZABOm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:42:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZABOmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:42:55 -0500
Date: Fri, 2 Jan 2009 15:42:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ingo Brueckl <ib@wupperonline.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jj@chaosbits.net>, Tom Spink <tspink@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compile time warnings
Message-ID: <20090102144248.GA13621@elte.hu>
References: <20090102130140.GA30190@elte.hu> <495e192c@wupperonline.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495e192c@wupperonline.de>
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


* Ingo Brueckl <ib@wupperonline.de> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
>  > yes, with a small nit:
> >>
> >> +static inline void permanent_kmaps_init(pgd_t *pgd_base)
> >> +{
> >> +     (void) pgd_base;
> 
>  > there's no need for this line - this is not a macro, so the function
>  > parameter does not have to be 'used'.
> 
> I live and learn.
> 
> fix compiler warning in arch/x86/mm/init_32.c

applied to tip/x86/cleanups, thanks! Find below the final form of the 
commit.

	Ingo

---------------->
>From a9067d537615d534dcef06c0d819472e43a0d152 Mon Sep 17 00:00:00 2001
From: Ingo Brueckl <ib@wupperonline.de>
Date: Fri, 2 Jan 2009 14:42:00 +0100
Subject: [PATCH] x86: convert permanent_kmaps_init() from macro to inline

Impact: cleanup

This compiler warning:

  arch/x86/mm/init_32.c:515: warning: unused variable 'pgd_base'

triggers because permanent_kmaps_init() is a CPP macro in the
!CONFIG_HIGHMEM case, that does not tell the compiler that the
'pgd_base' parameter is used.

Convert permanent_kmaps_init() (and set_highmem_pages_init()) to
C inline functions - which gives the parameter a proper type and
which gets rid of the compiler warning as well.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 800e1d9..ad98b18 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -434,8 +434,12 @@ static void __init set_highmem_pages_init(void)
 #endif /* !CONFIG_NUMA */
 
 #else
-# define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init()	do { } while (0)
+static inline void permanent_kmaps_init(pgd_t *pgd_base)
+{
+}
+static inline void set_highmem_pages_init(void)
+{
+}
 #endif /* CONFIG_HIGHMEM */
 
 void __init native_pagetable_setup_start(pgd_t *base)
