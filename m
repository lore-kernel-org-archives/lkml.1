Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbXGQHq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbXGQHq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXGQHqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:46:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45518 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbXGQHqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:46:16 -0400
Date: Tue, 17 Jul 2007 09:45:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Kent <raven@themaw.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717074537.GA13539@elte.hu>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184648474.3188.33.camel@raven.themaw.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Kent <raven@themaw.net> wrote:

> Yes it does and I have two reported bugs so far.
> 
> In several places I have code similar to:
> 
> wait.tv_sec = time(NULL) + 1;
> wait.tv_nsec = 0;
> 
> signaled = 0;
> while (!signaled) {
>         status = pthread_cond_timedwait(&cond, &mutex, &wait);
>        if (status) {
>              if (status == ETIMEDOUT)
>                   break;
>              fatal(status);
>       }
> }

ah! It passes in a low-res time source into a high-res time interface 
(pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
time(NULL) + 2, or change it to:

	gettimeofday(&wait, NULL);
	wait.tv_sec++;

does this solve the spinning?

i'm wondering how widespread this is. If automount is the only app doing 
this then _maybe_ we could get away with it by changing automount?

	Ingo
