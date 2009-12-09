Return-Path: <linux-kernel-owner+w=401wt.eu-S967041AbZLIAra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967041AbZLIAra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967034AbZLIAr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:47:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34517 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967004AbZLIAr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:47:28 -0500
Date: Wed, 9 Dec 2009 00:47:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091209004734.GO14381@ZenIV.linux.org.uk>
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com> <4B1D988E.2000305@gmail.com> <20091208015148.GK14381@ZenIV.linux.org.uk> <4B1EEE42.6090202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1EEE42.6090202@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 01:24:34AM +0100, Emese Revfy wrote:

> If constifying the function pointer fields reduces readability,
> what would you say for turning then into typedefs, something like this:
> 
> typedef int (* super_ops_statfs) (struct dentry *, struct kstatfs *);
> struct super_operations {
> ...
> 	const super_ops_statfs statfs;
> ...
> };

Even worse, since one has to go back to typedef to figure out WTF is
going on.
 
> > Moreover, you *still* are not
> > covering the real policy - these suckers should be statically allocated,
> > not just never modified.
> 
> If the super ops are allocated on the stack then they will be overwritten
> during later syscalls and will eventually crash the system on a future
> dereference, that is, this kind of problem manifests during development.
> 
> If the super ops are allocated by kmalloc/etc, then they will have to be
> explicitly initialised by writing to specific fields, my patch would prevent
> that.
> 
> So in the end the programmer is forced to allocate and initialise super ops
> statically.

... unless they go ahead and use memcpy(), etc.

What you really want is
	* no conversions to any other pointer types for pointers to it
and to any aggregate types containing it
	* no conversions from any other pointer types for the same set of
types
	* all objects of that type have static storage duration
	* no lvalues of that type are modifiable

Which is not a job for C compiler.  Yes, (4) means that memcpy() et.al.
give undefined behaviour.  And you get fsck-all satisfaction from knowing
that, since C compiler is not going to warn you about it.  sparse might,
if we teach it to do so.  Preferably - with minimal intrusiveness of
syntax being used.
