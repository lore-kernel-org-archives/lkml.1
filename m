Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbXLQDUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbXLQDUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 22:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXLQDUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 22:20:36 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:63754 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbXLQDUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 22:20:35 -0500
Date: Mon, 17 Dec 2007 12:20:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: div64: Rework 64-bit type safety checks in do_div().
Message-ID: <20071217032019.GA15449@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20071217014805.GA15156@linux-sh.org> <20071216190418.8acc64d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216190418.8acc64d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Ingo to CC regarding kernel/lockdep_proc.c..)

On Sun, Dec 16, 2007 at 07:04:18PM -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2007 10:48:05 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> > The options are to either 'fix' all callers of do_div() to make sure
> > they're using a uint64_t explicitly, or to update do_div() to make sure
> > that the value is 64-bits, regardless of specific type. Currently
> > everything that uses the generic do_div() causes a warning when using one
> > of 'u64', 'long long', etc. instead of 'uint64_t'.
> 
> u64 and uint64_t should be identical?
> 
Er, yes, that was supposed to be an 's64'. It only applies to sign
mismatch.

> > -/* The unnecessary pointer compare is there
> > - * to check for type safety (n must be 64bit)
> > - */
> > +/* The BUILD_BUG_ON() is there to check for type safety (n must be 64bit) */
> >  # define do_div(n,base) ({				\
> >  	uint32_t __base = (base);			\
> >  	uint32_t __rem;					\
> > -	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
> > +	BUILD_BUG_ON(sizeof(n) != sizeof(uint64_t));	\
> >  	if (likely(((n) >> 32) == 0)) {			\
> >  		__rem = (uint32_t)(n) % __base;		\
> >  		(n) = (uint32_t)(n) / __base;		\
> 
> The mismatch which I've seen triggering a lot is doing do_div() on an s64
> when it expects a u64.
> 
> And I think that _is_ a bug, isn't it?  do_div(-10, 10) should return -1,
> but as the implementation will convert -10 to <monstrously large +ve
> number>, the return value will be wildly wrong?
> 
If it's supposed to be u64 only, then yes, the existing check should be
ok. There are a lot of places (time keeping code, lockdep, etc.) that
operate on signed values though, and from the comments in some places
this seems to be intentional (ie, kernel/lockdep_proc.c has this gem):

static void snprint_time(char *buf, size_t bufsiz, s64 nr)
{
        unsigned long rem;

        rem = do_div(nr, 1000); /* XXX: do_div_signed */
        snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, ((int)rem+5)/10);
}

> I'm thinking that the problem here is that x86's do_div(s64, ...) doesn't
> warn.  So people write wrong code and then the problems only crop up on
> architectures which use asm-generic/div64.h, which does warn?

That seems to be an accurate asessment, yes. If do_div(s64, ...) is buggy
behaviour, then the current check is fine, and the callsites should be
corrected. Though if there's code in-tree that relies on s64 do_div, that seems
to be a more problematic issue.
