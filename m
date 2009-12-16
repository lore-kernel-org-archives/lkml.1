Return-Path: <linux-kernel-owner+w=401wt.eu-S965213AbZLPXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213AbZLPXC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965209AbZLPXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:02:05 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:35213 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbZLPXBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:01:48 -0500
Subject: Re: [PATCH -next] nfs: fix ISO C90 warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912162355350.2755@localhost.localdomain>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au>
	 <20091216142334.6a0ba115.randy.dunlap@oracle.com>
	 <1261003219.13878.6.camel@localhost>
	 <20091216144700.34b80b4b.randy.dunlap@oracle.com>
	 <alpine.LFD.2.00.0912162355350.2755@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 18:01:37 -0500
Message-Id: <1261004497.13878.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 9 sum msgs/h 1 total rcpts 2066 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3A66BDFA17C72F7D4633D13A547A3C44D02419AD
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 49 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 23:58 +0100, Thomas Gleixner wrote: 
> On Wed, 16 Dec 2009, Randy Dunlap wrote:
> > On Wed, 16 Dec 2009 17:40:19 -0500 Trond Myklebust wrote:
> > 
> > > On Wed, 2009-12-16 at 14:23 -0800, Randy Dunlap wrote: 
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Fix gcc ISO C90 warning:
> > > > 
> > > > fs/nfs/callback.c:356: warning: ISO C90 forbids mixed declarations and code
> > > > 
> > > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > > ---
> > > >  fs/nfs/callback.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > --- linux-next-20091215.orig/fs/nfs/callback.c
> > > > +++ linux-next-20091215/fs/nfs/callback.c
> > > > @@ -352,8 +352,8 @@ static int check_gss_callback_principal(
> > > >  static int nfs_callback_authenticate(struct svc_rqst *rqstp)
> > > >  {
> > > >  	struct nfs_client *clp;
> > > > -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> > > >  	int ret = SVC_OK;
> > > > +	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> > > >  
> > > 
> > > What version of gcc is giving rise to this warning?
> > 
> > > gcc --version
> > gcc (GCC) 4.2.1 (SUSE Linux)
> > 
> > > RPC_IFDEBUG is a macro that either evaluates to its argument, or to
> > > nothing, depending on whether or not RPC_DEBUG is defined or not. In
> > > neither case should it evaluate to anything illegal under C90 rules
> > > afaics.
> > 
> > Yep.  Odd warning.
> 
> Not really. If the debug macro evaluates to nothing then you have:
> 
>     struct nfs_client *clp;
>     ;
>     int ret = SVC_OK;
> 
> So you have a stray semicolon, which is interpreted as an empty code
> line. That qualifies for the mixed declaration and code case :)
> 
> I know it's nitpicking, but ...

Ah... I see what you mean.

So really what we should do is just move that semicolon inside the
macro. That would change the !RPC_DEBUG case to

    struct nfs_client *clp;

    int ret = SVC_OK;

which is 100% legal...

Cheers
  Trond

