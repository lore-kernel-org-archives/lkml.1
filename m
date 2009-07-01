Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZGAUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZGAUQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZGAUQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:16:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33147 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZGAUQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:16:14 -0400
Subject: Re: [Patch] allow file truncations when both suid and write 
 permissions set
From: Eric Paris <eparis@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       viro@zeniv.linux.org.uk
In-Reply-To: <7e0fb38c0907011229h328c8c48i55df5e234b7d367d@mail.gmail.com>
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
	 <4A4BA6F8.7090905@redhat.com> <4A4BB898.10909@redhat.com>
	 <7e0fb38c0907011229h328c8c48i55df5e234b7d367d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 16:15:41 -0400
Message-Id: <1246479341.22562.71.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 15:29 -0400, Eric Paris wrote:
> On Wed, Jul 1, 2009 at 3:27 PM, Eric Sandeen<sandeen@redhat.com> wrote:
> > Eric Sandeen wrote:
> >> Amerigo Wang wrote:
> >>> When suid is set and the non-owner user has write permission,
> >>> any writing into this file should be allowed and suid should be
> >>> removed after that.
> >>>
> >>> However, current kernel only allows writing without truncations,
> >>> when we do truncations on that file, we get EPERM. This is a bug.
> >
> > ...
> >
> >> So I think the main problem here is simply that we didn't set
> >> ATTR_FORCE, right...
> >>
> >> Seems a little odd to |= with ret, -then- check if it's non-0.  Maybe:
> >>
> >>       /* Remove suid/sgid on truncate too */
> >> -     newattrs.ia_valid |= should_remove_suid(dentry);
> >> +     ret = should_remove_suid(dentry);
> >> +     if (ret)
> >> +             newattrs.ia_valid |= (ret | ATTR_FORCE);
> >>
> >
> > On second thought, and after talking w/ eparis, I think this probably
> > needs a security_inode_killpriv() too... it seems like it might be best
> > to change file_remove_suid(*file) to dentry_remove_suid(*dentry) and
> > just call that from do_truncate()?
> >
> > -Eric
> 
> All of this stuff seems horribly complex....   I'm trying to wrap my
> head around everything going on here as well....

So NAK on both Amerigo's and Eric's patch.  ATTR_FORCE is wrong.
ATTR_FORCE here is going to force the security system to accept ALL of
the attr changes, not just the ATTR_KILL_SUID and/or ATTR_KILL_SGID you
|= in from should_remove_suid.

You need to follow esandeen's recommendation, change file_remove_suid()
to dentry_remove_suid() and then use dentry_remove_suid() in do_truncate
instead of what you are currently trying to do (and I think that's
supposed to be done under the i_mutex right?)

-Eric

-Eric

