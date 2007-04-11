Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXDKAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXDKAWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 20:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXDKAWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 20:22:53 -0400
Received: from pat.uio.no ([129.240.10.15]:33855 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbXDKAWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 20:22:52 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Neil Brown <neilb@suse.de>
Cc: Bob Copeland <me@bobcopeland.com>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <17948.4289.176612.555587@notabene.brown>
References: <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
	 <1176215836.14442.37.camel@heimdal.trondhjem.org>
	 <17947.64947.649081.411561@notabene.brown>
	 <1176239914.309.54.camel@heimdal.trondhjem.org>
	 <17948.916.464492.881283@notabene.brown>
	 <1176242364.309.69.camel@heimdal.trondhjem.org>
	 <17948.4289.176612.555587@notabene.brown>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 20:22:01 -0400
Message-Id: <1176250921.309.94.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.085)
X-UiO-Scanned: 1C02690D863DB85694731035C6D26EB3C4B55EC2
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 44 total 973706 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 08:33 +1000, Neil Brown wrote:

>   A READDIR (aka getdents2) should take a directory handle, a cookie,
>   and a filename, and should return filenames and cookies.  The
>   cookies may all be identical or may not.  The filename might be used
>   by the filesystem, or it might not.
> 
>   Filesystems that require a cursor in the 'struct file' to support
>   (local) getdents cannot be used with NFS.
> 
> While it doesn't make it possible to support all conceivable
> filesystems, it should make it easier for some filesystems to support
> the demands of NFS.

In order to be useful, I think you need to add a demand that the READDIR
call cannot loop back on itself for the case of a series of sequential
reads.

IOW: if a client attempts to step sequentially through the directory,
and is supplying valid filenames+cookies from the preceding READDIR
call, then the next READDIR call should be guaranteed never to loop back
to an earlier entry. Alternatively, if there is a danger that it might
due to some sudden and radical change in the directory layout, then it
should notify the client by returning something like a BAD_COOKIE error.

Otherwise, the client would have to cache _all_ previous READDIR results
since the last opendir()/rewinddir() in order to be able to do its own
loop detection and that will obviously never scale for large directories
or for directories that change frequently...

Cheers
  Trond

