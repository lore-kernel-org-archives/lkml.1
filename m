Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbXE2Hen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbXE2Hen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXE2Heg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbXE2Hef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:34:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Satoru Takeuchi <takeuchi_satoru.jp@fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] signal: multithread program returns with wrong errno on receiving SIGSTOP
In-Reply-To: Oleg Nesterov's message of  Monday, 28 May 2007 11:07:53 +0400 <20070528070753.GA989@tv-sign.ru>
X-Shopping-List: (1) Conscientious socks
   (2) Capricious configurations
   (3) Inconspicuous acidic animal propositions
   (4) Fanatical despondent deception
   (5) Tenacious perilous connotations
Message-Id: <20070529073354.729431F8511@magilla.localdomain>
Date: Tue, 29 May 2007 00:33:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your fix seems like the only way to go.  From skimming all the ERESTART*
uses, I think that in all cases (except for n_tty.c:job_control before your
patch), TIF_SIGPENDING is indeed set when a thread returns -ERESTART*.

But it makes me realize that there is a danger of leaking a -ERESTART*
return code to userland when TIF_SIGPENDING gets cleared by another thread
doing a recalc_sigpending_tsk.  Because of -ERESTART* I think we must make
it a rule that no thread can clear another thread's TIF_SIGPENDING, only
set it (unless it's known to be stopped in the signal code or something).
>From our recent work on it, I think that do_sigaction is in fact the only
place this can happen.  So that says we should err in the other direction
from what I said before in do_sigaction, and not have it do recalc at all.


Thanks,
Roland
