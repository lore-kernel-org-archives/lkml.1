Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZB1Qz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZB1Qz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZB1QzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:55:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbZB1QzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:55:14 -0500
Date: Sat, 28 Feb 2009 08:54:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
In-Reply-To: <20090228081123.GA5906@nowhere>
Message-ID: <alpine.LFD.2.00.0902280845580.3111@localhost.localdomain>
References: <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu>
 <20090227061936.GA5318@nowhere> <alpine.LFD.2.00.0902271631231.3111@localhost.localdomain> <20090228081123.GA5906@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Frederic Weisbecker wrote:
> 
> You're right, that's much proper.
> See the V2 below:

Good. This looks better.

One final (?) nit:

> +		default: {
> +			enum format_type type = spec.type;
> +
> +			if (type == FORMAT_TYPE_LONG_LONG)
> +				num = va_arg(args, long long);
> +			else if (type == FORMAT_TYPE_ULONG)
> +				num = va_arg(args, unsigned long);
> +			else if (type == FORMAT_TYPE_LONG)
> +				num = va_arg(args, unsigned long);
> +			else if (type == FORMAT_TYPE_SIZE_T)
> +				num = va_arg(args, size_t);
> +			else if (type == FORMAT_TYPE_PTRDIFF)
> +				num = va_arg(args, ptrdiff_t);
> +			else if (type == FORMAT_TYPE_USHORT)
> +				num = (unsigned short) va_arg(args, int);
> +			else if (type == FORMAT_TYPE_SHORT)
> +				num = (short) va_arg(args, int);
> +			else if (type == FORMAT_TYPE_UINT)
> +				num = va_arg(args, unsigned int);
> +			else
> +				num = va_arg(args, unsigned int);
> +
> +			str = number(str, end, num, spec.base,
> +				spec.field_width, spec.precision, spec.flags);

You've got three copes of these (in the three different users), and that 
just looks horrid. I see why you did it, but even something like

		case FORMAT_TYPE_LONG_LONG:
			num = va_arg(args, long long);
			goto handle_number;
		case FORMAT_TYPE_ULONG:
		...
		case FORMAT_TYPE_INT:
			num = va_arg(args, int);
	handle_number:
		str = number(str, end, num, &spec);
		break;

would be better.

And yes, please do pass in "spec" to the "number()/pointer()/string()" 
routines instead of exploding it into the individual numbers. When 
cleaning up, let's just do it properly..

		Linus
