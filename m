Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXCVCDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXCVCDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXCVCDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:03:04 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56656 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025AbXCVCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:03:01 -0400
X-Sasl-enc: C/qGh4z4EBPOVBRaK3K0WjhvlUao7Jiyw8+Z2mDbR+3/ 1174528980
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
From: Ian Kent <raven@themaw.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
References: <Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	 <m1ird1o243.fsf@ebiederm.dsl.xmission.com>
	 <1174055467.3397.17.camel@raven.themaw.net> <45FAAD4F.4000204@fr.ibm.com>
	 <1174063618.3397.58.camel@raven.themaw.net>
	 <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	 <20070319200839.GB19449@sergelap.austin.ibm.com>
	 <m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	 <20070320201548.GA21312@sergelap.austin.ibm.com>
	 <m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	 <20070320214125.GA5585@sergelap.austin.ibm.com>
	 <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 11:00:51 +0900
Message-Id: <1174528851.4635.6.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 16:01 -0600, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> >> >  void autofs4_dentry_release(struct dentry *);
> >> >  extern void autofs4_kill_sb(struct super_block *);
> >> > diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> >> > index 9857543..4a9ad9b 100644
> >> > --- a/fs/autofs4/waitq.c
> >> > +++ b/fs/autofs4/waitq.c
> >> > @@ -141,8 +141,8 @@ static void autofs4_notify_daemon(struct
> >> >  		packet->ino = wq->ino;
> >> >  		packet->uid = wq->uid;
> >> >  		packet->gid = wq->gid;
> >> > -		packet->pid = wq->pid;
> >> > -		packet->tgid = wq->tgid;
> >> > +		packet->pid = pid_nr(wq->pid);
> >> > +		packet->tgid = pid_nr(wq->tgid);
> >> >  		break;
> >> 
> >> I'm assuming we build the packet in the process context of the
> >> daemon we are sending it to.  If not we have a problem here.
> >
> > Yes this is data being sent to a userspace daemon (Ian pls correct me if
> > I'm wrong) so the pid_nr is the only thing we can send.
> 
> Agreed.  The question is are we in the user space daemon's process when
> we generate the pid_nr.  Or do we stuff this in some kind of socket,
> and the socket switch locations of the packet.

The context here is the automount daemon only for expire runs.

Mount request packets are triggered by user processes walking over an
autofs mount point directory. So "current" in this case isn't the autofs
daemon.

Requests are sent via a pipe to the daemon.

Ian


