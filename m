Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbZD1LWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbZD1LWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbZD1LWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:22:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660AbZD1LWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:22:17 -0400
Date: Tue, 28 Apr 2009 13:22:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/3] tracing/filters: new event parser
Message-ID: <20090428112205.GA20760@elte.hu>
References: <1240905879.6416.118.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240905879.6416.118.camel@tropicana>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> This patchset replaces the current event parser hack with a 
> better, more extensible version.  See patch 3 for the details on 
> syntax and usage.
> 
> Basically, instead of defining a filter predicate by predicate as 
> in the current version, you now define the whole thing all at once 
> and in addition to the current == and != operators, can use >, <, 
> >=, <=, parens and the logical operators && and ||.  Some 
> examples:
> 
> # echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
> 
> # echo "common_preempt_count > 4" > filter
> 
> # echo "common_preempt_count > 4 && common_pid != 0" > filter
> 
> It also does some basic error reporting, which you can see by 
> cat'ing the filter file after a failed set (this needs a little 
> more work to report the error position, but is still useful):
> 
> # echo "(sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
> -bash: echo: write error: Invalid argument
> # cat filter
> (sig >= 10 && sig < 15) || dsig == 17) && comm != bash
> ^
> parse_error: Unbalanced parens
> 
> It should be relatively easy to add new operators; it's 
> implemented as a standard infix to postfix converter - when a 
> filter is defined, as before, it creates a set of predicates that 
> are evaluated efficiently at run-time.
> 
> I tried to make the parser itself reusable so that it could also 
> be pointed at a completely separate set of operators and an 
> unevaluated operand, with the resulting expression components 
> available in the intermediate postfix list. e.g. for say a field 
> of type dev_t, the parser could be set up and pointed at an 
> operand of the form (8,3) or 8:3 or /dev/sda, and the parsed 
> results retrieved from the parse state object, something like 
> this:
> 
> enum kdev_t_filter_op_ids
> {
>        COMMA_OP,
> }; 
> 
> struct filter_op kdev_t_filter_ops[] = {
>        { COMMA_OP, ",", 1 },
>        { NO_OP, "NO_OP", 0 },
>        { OPEN_PAREN_OP, "(", 0 },
> };
> 
> parse_init(parse_state, kdev_t_filter_ops, dev_string); 
> filter_parse(parse_state);
> 
> The parsed operator and operands could then be found in the 
> parse_state.postfix list and used to generate the dev_t value, or 
> if it was specified as a string ('sda' or /dev/sda), there would 
> only be one item in the list which could be used in that case to 
> look up the value.

Very impressive changes! I'll have a closer look later today.

One thing that might make sense to add in future patches is a 
negation (logic) operator for integer fields. The expression
"!x" could be equivalent to "x == 0".

( Bitwise operators and basic arithmetics might also make sense in 
  the longer run, albeit i'm not sure how far we want to push
  arithmetics. It would need an extension of the operator result
  abstraction, to be able to return a value, beyond true/false. )

	Ingo
