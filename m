Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYHLTYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYHLTYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHLTYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:24:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33696 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYHLTYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:24:22 -0400
Date: Tue, 12 Aug 2008 20:24:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812192419.GU28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <20080812182240.GS28946@ZenIV.linux.org.uk> <20080812183745.GT28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812183745.GT28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 07:37:45PM +0100, Al Viro wrote:

> FWIW, how about that sequence:
> 
> Patch 1:
> Turn all filldir(...) < 0 into filldir() != 0 in ->readdir() instances,
> no changes other than that.  Everything should keep working as-is.
> 
> Patch 2:
> Make fillonedir() return 1 on the second call; make filldir() et.al.
> return 1 instead of -EINVAL if we have ->previous != NULL.  Again,
> should be no breakage.

aargh...
Patch 2.5:
  Fix braindead instances of ->readdir() that return odd crap on success
  (e.g. coda_readdir() returning the count of filldir calls that had returned
  zero).

> Patch 3: switch ->readdir() to your "return anything non-null we got from
> callback".  AFAICS, main callers will see no breakage, but in any case
> we have few enough of those to adjust them as needed first.
> 
> Patch 4: get rid of ->error and its ilk; adjust callers in obvious ways
> (e.g. sys_gtedents() would bail out on negative from vfs_readdir() as
> it does now and treat 0 and 1 in the same way - put_user() ? -EFAULT : <how
> much did we copy).  Callers can be taken care one by one.  Again, no breakage
> and everything's bisectable.
> 
> Patch 5 (maybe):
> #define READDIR_MORE INT_MAX
> Have ->readdir() instances that decide to stop once they'd done several
> filldir calls return it if there's still more left.
> Have vfs_readdir() loop calling ->readdir() as long as it gets READDIR_MORE.
> Get rid of weird loops in callers.
> 
> I'm not sure that the last one is needed - we might be better off just by
> making the such instances loop themselves.  In any case, loops in callers
> (nfsd, etc.) are begging for trouble...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
