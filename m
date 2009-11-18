Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbZKRVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbZKRVHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZKRVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:07:53 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50319 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbZKRVHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:07:52 -0500
Date: Wed, 18 Nov 2009 22:07:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
       atl1-devel@lists.sourceforge.net, Jie Yang <jie.yang@atheros.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       arnd@arndb.de
Subject: Re: [PATCH 1/16] drivers/net/atl1c: remove exceptional & on function
 name
In-Reply-To: <1258569615.24178.13.camel@Joe-Laptop.home>
Message-ID: <Pine.LNX.4.64.0911182202350.28287@ask.diku.dk>
References: <Pine.LNX.4.64.0911181920010.20943@ask.diku.dk>
 <1258569615.24178.13.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Joe Perches wrote:

> On Wed, 2009-11-18 at 19:20 +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > In this file, function names are otherwise used as pointers without &.
> > 
> > A simplified version of the semantic patch that makes this change is as
> > follows: (http://coccinelle.lip6.fr/)
> 
> Hi Julia, thanks for doing this.
> 
> Can you please post the complete version of the semantic patch?

There are basically three parts to the following semantic patch.  The 
first part counts the number of references to functions that do and do not 
have & in front of them.  For simplicity, a function is considered to be 
something that is explicitly defined in the current file.  It would be 
possible to also consider functions for which there is only a prototype.

The second part, consisting of the python code in the middle considers the 
counts and decides which transformation to make, if any.  In the end, to 
limit the number of files to consider, I just consider files for which 
there is only one occurrence of one case and more than 9 occurrences of 
the other.  The two small python rules after that one throw away all of 
the matches of function names that do not correspond to the case that is 
desired.

The last few rules do the transformation.  Both transformations are put in 
one rule, which is safe because all matches for the transformation that is 
not wanted have been discarded.

julia

@script:python@
@@

with_and = 0
without_and = 0

@r@
identifier f;
@@

f(...) { ... }

@addr1@
identifier r.f;
position pa;
@@

 &f@pa

@script:python@
p << addr1.pa;
@@

with_and = with_and + 1

@r1@
identifier r.f;
position p;
declarer name  EXPORT_SYMBOL;
@@

(
EXPORT_SYMBOL(f@p);
|
module_init(f@p);
|
module_exit(f@p);
|
f@p(...)
)

@noaddr1@
identifier r.f;
position pn != r1.p;
@@

(
  &f
|
 f@pn
)

@script:python@
p << noaddr1.pn;
@@

without_and = without_and + 1

@script:python@
@@

choose_without_and = False
#if (with_and * 25 < without_and):
#  choose_without_and = True
if (with_and == 1 and without_and > 9):
  choose_without_and = True

choose_with_and = False
#if (without_and * 25 < with_and):
#  choose_with_and = True
if (without_and == 1 and with_and > 9):
  choose_with_and = True

@script:python@
p << addr1.pa;
f << r.f;
@@

if (choose_with_and or not choose_without_and):
  cocci.include_match(False)

@script:python@
p << noaddr1.pn;
f << r.f;
@@

if (choose_without_and or not choose_with_and):
  cocci.include_match(False)

@@
identifier f;
position addr1.pa;
position noaddr1.pn;
@@

(
- &f@pa
+ f
|
- f@pn
+ &f
)
