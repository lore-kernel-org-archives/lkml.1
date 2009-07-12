Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZGLJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZGLJmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZGLJmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:42:08 -0400
Received: from ozlabs.org ([203.10.76.45]:37710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZGLJmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:42:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Mierswa <impulze@impulze.org>
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
Date: Sun, 12 Jul 2009 19:11:57 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A50B09B.9030901@impulze.org> <4A5282B4.8070302@impulze.org> <4A529CBA.4030408@impulze.org>
In-Reply-To: <4A529CBA.4030408@impulze.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907121911.58333.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009 10:24:18 am Daniel Mierswa wrote:
> There was a limitation for kernel parameters with regards to quoting. It
> wasn't possible to escape quotes or use quotes to form space-filled
> values inside parameters.

Hi Daniel!

   Yes, we've never had the ability to escape quotes (and you're the first to
ask), so when I wrote this code I kept it simple.  You can have spaced out
values, but you need to quote the whole thing "param=some value with spaces".

   We have to be careful not to break existing cmdlines tho: I don't know
if anyone uses \ currently, but simply interpreting \" is probably safe.

> +/* handle quotes in tokens (parameter and values)
> + * '" foo bar "' => ' foo bar '
> + * '" foo \" "'  => ' foo " '
> + */
> +static void add_token(char ** token, char * args)

add_token is a weird name for this.  It actually mangles the argument, and it
really should return the char *.

How about something like:
	static unsigned int pull_token(char *args, const char *delim)

Which unescapes and returns the length of the token, or zero if it simply
swallowed delimeters?  Assuming it always nul terminates, then the caller can
simply do:

	while (*args) {
		len = pull_token(args, " \t\n=");
		if (!len)
			/* Leading whitespace. */
			continue;
		*param = args;
		args += len;
		if (args[0] != '=') {
			*val = NULL;
		} else {
			len = pull_token(args+1, " \t\n");
			*val = args;
			args += len;
	}

Important cases to test are:
	x			param = "x", val = NULL
	x=			param = "x", val = ""
	x=y=1		param = "x", val = "y=1"

Plus all variations where x and y contain quotes.

Cheers,
Rusty.
