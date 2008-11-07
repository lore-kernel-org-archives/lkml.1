Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYKGSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYKGSMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKGSL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:11:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:48477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYKGSL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:11:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=nT5teKwkVSFRS78GaZJCSi36/4cRnh1/a8g+XXM4py1+35a6OJQ9c8s6sW+9sJrN+
	2J04skJPeaz4qo0hOwZ+g==
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Frank Mayhar <fmayhar@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226053744.7803.5851.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
	 <1225984098.7803.4642.camel@twins>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 07 Nov 2008 10:10:48 -0800
Message-Id: <1226081448.28191.64.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 11:29 +0100, Peter Zijlstra wrote: 
> (fwiw your email doesn't come across properly, evo refuses to display
> them, there's some mangling of headers which makes it think there's an
> attachment)

Strange, evolution is what I used.  It's what I'm using to write this.

> On Thu, 2008-11-06 at 15:52 -0800, Frank Mayhar wrote:
> Well, I'm not thinking you did it right ;-)

Well you would be wrong, then, wouldn't you? :-)

> While I agree that the linear loop is sub-optimal, but it only really
> becomes a problem when you have hundreds or thousands of threads in your
> application, which I'll argue to be insane anyway.

You might argue that (and a few months ago I would have agreed with you)
but you would, I'm afraid, be wrong.  It very much depends on the
application.  We ran into the problem when we were running applications
with more than 4500 threads; there are good reasons to have lots-n-lots
of threads having to do with efficient use of resources, which I can't
go into at the moment.

> But with your new scheme it'll be a problem regardless of how many
> threads you have, as long as each running application will have at least
> 2 (not uncommon these days).

If and only if the process on the CPU at the tick is using a POSIX
interval timer.

Further, the former implementation had quadratic (or nearly so)
performance varying by the number of threads in a process (making it
impossible to predict how long the processing will take).  This
implementation has linear performance based on the number of CPUs which
is fixed over the life of the running kernel instance.

> Furthermore, the memory requirements for your solution now also scale
> with cpus instead of threads, again something not really appreciated.
> 
> Therefore I say your solution is worse than the one we had.

I'm sorry, I can't agree.  While I again admit that it may not be
optimal, it's certainly never going to hit a soft lockup until the
numbers of CPUs are far greater than 4096 and even then it's going to be
difficult to make it fail since the algorithm is more efficient.

The simple fact is that with the old implementation it is possible to
wedge the kernel simply by having a single process spawn a large number
of threads with an interval timer running.

> You should optimize for the common case, and ensure the worst case
> doesn't suck. You did it backwards.

You're saying that having four or fewer CPUs isn't the common case?

Oh, and you keep calling it "my" solution.  I should really share credit
(or blame) with Roland McGrath, who collaborated with me to write this
thing.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

