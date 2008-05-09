Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYEIEWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYEIEWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYEIEWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:22:23 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:42986 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495AbYEIEWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:22:22 -0400
X-Authority-Analysis: v=1.0 c=1 a=frr7tnlS5JwA:10 a=j7aJu_usDzAA:10
 a=wgyEEsrxFksT-jrwEgkA:9 a=g00he5odUrcubmscmg8A:7
 a=eGl_QAfsSdjw-M8R3OpUyJRWEZsA:4 a=WuK_CZDBSqoA:10
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile
	returned 0? can't cope (bisected)
From: Tom Zanussi <zanussi@comcast.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1210231275.7301.17.camel@charm-linux>
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
	 <20080507211641.GR16217@kernel.dk>  <1210231275.7301.17.camel@charm-linux>
Content-Type: text/plain
Date: Thu, 08 May 2008 23:22:19 -0500
Message-Id: <1210306939.7205.9.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 02:21 -0500, Tom Zanussi wrote:
> On Wed, 2008-05-07 at 23:16 +0200, Jens Axboe wrote:
> > On Wed, May 07 2008, Dan Williams wrote:
> > > Hi Tom, Jens,
> > > 
> > > My build system started reporting these error messages recently.
> > > Reverting commit c3270e577c18b3d0e984c3371493205a4807db9d on top of
> > > 2.6.26-rc1 gets things working for me again.
> > 
> > Irk, that patch did scare me a bit (hence I asked Tom to double check as
> > wel :-). I'll take a look in the morning, all test boxes are off at this
> > point in time.
> > 
> 
> I did, and it still looks ok to me, but obviously it's not, so I'll have
> to do some more digging.
> 
> The only thing I can think of right now that might be a possible cause
> would be in splice_direct_to_actor(), if we had an incomplete transfer,
> the sd->pos returned and assigned would have the value set by the failed
> actor().  Maybe something like the following would take care of that
> case, but I haven't had a chance to test it yet - will do that tomorrow
> night...
> 

Looks like I was on the right track - can you try this patch out
instead?  It makes sure sd.pos is updated correctly if the transfer was
incomplete or failed.  I ran some kernel compiles using distcc while
running blktrace in sendfile mode and didn't see any problems with
either.

Tom

diff --git a/fs/splice.c b/fs/splice.c
index 633f58e..3bd95a7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -986,7 +986,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 	while (len) {
 		size_t read_len;
-		loff_t pos = sd->pos;
+		loff_t pos = sd->pos, prev_pos = pos;
 
 		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
@@ -1001,15 +1001,19 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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


