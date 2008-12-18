Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYLRXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYLRXBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYLRXAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:00:16 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:43225 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYLRXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:00:13 -0500
Date: Thu, 18 Dec 2008 14:58:37 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20081218225837.GB21870@mail.oracle.com>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229603308.9487.227.camel@twins>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494AD5B3.01E2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:28:28PM +0100, Peter Zijlstra wrote:
> In fact, both (configfs) mkdir and rmdir seem to synchronize on
> su_mutex..
> 
>  mkdir B/C/bar
> 
>    C.i_mutex
>      su_mutex
> 
> vs
> 
>  rmdir foo
> 
>    parent(foo).i_mutex
>      foo.i_mutex
>        su_mutex
> 
> 
> once holding the rmdir su_mutex you can check foo's user-content, since
> any mkdir will be blocked. All you have to do is then re-validate in
> mkdir's su_mutex that !IS_DEADDIR(C).

	We explicitly do not take any i_mutex locks after taking
su_mutex.  That's an ABBA risk.  su_mutex protects the hierarchy of
config_items.  i_mutex protects the vfs view thereof.
	If you look in mkdir, we take su_mutex, get a new item from the
client subsystem, then drop su_mutex.  After that, we go about building
our filesystem structure, using i_mutex where appropriate.  More
importantly is rmdir(2), where we use i_mutex in
configfs_detach_group(), but are not holding su_sem.  Only when
configfs_detach_group() has successfully returned and we have torn down
the filesystem structure do we take su_mutex and tear down the
config_item structure.
	In fact, we're part of the way there.  Check out that
USET_DROPPING flag we set in detach_prep() while scanning for user
objects.  That flags us racing mkdir(2).  When we are done with
detach_prep(), we know that mkdir(2) calls racing behind us will do
nothing until we safely lock them out with the locking in
detach_group().  All mkdir(2) calls will have exited by the time we get
the mutex, and no new mkdir(2) call can start because we have the mutex.
	Now look in detach_groups().  We drop the groups children before
marking them DEAD.  Louis' plan, I think, is to perhaps mark a group
DEAD, disconnect it from the vfs, and then operate on its children.  In
this fashion, perhaps we can unlock the trailing lock like a normal VFS
operation.
	This will require some serious auditing, however, because now
vfs functions can get into the vfs objects behind us.  And more vfs
changes affect us.  Whereas the current locking relies on the vfs's
parent->child lock ordering only, something that isn't likely to be
changed.

Joel


-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
