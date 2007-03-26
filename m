Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXCZVnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXCZVnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXCZVnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:43:33 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:33784 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXCZVnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:43:32 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20070326140036.f3352f81.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 14:00:36 -0700)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu> <20070326140036.f3352f81.akpm@linux-foundation.org>
Message-Id: <E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Mar 2007 23:43:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch makes writing to shared memory mappings update st_ctime and
> > st_mtime as defined by SUSv3:
> 
> Boy this is complicated.

You tell me?

> Is there a simpler way of doing all this?  Say, we define a new page flag
> PG_dirtiedbywrite and we do SetPageDirtiedByWrite() inside write() and
> ClearPageDirtiedByWrite() whenever we propagate pte-dirtiness into
> page-dirtiness.  Then, when performing writeback we look to see if any of
> the dirty pages are !PageDirtiedByWrite() and, if so, we update [mc]time to
> current-time.

I don't think a page flag gains anything over the address_space flag
that this patch already has.

The complexity is not about keeping track of the "data modified
through mmap" state, but about msync() guarantees, that POSIX wants.

And these requirements do in fact make some sense: msync() basically
means:

  "I want the data written through mmaps to be visible to the world"

And that obviously includes updating the timestamps.

So how do we know if the data was modified between two msync()
invocations?  The only sane way I can think of is to walk the page
tables in msync() and test/clear the pte dirty bit.

Yes, this will make msync(MS_ASYNC) more heavyweight again.  But if an
application doesn't want to update the timestamps, it should just omit
this call, since it does nothing else.

There shouldn't be any other side effect.

Miklos
