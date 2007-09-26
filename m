Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbXIZRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbXIZRxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXIZRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:53:04 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48108 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXIZRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:53:01 -0400
To: haveblue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-reply-to: <1190823545.30530.19.camel@localhost> (message from Dave Hansen
	on Wed, 26 Sep 2007 09:19:05 -0700)
Subject: Re: missing mnt_drop_write() on open error
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
	 <1190769669.26982.325.camel@localhost>
	 <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu> <1190823545.30530.19.camel@localhost>
Message-Id: <E1Iab1W-0005Ye-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 19:50:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-09-26 at 10:38 +0200, Miklos Szeredi wrote:
> > In __dentry_open() there's still a few places where fput() won't be
> > called, notably when ->open fails, which is what I'm triggering I
> > think.
> > 
> > Also even more horrible things can happen because of the
> > nd->intent.open.file thing.  For example if the lookup routine calls
> > lookup_instantiate_filp(), and after this, but before may_open() some
> > error happens, then release_open_intent() will call fput() on the
> > file, which will cause mnt_drop_write() to be called, even though a
> > matching mnt_want_write() hasn't yet been called.  Ugly, eh? 
> 
> I'm not sure it is _that_ horrible. ;)
> 
> Do you see any reason we can't just shadow the
> get/put_write_access(inode) calls with mnt_want/drop_write() calls?  I
> think they're always matched.

Maybe.  Can we do the mnt_want_write() from __dentry_open(), instead
of may_open()?  That would be a lot cleaner.

Btw, may_open() doesn't do mnt_want_write() around the truncation if
file is opened with O_TRUNC | O_RDONLY.

Miklos
