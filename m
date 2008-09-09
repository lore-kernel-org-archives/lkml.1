Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYIITOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYIITOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYIITOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:14:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41293 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIITOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:14:15 -0400
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-nfs@vger.kernel.org
Message-Id: <869FF00C-4DAF-4D19-80AF-9230617A9223@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: ebiederm@xmission.com
In-Reply-To: <m1fxo9mba5.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [RFC][PATCH] sunrpc: fix oops in rpc_create() when the mount namespace is unshared
Date: Tue, 9 Sep 2008 15:00:55 -0400
References: <48C52B29.4020204@fr.ibm.com> <20080909124311.GA10053@us.ibm.com> <m18wu1nyon.fsf@frodo.ebiederm.org> <20080909152952.GA21207@us.ibm.com> <DE845309-1684-472A-8269-78AB3A2823A9@oracle.com> <m1fxo9mba5.fsf@frodo.ebiederm.org>
X-Mailer: Apple Mail (2.928.1)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 9, 2008, at Sep 9, 2008, 2:20 PM, ebiederm@xmission.com wrote:
> Chuck Lever <chuck.lever@oracle.com> writes:
>
>> If the upper layers are responsible for providing the utsname, you  
>> will need to
>> fix up lockd and the NFS server's callback client too, at  least.
>
> Actually looking at the code.  It looks like a proper fix may be   
> even simpler.
> Why do we have both clnt->cl_server and clnt->cl_nodename?    Or is  
> cl_server
> the other side of the connection?

cl_server is the server-side.  cl_nodename is the "machine name" of  
the client.

>>>> What are we trying to achieve by reading utsname?
>>>
>>> It looks like it gets copied into the sunrpc messages so I assume  
>>> it is
>>> a part of the sunrpc spec?
>>
>> It appears to be used only for RPC's AUTH_SYS credentials.  The  
>> nodename is used
>> to identify the caller's host.  See RFC 1831,  Appendix A:
>>
>>  http://rfclibrary.hosting.com/rfc/rfc1831/rfc1831-16.asp
>
> Thanks that helps a lot.
>
>> I'm not terribly familiar with uts namespaces, though.  Can someone  
>> explain why
>> we need to distinguish between these for AUTH_SYS if the  caller is  
>> on a remote
>> system?
>
> Semantically processes in different uts namespaces are on different  
> machines.

OK.

>> I don't like the idea of an oops in here.  Instead, (for now) it  
>> should warn and
>> fail to create the client, IMO.
>
> Which is interesting when the problem happens during NFS unmount.   
> Although
> frankly it could fail anyway.
>
> It seems strange that we are creating a client during unmount anyway.

It's worth investigating.  Just enable RPC tracing (/usr/sbin/rpcdebug  
-m rpc -s all) before shutting down the client.

NFS unmounting is historically difficult because during a system  
shutdown, unmounting is the last thing to occur, and usually happens  
after most system services (such as the portmapper service) have  
become unavailable.  That's fine for local file systems, but it makes  
for a rather dodgy situation for NFS.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
