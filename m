Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZCPWRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZCPWRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZCPWRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:17:31 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41525 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZCPWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:17:30 -0400
Date: Mon, 16 Mar 2009 22:15:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: David Howells <dhowells@redhat.com>
cc: jmalicki@metacarta.com, chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
In-Reply-To: <27000.1236864221@redhat.com>
Message-ID: <Pine.LNX.4.64.0903162154200.28429@blonde.anvils>
References: <Pine.LNX.4.64.0903102329020.8584@blonde.anvils>
 <Pine.LNX.4.64.0903102105590.21727@blonde.anvils>
 <20090310180740.29065.10735.stgit@warthog.procyon.org.uk> <6503.1236726067@redhat.com>
 <27000.1236864221@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > We do.  See the original thread.  It's here at
> > http://lkml.org/lkml/2009/2/26/233
> > and appended below for convenience.  We do know that patch did not
> > fix Joe's problem, and we don't yet know whether addressing the
> > files->count issue will actually fix it, but I'm hopeful.
> 
> Looks reasonable.

Thanks for taking a look.

Yes, I'm inclined to go with that, and removing the files->count
check from exec.c.  Joe, did you manage to try your testing with
my original patch plus that files->count check removed from 2.6.28's
unsafe_exec()?

Though I've since thought a better answer would probably be to unshare
fs and sighand from the exec'ing task in the same way that files is
unshared at the start, then I hope we wouldn't need to suppress setuid
in the case when any of those had been shared.

But I believe that course would make a slight difference to the behaviour
of the respective CLONE flags versus exec: I'd guess a difference that
nobody cares about, but my guesses don't count for much here, and I
really don't want to cause any regression.

Chris, have you had a chance to look at any of this yet?

> One thing that should be added, though, is a comment in
> struct fs_struct to give a warning about the consequences of incrementing the
> usage count for anything other than CLONE_FS.

Yes, that's a very sensible addition, thanks - if we do go this way,
rather than unsharing.  I'll hold on to this as one of a set of three:
my original fs->count avoidance one, your comment on that below, and
removing the files->count check from exec.c.

Since Joe's bug has been around forever (if it is what we think it
is), I'm disinclined to rush the fix - something nice to add to
-stable, rather than needing to squeeze into 2.6.29.

Hugh

> 
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] Annotate struct fs_struct's usage count to indicate the restrictions upon it
> 
> Annotate struct fs_struct's usage count to indicate the restrictions upon it.
> It may not be incremented, except by clone(CLONE_FS), as this affects the
> check in check_unsafe_exec() in fs/exec.c.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/fs_struct.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
> index a97c053..b12ede4 100644
> --- a/include/linux/fs_struct.h
> +++ b/include/linux/fs_struct.h
> @@ -4,7 +4,11 @@
>  #include <linux/path.h>
>  
>  struct fs_struct {
> -	atomic_t count;
> +	atomic_t count;	/* This usage count is used by check_unsafe_exec() for
> +			 * security checking purposes - therefore it may not be
> +			 * incremented, except by clone(CLONE_FS).
> +			 */
> +
>  	rwlock_t lock;
>  	int umask;
>  	struct path root, pwd;
