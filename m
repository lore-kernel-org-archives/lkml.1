Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbZAGA60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbZAGA60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbZAGA5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:57:51 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40905 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbZAGA5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:57:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	<20090106011314.961946803@us.ibm.com>
	<20090106200229.GA17031@us.ibm.com>
	<1231274682.20316.65.camel@heimdal.trondhjem.org>
	<20090106215831.GE18147@us.ibm.com>
	<m1eizg11fy.fsf@frodo.ebiederm.org>
	<1231283734.8041.6.camel@heimdal.trondhjem.org>
	<20090106233238.GD13785@fieldses.org>
	<1231284943.8041.8.camel@heimdal.trondhjem.org>
	<20090106235322.GE13785@fieldses.org>
	<1231286879.14345.194.camel@localhost>
Date: Tue, 06 Jan 2009 16:55:16 -0800
In-Reply-To: <1231286879.14345.194.camel@localhost> (Matt Helsley's message of
	"Tue, 06 Jan 2009 16:07:59 -0800")
Message-ID: <m1zli4ylxn.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matt Helsley <matthltc@us.ibm.com>
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

Matt Helsley <matthltc@us.ibm.com> writes:

> On Tue, 2009-01-06 at 18:53 -0500, J. Bruce Fields wrote:
>> On Tue, Jan 06, 2009 at 06:35:43PM -0500, Trond Myklebust wrote:
>> > On Tue, 2009-01-06 at 18:32 -0500, J. Bruce Fields wrote:
>> > > On Tue, Jan 06, 2009 at 06:15:34PM -0500, Trond Myklebust wrote:
>> > > > On Tue, 2009-01-06 at 15:04 -0800, Eric W. Biederman wrote:
>> > > > > That implies to me you want to capture the value at mount time, and to
>> > > > > pass it in to the rpc_call creation, and only at very specific well
>> > > > > defined points where we interact with user space should we examine
>> > > > > current->utsname().  At which point there should be no question
>> > > > > of current->utsname() is valid as the user space process is alive.
>> > > > 
>> > > > Why pretend that the filesystem is owned by a particular namespace? It
>> > > > can, and will be shared among many containers...

Sounds right.  Still like the owner of a file it can happen that some
containers are more correct than others.  Especially in the context of
mount merging and the other sophisticated caching that happens in NFS
this increasingly sounds like something that belongs in the cred as
that is where it is used.

>> > > If the only purpose of this is to fill in the auth_unix cred then
>> > > shouldn't it be part of whatever cred structures are passed around?
>> > 
>> > So how does tracking it in a shared structure like the rpc_client help?
>> > If you consider it to be part of the cred, then it needs to be tracked
>> > in the cred...
>> 
>> Right, that's what I meant.
>> 
>> It seems like overkill, though.  Does anyone actually care whether these
>> names are right?
>
> That's certainly a tempting angle. However we may not "control" the
> server code -- couldn't there be some oddball (maybe even proprietary)
> NFS servers out there that users do care about interacting with?

Matt could you look at what it will take to do the right thing from
the network namespace side of things as well?  I believe it is going
to require the same level of understanding of the interactions in the code
to get there.

For the network namespace we should cache it at mount or server
startup and use it until we are done.  In a network namespace context
there are good reasons for that because talking to 10.0.0.1 on one
network may not be the same machine as talking to 10.0.0.1 on another
network.  NFS reestablishes tcp connections if the connection to the
server breaks doesn't it?  Or is that left to user space?

Eric
