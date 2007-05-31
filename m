Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbXEaRGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbXEaRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXEaRGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:06:38 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46291 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXEaRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:06:37 -0400
Date: Thu, 31 May 2007 18:06:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, cotte@de.ibm.com, neilb@suse.de,
       zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
In-Reply-To: <20070531103316.GO32105@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705311750180.12688@blonde.wat.veritas.com>
References: <20070531103316.GO32105@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAemFudXNzaUB1cy5pYm0uY29tAG5laWxiQHN1c2UuZGUAdG9ydmFsZHNAb3NkbC5vcmcAamVucy5heGJvZUBvcmFjbGUuY29tAGhjaEBpbmZyYWRlYWQub3JnAGNvdHRlQGRlLmlibS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Jens Axboe wrote:
> 
> This patch removes the ->sendfile() hook from the file_operations
> structure, and replaces the sys_sendfile() mechanism to be based on
> ->splice_read() instead. There should be no functional changes.
> 
> Work to be done:
> 
> - The ext2 xip support needs a splice_read() implementation, currently I
>   just if 0'ed out the send xip_file_sendfile(). CC'ed Carsten, who
>   seems to be the author of this code.
> 
> - shmem needs a splice_read() implementation. Optimistically CC'ed Hugh.

I'll take that "Optimistically" as a special compliment,
rather than as a particular insult ;)

Yes, thanks, please leave shmem_file_splice_read() to me, I'll give
it priority now.  Not deep enough in yet, but I'll probably aim for
something simple-minded (correct but slow once it hits swap).

> 
> - nfds: The ->rq_sendfile_ok optimization is gone for now. I can't
>   determine the value of it, but I'm assuming it's there for a reason.
>   Any chance this can be converted to splice, or use something else than
>   ->sendfile()? CC'ed Neil.
> 
> - relay: needs a splice_read() implementation. I think Tom already has
>   one, CC'ed him.
> 
> Apart from that, it was mostly straight forward. Almost everybody uses
> generic_file_sendfile(), which makes the conversion easy. I changed loop
> to use do_generic_file_read() instead of sendfile, it works for me...

Christoph already picked up on that, and it's of interest to shmem too:
loop over tmpfs in 2.6 was relying on shmem_file_sendfile, for which
the generic route is not good enough.

If we're giving a .splice_read to everything which used to have a
.sendfile, then I think you just need to make do_lo_read() use
->splice_read now?

Hugh
