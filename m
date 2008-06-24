Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbYFXMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbYFXMCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYFXMCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:02:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43694 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYFXMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:02:38 -0400
To: johnpol@2ka.mipt.ru
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
In-reply-to: <20080624114654.GA27123@2ka.mipt.ru> (message from Evgeniy
	Polyakov on Tue, 24 Jun 2008 15:46:54 +0400)
Subject: Re: [rfc patch 3/4] splice: remove confirm from pipe_buf_operations
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu> <20080624114654.GA27123@2ka.mipt.ru>
Message-Id: <E1KB7E3-0001Lf-K4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Jun 2008 14:02:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > basically like PageWriteback(), but for read-in.
> > 
> > OK it could be done, possibly at great pain.  But why is it important?
> 
> Maybe not that great if mark all readahead pages as, well, readahead,
> and do the same for readpage (essnetially it is the same).

It isn't that easy.  Readahead (->readpages()) is best effort, and is
allowed to not bring the page uptodate, since it will be retried with
->readpage().  I don't know whether any filesystems actually do that,
but it's allowed nonetheless.

> > What's the use case where it matters that splice-in should not block
> > on the read?
> 
> To be able to transfer what was already read?

That needs the consumer to be non-blocking...

Umm, one more reason why the ->confirm() stuff is currently busted:
pipe_read() will block on such a buffer even if pipe file is marked
O_NONBLOCK.  Fixing that would take a hell of a lot of added
complexity in pipe_poll(), etc...

Miklos
