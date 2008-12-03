Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbYLCFT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbYLCFT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYLCFTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:19:18 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39458 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYLCFTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QNkPlIK2v5DV0kw7yjpnTHb8sv+XrdfnVeWpuUbAlattCiOwTQnSWqbPJppnFACBvL
         plSguvZi8PrhB6iU6lpyLHp61dMgB0u/JAiGqGKtjHZkxIV3V48ozA14kQYN0PCkzKlq
         ioc9ptmfV5FYQGt+xJ8tFLeRPvAwNFnqwHlLI=
Subject: Re: [PATCH] relay: When unsigned ret cannot store a negative value
From: Tom Zanussi <tzanussi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roel kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20081202203734.1e4c9835.akpm@linux-foundation.org>
References: <493161DE.6000703@gmail.com>
	 <20081202141042.3e0db395.akpm@linux-foundation.org>
	 <1228278591.10702.5.camel@charm-linux>
	 <20081202203734.1e4c9835.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 23:19:14 -0600
Message-Id: <1228281554.10858.13.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 20:37 -0800, Andrew Morton wrote:
> On Tue, 02 Dec 2008 22:29:51 -0600 Tom Zanussi <zanussi@comcast.net> wrote:
> 
> > 
> > On Tue, 2008-12-02 at 14:10 -0800, Andrew Morton wrote:
> > > On Sat, 29 Nov 2008 10:38:06 -0500
> > > roel kluin <roel.kluin@gmail.com> wrote:
> > > 
> > > > When unsigned ret cannot store a negative value
> > > > 
> > > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > > ---
> > > > UNTESTED! is this the way to go?
> > > > 
> > > > diff --git a/kernel/relay.c b/kernel/relay.c
> > > > index 32b0bef..c9d62e5 100644
> > > > --- a/kernel/relay.c
> > > > +++ b/kernel/relay.c
> > > > @@ -1220,7 +1220,8 @@ static int subbuf_splice_actor(struct file *in,
> > > >  			       unsigned int flags,
> > > >  			       int *nonpad_ret)
> > > >  {
> > > > -	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
> > > > +	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
> > > > +	ssize_t ret;
> > > >  	struct rchan_buf *rbuf = in->private_data;
> > > >  	unsigned int subbuf_size = rbuf->chan->subbuf_size;
> > > >  	uint64_t pos = (uint64_t) *ppos;
> > > > @@ -1289,7 +1290,8 @@ static int subbuf_splice_actor(struct file *in,
> > > >  	if (!spd.nr_pages)
> > > >  		return 0;
> > > >  
> > > > -	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
> > > > +	ret = splice_to_pipe(pipe, &spd);
> > > > +	*nonpad_ret = ret;
> > > >  	if (ret < 0 || ret < total_len)
> > > >  		return ret;
> > > >  
> > > 
> > > Yeah, this code needs help.  subbuf_splice_actor() returns `int', but
> > > carefully calculates and returns an unsigned type.
> > > 
> > > I suspect that quite a bit of code in there (including
> > > relay_file_splice_read()) should be gone through and have its choice of
> > > types reviewed and fixed.  Probably by converting things to ssize_t.
> > > 
> > > 
> > 
> > And maybe generic_file_splice_read() too, from whence it came.
> 
> sure.
> 
> >  Speaking
> > of which, is there some reason why this patch:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0810.3/0094.html
> > 
> > never got picked up?
> > 
> 
> Incompetence I guess.

No problem, thanks for finally picking it up. :-)

> 
> Damn man, that's your third email address :(

Yeah, the purpose of the gmail address is to avoid that but I forget to
use it - will try to be less careless in the future. ;-)

