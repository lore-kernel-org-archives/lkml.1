Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0BJR4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:56:00 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab0BJRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DipFVf0PXpgXC1viBqKJV0yHgld1zX4fKq5V1wijnCc2tVDXGq+iNnjtoJgJlSNged
         3S2Gb1SF65I9MgMJYNNCal6Z8JN7RRfozaDp3b9g8B5Lik97q4Nbu3KaP3VVnac6MWiX
         //XrH7fiqA5+FxUYIu8aDbOk6h3LFQI0Az68g=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysfs: differentiate  between locking links and non-links
Date: Wed, 10 Feb 2010 09:55:51 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7; KDE/4.3.5; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, Tejun Heo <tj@kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
References: <19314.1869.847327.15190@notabene.brown> <m1636556xr.fsf@fess.ebiederm.org>
In-Reply-To: <m1636556xr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100955.52493.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010 09:36:32 am Eric W. Biederman wrote:
> Neil Brown <neilb@suse.de> writes:
> > Hi,
> >  I've just spent a while sorting out some lockdep complaints triggered
> >  by the recent addition of the "s_active" lockdep annotation in sysfs
> >   (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)
> >
> >  Some of them are genuine and I have submitted a fix for those.
> >  Some are, I think, debatable and I get to that is a minute.  I've
> >  submitted a fix for them anyway.
> >  But some are to my mind clearly bogus and I'm hoping that can be
> >  fixed by the change below (or similar).
> >  The 'bogus' ones are triggered by writing to a sysfs attribute file
> >  for which the handler tries to delete a symlink from sysfs.
> >  This appears to be a recursion on s_active as s_active is held while
> >  the handler runs and is again needed to effect the delete.  However
> >  as the thing being deleted is a symlink, it is very clearly a
> >  different object to the thing triggering the delete, so there is no
> >  real loop.
> >
> >  The following patch splits the lockdep context in two - one for
> >  symlink and one for everything else.  This removes the apparent loop.
> >  (An example report can be seen in
> >      http://bugzilla.kernel.org/show_bug.cgi?id=15142).
> >
> >  The "debatable" dependency loops happen when writing to one attribute
> >  causes a different attribute to be deleted.  In my (md) case this can
> >  actually cause a deadlock as both the attributes take the same lock
> >  while the handler is running.  This is because deleting the attribute
> >  will block until the all accesses of that attribute have completed (I
> >  think).
> 
> You are correct.  Not until the file handles are closed but until all
> users of the underyling methods are complete.
> 
> >  However it should be possible to delete a name from sysfs while there
> >  are still accesses pending (it works for normal files!!).  So if
> >  sysfs could be changed to simply unlink the file and leave deletion to
> >  happen when the refcount become zero it would certainly make my life
> >  a lot easier, and allow the removal of some ugly code from md.c.
> >  I don't know sysfs well enough to suggest a patch though.
> 
> Thanks for this.
> 
> Separating out symlinks and treating them differently because they can not
> cause problems is definitely worth doing.  We never take an active
>  reference in the symlink code so we can never block waiting for symlinks
>  to be deleted.
> 
> 
> We block when deleting files in sysfs (and proc and sysctl).  If we
> did not block we could follow pointers into modules that are being
> deleted, or those methods that are running could access data
> structures that we want to tear down (perhaps there is a lock we want
> to kfree).  Blocking in sysfs is to simplify the life of the callers.
> Unfortunately for a handful of callers it complicates things.

Exactly. Before Tejun changed sysfs to provide guarantee that no
show/store methods are still running, nor new references to the
corresponding kobject will be acquired through sysfs after
sysfs_remove_file() returns, you had to jump through million of
hoops at subsystem level to work with lifetime rules and work around
the fact that kobjects could outlive your module.

I was glad to see bunch of ugly code in serio, gameport and input go
and I do not want it coming back ;)

> 
> If you want to compare this to regular files think of what sysfs is
> doing as a combined remove and revoke.  The remove is easy.  Revoke
> is just plane difficult.
> 
> Eric

-- 
Dmitry
