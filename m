Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYDWHJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYDWHJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYDWHIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:08:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14254 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYDWHIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:08:53 -0400
Date: Wed, 23 Apr 2008 09:08:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Tom Zanussi <zanussi@comcast.net>, linux-btrace@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       wilder@us.ibm.com
Subject: Re: blktrace/relay/s390: Oops in subbuf_splice_actor
Message-ID: <20080423070850.GV12774@kernel.dk>
References: <20080314084337.GA9436@schmichrtp.de.ibm.com> <20080314115802.GK17940@kernel.dk> <20080314130552.GA9352@schmichrtp.de.ibm.com> <20080314131007.GQ17940@kernel.dk> <20080314132238.GA9815@schmichrtp.de.ibm.com> <1207628587.7535.8.camel@charm-linux> <20080423070605.GA5450@schmichrtp.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423070605.GA5450@schmichrtp.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Christof Schmitt wrote:
> On Mon, Apr 07, 2008 at 11:23:07PM -0500, Tom Zanussi wrote:
> > > Dave, can you have a look at this? I can easily reproduce the problem
> > > on s390 Linux for testing and getting more debug information.
> > > 
> > 
> > Not sure anyone's still looking into this, but it doesn't look like an
> > s390 problem specifically.  Apparently what happened was that some
> > internal changes to splice seem to have broken the relay splice_read
> > implementation.  The above patch fixes part of the problem; the patch
> > below should fix the rest, and AFAICT it doesn't break anything else.
> > 
> > Signed-off-by: Tom Zanussi <zanussi@comcast.net>
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index a861bb3..068b210 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -1094,7 +1094,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
> > 
> >  	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
> >  	if (ret > 0)
> > -		*ppos += ret;
> > +		*ppos = sd.pos;
> > 
> >  	return ret;
> >  }
> > diff --git a/kernel/relay.c b/kernel/relay.c
> > index d6204a4..dc873fb 100644
> > --- a/kernel/relay.c
> > +++ b/kernel/relay.c
> > @@ -1162,7 +1162,7 @@ static ssize_t relay_file_splice_read(struct file *in,
> >  	ret = 0;
> >  	spliced = 0;
> > 
> > -	while (len) {
> > +	while (len && !spliced) {
> >  		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
> >  		if (ret < 0)
> >  			break;
> > 
> > 
> 
> Sorry for the late response and yes, our tests on s390 are still
> tracking the issue. I just ran a short test on 2.6.25 with the above
> patch applied. With this patch, blktrace client/server mode works
> again with the sendfile() call and returns valid data for blkparse.
> 
> Thanks everybody for helping with this problem.
> 
> Jens, will you pick up this patch for inclusion?

Certainly, thanks to Tom for providing this and you for testing!

-- 
Jens Axboe

