Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZCXWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZCXWPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZCXWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:15:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZCXWO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:14:58 -0400
Date: Tue, 24 Mar 2009 23:14:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324221439.GE29509@elte.hu>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324215738.GD5975@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Mar 24, 2009 at 10:48:46PM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Well it's a very naive listing, there are sometimes some problems. 
> > > For example on x86-64, I had to save even some non-scratch 
> > > registers before calling the return hook, I still don't know why.
> > 
> > btw., which are those registers?
> > 
> > 	Ingo
> 
> 
> I would expect to only save rax,rdi,rsi,rdx,rcx,r8,r9 which are 
> used for parameters.

> And I had some crashes until I append r10 and r11 which actually 
> are scratch if I'm not wrong, but since they are scratch and are 
> not used for arguments, I thought they didn't need to be saved.
> 
> Well, I think there were some code flow cases I was missing.

Correct, r10 and r11 are clobbered registers too - and you need to 
save them too in mcount methods.

The reason is that mcount has a special calling convention - it's 
not just about not destroying arguments - GCC can keep data in r10 
or r11 scratch registers across function calls as well - for example 
for relatively static functions that are in its local optimization 
scope.

If GCC can prove that the local scope function itself does not 
clobber r10/r11, it does not have to clobber them across the 
function call. But the mcount() callback still gets inserted.

So the rule is: mcount must not destroy _any_ register state. 
(beyond flags)

	ngo
