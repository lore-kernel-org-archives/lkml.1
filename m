Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYLCEaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYLCEaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYLCE34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:29:56 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59106 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbYLCE3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:29:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=h32T_KcqPdoA:10 a=RjYI-TDzwGgA:10
 a=VPW9pYw8AAAA:8 a=93oYQrhTFvutN2OXX0EA:9 a=3IgP5UJl2oegXXm12Ml9uHMJNMYA:4
 a=H08WjgAdDpYA:10 a=MSl-tDqOz04A:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH] relay: When unsigned ret cannot store a negative value
From: Tom Zanussi <zanussi@comcast.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roel kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org,
       Tom Zanussi <zanussi@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20081202141042.3e0db395.akpm@linux-foundation.org>
References: <493161DE.6000703@gmail.com>
	 <20081202141042.3e0db395.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 22:29:51 -0600
Message-Id: <1228278591.10702.5.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 14:10 -0800, Andrew Morton wrote:
> On Sat, 29 Nov 2008 10:38:06 -0500
> roel kluin <roel.kluin@gmail.com> wrote:
> 
> > When unsigned ret cannot store a negative value
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > UNTESTED! is this the way to go?
> > 
> > diff --git a/kernel/relay.c b/kernel/relay.c
> > index 32b0bef..c9d62e5 100644
> > --- a/kernel/relay.c
> > +++ b/kernel/relay.c
> > @@ -1220,7 +1220,8 @@ static int subbuf_splice_actor(struct file *in,
> >  			       unsigned int flags,
> >  			       int *nonpad_ret)
> >  {
> > -	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> > +	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
> > +	ssize_t ret;
> >  	struct rchan_buf *rbuf = in->private_data;
> >  	unsigned int subbuf_size = rbuf->chan->subbuf_size;
> >  	uint64_t pos = (uint64_t) *ppos;
> > @@ -1289,7 +1290,8 @@ static int subbuf_splice_actor(struct file *in,
> >  	if (!spd.nr_pages)
> >  		return 0;
> >  
> > -	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
> > +	ret = splice_to_pipe(pipe, &spd);
> > +	*nonpad_ret = ret;
> >  	if (ret < 0 || ret < total_len)
> >  		return ret;
> >  
> 
> Yeah, this code needs help.  subbuf_splice_actor() returns `int', but
> carefully calculates and returns an unsigned type.
> 
> I suspect that quite a bit of code in there (including
> relay_file_splice_read()) should be gone through and have its choice of
> types reviewed and fixed.  Probably by converting things to ssize_t.
> 
> 

And maybe generic_file_splice_read() too, from whence it came.  Speaking
of which, is there some reason why this patch:

http://lkml.indiana.edu/hypermail/linux/kernel/0810.3/0094.html

never got picked up?


