Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbYEUMhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbYEUMhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763949AbYEUMhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:37:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764061AbYEUMhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:37:06 -0400
Date: Wed, 21 May 2008 08:37:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, systemtap@sources.redhat.com,
       usb-storage@lists.one-eyed-alien.net, linux-cifs-client@lists.samba.org,
       linux-nfs@vger.kernel.org
Subject: Re: [2.6 patch] unexport uts_sem
Message-ID: <20080521123700.GA8770@infradead.org>
References: <20080505182937.GZ17139@cs181133002.pp.htv.fi> <y0mwsloq4kc.fsf@ton.toronto.redhat.com> <20080520172730.GA2361@infradead.org> <20080520183802.GA686@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520183802.GA686@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:38:02PM -0400, Frank Ch. Eigler wrote:
> Sorry, I misspoke - this check is intended not to cross-check
> kernel-devel and the kernel itself, but the debuginfo or similar data
> that is given to describe target of a systemtap script.  I guess for
> new enough kernels we'll just do that using buildid hash codes.
> 
> By the way, there do appear to be a few suspect in-tree users of
> utsname() without uts_sem locking (usb/storage/usb.c

Just a debug printk.  Note sure why this particular one needs to
print the version, but if it really wants to do it it should rather use
UTS_RELEASE.

> cifs/connect.c,

This one is quite fishy. Not sure what it needs the name for but the
kernel utsname is probably a bad choise.  And yes, this one actually
is racy because the host name can change.

> char/random.c,

random.c is always built-in and utsname is called during the
single-threaded kernel initialization phase, so this is safe.

> fs/lockd/clntproc.c, ...).

Yes, this one is racy.  Should probably be fixed by starting lockd
with CLONE_NEWUTS so that it never changed during it's lifetime.
It's probably not a good idea when it changes with outstanding lockd
request anyway.

> If these need to be fixed,
> then wouldn't uts_sem need to come back exported?
