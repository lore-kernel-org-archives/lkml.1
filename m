Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbXIZIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbXIZIld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXIZIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:41:25 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:43451 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXIZIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:41:25 -0400
To: haveblue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <1190769669.26982.325.camel@localhost> (message from Dave Hansen
	on Tue, 25 Sep 2007 18:21:09 -0700)
Subject: Re: missing mnt_drop_write() on open error
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu> <1190769669.26982.325.camel@localhost>
Message-Id: <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 10:38:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-09-26 at 01:14 +0200, Miklos Szeredi wrote:
> > I get this at umount, if there was a failed open():
> > 
> > WARNING: at fs/namespace.c:586 __mntput()
> > 
> > I think the problem is that may_open() calls mnt_want_write(), but if
> > open doesn't succeed, mnt_drop_write() will not be called.
> 
> Does this help?

It didn't fix it for me, but the patch looks OK.

In __dentry_open() there's still a few places where fput() won't be
called, notably when ->open fails, which is what I'm triggering I
think.

Also even more horrible things can happen because of the
nd->intent.open.file thing.  For example if the lookup routine calls
lookup_instantiate_filp(), and after this, but before may_open() some
error happens, then release_open_intent() will call fput() on the
file, which will cause mnt_drop_write() to be called, even though a
matching mnt_want_write() hasn't yet been called.  Ugly, eh?

> I'm also thinking that we should change the open_namei*
> functions to simply return 'struct file *'.  Those are the only users
> other than NFS, and forcing the return of a file like that will force
> users to do the fput() on it if they don't want it any more.  We'd just
> need to make sure no new may_open() users pop up.  Any thoughts on that?

Yeah, something needs to be done with open, because currently it's way
too convoluted.

Miklos
