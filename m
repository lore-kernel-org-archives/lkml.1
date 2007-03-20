Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbXCTWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbXCTWI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXCTWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:08:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58909 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXCTWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:08:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	<m1ird1o243.fsf@ebiederm.dsl.xmission.com>
	<1174055467.3397.17.camel@raven.themaw.net>
	<45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070320201548.GA21312@sergelap.austin.ibm.com>
	<m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	<20070320214125.GA5585@sergelap.austin.ibm.com>
Date: Tue, 20 Mar 2007 16:01:38 -0600
In-Reply-To: <20070320214125.GA5585@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 20 Mar 2007 16:41:25 -0500")
Message-ID: <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

>> >  void autofs4_dentry_release(struct dentry *);
>> >  extern void autofs4_kill_sb(struct super_block *);
>> > diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
>> > index 9857543..4a9ad9b 100644
>> > --- a/fs/autofs4/waitq.c
>> > +++ b/fs/autofs4/waitq.c
>> > @@ -141,8 +141,8 @@ static void autofs4_notify_daemon(struct
>> >  		packet->ino = wq->ino;
>> >  		packet->uid = wq->uid;
>> >  		packet->gid = wq->gid;
>> > -		packet->pid = wq->pid;
>> > -		packet->tgid = wq->tgid;
>> > +		packet->pid = pid_nr(wq->pid);
>> > +		packet->tgid = pid_nr(wq->tgid);
>> >  		break;
>> 
>> I'm assuming we build the packet in the process context of the
>> daemon we are sending it to.  If not we have a problem here.
>
> Yes this is data being sent to a userspace daemon (Ian pls correct me if
> I'm wrong) so the pid_nr is the only thing we can send.

Agreed.  The question is are we in the user space daemon's process when
we generate the pid_nr.  Or do we stuff this in some kind of socket,
and the socket switch locations of the packet.

Basically I'm just trying to be certain we are calling pid_nr in the
proper context.  Otherwise we could get the wrong pid when we have
multiple pid namespaces in play.

Eric
