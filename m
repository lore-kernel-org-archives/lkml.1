Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYHMHxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYHMHxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHMHwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:52:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbYHMHwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:52:51 -0400
Date: Wed, 13 Aug 2008 09:52:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Message-ID: <20080813075236.GA8052@elte.hu>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com> <20080813074503.GB398@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813074503.GB398@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> the dry_run variable is now unused in unpack_to_rootfs() and could be 
> eliminated.

also, while we are materially touching init/initramfs.c, that file has 
collected a few uglies in the past few years, checkpatch --file says:

  total: 7 errors, 7 warnings, 3 checks, 562 lines checked

it has a few other problems as well that can be seen if you look at the 
file. Unused macros:

 /* Diagnostic functions (stubbed out) */
 #define Assert(cond,msg)
 #define Trace(x)
 #define Tracev(x)
 #define Tracevv(x)
 #define Tracec(c,x)
 #define Tracecv(c,x)

 #define STATIC static
 #define INIT __init

lots of no-newline-after-variable-definitions instances:

 {
         int written;
         dry_run = check_only;

no-newline-before-return:

         kfree(header_buf);
         return message;
 }

so it would be nice to start off with a cleanup [strictly no code 
changed] patch.

then it also has an absolutely crazy turn-error-printouts-off hack:

 static __initdata char *message;
 static void __init error(char *x)
 {
         if (!message)
                 message = x;
 }

which is unobvious, 100% unused and should be removed.

those error()s should be pr_debug() perhaps. [this should be a second 
cleanup patch as it changes the code]

Hm?

	Ingo
