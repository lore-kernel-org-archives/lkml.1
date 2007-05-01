Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbXEARLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbXEARLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEARLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:11:35 -0400
Received: from ms-smtp-05.southeast.rr.com ([24.25.9.104]:37059 "EHLO
	ms-smtp-05.southeast.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXEARLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:11:34 -0400
Date: Tue, 1 May 2007 13:11:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: [NFS] [PATCH] RPC: add wrapper for svc_reserve to account for
	checksum
Message-ID: <20070501171121.GC15222@salusa.poochiereds.net>
References: <20070421131523.GA18100@dantu.rdu.redhat.com> <17974.41587.666167.650575@notabene.brown> <20070501170123.GB15222@salusa.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501170123.GB15222@salusa.poochiereds.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 01:01:27PM -0400, Jeff Layton wrote:
> On Tue, May 01, 2007 at 12:14:11PM +1000, Neil Brown wrote:
> > 
> > Yes, that asn1 encoding does seem rather awkward.
> > 
> > Maybe we should just use RPC_MAX_AUTH_SIZE like other bits of GSS code
> > does.  There is no great cost in reserving too much space - it just
> > might slow things down a little when tight on memory.
> > What would you think of submitting an incremental patch which replaces
> > the "56" with "RPC_MAX_AUTH_SIZE" ?
> > 
> > Thanks (and sorry for the delay).
> > NeilBrown
> > 
> 
> Thanks for looking into this, Neil. I wasn't sure how hard a reservation that
> was (still working on wrapping my brain around the RPC code). I'll have a look
> at the patch you posted. Hopefully that is the problem...
> 
> As far as your suggestion to use RPC_MAX_AUTH_SIZE, that sounds like a good
> idea to me. I'm all for avoiding "magic" numbers. How does this look? I also
> cleaned up the comments as well.
> 

Resending patch with a proper signed-off-by line. Also cc'ing Andrew:

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 9114f11..ed7cbf1 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -399,10 +399,9 @@ char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
 /*
  * When we want to reduce the size of the reserved space in the response
  * buffer, we need to take into account the size of any checksum data that
- * may be at the end of the packet. For now, just use a hardcoded value
- * for each possible authflavor. This will need to be updated when new
- * encryption types or algorithms are added, or we'll have to come up with
- * a way to reasonably calculate this on the fly (maybe via a new auth_op).
+ * may be at the end of the packet. This is difficult to determine exactly
+ * for all cases without actually generating the checksum, so we just use a
+ * static value.
  */
 static inline void 
 svc_reserve_auth(struct svc_rqst *rqstp, int space)
@@ -411,7 +410,7 @@ svc_reserve_auth(struct svc_rqst *rqstp, int space)
 
 	switch(rqstp->rq_authop->flavour) {
 		case RPC_AUTH_GSS:
-			added_space = 56; /* determined empirically */
+			added_space = RPC_MAX_AUTH_SIZE;
 	}
 	return svc_reserve(rqstp, space + added_space);
 }
