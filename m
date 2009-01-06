Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZAFXH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZAFXH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZAFXHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:07:50 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45826 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZAFXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:07:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	<20090106011314.961946803@us.ibm.com>
	<20090106200229.GA17031@us.ibm.com>
	<1231274682.20316.65.camel@heimdal.trondhjem.org>
	<20090106215831.GE18147@us.ibm.com>
Date: Tue, 06 Jan 2009 15:04:17 -0800
In-Reply-To: <20090106215831.GE18147@us.ibm.com> (Serge E. Hallyn's message of
	"Tue, 6 Jan 2009 15:58:31 -0600")
Message-ID: <m1eizg11fy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Trond Myklebust (trond.myklebust@fys.uio.no):
>> On Tue, 2009-01-06 at 14:02 -0600, Serge E. Hallyn wrote:
>> > Quoting Matt Helsley (matthltc@us.ibm.com):
>> > > We can often specify the UTS namespace to use when starting an RPC client.
>> > > However sometimes no UTS namespace is available (specifically during
> system
>> > > shutdown as the last NFS mount in a container is unmounted) so fall
>> > > back to the initial UTS namespace.
>> > 
>> > So what happens if we take this patch and do nothing else?
>> > 
>> > The only potential problem situation will be rpc requests
>> > made on behalf of a container in which the last task has
>> > exited, right?  So let's say a container did an nfs mount
>> > and then exits, causing an nfs umount request.
>> > 
>> > That umount request will now be sent with the wrong nodename.
>> > Does that actually cause problems, will the server use the
>> > nodename to try and determine the client sending the request?
>> 
>> The NFSv2/v3 umount rpc call will be sent by the 'umount' program from
>> userspace, not the kernel. The problem here is that because lazy mounts
>> exist, the lifetime of the RPC client may be longer than that of the
>
> Right that was what i was referring to.
>
>> container. In addition, it may be shared among more than 1 container,
>> because superblocks can be shared.
>
> Good point.  And in that case what do we care about (even though
> apparently we just might not care at all :) - who did the mount,
> or who is using it?
>
> In fact one thing I noticed in Matt's patch 3 was that he copied
> in the nodename verbatim, so a future hostname() by the container
> wouldn't be reflected, again not sure if that would matter.
>
>> One thing you need to be aware of here is that inode dirty data
>> writebacks may be initiated by completely different processes than the
>> one that dirtied the inode.
>
> Right, but I *was* thinking that we wanted to associate the nodename
> on the rpc calls with the hostname of the mounter, not the actor.  Maybe
> you'll tell me above that that is bogus.
>
>> IOW: Aside from being extremely ugly, approaches like [PATCH 4/4] which
>> rely on being able to determine the container-specific node name at RPC
>> generation time are therefore going to return incorrect values.
>
> So should we use patch 2/4, plus (as someone - was it you? - suggested)
> using a DEFAULT instead of init_utsname()->nodename when
> current->utsname() == NULL?

Is there any reason to believe that the kernel helper threads will ever
have a useful namespace value?  I don't think so.

That implies to me you want to capture the value at mount time, and to
pass it in to the rpc_call creation, and only at very specific well
defined points where we interact with user space should we examine
current->utsname().  At which point there should be no question
of current->utsname() is valid as the user space process is alive.

Eric
