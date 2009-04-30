Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZD3CLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZD3CLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZD3CLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:11:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:47812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbZD3CLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:11:33 -0400
Message-ID: <49F908A1.70207@kernel.org>
Date: Thu, 30 Apr 2009 11:10:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu> <49F043A4.2060700@kernel.org> <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu>
In-Reply-To: <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 02:10:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
>>> VFS inode should never be needed by the CUSE codepaths.  Well, maybe
>>> for setting access/modification times, but in any case those need not
>>> be shared with fuse code.
>> One more usage: locking.
> 
> You mean inode->i_mutex locking?  It doesn't look to me as if cuse
> would need to do any of that.

Well, there are a few places in file.c and dir.c IIRC and I think
there's one path which CUSE uses (or used, it might have gone away
with your changes).  I was concerned with the different assumptions
FUSE code paths are under depending on whether the code is used by
CUSE or that, which is not at all obvious from looking at the FUSE
code only, so the large update to put FUSE file handling paths under
the same assumptions which are safe for CUSE.  I think it's too subtle
but it's also true that the paths used by CUSE are quite limited, so
as long as you can keep a close eye on it I guess it would be okay.

>>> I don't see any problems with doing the device initialization in the
>>> context of the replying process (which will usually be the same as
>>> the one opening the device anyway).
>> I don't know.  If it's simple, sure why not.  If it makes things even
>> marginally more complex (state saving and so on), why go that way?
> 
> OK, I folded FUSE_INIT into CUSE_INIT, and moved the CUSE_INIT reply
> processing into the ->end() callback.  This also allows us to remove
> the CUSE_INIT_DONE message, since now the write(2) on the cuse device
> will only return when the device initialization is complete.
> 
> Overall it results in some 100 lines less code (well, some of that is
> because I folded <linux/cuse.h> into <linux/fuse.h>).  But the simpler
> initialization sequence is, I think, definitely worth it.
> 
> The patches are pushed out to the 'cuse' and 'for-next' branches of
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git
>
> I'll post the updated libfuse patch as well.  Please let me know if
> you find anything wrong with the current patches.

Looks good to me.  Much prettier with two inits merged.

Thanks.

-- 
tejun
