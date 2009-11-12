Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZKLNqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZKLNqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZKLNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:45:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZKLNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:45:58 -0500
Date: Thu, 12 Nov 2009 14:45:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rostedt@goodmis.org
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
Message-ID: <20091112134554.GA30272@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
 <20091111134730.a0da9e38.akpm@linux-foundation.org>
 <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@canonical.com> wrote:

> >> ? ? ? s = kmalloc(sizeof(*s), GFP_KERNEL);
> >> ? ? ? if (!s)
> >> - ? ? ? ? ? ? return ENOMEM;
> >> + ? ? ? ? ? ? return -ENOMEM;
> >>
> >> ? ? ? trace_seq_init(s);
> >>
> >
> > lol, there we go again.
> >
> > Andy, can we have a checkpatch rule please?
> 
> Thats a tricky one.  Not only do we not really have a sensible way to 
> know if ENOMEM is an errno, we also find a bunch of places that we 
> appear to use positive errno's as return values where we would falsly 
> complain about.  Its particularly common in scsi and filesystems. 
> Admittedly the vast majority are return -EXXX form, so we could add 
> this as a non-default check perhaps.
> 
> Thoughts?

Even in filesystems, ~80% of the cases use proper negative values:

 $ git grep 'return -E' fs/ | wc -l
 4540
 $ git grep 'return E' fs/ | wc -l
 895

For SCSI it's even better, ~97% of the cases use the kernel's standard:

 $ git grep 'return -E' drivers/scsi/ | wc -l
 1448
 $ git grep 'return E' drivers/scsi/ | wc -l
 50

So i'd suggest to make this a default-enabled check. (default disabled 
checks are used only by a small minority) For a _long_ time has this 
been the kernel standard.

	Ingo
