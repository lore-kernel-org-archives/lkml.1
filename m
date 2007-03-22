Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXCVNcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXCVNcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbXCVNcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:32:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44961 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXCVNcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:32:03 -0400
Date: Thu, 22 Mar 2007 08:31:54 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ian Kent <raven@themaw.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
Message-ID: <20070322133153.GB22933@sergelap.austin.ibm.com>
References: <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com> <20070319200839.GB19449@sergelap.austin.ibm.com> <m1odmpvuft.fsf@ebiederm.dsl.xmission.com> <20070320201548.GA21312@sergelap.austin.ibm.com> <m17itbmypc.fsf@ebiederm.dsl.xmission.com> <20070320214125.GA5585@sergelap.austin.ibm.com> <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com> <1174528851.4635.6.camel@raven.themaw.net> <20070322021931.GA11485@sergelap.austin.ibm.com> <1174533494.4635.37.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174533494.4635.37.camel@raven.themaw.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ian Kent (raven@themaw.net):
> On Wed, 2007-03-21 at 21:19 -0500, Serge E. Hallyn wrote:
> > Quoting Ian Kent (raven@themaw.net):
> > > On Tue, 2007-03-20 at 16:01 -0600, Eric W. Biederman wrote:
> > > > "Serge E. Hallyn" <serue@us.ibm.com> writes:
> > > > 
> > > > >> >  void autofs4_dentry_release(struct dentry *);
> > > > >> >  extern void autofs4_kill_sb(struct super_block *);
> > > > >> > diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> > > > >> > index 9857543..4a9ad9b 100644
> > > > >> > --- a/fs/autofs4/waitq.c
> > > > >> > +++ b/fs/autofs4/waitq.c
> > > > >> > @@ -141,8 +141,8 @@ static void autofs4_notify_daemon(struct
> > > > >> >  		packet->ino = wq->ino;
> > > > >> >  		packet->uid = wq->uid;
> > > > >> >  		packet->gid = wq->gid;
> > > > >> > -		packet->pid = wq->pid;
> > > > >> > -		packet->tgid = wq->tgid;
> > > > >> > +		packet->pid = pid_nr(wq->pid);
> > > > >> > +		packet->tgid = pid_nr(wq->tgid);
> > > > >> >  		break;
> > > > >> 
> > > > >> I'm assuming we build the packet in the process context of the
> > > > >> daemon we are sending it to.  If not we have a problem here.
> > > > >
> > > > > Yes this is data being sent to a userspace daemon (Ian pls correct me if
> > > > > I'm wrong) so the pid_nr is the only thing we can send.
> > > > 
> > > > Agreed.  The question is are we in the user space daemon's process when
> > > > we generate the pid_nr.  Or do we stuff this in some kind of socket,
> > > > and the socket switch locations of the packet.
> > > 
> > > The context here is the automount daemon only for expire runs.
> > > 
> > > Mount request packets are triggered by user processes walking over an
> > > autofs mount point directory. So "current" in this case isn't the autofs
> > > daemon.
> > > 
> > > Requests are sent via a pipe to the daemon.
> > 
> > So is the pid used for anything other than debugging?
> > 
> > In any case, here is a replacement patch which sends the pid number
> > in the pid_namespace of the process which did the autofs4 mount.
> > 
> > Still not sure whether that is actually what makes sense...
> > 
> > From: "Serge E. Hallyn" <serue@us.ibm.com>
> > Subject: [PATCH] autofs: prevent pid wraparound in waitqs
> > 
> > Instead of storing pid numbers for waitqs, store references
> > to struct pids.  Also store a reference to the mounter's pid
> > namespace in the autofs4 sb info so that pid numbers for
> > mount miss and expiry msgs can send the pid# in the mounter's
> > pidns.
> 
> I think this amounts to what I suggested in my previous replies.
> Hopefully my comments are enough to clear up any questions on
> correctness of this approach.
> 
> Sorry to be a pain but I'm having a little trouble reviewing the patch
> because I'm not clear on where the code to handle the automount process
> group (so called oz_pgrp), from the first patch, fits in with this.

It also has pidspace infrastructure code in it, so I think we will just
hold off on this until we have that infrastructure merged into the
pidspace code and into -mm.  Then we can send you a single, more concise
patch.

> Is this patch in addition to the original?

Yes.

> If so are the references to pid_nr still OK?

I think so, because AIUI the rest are all executed in a context where
current is both the actor and recipient.

Thanks for your help.

thanks,
-serge
