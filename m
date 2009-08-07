Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZHGIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZHGIEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZHGIEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:04:36 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:45283 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbZHGIEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bE1PdoN7ajKVAtoLm9P1gt5Wdsd+T35csoFzbcbHlz2v1TgTpYSEqUjAJtHEGal4E2
         8mD1GRcOd1YaOSsIWLssJyOkG1YSAQFLS1dYoQ+3b+f9HYsI3M9lHKZ3qOPtOir9ZvGV
         WGtP404fOCUaOlH3Z+Jg2EIRPyjyk8T74iW+M=
Date: Fri, 7 Aug 2009 10:04:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090807080428.GB4955@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <1249564170-18627-4-git-send-email-arnd@arndb.de> <20090807062356.GA4955@nowhere> <200908070904.11260.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908070904.11260.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:04:11AM +0200, Arnd Bergmann wrote:
> On Friday 07 August 2009, Frederic Weisbecker wrote:
> 
> > On Thu, Aug 06, 2009 at 03:09:28PM +0200, Arnd Bergmann wrote:
> > > The VT specific compat_ioctl handlers are the only ones
> > > in common code that require the BKL. Moving them into
> > > the vt driver lets us remove the BKL from the other handlers
> > > and cleans up the code.
> > 
> > 
> > Why does it require the bkl?
> > 
> 
> All the VT ioctls are currently called under the BKL. I did not try
> to find out why that is but simply kept that state. All other
> compat ioctl do not interact with device driver state at all,
> so they obviously do not need the BKL.


Ah ok.


 
> > > +
> > > +long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
> > > +	     unsigned int cmd, unsigned long arg)
> > > +{
> > > +	struct vc_data *vc = tty->driver_data;
> > > +	struct console_font_op op;	/* used in multiple places here */
> > > +	struct kbd_struct *kbd;
> > > +	unsigned int console;
> > > +	void __user *up = (void __user *)arg;
> > > +	int perm;
> > > +	int ret = 0;
> > > +
> > > +	console = vc->vc_num;
> > > +
> > > +	lock_kernel();
> > 
> > 
> > 
> > It would be really nice to add a comment here that explain what it
> > is protecting.
> > I would like to work on removing the bkl from tty, and such nude lock_kernel()
> > don't help much to work in this area.
> > This is more than ever a FUD lock, nothing about its role in tty in the Lockronomicon,
> > and even not in the comments :-)
> 
> This function is a straight copy from vt_ioctl, with the data structures replaced,
> and calling it vt_ioctl where they are identical.
> 
> You are right that this needs more code comments to make that obvious.
> 
> 	Arnd <><


Ok. This looks like a nice series. A bkl pushdown that only goes down
in one site among several others enlightens the understanding of what it
is protecting (beside the nice fact it also burned three bkl callsites :-)

Thanks!

