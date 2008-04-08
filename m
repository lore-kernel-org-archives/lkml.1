Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbYDHEhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbYDHEhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYDHEhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:37:39 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:48087 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYDHEhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:37:38 -0400
X-Authority-Analysis: v=1.0 c=1 a=U9g90OMrTUoA:10 a=Vv2eyNxEwo0A:10
 a=FP58Ms26AAAA:8 a=cNrkCtsKjNPWfGvT8DUA:9 a=LOrqZWpjvEz0vtiv3StQp5d-bVEA:4
 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: blktrace/relay/s390: Oops in subbuf_splice_actor
From: Tom Zanussi <zanussi@comcast.net>
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrace@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       wilder@us.ibm.com
In-Reply-To: <20080314132238.GA9815@schmichrtp.de.ibm.com>
References: <20080314084337.GA9436@schmichrtp.de.ibm.com>
	 <20080314115802.GK17940@kernel.dk>
	 <20080314130552.GA9352@schmichrtp.de.ibm.com>
	 <20080314131007.GQ17940@kernel.dk>
	 <20080314132238.GA9815@schmichrtp.de.ibm.com>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 23:23:07 -0500
Message-Id: <1207628587.7535.8.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 14:22 +0100, Christof Schmitt wrote:
> plain text document attachment (Re: blktrace/relay/s390: Oops in
> subbuf_splice_actor.eml)
> On Fri, Mar 14, 2008 at 02:10:07PM +0100, Jens Axboe wrote:
> > On Fri, Mar 14 2008, Christof Schmitt wrote:
> > > On Fri, Mar 14, 2008 at 12:58:03PM +0100, Jens Axboe wrote:
> > > > That is indeed a bug, does this work for you?
> > > > 
> > > > diff --git a/kernel/relay.c b/kernel/relay.c
> > > > index d080b9d..39d1fa8 100644
> > > > --- a/kernel/relay.c
> > > > +++ b/kernel/relay.c
> > > > @@ -1066,7 +1066,7 @@ static int subbuf_splice_actor(struct file *in,
> > > >  			       unsigned int flags,
> > > >  			       int *nonpad_ret)
> > > >  {
> > > > -	unsigned int pidx, poff, total_len, subbuf_pages, ret;
> > > > +	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> > > >  	struct rchan_buf *rbuf = in->private_data;
> > > >  	unsigned int subbuf_size = rbuf->chan->subbuf_size;
> > > >  	uint64_t pos = (uint64_t) *ppos;
> > > > @@ -1098,7 +1098,9 @@ static int subbuf_splice_actor(struct file *in,
> > > >  	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
> > > >  	poff = read_start & ~PAGE_MASK;
> > > > 
> > > > -	for (total_len = 0; spd.nr_pages < subbuf_pages; spd.nr_pages++) {
> > > > +	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
> > > > +
> > > > +	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
> > > >  		unsigned int this_len, this_end, private;
> > > >  		unsigned int cur_pos = read_start + total_len;
> > > 
> > > With the patch, i can run dd and 'blktrace -h traceserver' without the
> > > oops. But the output from blktrace only contains only zeros and no
> > > usable data for blkparse. Using blktrace to write the data directly to
> > > disk, without using the blktrace server works. Is there anything i
> > > should look for to help debugging the problem?
> > 
> > We should probably get Tom in the loop, as he is the relay expert. I'll
> > make sure the above patch gets into 2.6.25, as it is definitely a bug
> > that needs fixing.
> 
> http://relayfs.sourceforge.net/contact.html mentions Tom Zanussi, but
> his email address seems to be no longer valid. I copy Dave Wilder
> here, since he is mentioned as relay maintainer on the web page.
> 

Hi,

Yeah, I no longer work for IBM - I need to update the relayfs site to
reflect that.

> Dave, can you have a look at this? I can easily reproduce the problem
> on s390 Linux for testing and getting more debug information.
> 

Not sure anyone's still looking into this, but it doesn't look like an
s390 problem specifically.  Apparently what happened was that some
internal changes to splice seem to have broken the relay splice_read
implementation.  The above patch fixes part of the problem; the patch
below should fix the rest, and AFAICT it doesn't break anything else.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>

diff --git a/fs/splice.c b/fs/splice.c
index a861bb3..068b210 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1094,7 +1094,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
 	if (ret > 0)
-		*ppos += ret;
+		*ppos = sd.pos;
 
 	return ret;
 }
diff --git a/kernel/relay.c b/kernel/relay.c
index d6204a4..dc873fb 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1162,7 +1162,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 	ret = 0;
 	spliced = 0;
 
-	while (len) {
+	while (len && !spliced) {
 		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
 		if (ret < 0)
 			break;



