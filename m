Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYIXD6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYIXD6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIXD5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:57:55 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:45906 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYIXD5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:57:55 -0400
X-Authority-Analysis: v=1.0 c=1 a=HUNA_2dSPb8A:10 a=2YXWcbh8Xt0A:10
 a=kjXLa7uhHNlVxMKT-qYA:9 a=kJWxOwU5GWSKRrOWIAIA:7
 a=-pQPfw6jHAXerf6bx7zr5AuVHBQA:4 a=si9q_4b84H0A:10 a=MSl-tDqOz04A:10
 a=XF7b4UCPwd8A:10
Subject: Re: [PATCH 3/3] relay - add channel flags
From: Tom Zanussi <zanussi@comcast.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, prasad@linux.vnet.ibm.com, mbligh@google.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, compudj@krystal.dyndns.org, rostedt@goodmis.org,
       od@novell.com, fche@redhat.com, hch@lst.de, dwilder@us.ibm.com
In-Reply-To: <20080923132053.eb2cf871.akpm@linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147676.6875.138.camel@charm-linux>
	 <20080923132053.eb2cf871.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 22:57:50 -0500
Message-Id: <1222228670.7761.9.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments on these patches - I'll include the changes in
the next go-round.

On Tue, 2008-09-23 at 13:20 -0700, Andrew Morton wrote:
> On Tue, 23 Sep 2008 00:27:56 -0500
> Tom Zanussi <zanussi@comcast.net> wrote:
> 
> > Add channel flags to relay, remove global callback param.
> >     
> > relay should probably have had a flags param from the beginning; it
> > wasn't originally added because it wasn't originally needed - it
> > probably would have helped avoid some of the callback contortions
> > that were added due to a lack of flags.  This adds them and does a
> > small amount of low-hanging cleanup, and is also in preparation for
> > some new flags in future patches.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> > diff --git a/block/blktrace.c b/block/blktrace.c
> > index eb9651c..150c5f7 100644
> > --- a/block/blktrace.c
> > +++ b/block/blktrace.c
> > @@ -356,8 +356,7 @@ static int blk_remove_buf_file_callback(struct dentry *dentry)
> >  static struct dentry *blk_create_buf_file_callback(const char *filename,
> >  						   struct dentry *parent,
> >  						   int mode,
> > -						   struct rchan_buf *buf,
> > -						   int *is_global)
> > +						   struct rchan_buf *buf)
> >  {
> >  	return debugfs_create_file(filename, mode, parent, buf,
> >  					&relay_file_operations);
> > @@ -424,7 +423,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
> >  		goto err;
> >  
> >  	bt->rchan = relay_open("trace", dir, buts->buf_size,
> > -				buts->buf_nr, &blk_relay_callbacks, bt);
> > +			       buts->buf_nr, &blk_relay_callbacks, bt, 0UL);
> >  	if (!bt->rchan)
> >  		goto err;
> >  
> > diff --git a/include/linux/relay.h b/include/linux/relay.h
> > index 52e4d61..18fd269 100644
> > --- a/include/linux/relay.h
> > +++ b/include/linux/relay.h
> > @@ -25,7 +25,13 @@
> >  /*
> >   * Tracks changes to rchan/rchan_buf structs
> >   */
> > -#define RELAYFS_CHANNEL_VERSION		7
> > +#define RELAYFS_CHANNEL_VERSION		8
> 
> What is the significance of this change?  Does it affect the
> kernel<->userspace interface?  Is it back-compatible with existing
> userspace?
> 

No, nothing to do with the kernel-userspace interface.  The channel
version is included in the channel struct and was meant as an aid in
deciphering channel data in crash dumps.

Tom

> 
> > +/*
> > + * relay channel flags
> > + */
> > +#define RCHAN_MODE_OVERWRITE		0x00000001	/* 'flight' mode */
> > +#define RCHAN_GLOBAL_BUFFER		0x00000002	/* not using per-cpu */
> >  
> >
> > ...
> >
> > @@ -480,7 +478,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
> >   	buf->cpu = cpu;
> >   	__relay_reset(buf, 1);
> >  
> > - 	if(chan->is_global) {
> > +	if(chan->flags & RCHAN_GLOBAL_BUFFER) {
> 	
> Please use checkpatch.  It's a little thing, but it's so easy to fix..
> 
> >   		chan->buf[0] = buf;
> >   		buf->cpu = 0;
> >    	}
> >
> > ...

