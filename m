Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYKCNYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYKCNYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKCNY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:24:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:50664 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYKCNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:24:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oBXRg1jN/28w+6DlphuB+6rr7oLi1jc7cZYaXX3qNM4yfQ9ZY2uqUDdRlYlrSNqn3Y
         xvznQmqnEO5e5aUkZ40vwqq1qKivSiKR2yJXllMY6sH7j7NpgLz2DHFaPNMbLcgE3AE6
         Z9ti3rMrYWqnnqfHRv/beqji5CqH2C3oENkxU=
Message-ID: <c62985530811030524w62cf96a6j117904c31896770c@mail.gmail.com>
Date: Mon, 3 Nov 2008 14:24:27 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081103064647.GA4826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
	 <20081103064647.GA4826@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Ingo Molnar <mingo@elte.hu>:
> i'm wondering, does the changing to raw-spinlocks fix the deadlock?

Yes. The real problem was that insertion hold a spinlock, and then the spinlock
was traced, and then it could hold anymore the spinlock in insertion
....deadlock.
It fixed the problem with this solution.

> It's generally just the lack of recursion checking that is causing
> lockdep troubles - and recursion checking we want for all the more
> intrusive ftrace plugins anyway.

This problem wasn't lockdep relative. _But_ I had to deactivate lockdep for my
plugin to work. It seems there are some deadlock encountered with lockdep
enabled but I'm not sure why...
But of course it's just to make easy its implementation, I will adapt
it to rely on lockdep
in the end.

> Frederic, do you have trouble finding the source of the deadlock? In
> theory the NMI watchdog should be able to punch through it. (if not
> then we need to improve things so that it can)

I haven't any deadlock more (I hope) since I implemented the solution
of Steven (
and deactivated lockdep). But I discovered other problems that seem to
rely on page
faults (or it causes them). But I'm not sure yet, it was late at
night. I went to bed after some awful Oops.

The good news is that I now have backtraces to debug it :-)
