Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXJAW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXJAW5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJAW5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:57:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXJAW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:57:17 -0400
Date: Mon, 1 Oct 2007 15:55:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: davids@webmaster.com
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001155530.5661fdef@laptopd505.fenrus.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEPLHCAC.davids@webmaster.com>
References: <20071001153529.7c669c7a@laptopd505.fenrus.org>
	<MDEHLPKNGKAHNMBLJOLKAEPLHCAC.davids@webmaster.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 15:44:09 -0700
"David Schwartz" <davids@webmaster.com> wrote:

> 
> > yielding IS blocking. Just with indeterminate fuzzyness added to
> > it....
> 
> Yielding is sort of blocking, but the difference is that yielding
> will not idle the CPU while blocking might. 

not really; SOMEONE will make progress, the one holding the lock.
Granted, he can be on some other cpu, but at that point all yielding
gets you is a bunch of cache bounces.

>Yielding is sometimes
> preferable to blocking in a case where the thread knows it can make
> forward progress even if it doesn't get the resource. (As in the
> examples I explained.)

that's also what trylock is for... as well as spinaphores...
(you can argue that futexes should be more intelligent and do
spinaphore stuff etc... and I can buy that, lets improve them in the
kernel by any means. But userspace yield() isn't the answer. A
yield_to() would have been a ton better (which would return immediately
if the thing you want to yield to is running already somethere), a
blind "yield" isn't, since it doesn't say what you want to yield to.

Note: The answer to "what to yield to" isn't "everything that might
want to run"; we tried that way back when the 2.6.early scheduler was
designed and that turns out to not be what people calling yield
expected.. (it made their things even slower than they thought). So
they want "yield to" semantics, without telling the kernel what they
want to yield to, and complain if the kernel second-guesses wrongly....


not a good api.
