Return-Path: <linux-kernel-owner+w=401wt.eu-S1764976AbYB2BN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764976AbYB2BN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYB2BKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:10:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYB2BK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:10:27 -0500
Date: Thu, 28 Feb 2008 20:09:58 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] nfs4: 30 second delay during umount of remote fs
 on system shutdown
Message-ID: <20080228200958.0cde6fe8@tleilax.poochiereds.net>
In-Reply-To: <200802290203.06241.elendil@planet.nl>
References: <200802281829.16343.elendil@planet.nl>
	<1204235218.7109.13.camel@heimdal.trondhjem.org>
	<200802290203.06241.elendil@planet.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 02:03:05 +0100
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 28 February 2008, Trond Myklebust wrote:
> > On Thu, 2008-02-28 at 18:29 +0100, Frans Pop wrote:
> > > I have verified that portmap is also not running during S31umountnfs.sh
> > > with 2.6.24, so apparently there has been a change in the kernel that
> > > has made umount look for portmap and cause the 30 second delay if it is
> > > not running.
> >
> > You are probably seeing the effect of lockd going down: it always
> > attempts to unregister from the portmapper (and no, this is _not_ new
> > behaviour).
> 
> It is _very much_ new behavior because as soon as I boot (and shut down) 
> with a 2.6.24 kernel the problem completely disappears. Userland is *100% 
> identical* between my tests.
> 
> > If debian is killing the portmapper while lockd is still up, then that
> > is a definite debian bug...
> 
> I have no idea about that. AFAICT lockd is not even running (at least, 
> there's no process named lockd, even when the system is running normally.
> Isn't lockd an nfs3 thing? I'm using nfs4 here.
> 

It may be the NFSv4 callback thread going down then. It also tries to
unregister with the portmapper and recent patches fixed the reference
counting so that it actually tears things down instead of just leaking
memory and sockets.

I'm not sure what we can do about that other than try to fix it so that
it doesn't try to unregister with the portmapper. It really doesn't need
to since it no longer registers with it.

-- 
Jeff Layton <jlayton@redhat.com>
