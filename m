Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYFXUG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYFXUG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYFXUGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:06:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41651 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYFXUGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:06:18 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0806241246240.2926@woody.linux-foundation.org>
	(message from Linus Torvalds on Tue, 24 Jun 2008 12:47:27 -0700 (PDT))
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
 <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org> <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org> <E1KBDpg-0002bR-3X@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241216350.2926@woody.linux-foundation.org>
 <E1KBE7p-0002eT-CJ@pomaz-ex.szeredi.hu> <E1KBEA8-0002ey-II@pomaz-ex.szeredi.hu> <E1KBEFY-0002fh-5m@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241246240.2926@woody.linux-foundation.org>
Message-Id: <E1KBEmA-0002m2-EF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Jun 2008 22:06:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Or it can only happen if there was an I/O error on reading the page.
> 
> Now, IO errors are something else. They should have the PG_error bit set, 
> and we should just return EIO or something.

Linus, you're right (as always), but see where this is going?  A rare
problem (splice() returning short count because of an invalidated
page) is becoming an even more rare problem (splice() returning
rubbish instead of an error, if ->readpage() failed, and filesystem
forgot to set PG_error).  And it won't show up in any other paths,
because the generic_file_aio_read() path will just check
PageUptodate(), and return -EIO if not.

OK, maybe we should add a WARN_ON(!PageError()) for the
!PageUptodate() case in generic_file_aio_read(), but that could still
leave some filesystems broken for a long time which experience I/O
errors rarely.

So I think the only sane solution here is to remove
ClearPageUptodate().  But that's a VM people's call, I don't have
enough insight into that.

Miklos
