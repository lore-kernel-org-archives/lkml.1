Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbXLMWvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbXLMWvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763113AbXLMWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:51:12 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:44722 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762272AbXLMWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:51:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Lg3rzoI+phmgOEo4XM2hkufix/YHVrsNCnRuiyMdv7NSXHbAuVpFW24sPO8eyCCclUtzJPsUFGLkb3OVwV1tyXAU9tCIb41eX60Xqy4xvhonPhJ0esNkeNxiI0bPW7pMiP+cHPY2Kx9fPOtk5urzZCnU3jQD/VqcJxRBtEFc3Dk=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 36/42] VFS: export drop_pagecache_sb
Date: Fri, 14 Dec 2007 09:47:10 +1100
User-Agent: KMail/1.9.5
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200712131524.lBDFOHBv024206@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200712131524.lBDFOHBv024206@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140947.11049.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 02:24, Erez Zadok wrote:
> In message <200712121638.35167.nickpiggin@yahoo.com.au>, Nick Piggin writes:
> > On Monday 10 December 2007 13:42, Erez Zadok wrote:
> > > Needed to maintain cache coherency after branch management.
> >
> > Hmm, I'd much prefer to be able to sleep in invalidate_mapping_pages
> > before this function gets exported.
> >
> > As it is, it can cause massive latencies on preemption and the inode_lock
> > so it is pretty much debug-only IMO. I'd rather it didn't escape into the
> > wild as is.
> >
> > Either that or rework your cache coherency somehow.
>
> Nick, thanks for the advice.
>
> We use a generation number after each successful branch configuration
> command, so that ->d_revalidate later on can discover that change, and
> rebuild the union of objects.  At ->remount time, I figured it'd be nice to
> "encourage" that revalidation to happen sooner, by invalidating as many
> upper pages as possible, thus causing ->d_revalidate/->readpage to take
> place sooner.  So we used to call drop_pagecache_sb from our remount code:
> it was the only caller of drop_pagecache_sb.  It wasn't too much of an
> latency issue to call drop_pagecache_sb there: the VFS remount code path is
> already pretty slow (dropping temporarily to readonly mode, and dropping
> other caches), and remount isn't an operation used often, so a little bit
> more latency would probably not have been noticed by users.

Well a large, infrequent spike is the most damaging to latency sensitive
users. And anyway, I guess the infrequency of remount means it doesn't
have to be really efficient with invalidating pagecache either.


> Nevertheless, it was not strictly necessary to call drop_pagecache_sb in
> unionfs_remount, because the objects in question will have gotten
> revalidated sooner or later anyway; the call to drop_pagecache_sb was just
> an optimization (one which I wasn't 100% sure about anyway, as per my long
> "XXX" comment above that call in unionfs_remount).
>
> So I agree with you: if this symbol can be abused by modules and cause
> problems, then exporting it to modules is too risky.  I've reworked my code
> to avoid calling drop_pagecache_sb and I'll [sic] drop that patch.

Thanks, I'd be much happier with that.
