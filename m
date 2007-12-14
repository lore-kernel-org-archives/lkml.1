Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbXLNXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbXLNXYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXLNXYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:24:01 -0500
Received: from thunk.org ([69.25.196.29]:43655 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXLNXYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:24:00 -0500
Date: Fri, 14 Dec 2007 18:23:23 -0500
From: Theodore Tso <tytso@mit.edu>
To: John Reiser <jreiser@BitWagon.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071214232322.GE17344@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762EB63.8070100@BitWagon.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 12:45:23PM -0800, John Reiser wrote:
> > It's getting folded into the random number pool, where it will be
> > impossible to recover it unless you already know what was in the
> > pool.  And if you know what's in the pool, you've already broken into
> > the kernel.
> 
> The combination of capturing data from other users, plus seeding
> the pool with your own data, just might be powerful enough to help
> steal secrets, sometime in the next five years, from data that is
> recorded today.

Um, no.  Just seeding the pool with your own data won't help, since
that still won't tell you the initial contents of the pool.  And if
you know the initial contents of the pool, then you've broken root.
And being able to steal from the pool also assumes that you've broken
into the system; it is never, ever exported to userspace, even if
you're root (unless you use something like /dev/kmem).  Furthermore,
if you don't know the previous contents of the pool, you'll never be
able to recover the information, either now or five years in the
future, since information is XOR'ed into the pool.

> > But I'm sympathetic to making Valgrind happy.  ...

How about wrapping it in a #ifdef CONFIG_UML, which is the only way
you can use Valgrind?  The memset will slow down things unnecessarily,
and mixing in the unknown previous contents of the stack (a) doesn't
hurt, and (b) could make life more complicated for an attacker.

            	      	    	      - Ted
