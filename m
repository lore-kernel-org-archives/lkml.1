Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZAYMUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZAYMUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZAYMUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:20:42 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52050 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbZAYMUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:20:41 -0500
Date: Sun, 25 Jan 2009 23:20:39 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090125122039.GA16603@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20090125110126.GA11598@brong.net>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 25, 2009 at 10:01:27PM +1100, Bron Gondwana wrote:
> On Sun, Jan 25, 2009 at 12:03:34AM +1100, Bron Gondwana wrote:
> > The attached patches do this - the first bumps the default to 1024, and
> > the second adds /proc/sys/fs/epoll/limits which contains 4 values.  The
> > first two are the maximum current value for each field, and the second
> > two are the values of max_user_instances and max_user_watches again,
> > similar to the file-max interface.
> 
> And this third one (on top of the other two) adds the UIDs of the most
> heavily using users to the "limits" file, to help you track them down.

Patch 4 - I'll stop now ;)

Allow '0' for unlimited for both limits.

I notice that root gets limited same as anyone else.  Any opinion on
special-casing root and not limiting the number of epolls they can
create?  There are plenty of other ways root can be nasty if it's so
inclined!

Bron.

--UugvWAfsgieZRqgk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-epoll-allow-0-for-unlimited-on-epoll-limits.patch"

>From ced9c438dc5120140b3af950618183343ca3d530 Mon Sep 17 00:00:00 2001
From: Bron Gondwana <brong@fastmail.fm>
Date: Sun, 25 Jan 2009 23:17:31 +1100
Subject: [PATCH] epoll: allow 0 for "unlimited" on epoll limits

---
 fs/eventpoll.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 2113795..ce8879b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -597,8 +597,9 @@ static int ep_alloc(struct eventpoll **pep)
 
 	user = get_current_user();
 	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			epoll_limits.max_user_instances))
+	if (unlikely(epoll_limits.max_user_instances &&
+                       (atomic_read(&user->epoll_devs) >=
+			epoll_limits.max_user_instances)))
 		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -776,8 +777,9 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     epoll_limits.max_user_watches))
+	if (unlikely(epoll_limits.max_user_watches && 
+                    (atomic_read(&ep->user->epoll_watches) >=
+		     epoll_limits.max_user_watches)))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
-- 
1.5.6.3


--UugvWAfsgieZRqgk--
