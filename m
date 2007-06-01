Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbXFASEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbXFASEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760530AbXFASD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:03:59 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:61052 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760879AbXFASD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:03:58 -0400
Date: Fri, 1 Jun 2007 14:03:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601180356.GA7641@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070601170739.GA11115@waste.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:00:51 up 4 days,  2:39,  2 users,  load average: 0.83, 0.41, 0.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Mackall (mpm@selenic.com) wrote:
> On Fri, Jun 01, 2007 at 12:46:23PM -0400, Mathieu Desnoyers wrote:
> > * Matt Mackall (mpm@selenic.com) wrote:
> > > On Thu, May 31, 2007 at 03:42:50PM +0200, Andi Kleen wrote:
> > > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> > > > 
> > > > > Reimplementation of the cond calls which uses a hash table to hold the active
> > > > > cond_calls. It permits to first arm a cond_call and then load supplementary
> > > > > modules that contain this cond_call.
> > > > 
> > > > Hash table is probably overkill. This is a very very slow path operation.
> > > > Can you simplify the code? Just a linked list of all the condcall segments
> > > > should be enough  and then walk it.
> > > 
> > > I think it could be greatly simplified by using symbols instead of
> > > strings.
> > > 
> > > That is, doing cond_call(foo, func()) rather than cond_call("foo",
> > > func()). Here foo is a structure or type holding the relevant info to
> > > deal with the cond_call infrastructure. For unoptimized architectures,
> > > it can simply be a bool, which will be faster.
> > > 
> > > This has the added advantage that the compiler will automatically pick
> > > up any misspellings of these things. And it saves the space we'd use
> > > on the hash table too.
> > > 
> > 
> > The idea is interesting, but does not fit the problem: AFAIK, it will
> > not be possible to do multiple declarations of the same symbol, which is
> > needed whenever we want to declare a cond_call() more than once or to
> > embed it in an inline function.
> 
> It's not clear to me why either of those things are necessary. An
> example please?
> 

Case where we want to declare the same cond_call multiple times :

function_a(int var)
{
  ...
  cond_call(profile_on, profile_hit(...));
  ...
}


function_b(int var, int var2)
{
  ...
  cond_call(profile_on, profile_hit(...));
  ...
}


Case in inline function :

static inline myinlinefct()
{
  ...
  cond_call(profile_on, profile_hit(...));
  ...
}


somefct()
{
  ...
  myinlinefct();
  ...
  myinlinefct();
  ...
}

Those will result in multiple declarations of the cond_call.


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
