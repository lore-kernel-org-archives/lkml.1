Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbZKNAlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbZKNAlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbZKNAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:41:11 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:54182 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbZKNAlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:41:10 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Sat, 14 Nov 2009 00:41:15 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdkubb$rdb$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <19857.1258147396@turing-police.cc.vt.edu> <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk> <24306.1258153693@turing-police.cc.vt.edu>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258159275 28075 128.32.168.222 (14 Nov 2009 00:41:15 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 14 Nov 2009 00:41:15 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Here's a concrete example of how a previously audited strcmp() can go bad...
>
>struct foo {
>    char[16] a; /* old code allows 15 chars and 1 more for the \0 */
>    int b;
>    int c;
>}
>
>bzero(foo,sizeof(foo));
>
>Now code can pretty safely mess with the first 15 bytes of foo->a and
>we know we're OK if we call strcmp(foo->a,....) because that bzero()
>nuked a[15] for us. It's safe to strncpy(foo->a,bar,15); and not worry
>about the fact that if bar is 15 chars long, a trailing \0 won't be put in.
>
>Now somebody comes along and does:
>
>struct foo {
>    char *a; /* we need more than 15 chars for some oddball hardware */
>    int b;
>    int c;
>}
>
>bzero(foo,sizeof(foo));
>foo->a = kmalloc(32);  /* whoops should have been kzmalloc */
>
>Now suddenly, strncpy(foo->a,bar,31); *isn't* safe....
>
>(Yes, I know there's plenty of blame to go around in this example - the failure
>to use kzmalloc, the use of strncpy() without an explicit \0 being assigned
>someplace, the use of strcmp() rather than strncmp()... But our tendency to
>intentionally omit several steps of this to produce more efficient code means
>it's easier to shoot ourselves in the foot...)

I'm not persuaded by your arguments against strcmp(): not even
a little bit.

1) The particular code snippets under discussion here were of the
form
    strncmp(foo, "constant", sizeof("constant"))
And the proposal is to replace this code with
    strcmp(foo, "constant")
Do you really mean to object to this proposal?

Please note that the '\0'-termination issues you mention do not
come up when comparing to a string constant.  strcmp(, "constant")
is not going to run past the end of your 16-byte buffer.  Moreover,
even if there was an issue with '\0'-termination, it would be present
to exactly the same degree with strncmp(), since the two code snippets
are behaviorally identical (in this case, it is not an issue for either
one, but if there was some context where it was an issue for strcmp(),
it would be an issue for the strncmp() equivalent, too).  So none
of your arguments are a good reason to prefer
    strncmp(foo, "constant", sizeof("constant"))
to
    strcmp(foo, "constant")

2) More generally, you seem to be concerned about bugs where one
piece of code fails to '\0'-terminate a string, and another piece of
code invokes some library function that relies upon '\0'-termination.
That is not specifically a strcmp() issue; this is an issue with using
any string library that assumes '\0'-termination, where the string is not
'\0'-terminated.  That's a much broader issue that should be addressed by
other means.  Saying "strcmp() is bad" is a poor response to this risk.
For every string, you should decide whether it must be '\0'-terminated
or not, and then act appropriately.

If the string is intended to be '\0'-terminated, then you have
an obligation to ensure that all code consistently maintains this
invariant, and in return you may call string libraries that assume
'\0'-termination.  Or if the string isn't intended to be '\0'-terminated,
then you should never be calling any string library function that
assumes '\0'-termination.  This is pretty elementary stuff: if you do
much C programming, you're hopefully used to this.  There's nothing
wrong with using strcmp(), if it is used appropriately.  A kneejerk
"never use strcmp()" seems like poor policy to me.

In summary, I think your arguments against strcmp() are unpersuasive in
this context.  Perhaps in some other context they are relevant, but not
to this thread.  Focusing on strcmp() is misplaced.

If you want to do something useful, I think it would be more useful
to focus on checking that strings are properly '\0'-terminated where
this is necessary -- but realize that this is a much more challenging
property, and it's going to require something much more sophisticated
than just "don't use strcmp()".  Most likely, this is not something that
Cocinelle will be sophisticated enough to handle usefully, at least in
the general case.
