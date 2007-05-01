Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXEACOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXEACOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXEACOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:14:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:55205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXEACOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:14:39 -0400
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>
Date: Tue, 1 May 2007 12:14:11 +1000
Message-ID: <17974.41587.666167.650575@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH] RPC: add wrapper for svc_reserve to account for
	checksum
In-Reply-To: message from Jeff Layton on Saturday April 21
References: <20070421131523.GA18100@dantu.rdu.redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday April 21, jlayton@redhat.com wrote:
> When the kernel calls svc_reserve to downsize the expected size of an RPC
> reply, it fails to account for the possibility of a checksum at the end of
> the packet. If a client mounts a NFSv2/3 with sec=krb5i/p, and does I/O then
> you'll generally see messages similar to this in the server's ring buffer:
> 
> RPC request reserved 164 but used 208
> 
> While I was never able to verify it, I suspect that this problem is also the
> root cause of some oopses I've seen under these conditions:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227726

I don't think to two are that closely related.
The space reservation mentioned in the "RPC request reserved ..."
messages is a fairly soft reservation.  We try to make sure the
network stack reserves a certain amount of space, then try never to
start processing a request unless we will be able to reply without
exceeding that allocation.
If we get it wrong and do exceed the allocation, the worst that might
happen is that we might block while writing the reply and maybe have
to close a connection, or send out an incomplete packet, or something
like that.  Certainly not an oops.

The extra space needed at the end of the message of integrity
information which we weren't accounting for properly does seemed to be
accounted correctly in svcauth_gss_wrap_resp_integ (I'm less sure of
_wrp_resp_priv, but it is probably right).

Of the two Oops in that BUG, the first seems to be the
		BUG_ON(resbuf->tail[0].iov_len);
in svcauth_gss_wrap_resp_integ (assuming code in 2.6.9-44.ELxenU is at
least vaguely similar to current -mm).

I don't think this BUG_ON is correct.  If a readdir finds zero entries,
then will be some trailer information in the 'tail', but page_len will
be 0.  I think the following patch is correct and could fix that.
Bruce:  does it look OK to you?


The second oops is harder to interpret.
I looks like tcp_send_page is getting a NULL page, though it could be
getting a length > PAGE_SIZE which might have the same effect.

It reminds me of
  http://bugzilla.kernel.org/show_bug.cgi?id=7795
but I'm not convinced it is the same.

> 
> Unfortunately, there doesn't seem to be a good way to reliably determine the
> expected checksum length prior to actually calculating it, particularly with
> schemes like spkm3.

Yes, that asn1 encoding does seem rather awkward.

Maybe we should just use RPC_MAX_AUTH_SIZE like other bits of GSS code
does.  There is no great cost in reserving too much space - it just
might slow things down a little when tight on memory.
What would you think of submitting an incremental patch which replaces
the "56" with "RPC_MAX_AUTH_SIZE" ?

Thanks (and sorry for the delay).
NeilBrown

--
Simplify (and fix) adding of integrity data to end of rpc message

There is no value in a special case for adding integ data to the
'head' part of the reply in the case where there is no body.
Always put it in the 'tail', placing that after the current head if it
doesn't have a place yet.
As readdir can potentially return an empty body and a non-empty tail,
the BUG_ON can fire.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/auth_gss/svcauth_gss.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-05-01 11:42:31.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-05-01 11:42:55.000000000 +1000
@@ -1210,13 +1210,7 @@ svcauth_gss_wrap_resp_integ(struct svc_r
 	if (xdr_buf_subsegment(resbuf, &integ_buf, integ_offset,
 				integ_len))
 		BUG();
-	if (resbuf->page_len == 0
-			&& resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE
-			< PAGE_SIZE) {
-		BUG_ON(resbuf->tail[0].iov_len);
-		/* Use head for everything */
-		resv = &resbuf->head[0];
-	} else if (resbuf->tail[0].iov_base == NULL) {
+	if (resbuf->tail[0].iov_base == NULL) {
 		if (resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE > PAGE_SIZE)
 			goto out_err;
 		resbuf->tail[0].iov_base = resbuf->head[0].iov_base
