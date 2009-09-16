Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbZIPRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbZIPRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbZIPRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759731AbZIPRaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:30:23 -0400
Date: Wed, 16 Sep 2009 13:30:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>
Subject: Re: io-controller: file system meta data operations
Message-ID: <20090916173020.GD5221@redhat.com>
References: <alpine.DEB.2.00.0909161445440.11232@sebohet.brgvxre.pu> <20090916144946.GB5221@redhat.com> <alpine.DEB.2.00.0909161650360.14727@sebohet.brgvxre.pu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909161650360.14727@sebohet.brgvxre.pu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 05:03:11PM +0200, Tobias Oetiker wrote:
> Hi Vivek,
> 
> Today Vivek Goyal wrote:
> 
> > On Wed, Sep 16, 2009 at 02:58:52PM +0200, Tobias Oetiker wrote:
> > > Hi Vivek,
> > >
> > > I am trying to optimize user-experience on a busy NFS server.
> > >
> > > I think much could be achieved if the following was true.
> > >
> > >   get a response to file system meta data operations (opendir,
> > >   readdir, stat, mkdir, unlink) within 200 ms even under heavy
> > >   read/write strain ...
> > >
> >
> > Hi tobi,
> >
> > Is it better with vanilla CFQ (without io controller). I see that CFQ
> > preempts the ongoing process if it receives a meta data request and that
> > way it provides faster response.
> >
> > If yes, then similar thing should work for IO controller also. Wait there
> > is one issue though. If a file system request gets backlogged in a group
> > while a different group was being served, then preemption will not happen
> > and that's probably the reason you are not seeing better latencies.
> 
> I only looked at io-controller once I did not get ahead with
> vanilla cfq ( and the other schedulers for that matter).

Thinking more about it. You need to first identify where the latency is
coming from. io controller can help you in providing better latencies if
latencies are coming from other processes competing for the disk and delay
is coming from the fact that metadata request from nfs thread is blocked
behind other requests.

I see that CFQ preempts a current queue if it is not doing metadata
operation. That means CFQ is providing immediate access to disk(apart from
requests in dispatch queue or in hardware). 

So I am not even sure where the delay is coming from. Once we figure that
out, I can tell whether io controller will help you or not. In general, io
controller will be able to help you if delay is coming from the IO
scheduler because you are queued behind other requests. But in case of
CFQ, that does not seem to be the case.

Can you do some blktraces and figure out where the delay is coming from?

Thanks
Vivek
