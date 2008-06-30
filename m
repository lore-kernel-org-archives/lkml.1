Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYF3GbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYF3GbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYF3Gaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:30:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbYF3Gav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:30:51 -0400
Date: Mon, 30 Jun 2008 08:30:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 25/39] merge common parts of uaccess.
Message-ID: <20080630063030.GA31336@elte.hu>
References: <1214602486-17080-17-git-send-email-gcosta@redhat.com> <1214602486-17080-18-git-send-email-gcosta@redhat.com> <1214602486-17080-19-git-send-email-gcosta@redhat.com> <1214602486-17080-20-git-send-email-gcosta@redhat.com> <1214602486-17080-21-git-send-email-gcosta@redhat.com> <1214602486-17080-22-git-send-email-gcosta@redhat.com> <1214602486-17080-23-git-send-email-gcosta@redhat.com> <1214602486-17080-24-git-send-email-gcosta@redhat.com> <1214602486-17080-25-git-send-email-gcosta@redhat.com> <1214602486-17080-26-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214602486-17080-26-git-send-email-gcosta@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> common parts of uaccess_32.h and uaccess_64.h
> are put in uaccess.h.

-tip testing found that it causes this build failure:

  fs/binfmt_aout.c: Assembler messages:
  fs/binfmt_aout.c:152: Error: suffix or operands invalid for `cmp'

with:

  http://redhat.com/~mingo/misc/config-Mon_Jun_30_08_17_42_CEST_2008.bad

and comparing the 32-bit and unified version is not simple and the 
commit is rather large.

I'm sure the fix is simple, but this bug shows a structural problem with 
this unification patch. The proper way to unify files is to first bring 
both the 32-bit and the 64-bit version up to a unified form via 
finegrained changes, so that uaccess_32.h and uaccess_64.h becomes 
exactly the same file.

... _then_ only, in a final 'mechanic unification' step the two files 
are merged into uaccess.h. (but no change is done to the content)

If anything breaks during such a series it's bisectable to a finegrained 
patch on either the 32-bit or the 64-bit side. If this commit was shaped 
that way i could now report to you the exact bisection result - instead 
of this too-broad bisection result.

So please rework this commit in that fashion (not just to fix this 
breakage but in anticipation of future commits) - uaccess.h is central 
enough for us to be super careful about it.

	Ingo
