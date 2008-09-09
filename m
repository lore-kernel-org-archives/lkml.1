Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYIISZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYIISZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYIISZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:25:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44571 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYIISZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:25:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chuck Lever <chuck.lever@oracle.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-nfs@vger.kernel.org
References: <48C52B29.4020204@fr.ibm.com> <20080909124311.GA10053@us.ibm.com>
	<m18wu1nyon.fsf@frodo.ebiederm.org>
	<20080909152952.GA21207@us.ibm.com>
	<DE845309-1684-472A-8269-78AB3A2823A9@oracle.com>
Date: Tue, 09 Sep 2008 11:20:18 -0700
In-Reply-To: <DE845309-1684-472A-8269-78AB3A2823A9@oracle.com> (Chuck Lever's
	message of "Tue, 9 Sep 2008 13:07:40 -0400")
Message-ID: <m1fxo9mba5.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chuck Lever <chuck.lever@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2769]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH] sunrpc: fix oops in rpc_create() when the mount namespace is unshared
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> writes:

> If the upper layers are responsible for providing the utsname, you will need to
> fix up lockd and the NFS server's callback client too, at  least.

Actually looking at the code.  It looks like a proper fix may be  even simpler.
Why do we have both clnt->cl_server and clnt->cl_nodename?    Or is cl_server
the other side of the connection?

>>> What are we trying to achieve by reading utsname?
>>
>> It looks like it gets copied into the sunrpc messages so I assume it is
>> a part of the sunrpc spec?
>
> It appears to be used only for RPC's AUTH_SYS credentials.  The nodename is used
> to identify the caller's host.  See RFC 1831,  Appendix A:
>
>   http://rfclibrary.hosting.com/rfc/rfc1831/rfc1831-16.asp

Thanks that helps a lot.

> I'm not terribly familiar with uts namespaces, though.  Can someone explain why
> we need to distinguish between these for AUTH_SYS if the  caller is on a remote
> system?

Semantically processes in different uts namespaces are on different machines.

> I don't like the idea of an oops in here.  Instead, (for now) it should warn and
> fail to create the client, IMO.

Which is interesting when the problem happens during NFS unmount.  Although
frankly it could fail anyway.

It seems strange that we are creating a client during unmount anyway.

Eric
