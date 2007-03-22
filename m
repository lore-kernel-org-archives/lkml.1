Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXCVGoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXCVGoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXCVGoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:44:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57250 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXCVGoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:44:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070320201548.GA21312@sergelap.austin.ibm.com>
	<m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	<20070320214125.GA5585@sergelap.austin.ibm.com>
	<m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
	<1174528851.4635.6.camel@raven.themaw.net>
	<20070322021931.GA11485@sergelap.austin.ibm.com>
Date: Thu, 22 Mar 2007 00:43:08 -0600
In-Reply-To: <20070322021931.GA11485@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Wed, 21 Mar 2007 21:19:31 -0500")
Message-ID: <m1irctaidf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:
>
> So is the pid used for anything other than debugging?
>
> In any case, here is a replacement patch which sends the pid number
> in the pid_namespace of the process which did the autofs4 mount.
>
> Still not sure whether that is actually what makes sense...
>
> From: "Serge E. Hallyn" <serue@us.ibm.com>
> Subject: [PATCH] autofs: prevent pid wraparound in waitqs
>
> Instead of storing pid numbers for waitqs, store references
> to struct pids.  Also store a reference to the mounter's pid
> namespace in the autofs4 sb info so that pid numbers for
> mount miss and expiry msgs can send the pid# in the mounter's
> pidns.

Hmm.  Not quite what I would have expected but given that
we are sending data over a pipe that sounds reasonable.

If it wasn't a pipe we would really want to do this in
the context of the process receiving the message, but since
a pipe can receive a message, and then be passed to another
process we clearly can't know the pid namespace of the
process receiving the message.

Therefore just caching the pid namespace either on pipe
open or on mount makes sense.  pipe open might be better.

Serge we really need to introduce __pid_nr in a separate
patch.   And we really seem to be confusing Ian.

Plus we have some pid namespace ref counting issues we need
to handle carefully.

Let's stop working on autofs4 for a bit, fix the pid namespace
infrastructure so there is enough of it to handle autofs4 and
then come back.

Either that or take autofs4 in two passes.  Pass one we do what
we can with the current infrastructure.  Pass two after we fix up
the infrastructure including introducing __pid_nr we come back
and update autofs4 to handle multiple pid namespaces properly.

Eric
