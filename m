Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYJaEJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYJaEJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYJaEI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:08:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:43624 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJaEI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:08:56 -0400
Message-ID: <f73f7ab80810302108n37f72994qfc5d7d83b64e290@mail.gmail.com>
Date: Fri, 31 Oct 2008 00:08:54 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "J.R. Mauro" <jrm8005@gmail.com>
Subject: Re: merging other repos into linux-2.6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081030054944.GA19035@kroah.com>
	 <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
	 <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org>
	 <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:38 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> I agree. The only viable automated approach would be something akin to
> git-submodule but with the ability to integrate the submodule'd
> project upon import in such a way that things like bisection would
> follow the main project's ancestry and ignore the submodule's. But
> that's not possible right now and probably won't be in the foreseeable
> future.

Here's one relatively easy solution:

(1)  Fetch the to-be-merged branch of the "child" project into a
repository with the parent project ($KIDBRANCH)

(2)  Find a branch on which you are going to rebase the child
project's history ($BASEBRANCH)

(3)  Determine a directory into which you are going to put the child
project's history ($SUBDIR)

(4)  Identify the first revision of the child project by looking at
the last (first-in-time) entry in "git log" of that branch.
($KIDSTART)

(5)  Graft the kid's history onto the parent's history at that point:
echo "$KIDSTART $(git rev-parse --verify $BASEBRANCH)" >.git/info/grafts

(6)  Rewrite the kid's history as a subdir of that version of the parent:
git filter-branch --index-filter 'git read-tree master && git
read-tree --prefix=drivers/newkiddriver/ "$GIT_COMMIT"' --
"$BASEBRANCH..$KIDBRANCH"

Now the history of $KIDBRANCH will appear to be a series of commits
which add files in $SUBDIR of the parent project, without any changes
at all to the parent project's tree.  You can then do a merge of what
appears to be a normal development branch into the main repository.

Since none of the files are even remotely referenced, there can be no
possible build failures (hence bisection is not broken).  You may then
add commits which add Kconfig options and Makefile references and
happily develop away.

Cheers,
Kyle Moffett
