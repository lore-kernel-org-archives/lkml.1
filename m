Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZDQWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZDQWwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZDQWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:51:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:52381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZDQWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:51:55 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: bfields@citi.umich.edu, hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090417224350.GN26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl>
	 <1239960739.3428.33.camel@macbook.infradead.org>
	 <20090417193233.GM26366@ZenIV.linux.org.uk>
	 <1240006620.19059.41.camel@macbook.infradead.org>
	 <20090417224350.GN26366@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 23:51:47 +0100
Message-Id: <1240008708.21423.16.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 23:43 +0100, Al Viro wrote:
> On Fri, Apr 17, 2009 at 11:17:00PM +0100, David Woodhouse wrote:
> > It sounds like the better answer is to just make sure i_mutex is held
> > when nfsd_buffered_readdir() calls back into the provided filldir
> > function (we could do it in the various filldir functions themselves,
> > _if_ they call lookup_one_len(), but I think I prefer it this way --
> > it's simpler). Patch below for comment.
> 
> Umm...  I can live with that, assuming that we don't have callbacks
> that take i_mutex themselves.  AFAICS, everything we call there is
> either obviously not touching i_mutex or is already called while we
> hold i_mutex elsewhere,

More than that... until commit 14f7dd63, we were holding i_mutex when we
called back into those callbacks from nfsd_readdir() itself. We're only
reverting to a fairly recent behaviour, in that respect.

> > (While I'm staring at it, it looks like nfsd_buffered_readdir() should
> > be returning a __be32 not an int, and its 'return -ENOMEM' should be
> > 'return nfserrno(-ENOMEM)'. The first bug I inherited from the existing
> > nfsd_do_readdir() when I replaced it, but the second is all my own. I'll
> > send a patch to fix those shortly.)
> 
> Fold it into this one, please.

OK.

Ah, and see also commit 05f4f678b (Bruce).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

