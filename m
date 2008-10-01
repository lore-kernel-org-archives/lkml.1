Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYJAKcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYJAKcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYJAKcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:32:45 -0400
Received: from lazybastard.de ([212.112.238.170]:44168 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYJAKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:32:44 -0400
Date: Wed, 1 Oct 2008 12:32:25 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
Message-ID: <20081001103224.GB31146@logfs.org>
References: <1222787736.2995.24.camel@castor.localdomain> <20080930193318.GA31146@logfs.org> <1222855567.3052.31.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1222855567.3052.31.camel@castor.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 October 2008 11:06:07 +0100, Richard Kennedy wrote:
> 
> No I haven't made it available as it's really only a proof of concept,
> and I still don't have any sensible ideas how to deal with pointers to
> functions. Plus I'm still testing it to see if the results are anything
> like reasonable.
> Also it's finding lots of potentially recursive code paths and my
> heuristic to deal with them is very basic. I'm just adding a feature so
> that I can ignore some code paths, so maybe that will help.

Sounds very familiar. ;)

Function pointers are fairly easy.  When a function pointer is part of a
structure, simply consider that pointer to be a pseudo-function that
doesn't consume any stack space.  Whenever that pointer is written to,
that value can be "called" from the pseudo-function.  Callback functions
that are passed as function parameters can be handles similarly.

Getting this information wasn't too hard with smatch, but smatch depends
on gcc 3.1, which has *ahem* matured a bit.

Recursions essentially consume an infinite amount of stack unless you
know the upper bound for them.  I handled this two-fold.  First, every
single recursion is reported.  Secondly, every recursion is assumed to
be taken exactly once when calculating stack consumption.  This is the
minimal sane value.  Feel free to pick two or three if you prefer.

The main function code was done in two stages, iirc.  First stage simply
creates the call graph in memory.  Somewhere in the range of a million
objects.  Then I collapsed the graph from the leaves.  If function A
calls functions B, C and D, you first throw away two of the called
functions and keep the one with the biggest stack footprint.  Then A is
turned into a function A' that has the combined stack footprint of A and
B (assuming C and D are lighter) and is a leaf function.  Add some
annotation that B is called, along with anything B itself called before
it was collapsed.

If you use this method, recursions will sooner or later turn into a
pattern where A calls A.  Trivial to detect.

Maybe my thesis has a few more details:
http://wh.fh-wedel.de/~joern/quality.pdf

Jörn

-- 
Joern's library part 13:
http://www.chip-architect.com/
