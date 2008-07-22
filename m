Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYGVCNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYGVCNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYGVCN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:13:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbYGVCNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:13:25 -0400
Date: Tue, 22 Jul 2008 03:13:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] auditsc: test below 0 on unsigned ino
Message-ID: <20080722021324.GI28946@ZenIV.linux.org.uk>
References: <488529DC.2030504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488529DC.2030504@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 08:29:16PM -0400, roel kluin wrote:
> ino is unsigned so the test didn't work.
                              ^^^^^^^^^^^

Kindly report the way to reproduce your remarkable observation.  Do not
forget to include the compiler version, since the following two lines

> -	if (ctx->names[index].ino == -1)
> +	if (ctx->names[index].ino == -1ul)

are equivalent.  -1 is an expression of type int.  ctx->names[index].ino
is an expression of type unsigned long.  If both operands of a comparison
operator have arithmetic types, the usual arithmetic conversions (see 6.3.1.8)
are applied to the operands.  In this case, both types are integer ones and
not modified by integer promotions.  One is signed, another is unsigned and
the rank of unsigned one is greater or equal to that of the signed one
(rank(unsigned long) = rank(signed long) > rank(signed int)).  Therefore,
the operand with signed integer type (-1) is converted to the type of
argument with unsigned integer type.  Then they are compared.

In the second case both operands have the same integer type (unsigned long)
and comparison is done without any conversions.

Proof that (unsigned long)-1 and -1ul have the same value (namely, the maximal
value that can be represented in unsigned long) is left as an exercise for
reader.

Assuming that you have indeed observed a case when results of these tests
differed, you have found a blatant non-compliance of whatever C compiler
you were using.  I am sure that maintainers of that compiler would like to
see your bug report, especially since you already have a reproducer.  So
would everybody else, to know which version to avoid.
