Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXCVN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXCVN25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXCVN25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:28:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45033 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXCVN2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:28:55 -0400
Date: Thu, 22 Mar 2007 08:28:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Ian Kent <raven@themaw.net>,
       Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
Message-ID: <20070322132853.GA22933@sergelap.austin.ibm.com>
References: <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com> <20070319200839.GB19449@sergelap.austin.ibm.com> <m1odmpvuft.fsf@ebiederm.dsl.xmission.com> <20070320201548.GA21312@sergelap.austin.ibm.com> <m17itbmypc.fsf@ebiederm.dsl.xmission.com> <20070320214125.GA5585@sergelap.austin.ibm.com> <m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com> <1174528851.4635.6.camel@raven.themaw.net> <20070322021931.GA11485@sergelap.austin.ibm.com> <m1irctaidf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irctaidf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
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
> Hmm.  Not quite what I would have expected but given that
> we are sending data over a pipe that sounds reasonable.
> 
> If it wasn't a pipe we would really want to do this in
> the context of the process receiving the message, but since
> a pipe can receive a message, and then be passed to another
> process we clearly can't know the pid namespace of the
> process receiving the message.
> 
> Therefore just caching the pid namespace either on pipe
> open or on mount makes sense.  pipe open might be better.

Right, but the pipe is always opened on mount I think.  (at
autofs4_fill_super)

> Serge we really need to introduce __pid_nr in a separate
> patch.

Agreed.

> And we really seem to be confusing Ian.
> 
> Plus we have some pid namespace ref counting issues we need
> to handle carefully.
> 
> Let's stop working on autofs4 for a bit, fix the pid namespace
> infrastructure so there is enough of it to handle autofs4 and
> then come back.

Agreed.  I just wasn't comfortable stopping until I felt we knew how
autofs4 was going to be addressed.  I think we know now, plus we've
verified another definite need for the __pid_nr(pidns, pid) helper.

> Either that or take autofs4 in two passes.  Pass one we do what
> we can with the current infrastructure.  Pass two after we fix up
> the infrastructure including introducing __pid_nr we come back
> and update autofs4 to handle multiple pid namespaces properly.

Nah, let's hold off, and I'll sit on a patch to send out once rest of
the infrastructure goes in.

-serge
