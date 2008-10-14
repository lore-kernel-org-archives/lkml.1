Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYJNEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYJNEES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 00:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYJNEEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 00:04:07 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:53981 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYJNEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 00:04:06 -0400
X-Authority-Analysis: v=1.0 c=1 a=AE1oZuSjHPYA:10 a=4XX46gVHXKYA:10
 a=W3Sz2NZjJCc3GUAG8IQA:9 a=rgHATxLIXdVmzrAXLwkov3mGIzMA:4 a=50e4U0PicR4A:10
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Tom Zanussi <zanussi@comcast.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1223881068.31587.1.camel@penberg-laptop>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <1223701131.7489.25.camel@charm-linux>
	 <1223881068.31587.1.camel@penberg-laptop>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 23:03:51 -0500
Message-Id: <1223957031.10883.7.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Mon, 2008-10-13 at 09:57 +0300, Pekka Enberg wrote:
> Hi Tom,
> 
> On Fri, 2008-10-10 at 23:58 -0500, Tom Zanussi wrote:
> > It looks like you hit the same problem as described here:
> > 
> > commit 8191ecd1d14c6914c660dfa007154860a7908857
> > 
> >     splice: fix infinite loop in generic_file_splice_read()
> > 
> > relay uses the same loop but it never got noticed or fixed.  Can you try
> > the following patch:
> > 
> > diff --git a/kernel/relay.c b/kernel/relay.c
> > index 8d13a78..6a4d439 100644
> > --- a/kernel/relay.c
> > +++ b/kernel/relay.c
> > @@ -1318,12 +1318,9 @@ static ssize_t relay_file_splice_read(struct file *in,
> >  		if (ret < 0)
> >  			break;
> >  		else if (!ret) {
> > -			if (spliced)
> > -				break;
> > -			if (flags & SPLICE_F_NONBLOCK) {
> > +			if (flags & SPLICE_F_NONBLOCK)
> >  				ret = -EAGAIN;
> > -				break;
> > -			}
> > +			break;
> >  		}
> >  
> >  		*ppos += ret;
> > 
> 
> Indeed. That fixes the deadlock.
> 
> However, now I don't get anything to the cpu*.out files if I run
> kmemtraced with kmemtrace disabled. If I enable kmemtrace manually and
> then run kmemtraced, I do receive some data. I did apply the
> kmemtrace-user patch as well.
> 
> Hmm?

To me, that sounds like how it should work - if kmemtrace is disabled,
it shouldn't be logging anything, and that's in fact what I saw when
debugging this - it started out disabled and therefore nothing being
logged to relay (printks confirmed that).  When I wrote 1 to the enabled
file, data started getting logged to relay and to the *.out files.

So I don't know why the enabled state behaves the way it does, or if
it's unexpected, but that anyway doesn't seem like a relay problem to
me.

Tom

> 
> 		Pekka
> 

