Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbYCGUnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbYCGUnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbYCGUmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:42:55 -0500
Received: from pat.uio.no ([129.240.10.15]:43658 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181AbYCGUmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:42:54 -0500
Subject: Re: READDIRPLUS max mount option
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Kyle Rose <krose@krose.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <47D1A0F5.2070501@krose.org>
References: <47D1995E.6060501@krose.org>
	 <1204919978.16746.12.camel@heimdal.trondhjem.org>
	 <47D1A0F5.2070501@krose.org>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 15:42:50 -0500
Message-Id: <1204922570.16746.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 611C71786C1058EEC0E34D09465682D7E6779A81
X-UiO-SR-test: 91DAC478C284DEFEEB00CAA4EE6AA33A80F06F3C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 246 total 7289940 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-07 at 15:09 -0500, Kyle Rose wrote:
> > The binary mount format is frozen forever, so the changes to nfs_mount.h
> > and nfs4_mount.h are definitely NACKed.
> >   
> Ah. :-)  So is there no way to add mount options, or is there a 
> different mechanism today?

Newer versions of 'mount' should use the text-based interface.

> > Otherwise, it would be nice to know why this absolutely has to be made a
> > mount option rather than just having a system-wide option (either a
> > module/boot parameter or a sysctl) to control the behaviour of all
> > mounts.
> >   
> I mount multiple remote file systems.  Only one of them I own, so I'm 
> willing to potentially hammer it with huge READDIRPLUS requests, while 
> the others probably deserve more benign behavior. ;-)

The size of the actual READDIRPLUS requests is completely unaffected by
your patch. Your change actually means that the client will continue to
use READDIRPLUS on very large directories instead of falling back to
readdir.
The reason for falling back to readdir is that value of readdirplus
tends to decrease with larger directories as the cost of caching all
those dentries, attributes and filehandles both on the client and the
server goes up.

If you want a faster readdir(), you will find that splitting those huge
directories up into smaller subdirs is an alternative solution that
tends to scale much better on both client and server.

> In general, I think having system-wide defaults somewhere in proc is 
> helpful---and certainly superior to a constant in the source---but there 
> should really be mount-specific overrides wherever the system-wide 
> default might not be globally appropriate.

Having hundreds of mount options for minor tweaks is not an acceptable
practice. Each mount option needs to be abundantly justified.

Since we're talking about what is really a quite arbitrary limit, I can
certainly see an argument for why we might want a way to change it, but
I'm still not convinced that we need to be setting this parameter at the
mountpoint level.

Cheers
  Trond

