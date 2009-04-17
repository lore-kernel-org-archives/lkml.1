Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZDQNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZDQNOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZDQNO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:14:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33231 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZDQNOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:14:25 -0400
Date: Fri, 17 Apr 2009 15:17:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [28/28] x86: MCE: Implement new status bits
Message-ID: <20090417131730.GN14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150811.DD6DA1D046E@basil.firstfloor.org> <49E866E7.7070507@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E866E7.7070507@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 08:24:23PM +0900, Hidetoshi Seto wrote:

Note. I have some fixes on my own for this one already. I wrote
some new validation tools for the grader which detected some problems.

> Andi Kleen wrote:
> >  static struct severity {
> >  	u64 mask;
> >  	u64 result;
> >  	unsigned char sev;
> >  	unsigned char mcgmask;
> >  	unsigned char mcgres;
> > +	unsigned char ser;
> > +	unsigned char context;
> >  	char *msg;
> >  } severities[] = {
> > +#define KERNEL .context = IN_KERNEL
> > +#define USER .context = IN_USER
> > +#define SER .ser = 1
> > +#define NOSER .ser = -1
> 
> ser is unsigned or signed?

We only really use it as a abstract flag that is only compared for
equality so it doesn't matter.  I can change it to 2, or better define
another enum.

> 
> >  int mce_severity(struct mce *a, int tolerant, char **msg)
> >  {
> >  	struct severity *s;
> > @@ -51,11 +101,14 @@
> >  			continue;
> >  		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
> >  			continue;
> > -		if (s->sev > MCE_NO_SEVERITY && (a->status & MCI_STATUS_UC) &&
> > -			tolerant < 1)
> > -			return MCE_PANIC_SEVERITY;
> > +		if ((s->ser == 1 && !mce_ser) || (s->ser == -1 && mce_ser))
> > +			continue;
> > +		if (s->context && error_context(a) != s->context)
> > +			continue;
> >  		if (msg)
> >  			*msg = s->msg;
> > +		if (s->context == IN_KERNEL && panic_on_oops)
> > +			return MCE_PANIC_SEVERITY;
> >  		return s->sev;
> >  	}
> >  }
> 
> Where did you throw away the statements for "tolerant < 1"?

You mean why? 

It didn't really fit into the new status bits and didn't improve
behaviour with recovery.  I had originally
planned to fit it in, but after trying hard I gave up on that.

it only has its old meaning now, which means whether to risk
do_exit in kernel context (slight risk of deadlock) or not.
This has the advantage that it doesn't change behaviour
(although at least without mca recovery it didn't really matter
because you tended to always panic anyways)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
