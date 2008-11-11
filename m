Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYKKGqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYKKGqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYKKGqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:46:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbYKKGqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:46:15 -0500
Date: Mon, 10 Nov 2008 22:46:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 05/11] Memory and pathname
 management functions.
Message-Id: <20081110224609.4906d89f.akpm@linux-foundation.org>
In-Reply-To: <4919277F.9050206@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060949.942652091@nttdata.co.jp>
	<20081105151217.4e8d11a9.akpm@linux-foundation.org>
	<49180E29.2060004@nttdata.co.jp>
	<20081110210405.d43458f3.akpm@linux-foundation.org>
	<4919277F.9050206@nttdata.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:34:39 +0900 Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> Andrew Morton wrote:
> >>> Note that I said "kmalloc", not "kzalloc".  This function zeroes
> >>> everything all the time, and surely that is not necessary.  It's just a
> >>> waste of CPU time.
> >>>
> >> Callers of tmy_alloc assume that allocated memory is zeroed.
> > 
> > That isn't the point.  For programmer convenience we could make
> > __alloc_pages() and kmalloc() zero all the memory too.  But we don't
> > because it is slow.
> Are you saying "make the callers of tmy_alloc() tolerable with
> uninitialized memory"?

Well.  That would be a desirable objective.  I can understand the
reasons for taking the easy way out.  Given that Tomoyo doesn't seem to
ever free memory again, one hopes that this function doesn't get called
a lot, so the performance impact of zeroing out all that memory should
be negligible.

I think.  Maybe I misinterpreted tmy_alloc(), and perhaps it _is_
called frequently?

> >> Creating pseudo files for each variables is fine, though I don't see
> >> advantage by changing from
> >> "echo Shared: 16777216 > /sys/kernel/security/tomoyo/meminfo" to
> >> "echo 16777216 > /sys/kernel/security/tomoyo/quota/shared_memory".
> > 
> > Well for starters, the existing interface is ugly as sin and will make
> > kernel developers unhappy.
> > 
> > There is a pretty strict one-value-per-file rule in sysfs files, and
> > "multiple tagged values in one file" violates that a lot.
> /sys/kernel/security/ is not sysfs but securityfs.
> Does "one-value-per-file rule" also apply to securityfs?

It should apply.  It's not so much a matter of rules and regulations. 
One needs to look at the underlying _reasons_ why those rules came
about.  We got ourselves into a sticky mess with procfs with all sorts
of ad-hoc data presentation and input formatting.  It's inconsistent,
complex, makes tool writing harder, etc.

So we recognised our mistakes and when sysfs (otherwise known as procfs
V2 :)) came about we decided that sysfs files should not make the same
mistakes.

So, logically, that thinking should apply to all new pseudo-fs files. 
Even, in fact, ones which are in /proc!
