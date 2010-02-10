Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0BJRgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:36:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59031 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0BJRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:36:37 -0500
To: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] sysfs: differentiate  between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Feb 2010 09:36:32 -0800
In-Reply-To: <19314.1869.847327.15190@notabene.brown> (Neil Brown's message of "Wed\, 10 Feb 2010 12\:09\:33 +1100")
Message-ID: <m1636556xr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> Hi,
>  I've just spent a while sorting out some lockdep complaints triggered
>  by the recent addition of the "s_active" lockdep annotation in sysfs
>   (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)
>
>  Some of them are genuine and I have submitted a fix for those.
>  Some are, I think, debatable and I get to that is a minute.  I've
>  submitted a fix for them anyway.
>  But some are to my mind clearly bogus and I'm hoping that can be
>  fixed by the change below (or similar).
>  The 'bogus' ones are triggered by writing to a sysfs attribute file
>  for which the handler tries to delete a symlink from sysfs.
>  This appears to be a recursion on s_active as s_active is held while
>  the handler runs and is again needed to effect the delete.  However
>  as the thing being deleted is a symlink, it is very clearly a
>  different object to the thing triggering the delete, so there is no
>  real loop.
>
>  The following patch splits the lockdep context in two - one for
>  symlink and one for everything else.  This removes the apparent loop.
>  (An example report can be seen in
>      http://bugzilla.kernel.org/show_bug.cgi?id=15142).
>
>  The "debatable" dependency loops happen when writing to one attribute
>  causes a different attribute to be deleted.  In my (md) case this can
>  actually cause a deadlock as both the attributes take the same lock
>  while the handler is running.  This is because deleting the attribute
>  will block until the all accesses of that attribute have completed (I
>  think).

You are correct.  Not until the file handles are closed but until all
users of the underyling methods are complete.

>  However it should be possible to delete a name from sysfs while there
>  are still accesses pending (it works for normal files!!).  So if
>  sysfs could be changed to simply unlink the file and leave deletion to
>  happen when the refcount become zero it would certainly make my life
>  a lot easier, and allow the removal of some ugly code from md.c.
>  I don't know sysfs well enough to suggest a patch though.

Thanks for this.  

Separating out symlinks and treating them differently because they can not
cause problems is definitely worth doing.  We never take an active reference
in the symlink code so we can never block waiting for symlinks to be deleted.


We block when deleting files in sysfs (and proc and sysctl).  If we
did not block we could follow pointers into modules that are being
deleted, or those methods that are running could access data
structures that we want to tear down (perhaps there is a lock we want
to kfree).  Blocking in sysfs is to simplify the life of the callers.
Unfortunately for a handful of callers it complicates things.

If you want to compare this to regular files think of what sysfs is
doing as a combined remove and revoke.  The remove is easy.  Revoke
is just plane difficult.

Eric
