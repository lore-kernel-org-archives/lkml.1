Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZALQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZALQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZALQUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:20:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58196 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZALQUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:20:36 -0500
Date: Mon, 12 Jan 2009 08:20:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090112162032.GB6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110220135.GF20611@logfs.org> <20090110142330.295a8847.akpm@linux-foundation.org> <1231631840.13420.24.camel@twins> <20090111083034.GB30090@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090111083034.GB30090@logfs.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 09:30:34AM +0100, Jörn Engel wrote:
> On Sun, 11 January 2009 00:57:20 +0100, Peter Zijlstra wrote:
> > 
> > B-tree's however have one thing over RB-trees, B-trees can be made
> > RCU-safe whereas RB-trees cannot be -- the only problem is that Joern's
> > doesn't do that.
> 
> And yours doesn't support multiple key sizes afaics.  I don't mind
> using your version as a basis, so long as my^Wboth requirements get
> fulfilled. ;)
> 
> Do you see a problem combining rcu with keys being an array of unsigned
> long?

There is a theory vs. practice issue here.  In theory, you could make any
dynamically allocated search structure RCU-searchable by copy-updating
the entire structure on each update.  In many cases, you only have to
replace a fairly small part.  In practice, the question is whether your
read-to-update ratio is large enough to make it a win.

The main potential issue with keys being an array of unsigned long is
that it is no longer possible to atomically rewrite a given key in place.
The usual ways to work around this are:

1.	Replace each key entry with a pointer to the array of unsigned
	longs, so that you can atomically rewrite the pointer.  The
	downside of this approach is the extra cache line accessed per
	key scanned.  The upside of this approach is that you might
	be able to share code with Peter's tree by using a comparison
	function (if NULL, just compare the entries directly) or some
	other similar trick.

2.	Place the array of unsigned longs directly in the structure, but
	copy-update the entire node rather than rewriting keys in place.
	This has better cache locality, but makes it more difficult to
	share code with the small-key variant.

There are probably other tricks as well.

							Thanx, Paul
