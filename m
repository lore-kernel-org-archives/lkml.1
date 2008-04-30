Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbYD3MR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbYD3MR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760028AbYD3MRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:17:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:43758 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763398AbYD3MRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:17:43 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+RRZZcSJqRkXiwe1Mhu5q/f+8rCBigBgDjFF3MDm
	FAM7jJ/kSNd9de
Date: Wed, 30 Apr 2008 14:17:38 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080430121738.GA4559@atjola.homenet>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet> <20080430093233.GD23528@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430093233.GD23528@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.04.30 11:32:33 +0200, Ingo Molnar wrote:
> Automating Sparse runs so that it can become part of our daily 
> patch-flow is _not_ trivial and it's not just a matter of typing make 
> C=1. Thomas is working on integrating Sparse delta analysis into our 
> daily patch workflow nevertheless.

Who said daily? More often can be better, but just before the pull
request is still better than nothing. And even some very basic and
stupid filtering can make the sparse output more feasible without losing
"too much" information (my stupid approach here can fail for example
when you remove an error of one class while introducing another one of
the same class).

Given the merge of x86.git that introduced this specific bug we have:
9e9abecf - "merge x86.git"

Now we can get:
$ git merge-base 9e9abecf^1 9e9abecf^2
4b119e21d0c66c22e8ca03df05d9de623d0eb50f

So you branched at 4b119e21... (your history is linear, that helps here)

To get the same information before the merge happened upstream, in your
local repo, you can do:
git merge-base for-linus origin/master
(or whatever your branches are called)

# So we get the old upstream version:
git checkout 4b119e21d0c
# setup config, whatever
make
make C=2 2>old-sparse

# Then the state of your tree right before the merge:
git checkout 9e9abecf^2
make
make C=2 2>new-sparse

# And now some stupid sorting and cleaning:
sort old-sparse | sed -e 's/^\([^:]*\):[^:]*:[^:]*:/\1:/' > old-sparsef
sort new-sparse | sed -e 's/^\([^:]*\):[^:]*:[^:]*:/\1:/' > new-sparsef

# How many old sparse warnings are gone now (approx.)?
$ diff old-sparsef new-sparsef | grep -c '^< [^ ]*:'
33

# And how many new do we have (approx.)?
$ diff old-sparsef new-sparsef | grep -c '^> [^ ]*:'
36


Depending on the order of the sed and sort commands, you get slightly
different output, due to code moving around or whatever, of course to
get that "mostly" right it takes more than the 5 minutes of thinking
that I spent on it.

In those cases in which there is more than 1 line per warning, the
output is obivously messed up here, so the actual number of real
warnings from sparse that are left is even lower than the number above
(26 for gone and new warnings in this case). And you can also only use
the filtered messages to navigate the original sparse log, because the
line numbers are stripped and the messed up ordering of multi-line
warnings, but well, shouldn't be too bad.

Slap another level of filtering on it that can ignore warnings that are
known to be bogus or in which you're simply not interested or whatever
and you're down to a pretty manageable set of warnings I guess.

Finally, yeah, I know, this approach is far from perfect, but in my
nobody-should-care-about-it opinion, it's better than nothing and it's
probably not too hard for you (or Thomas) to come up with a less stupid
filtering strategy, that's less error-prone than my hack.

Björn
