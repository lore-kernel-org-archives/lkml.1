Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZIAWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZIAWQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZIAWQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:16:37 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54517 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbZIAWQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hZNGc5QB8AY3dbYLgVoPUfSj/TP+rMUhooIxWCSz4QnmrXBbPwpPkR0J5JEXRbPzeU
         MMqtqymxB4yFT/upS9AfjHgxi0DwUIAThbCAIxB74sWqQTcJC5qUn/toIBbDs8u/5tqN
         wGWqZdZd2/wR3MkTy25MGghZe5NFEb4ghiD3E=
Date: Wed, 2 Sep 2009 00:16:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency
	inversions
Message-ID: <20090901221631.GA6108@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826201330.GA18761@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 12:13:30AM +0400, Alexander Beregalov wrote:
> On Tue, Aug 25, 2009 at 04:32:46AM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > This small set fixes some lock dependency inversions found in reiserfs
> > xattr and mmap paths.
> > I guess there are still some of them that I'll have to hunt, especially one
> > reported by Laurent Riffard and another one introduced by the reiserfs_readdir
> > path optimization (though I'm not sure about the latter, I have yet to find a
> > way to reproduce it properly).
> > 
> > As usual, these patches can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> > 	reiserfs/kill-bkl
> 
> Hi,
> possible circular locking dependency detected
> 
> Is it false positive?



No, this confirms a real one, also the worst because it has been
introduced by a nice optimization (in term of result of throughput)
that I'll probably need to revert.

reiserfs_readdir() has a reiserfs_write_lock -> mm->mmap_sem
dependency.
But reiserfs_readpage() has a mm->mmap_sem -> reiserfs_write_lock
dependency.

I'll send a fix soon. Thanks a lot for this report Alexander!

Frederic.

