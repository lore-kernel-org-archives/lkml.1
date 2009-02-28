Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZB1JP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZB1JP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZB1JNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:13:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZB1JNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:13:51 -0500
Date: Sat, 28 Feb 2009 10:13:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090228091305.GA20533@elte.hu>
References: <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <alpine.LFD.2.00.0902271631231.3111@localhost.localdomain> <20090228081123.GA5906@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228081123.GA5906@nowhere>
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

> > instead? Wouldn't that be nicer? I suspect it would make the 
> > code look nicer too (instead of doing "*base = x", you'd see 
> > "spec->base = x" and it would look less like line noise in 
> > the callee, an the caller could just do a single "struct 
> > format_spec spec = { 0, }" to initialize that thing).
> > 
> > 		Linus
> 
> You're right, that's much proper.
> See the V2 below:

Just a few (very) small code style pet peeves:

> +struct printf_spec {
> +	enum format_type type;
> +	int flags;			/* flags to number() */
> +	int field_width;		/* width of output field */
> +	int base;
> +	/* min. # of digits for integers; max number of chars for from string */
> +	int precision;
> +	int qualifier;
> +};

doesnt it look a bit tidier this way:

 struct printf_spec {
	enum format_type	type;
	int			flags;		/* flags to number()     */
	int			field_width;	/* width of output field */
	int			base;
	int			precision;	/* # of digits/chars     */
	int			qualifier;
 };

?

> +		case '+':
> +			spec->flags |= PLUS;
> +			break;
> +		case ' ':
> +			spec->flags |= SPACE;
> +			break;
> +		case '#':
> +			spec->flags |= SPECIAL;
> +			break;
> +		case '0':
> +			spec->flags |= ZEROPAD;
> +			break;
> +		default:
> +			found = false;

btw., this is one of the cases where i think the original style 
was more useful:

> +		case '+':	spec->flags |= PLUS;  break;
> +		case ' ':	spec->flags |= SPACE; break;
[etc.]

as it's always good to compress repetitive patterns of code.

(If checkpatch complains about this then ignore checkpatch.)

> +	case 'n':
> +		/* FIXME:
> +		* What does C99 say about the overflow case here? */

(this comment looks a bit funny.)

> +		default: {
> +			enum format_type type = spec.type;
> +
> +			if (type == FORMAT_TYPE_LONG_LONG)
> +				num = get_arg(long long);
> +			else if (type == FORMAT_TYPE_ULONG)
> +				num = get_arg(unsigned long);
> +			else if (type == FORMAT_TYPE_LONG)
> +				num = get_arg(unsigned long);
> +			else if (type == FORMAT_TYPE_SIZE_T)
> +				num = get_arg(size_t);
> +			else if (type == FORMAT_TYPE_PTRDIFF)
> +				num = get_arg(ptrdiff_t);
> +			else if (type == FORMAT_TYPE_USHORT)
> +				num = get_arg(unsigned short);
> +			else if (type == FORMAT_TYPE_SHORT)
> +				num = get_arg(short);
> +			else if (type == FORMAT_TYPE_UINT)
> +				num = get_arg(unsigned int);
> +			else
> +				num = get_arg(int);

Wouldnt it be cleaner as a switch() statement and to put into a 
helper function?

Also, could you please resend the current stuff with a 0/ 
description and a diffstat in the 0 mail so that we can all see 
all the patches again and the total impact?

	Ingo
