Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753097AbYLRL44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYLRL44 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLRL4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:56:46 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:52673 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbYLRL4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:56:46 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        swhiteho <swhiteho@redhat.com>
In-Reply-To: <20081218092744.GB30789@mail.oracle.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	 <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
	 <1229585208.9487.112.camel@twins>  <20081218092744.GB30789@mail.oracle.com>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 12:56:39 +0100
Message-Id: <1229601399.9487.218.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 01:27 -0800, Joel Becker wrote:

> 	It's about the default_groups and how they build up and tear
> down small bits of tree.
> 	A simple creation of a config_item, a mkdir(2), is a normal VFS
> lock set and doesn't make lockdep unhappy.  But if the new config_item
> has a default_group or two, they need locking too.  Not so much on
> mkdir(2), but on rmdir(2).

Hohumm,..

So the problem is that mkdir() doesn't just create a single entity but a
whole tree:

configfs:/my_subsystem/$ mkdir foo

might result in:

 foo/
 foo/A/
 foo/B/
 foo/B/C/

which on rmdir foo you'd have to tear down, but only if its that exact
tree and not when say A has any user created directories.

VFS mkdir A/blah only synchronizes on A.i_mutex and checks S_DEAD to
avoid races with rmdir A - which would lock first parent(A).i_mutex and
then A.i_mutex before detaching A and marking it S_DEAD.

So what you're now doing is locking the full foo/ subtree in order to
check there is no user content and block mkdir/creat from generating any
- which is where the trouble comes from, right?

Like said on IRC, the whole populated thing made me think of
mount/umount (steven whitehouse seems to have had a similar notion).

You basically want to synchronize any user mkdir/creat against foo
instead of just the new parent so that rmdir foo can tell if there is
any such content without having to lock the whole subtree.

That would mean them locking both foo and the new parent (when they're
not one and the same). Trouble seems to be that vfs_mkdir() and such
already have their new parent locked, which means you cannot go about
locking foo anymore. But that would have resulted in a 3 deep
lock-chain.

(and I don't see any filesystem hooks in user_path_parent() -- which is
probably a good thing)


Bugger..

