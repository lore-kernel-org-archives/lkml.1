Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXKGWEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXKGWEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbXKGWE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:04:28 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52301 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXKGWE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:04:26 -0500
To: hch@infradead.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
	<20071106133559.GA13366@infradead.org>
	<200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp>
	<20071107173039.GA25560@infradead.org>
In-Reply-To: <20071107173039.GA25560@infradead.org>
Message-Id: <200711080704.CHC65673.OOtFJFFSHQVOML@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 8 Nov 2007 07:04:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Hellwig wrote:
> > Isn't security_inode_create() a part of VFS internals?
> It's not.  security_inode_create is part of the LSM infrastructure, and
> the actual methods are part of security modules and definitively not
> VFS internals.
The reason why I want to access namespace_sem inside security_inode_create() is that
it doesn't receive "struct vfsmount" parameter.
If "struct vfsmount" *were* passed to security_inode_create(), 
I have no need to access namespace_sem.

And now, since calling down_read(&namespace_sem) causes deadlock, I'm looking for a solution.
What you said ("I'd start looking for design bugs in whatever code you have using it first.")
sounds "never try to implement pathname based access control at security_inode_create()",
which makes AppArmor (for OpenSuSE 10.1/10.2) and TOMOYO unable to apply access control.

At first, I thought that this lockdep's warning is a false positive,
since "struct inode" is allocated/freed dynamically.
But the warning still appears even after I disabled freeing memory
at destroy_inode() in fs/namei.c (so that address of locking object
in "struct inode" never be reused), it is likely genuine.

Regards.

