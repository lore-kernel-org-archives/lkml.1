Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbYCFAll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbYCFAll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYCFAeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:34:04 -0500
Received: from ozlabs.org ([203.10.76.45]:60341 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbYCFAeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:34:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 2/2] modules: Whine about suspicious return values from module's ->init() hook
Date: Thu, 6 Mar 2008 11:32:54 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
References: <200803042321.01683.rusty@rustcorp.com.au> <200803042322.26693.rusty@rustcorp.com.au> <20080305230445.GB937@cs181133002.pp.htv.fi>
In-Reply-To: <20080305230445.GB937@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061132.54554.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 10:04:45 Adrian Bunk wrote:
> On Tue, Mar 04, 2008 at 11:22:26PM +1100, Rusty Russell wrote:
> > Subject: Whine about suspicious return values from module's ->init() hook
> > Date: Mon, 11 Feb 2008 01:09:06 +0300
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> >
> > Return value convention of module's init functions is 0/-E. Sometimes,
> > e.g. during forward-porting mistakes happen and buggy module created,
> > where result of comparison "workqueue != NULL" is propagated all the way
> > up to sys_init_module. What happens is that some other module created
> > workqueue in question, our module created it again and module was
> > successfully loaded.
> >
> > Or it could be some other bug.
> >
> > Let's make such mistakes much more visible. In retrospective, such
> > messages would noticeably shorten some of my head-scratching sessions.
> >
> > Note, that dump_stack() is just a way to get attention from user.
> > Sample message:
> >
> > sys_init_module: 'foo'->init suspiciously returned 1, it should follow
> > 0/-E convention sys_init_module: loading module anyway...
> >...
>
> While I agree with Andrew that a BUG() would not be appropriate here I'm
> wondering why the module should be loaded?
>
> We do know that something in the module is buggy.

Unfortunately not: it's a semantic change.  Previously as per Unix standard, 
>=0 was good, < 0 was bad.  This resulted in some confusion, and so Alexey 
proposed tightening the rules, to only allow <= 0 values.

So we don't know that the module is buggy.  It's possible that it's returning 
ENODEV instead of -ENODEV, but it's also possible that it's returning 1 to 
mean "ok".

> And not loading the module also seems to be a good compromise between
> making the user notice the problem and not doing a panic().

Depends which way the failure is.  Andrew said not to break existing systems.

To avoid this, we'd need an audit which noone wants to do, so we're being 
lazy.

Hope that clarifies my thinking,
Rusty.
