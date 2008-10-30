Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYJ3Rmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYJ3Rmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYJ3Rmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:42:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbYJ3Rmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:42:39 -0400
Date: Thu, 30 Oct 2008 13:42:35 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent
 mount/umount (try #4)
Message-ID: <20081030134235.6d1276ae@barsoom.rdu.redhat.com>
In-Reply-To: <524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
	<524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 12:25:36 -0500
"Steve French" <smfrench@gmail.com> wrote:

> This is much better since it doesn't regress the tcon sharing (which we
> still need to extend for the shared superblock case) - I particularly like
> the new routines to put (free) the tcon and put the smb session, but think
> the locking gets more complicated (with little performance gain) moving from
> one global spinlock covering tcon/smb-session/cifs-tcp-socket to one
> embedded within each structure, and also could be confusing since the cifs
> tcp socket is already protected by a semaphore and now would have a spinlock
> too.   I think we greatly increase the chance of deadlock having to nest
> spinlocks.
> 

lockdep is pretty good about warning you if you're in danger of deadlock
(and I generally always have lockdep turned on).

I really think the fine-grained locking is the best scheme. It's pretty
clear how it should work. If you're walking or altering the lists
(and/or changing the refcounts) then you need to take the locks that
protect them. (granted, I probably need to do another respin that adds
some comments to this effect).

I think we want to resist having locks that protect too many things.
With that, we end up with the locks held over too much code. Not only is
that generally worse for performance, but it can paper over race
conditions.

-- 
Jeff Layton <jlayton@redhat.com>
