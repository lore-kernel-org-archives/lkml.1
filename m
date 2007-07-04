Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXGDMZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXGDMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXGDMZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:25:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbXGDMZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:25:16 -0400
Date: Wed, 4 Jul 2007 14:25:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070704122505.GB21813@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183549772.3812.10.camel@johannes.berg>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> > > +#define create_workqueue(name) \
> > > +({								\
> > > +	static struct lock_class_key __key;			\
> > > +	struct workqueue_struct *__wq;				\
> > > +								\
> > > +	__wq = __create_workqueue((name), 0, 0, &__key);	\
> > > +	__wq;							\
> > > +})
> > 
> > Why do we need __wq ?
> 
> No particular reason I think, I copied some other code doing it that 
> way.

yep, should be fine doing this:

 #define create_workqueue(name)				\
 ({							\
	static struct lock_class_key __key;		\
							\
	__create_workqueue((name), 0, 0, &__key);	\
 })

(and the return value of __create_workqueue() will be the 'return value' 
of the macro as well.)

> > 	+ extern struct workqueue_struct *__create_workqueue_key(..., key);
> > 	+ #define __create_workqueue(...)	\
> > 	+	static struct lock_class_key __key;	\
> > 	+	__create_workqueue_key(..., key);	\
> > 
> > but this is a matter of taste.

the above macro should at minimum be encapsulated with
do { ... } while (0) so that __create_workqueue() is a single C 
statement.

	Ingo
