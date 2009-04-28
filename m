Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZD1IFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZD1IFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbZD1IEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:04:45 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:57215 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbZD1IEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=a4qXTP13UdmWE9q9FOujIvQgdjZlxbfI/+cfJaUb+7ZRkZrRFYItVvJOUdu4X8XJJ1
         zHRdW7tZ3DWZdkkpckXnmUyFLrBNQfjMNtuZDC+vWI1GTlauK78XOScPlEIn3M7hH90/
         VUrrnnLWL7yR2txAORTsxoHSSJQWBs4IWIeZg=
Subject: [PATCH 0/3] tracing/filters: new event parser
From: Tom Zanussi <tzanussi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 03:04:39 -0500
Message-Id: <1240905879.6416.118.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset replaces the current event parser hack with a better, more
extensible version.  See patch 3 for the details on syntax and usage.  

Basically, instead of defining a filter predicate by predicate as in the
current version, you now define the whole thing all at once and in
addition to the current == and != operators, can use >, <, >=, <=,
parens and the logical operators && and ||.  Some examples:

# echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter

# echo "common_preempt_count > 4" > filter

# echo "common_preempt_count > 4 && common_pid != 0" > filter

It also does some basic error reporting, which you can see by cat'ing
the filter file after a failed set (this needs a little more work to
report the error position, but is still useful):

# echo "(sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
-bash: echo: write error: Invalid argument
# cat filter
(sig >= 10 && sig < 15) || dsig == 17) && comm != bash
^
parse_error: Unbalanced parens

It should be relatively easy to add new operators; it's implemented as a
standard infix to postfix converter - when a filter is defined, as
before, it creates a set of predicates that are evaluated efficiently at
run-time.

I tried to make the parser itself reusable so that it could also be
pointed at a completely separate set of operators and an unevaluated
operand, with the resulting expression components available in the
intermediate postfix list. e.g. for say a field of type dev_t, the
parser could be set up and pointed at an operand of the form (8,3) or
8:3 or /dev/sda, and the parsed results retrieved from the parse state
object, something like this:

enum kdev_t_filter_op_ids
{
       COMMA_OP,
}; 

struct filter_op kdev_t_filter_ops[] = {
       { COMMA_OP, ",", 1 },
       { NO_OP, "NO_OP", 0 },
       { OPEN_PAREN_OP, "(", 0 },
};

parse_init(parse_state, kdev_t_filter_ops, dev_string);
filter_parse(parse_state);

The parsed operator and operands could then be found in the
parse_state.postfix list and used to generate the dev_t value, or if it
was specified as a string ('sda' or /dev/sda), there would only be one
item in the list which could be used in that case to look up the value.

Tom



