Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYHVVRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYHVVRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYHVVRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:17:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518AbYHVVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:17:31 -0400
Date: Fri, 22 Aug 2008 14:16:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: pasky@suse.cz, Alan.Brunelle@hp.com, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-Id: <20080822141651.fe16ed99.akpm@linux-foundation.org>
In-Reply-To: <7v7ia8ahgu.fsf@gitster.siamese.dyndns.org>
References: <48A36838.3050309@hp.com>
	<20080819124602.9e8e69f7.akpm@linux-foundation.org>
	<48AEDD3D.4060507@hp.com>
	<20080822092549.ddcb7e79.akpm@linux-foundation.org>
	<20080822171651.GP10544@machine.or.cz>
	<20080822105136.a8432875.akpm@linux-foundation.org>
	<7v7ia8ahgu.fsf@gitster.siamese.dyndns.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 14:05:21 -0700
Junio C Hamano <gitster@pobox.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 22 Aug 2008 19:16:51 +0200
> > Petr Baudis <pasky@suse.cz> wrote:
> >
> >> On Fri, Aug 22, 2008 at 09:25:49AM -0700, Andrew Morton wrote:
> > ...
> >> > urgh, it's irritating when git-bisect directs you to a merge commit - it
> >> > hasn't done it for me for ages.
> >> 
> >> Hmm, but doesn't that happen only when it's actually really the merge
> >> commit that introduces the bug? Both parents of the merge commit were
> >> marked as good by the user, so...
> >
> > A merge commit doesn't contain any kernel changes?  It's the individual
> > commits (aka "patches") which were in that merge which broke stuff. 
> > Confused.
> >
> > We're trying to dive inside that merge commit to find out which of the
> > real commits caused the regression.
> 
> You may find neither parents were buggy, but the result of the merge is.
> 
> A trivial example is when one branch changes the semantics of an existing
> function and converts all the call sites to the updated semantics, while
> the other branch adds a new call site that still relies on the old
> behaviour of that function.  The merge most likely won't textually
> conflict, and neither git merge nor quilt patch would report conflicts,
> but the end result is that the new call site added by the latter branch
> now gets an unexpected outcome from the function and can misbehave.  You
> cannot blame the breakage to either branch for such a breakage.

Sure, but

a) whoever added a change like that without also causing the build to
   break is slappable and

b) there are now two commits (one in each branch) either one of
   which, when applied on top of the other branch will introduce the
   regression.

   That's useful infomation, but we don't know how to get
   git-bisect to give it to us.


It's pretty simple.  If git-bisect tells us that the regression was
introduced by a merge commit, we want to perform a bisection within
that merge's individual commits.

