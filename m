Return-Path: <linux-kernel-owner+w=401wt.eu-S1946284AbXBIJ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946284AbXBIJ4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946288AbXBIJ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:56:05 -0500
Received: from twin.jikos.cz ([213.151.79.26]:36864 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946284AbXBIJ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:56:01 -0500
Date: Fri, 9 Feb 2007 10:54:36 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
cc: linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Andrew Morton <akpm@osdl.org>, Zach Brown <zach.brown@oracle.com>,
       suparna@in.ibm.com, Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
Message-ID: <Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz>
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Ananiev, Leonid I wrote:

> Fix "Kernel BUG at fs/aio.c:509". Return EIOCBRETRY but not  EIO if page
> is busy.

I am currently also hunting in this area, and I think there is something 
strange in generic_file_aio_read(). This seems strange:

	for (seg = 0; seg < nr_segs; seg++) {
		read_descriptor_t desc;

		desc.written = 0;
		desc.arg.buf = iov[seg].iov_base;
		desc.count = iov[seg].iov_len;
		if (desc.count == 0)
			continue;
		desc.error = 0;
                        
		do_generic_file_read(filp,ppos,&desc,file_read_actor);
		retval += desc.written;
		if (desc.error) {
			retval = retval ?: desc.error;
			break;
		}
	}

So this code propagates desc.error back to caller _only if_ all of the 
previous segments had desc.written == 0. Which is bogus - we need to 
propagate -EIOCBRETRY as soon as any of the do_generic_file_read() 
returned it, so that the caller is aware of requests being queued.

I think something like this would be appropriate

[PATCH] AIO: handle return value from do_generic_file_read() properly

generic_file_aio_read() doesn't always propagate error return value from 
do_generic_file_read(). Namely handling of -EIOCBRETRY is important, because
aio_run_iocb() relies on this return value being always properly propagated
to it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 8332c77..5ce76ce 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			do_generic_file_read(filp,ppos,&desc,file_read_actor);
 			retval += desc.written;
 			if (desc.error) {
-				retval = retval ?: desc.error;
+				retval = desc.error;
 				break;
 			}
 		}

-- 
Jiri Kosina
