Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZFHRuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZFHRuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbZFHRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:50:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZFHRuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:50:22 -0400
Date: Mon, 8 Jun 2009 18:50:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
Message-ID: <20090608175018.GM8633@ZenIV.linux.org.uk>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu> <20090608162913.GL8633@ZenIV.linux.org.uk> <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 06:44:41PM +0200, Miklos Szeredi wrote:

> I'm still not getting what the problem is.  AFAICS file operations are
> either
> 
>  a) non-interruptible but finish within a short time or
>  b) may block indefinitely but are interruptible (or at least killable).
> 
> Anything else is already problematic, resulting in processes "stuck in
> D state".

Welcome to reality...

* bread() is non-interruptible
* so's copy_from_user()/copy_to_user()
* IO we are stuck upon _might_ be interruptible, but by sending a signal
to some other process

... just for starters.  If you sign up for auditing the tree to eliminate
"something's stuck in D state", you are welcome to it.  Mind you, you'll
have to audit filesystems for "doesn't check if metadata IO has failed"
first, but that _really_ needs to be done anyway.  On the ongoing basis.

Drivers, of course, are even more interesting - looking through foo_ioctl()
instances is a wonderful way to lower pH in stomach, but that's on the
"we want revoke()" side of it.
