Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYIKQpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYIKQpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYIKQpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:45:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62057 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYIKQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:45:00 -0400
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Message-Id: <02721E5E-6962-4699-86A5-EF5CFC787284@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <48C8DEA0.9080905@fr.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [RFC][PATCH] sunrpc: fix oops in rpc_create() when the mount namespace is unshared
Date: Thu, 11 Sep 2008 12:39:39 -0400
References: <48C52B29.4020204@fr.ibm.com> <20080909124311.GA10053@us.ibm.com> <m18wu1nyon.fsf@frodo.ebiederm.org> <20080909152952.GA21207@us.ibm.com> <DE845309-1684-472A-8269-78AB3A2823A9@oracle.com> <m1fxo9mba5.fsf@frodo.ebiederm.org> <48C791F9.8090606@fr.ibm.com> <76bd70e30809100812r4a7fa71crfc7196350e3ed1cf@mail.gmail.com> <m1ej3rixbx.fsf@frodo.ebiederm.org> <48C8DEA0.9080905@fr.ibm.com>
X-Mailer: Apple Mail (2.928.1)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric-

On Sep 11, 2008, at Sep 11, 2008, 5:02 AM, Cedric Le Goater wrote:
>> The conservative play is to always force use of the initial namespace
>> and to deny creation of mounts that would use different  
>> namespaces.  In part
>> because the initial version of the namespace always exists.  Which  
>> means
>> as relates to Cedrics initial patch we would still need to know which
>> mounts should cause us to use a different uts namespace so we can  
>> deny
>> them.
>
> I will send the initial patch which forces use of the initial  
> namespace because
> it does fix a real oops.

Today's patch looks reasonable to me.  I would add a FIXME comment in  
net/sunrpc/clnt.c near the site of the fix.

> Then, I should be able to find some time to work on improving the  
> uts namespace
> checks when NFS mounts are done.

As a final note, I don't think this is an issue only for NFS mounts.   
The problem is with how AUTH_SYS RPC credentials are formed.

cl_nodename is a copy of utsname kept in the rpc_clnt structure for  
efficiency.  I think the auth_unix code has to be more sensitive to  
which utsname is "in effect" for each RPC request.  We probably can't  
use the same utsname for all RPC requests for the life of an RPC  
client.  And since RPC credentials are cached, we should be more  
careful about which cached credential is selected.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
