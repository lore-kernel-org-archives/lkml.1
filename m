Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYLCEhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYLCEhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYLCEhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:37:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYLCEho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:37:44 -0500
Date: Tue, 2 Dec 2008 20:37:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tom Zanussi <zanussi@comcast.net>
Cc: roel kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org,
       Tom Zanussi <zanussi@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] relay: When unsigned ret cannot store a negative value
Message-Id: <20081202203734.1e4c9835.akpm@linux-foundation.org>
In-Reply-To: <1228278591.10702.5.camel@charm-linux>
References: <493161DE.6000703@gmail.com>
	<20081202141042.3e0db395.akpm@linux-foundation.org>
	<1228278591.10702.5.camel@charm-linux>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 22:29:51 -0600 Tom Zanussi <zanussi@comcast.net> wrote:

> 
> On Tue, 2008-12-02 at 14:10 -0800, Andrew Morton wrote:
> > On Sat, 29 Nov 2008 10:38:06 -0500
> > roel kluin <roel.kluin@gmail.com> wrote:
> > 
> > > When unsigned ret cannot store a negative value
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > ---
> > > UNTESTED! is this the way to go?
> > > 
> > > diff --git a/kernel/relay.c b/kernel/relay.c
> > > index 32b0bef..c9d62e5 100644
> > > --- a/kernel/relay.c
> > > +++ b/kernel/relay.c
> > > @@ -1220,7 +1220,8 @@ static int subbuf_splice_actor(struct file *in,
> > >  			       unsigned int flags,
> > >  			       int *nonpad_ret)
> > >  {
> > > -	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> > > +	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
> > > +	ssize_t ret;
> > >  	struct rchan_buf *rbuf = in->private_data;
> > >  	unsigned int subbuf_size = rbuf->chan->subbuf_size;
> > >  	uint64_t pos = (uint64_t) *ppos;
> > > @@ -1289,7 +1290,8 @@ static int subbuf_splice_actor(struct file *in,
> > >  	if (!spd.nr_pages)
> > >  		return 0;
> > >  
> > > -	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
> > > +	ret = splice_to_pipe(pipe, &spd);
> > > +	*nonpad_ret = ret;
> > >  	if (ret < 0 || ret < total_len)
> > >  		return ret;
> > >  
> > 
> > Yeah, this code needs help.  subbuf_splice_actor() returns `int', but
> > carefully calculates and returns an unsigned type.
> > 
> > I suspect that quite a bit of code in there (including
> > relay_file_splice_read()) should be gone through and have its choice of
> > types reviewed and fixed.  Probably by converting things to ssize_t.
> > 
> > 
> 
> And maybe generic_file_splice_read() too, from whence it came.

sure.

>  Speaking
> of which, is there some reason why this patch:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0810.3/0094.html
> 
> never got picked up?
> 

Incompetence I guess.

Damn man, that's your third email address :(
