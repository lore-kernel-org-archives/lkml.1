Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbXLPRUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbXLPRUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXLPRT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:19:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:56639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751740AbXLPRT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:19:56 -0500
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX180Sa874V40lQbzpFm73NQsTN36+FmFuTiIOrWKYs
	dzTtnbgBCzP05K
Subject: Re: [PATCH] debugfs: Revamp debugfs_create_{u,x,s}{8,16,32,64} to
	support signed integers
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071216170550.GA12697@kroah.com>
References: <1197823079.7530.11.camel@localhost>
	 <20071216170550.GA12697@kroah.com>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 18:19:53 +0100
Message-Id: <1197825593.7530.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-16 at 09:05 -0800, Greg KH wrote:
> On Sun, Dec 16, 2007 at 05:37:59PM +0100, Mattias Nissler wrote:
> > This makes debugfs use its own file_operations for the value accessor files
> > created by debugfs_create_XXX. Having that, we can also have proper versions
> > for signed integers.
> 
> Why not tweak the "SIMPLE_ATTRIBUTE" code to support this instead?  That
> way debugfs and all other filesystems could also use these attributes?

I expected that question ;-) Actually, I had a version that did this.
But it ended up being ugly, cause SIMPLE_ATTRIBUTEs expect to access the
values via get/set functions using u64. Here is what I did and why I
didn't like it:

* I made the set/get function interface more generic (as it is in the
debugfs patch), i.e. getting passed the buf, so they have to
decode/encode whatever they like into the buf instead of working with
u64
* This means either all code using SIMPLE_ATTRIBUTES must be changed, or
I need to add another wrapper macro that produces suitable get/set
functions from the u64 versions it gets passed.
* Changing all SIMPLE_ATTRIBUTE users is not what I want, cause moving
the csnprintf()/strtoull() calls out of the SIMPLE_ATTRIBUTE code means
it becomes less simple to use it, right?
* The wrapper is actually possible, but it suffers from cases where
somebody passes NULL for a get or set function (which is actually
expected, compare the code in libfs.c) It is possible to hack around
this, but it's ugly.

Then I thought, well, SIMPLE_ATTRIBUTEs are made to work with a set/get
function pair. But debugfs expects a pointer to an actual variable
anyway, so just bypass the SIMPLE_ATTRIBUTE code and make debugfs use
it's own file_operations (most of them shamelessly stolen from the
SIMPLE_ATTRIBUTE code, I admit).

Mattias

