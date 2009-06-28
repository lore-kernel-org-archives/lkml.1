Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZF1NiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZF1NiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZF1NiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:38:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZF1NiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:38:09 -0400
Date: Sun, 28 Jun 2009 15:37:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip RESEND] perf_counter x86: fix cache_event_ids table
Message-ID: <20090628133745.GA1942@elte.hu>
References: <1246129608.32198.29.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246129608.32198.29.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> + [C(L1D,  READ,     ACCESS)] = 0x0f40, /* L1D_CACHE_LD.MESI		*/
> + [C(L1D,  READ,     MISSES)] = 0x0140, /* L1D_CACHE_LD.I_STATE		*/

Dont you see how weird 'access' versus 'misses' reads?

Also, i like the PowerPC style more:

static int mpc7450_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = 
{
        [C(L1D)] = {            /*      RESULT_ACCESS   RESULT_MISS */
                [C(OP_READ)] = {        0,              0x225   },
                [C(OP_WRITE)] = {       0,              0x227   },
                [C(OP_PREFETCH)] = {    0,              0       },
        },
        [C(L1I)] = {            /*      RESULT_ACCESS   RESULT_MISS */
                [C(OP_READ)] = {        0x129,          0x115   },
                [C(OP_WRITE)] = {       -1,             -1      },
                [C(OP_PREFETCH)] = {    0x634,          0       },
        },

See how readable a two dimensional array is?

If we change the definitions on x86 then i'd suggest a small variant 
of this:

        [C(L1D)] = {          /* {  ACCESS         MISS   } */
                [C(READ    )]  = {       0,       0x225   },
                [C(WRITE   )]  = {       0,       0x227   },
                [C(PREFETCH)]  = {       0,           0   },
        },

	Ingo
