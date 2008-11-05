Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYKEK4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYKEK4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYKEKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:55:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbYKEKz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:55:59 -0500
Date: Wed, 5 Nov 2008 11:55:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Message-ID: <20081105105541.GB19361@elte.hu>
References: <490E3F73.1000405@gmail.com> <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com> <20081103064647.GA4826@elte.hu> <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com> <20081104094341.GO23790@elte.hu> <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com> <20081104120355.GA19969@elte.hu> <c62985530811050250u638c8f95j7d80a13f834b06bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811050250u638c8f95j7d80a13f834b06bf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/4 Ingo Molnar <mingo@elte.hu>:
> > just make sure normal printk is totally silent. (otherwise you get
> > double lines on the console plus no reduction in recursion risk)
> >
> > i usually add a return; hack to kernel/printk.c:printk(), to make sure
> > it never executes anything. (and add a notrace to it as well) Maybe we
> > could even make this dependent on early_printk=...,keep.
> 
> Thanks for your help!
> 
> I tried the earlyprintk=vga,keep and I thought that the normal printk
> output would
> be replaced by early_printk output but that's not the case...
> So I replaced the content of printk by this of early_printk and it worked.
> But it seems that after the setting of the console, the early_printk
> doesn't work anymore.
> 
> Should I disable something else? I haven't any console=.... parameter
> but I guess I missed
> something there...

perhaps try a "console=tty 3" bootup - to boot into non-graphics 
initlevel 3, and to have a vga tty set up. Then comment out the 
regular printk(), to make sure it never tries to output to the regular 
tty.

does earlyprintk=vga,keep work in that case?

> But, I set the parameter nmi_watchdog=2 (I didn't know I had to 
> start explicitly the nmi watchdog) and at last... I had my 
> backtraces :-)

heh :-)

> All these backtraces were related to time function. And one of the 
> special things of the time functions is that they often manipulate 
> 64 bits numbers. Actually I totally forgot that a function could 
> return a long long, so I had to save edx register in the return 
> handler to restore it in its end because 64 bits numbers are 
> returned as a couple into eax and edx in x86-32.
> 
> So the main problem is now solved. But it remains a last (but more 
> rare) deadlock somewhere. I don't know why at this time and the nmi 
> watchdog doesn't tell anything. So I will have to use early_printk 
> to see the last functions traced. But the problem is that it doesn't 
> print on the console...

hm. Let me know if you cannot get this to work. I regularly use 
earlyprintk=serial,...,keep myself, and it works there - but i dont 
use earlyprintk=vga,keep that often.

	Ingo
