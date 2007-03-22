Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXCVP2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXCVP2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXCVP2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:28:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51492 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbXCVP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:28:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <1174055467.3397.17.camel@raven.themaw.net>
	<45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070320201548.GA21312@sergelap.austin.ibm.com>
	<m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	<20070320214125.GA5585@sergelap.austin.ibm.com>
	<m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
	<20070321205834.GB21517@sergelap.austin.ibm.com>
	<1174530523.4635.25.camel@raven.themaw.net>
Date: Thu, 22 Mar 2007 09:22:37 -0600
In-Reply-To: <1174530523.4635.25.camel@raven.themaw.net> (Ian Kent's message
	of "Thu, 22 Mar 2007 11:28:43 +0900")
Message-ID: <m17it98fr6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Wed, 2007-03-21 at 15:58 -0500, Serge E. Hallyn wrote:

>> PS
>> Note that if I'm right, but some machine starts autofs in a child
>> pid_namespace, the pid_nr() the way I have it is wrong.  I'm not sure in
>> that case how we go about fixing that.  Somehow we need to store the
>> autofs userspace daemon's pid namespace pointer to help us find the
>> proper pid_nr.
>
> In order for any user space application to use the module it must mount
> the autofs file system, passing a file handle for the pipe to use for
> communication. This must always be done. Can we grab the process pid
> namespace at that time and store it in the superblock info structure?

I think this sounds like what Serge's did with his last patch, and
it sounds like the only reasonable thing we can do in this situation.

I had missed the fact the pipe is passed in at mount time.

> How does this affect getting ids for waitq request packets of other user
> space processes triggering mounts? I'm guessing that they would need to
> belong to the appropriate namespace for this mechanism to funtion
> correctly.

Not really.  As long as the user space applications that trigger the mount
is in the pid namespace where the mount was performed or in a child of that
pid namespace it will has a process id that you can see.

If it happens that someone is entirely too creative and the process that
triggered the mount is in an entirely different pid namespace that does
not map __pid_nr will return 0.  Not perfect but at least it is well defined.
And a reasonable thing to return for a process you cannot see.

Eric
