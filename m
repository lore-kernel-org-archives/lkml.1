Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbYEIL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbYEIL1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYEIL07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:26:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27094 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbYEIL06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:26:58 -0400
Date: Fri, 9 May 2008 13:26:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile  returned 0? can't cope (bisected)
Message-ID: <20080509112651.GR16217@kernel.dk>
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com> <20080507211641.GR16217@kernel.dk> <1210231275.7301.17.camel@charm-linux> <1210306939.7205.9.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210306939.7205.9.camel@charm-linux>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08 2008, Tom Zanussi wrote:
> 
> On Thu, 2008-05-08 at 02:21 -0500, Tom Zanussi wrote:
> > On Wed, 2008-05-07 at 23:16 +0200, Jens Axboe wrote:
> > > On Wed, May 07 2008, Dan Williams wrote:
> > > > Hi Tom, Jens,
> > > > 
> > > > My build system started reporting these error messages recently.
> > > > Reverting commit c3270e577c18b3d0e984c3371493205a4807db9d on top of
> > > > 2.6.26-rc1 gets things working for me again.
> > > 
> > > Irk, that patch did scare me a bit (hence I asked Tom to double check as
> > > wel :-). I'll take a look in the morning, all test boxes are off at this
> > > point in time.
> > > 
> > 
> > I did, and it still looks ok to me, but obviously it's not, so I'll have
> > to do some more digging.
> > 
> > The only thing I can think of right now that might be a possible cause
> > would be in splice_direct_to_actor(), if we had an incomplete transfer,
> > the sd->pos returned and assigned would have the value set by the failed
> > actor().  Maybe something like the following would take care of that
> > case, but I haven't had a chance to test it yet - will do that tomorrow
> > night...
> > 
> 
> Looks like I was on the right track - can you try this patch out
> instead?  It makes sure sd.pos is updated correctly if the transfer was
> incomplete or failed.  I ran some kernel compiles using distcc while
> running blktrace in sendfile mode and didn't see any problems with
> either.

Dan, can I talk you into re-trying current git with this patch applied?
It's basically the (now) reverted broken bits plus the fix from Tom from
this email.

diff --git a/fs/splice.c b/fs/splice.c
index 7815003..a048ad2 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -983,7 +983,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 	while (len) {
 		size_t read_len;
-		loff_t pos = sd->pos;
+		loff_t pos = sd->pos, prev_pos = pos;
 
 		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
@@ -998,15 +998,19 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		 * could get stuck data in the internal pipe:
 		 */
 		ret = actor(pipe, sd);
-		if (unlikely(ret <= 0))
+		if (unlikely(ret <= 0)) {
+			sd->pos = prev_pos;
 			goto out_release;
+		}
 
 		bytes += ret;
 		len -= ret;
 		sd->pos = pos;
 
-		if (ret < read_len)
+		if (ret < read_len) {
+			sd->pos = prev_pos + ret;
 			goto out_release;
+		}
 	}
 
 done:
@@ -1072,7 +1076,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
 	if (ret > 0)
-		*ppos += ret;
+		*ppos = sd.pos;
 
 	return ret;
 }
diff --git a/kernel/relay.c b/kernel/relay.c
index bc24dcd..7de644c 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1191,7 +1191,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 	ret = 0;
 	spliced = 0;
 
-	while (len) {
+	while (len && !spliced) {
 		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
 		if (ret < 0)
 			break;

-- 
Jens Axboe

