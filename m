Return-Path: <linux-kernel-owner+w=401wt.eu-S1751017AbZAENLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbZAENLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZAENLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:11:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51554 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZAENL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:11:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090103184921.GB20166@fieldses.org>
References: <20090103184921.GB20166@fieldses.org> <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com> <20090102164505.GA10465@fieldses.org> 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
Date: Mon, 05 Jan 2009 13:11:01 +0000
Message-ID: <18074.1231161061@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > > > No.  I started bisecting, and it does appear to be a regression from the
> > > > cred patches, but at some point in the middle there it hangs on boot (a
> > > > softlockup report blames a spinlock in set_groups).
> > > 
> > > Do you remember which patch you were at?
> 
> More precisely:
> 	- The last working commit is b6dff3ec... "CRED: Separate task
> 	  security context from task_struct".
> 	- The first commit exhibiting the permissions problem is
> 	  a6f76f2... "CRED: Make execve() take advantage of
> 	  copy-on-write credentials".

I presume by 'first' you mean 'latest'.

> 	- The 9 commits in between (from f1752eec to d84f4f9) result in
> 	  a soft lookup on boot.

I think the problem may be that f1752eec removes the lock initialisation for
init_cred from the INIT_CRED() macro:

	-	.lock			= __SPIN_LOCK_UNLOCKED(p.lock),	\

but doesn't add it to the out of line init_cred:

	+struct cred init_cred = {
	+	.usage			= ATOMIC_INIT(3),
	+	.securebits		= SECUREBITS_DEFAULT,
	+	.cap_inheritable	= CAP_INIT_INH_SET,
	+	.cap_permitted		= CAP_FULL_SET,
	+	.cap_effective		= CAP_INIT_EFF_SET,
	+	.cap_bset		= CAP_INIT_BSET,
	+	.user			= INIT_USER,
	+	.group_info		= &init_groups,
	+};

Can you try adding:

		.lock			= __SPIN_LOCK_UNLOCKED(init_cred.lock),

to that and also add:

		spin_lock_init(&pcred->lock);

into copy_creds() see if the problem goes away?

I'm a bit surprised that lockdep doesn't bark at this one - I thought it
checked for lock initialisation.

David
