Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757131AbYLPVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYLPVuc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYLPVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:50:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYLPVuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:50:18 -0500
Date: Tue, 16 Dec 2008 22:49:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Steven Rostedt <srostedt@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
        Bart Van Assche <bart.vanassche@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Message-ID: <20081216214926.GU14787@elte.hu>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net> <20081211210917.GB27010@uranus.ravnborg.org> <4942BA85.3070408@vlnb.net> <1229118607.24995.18.camel@localhost.localdomain> <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > All the above functionality is almost what we need. The only thing 
> > left, which I forgot to mention, is possibility to log also functions 
> > return value on exit. This is what TRACE_EXIT_RES() in SCST does. Is 
> > it possible to add those?
> 
> I want to add that on the function graph tracer. That can be done pretty 
> easily. The only problem comes with the type of the return value. Would 
> this tracer be supposed to always return a 64 bits value regardless of 
> the real typ of the value? There would be some pointless bytes on most 
> return values. I don't know how to proceed for this problem.

Things like mov ...,%eax are zero-extend so they'll zap the high 32 bits.

The real problem are byte return values generated via things like:

   movb $1, %al

those wont zero-extend, so you could get garbage in the output. One 
approach would be to try a quick hack just to see how common a problem 
this is.

We could extract the return type from the debuginfo, hash it in a 
read-mostly table and then look it up, but that seems complex both in 
terms of build overhead and in terms of runtime overhead.

	Ingo
