Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbXH1OUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbXH1OUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXH1OTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:19:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:44954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXH1OTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:19:50 -0400
Date: Tue, 28 Aug 2007 16:19:48 +0200 (CEST)
From: Michael Matz <matz@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
In-Reply-To: <20070828084315.GB27022@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0708281508540.23011@wotan.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
 <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de>
 <20070828003704.deed71ae.akpm@linux-foundation.org> <20070828084315.GB27022@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 28 Aug 2007, Sam Ravnborg wrote:

> Googeling I did not find a good description of where __extension__ can 
> be used so I fail to see where in the parse.y file I shal add the 
> keyword. I think __extension__ may be used both as a part of an 
> expression AND as part of a typedef (as in this case) but I wonder if 
> this is where it is limited to be used.

The grammatic rules involving __extension__ are these (the lhs stems from 
the standard directly):

   external-declaration:
     __extension__ external-declaration

   struct-declaration:
     __extension__ struct-declaration

   nested-declaration:
     __extension__ nested-declaration

   unary-operator: one of
     __extension__ __real__ __imag__

The first three allow to put __extension__ in front of any external or 
local declaration (including decls inside blocks, in C99), ala:

  {
    x = 1+3;
    __extension__ int y = 3;
    x += y;
  }

the last one defines __extension__ as an unary operator, which can be 
applied to all cast-expressions (which in turn are just unary 
expressions).  E.g.:

   x = 1 + __extension__ (2+3);

Note that the decls include the C99 nested-decls in for statements:

   for (__extension__ long long i = 0; ...)

Note further that there's a small ambiguity in parsing when just looking 
forward one token, namely between decl and expression, like in this 
example:

   { __extension__ int i;

vs.

   { __extension__ i + 2;

Here you can't decide if __extension__ introduces an expression or a decl.  
Probably doesn't matter for your parser.  Hope this helps.


Ciao,
Michael.
