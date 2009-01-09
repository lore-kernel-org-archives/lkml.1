Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZAIVy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZAIVy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZAIVyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:54:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZAIVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:54:17 -0500
Subject: Re: copy_{to,from}_user
From: Peter Zijlstra <peterz@infradead.org>
To: Brad Parker <brad@heeltoe.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4056.1231523557@mini>
References: <4056.1231523557@mini>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 22:54:21 +0100
Message-Id: <1231538061.29452.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 12:52 -0500, Brad Parker wrote:
> I have a question about copy_{to,from}_user.  
> 
> Most implementations I've seen do in-order copies and notice when an
> exception occurs and report back the progress.  This is straight
> forward.
> 
> (but to be honest, I have suspicions about how just how accurate those
> reports are i.e. +/- 1-3 bytes on some architectures)
> 
> On some cpu's it is advantageous to do an out-of-order copy to take
> advantage of various cache fill mechanisms.
> 
> The problem is that the out-of-order copy makes it impossible to know
> where the exception occurred (in terms of progress).
> 
> Would it be permissible to have a version of copy_{to,from}_user which
> does an out-of-order copy and when an exception occurs, restarts the
> copy from the beginning using a simple in-order copy, to make it
> possible to identify where the exception occurs?
> 
> The idea is that exceptions are rare and so the performance hit of doing
> the "recopy" would be minimal and would provide the required accuracy.

x86_64 already does some unrolling and is inaccurate as to where exactly
it happens. The only thing that is very important is that you _never_
say you copied more than you actually did.

That was the source of a data corruption bug a while ago, the code did
something like sequences: read 8 words, write 8 words. And reported the
number of bytes read, instead of bytes written, which is an
over-estimation.
