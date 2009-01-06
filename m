Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbZAFWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbZAFWih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbZAFWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:31:07 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:42904 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbZAFWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:31:03 -0500
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
Message-Id: <FB1BAB9F-25D4-449F-A66D-D1CC705F3741@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090106200229.GA17031@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
Date: Tue, 6 Jan 2009 17:29:05 -0500
References: <20090106011314.534653345@us.ibm.com> <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
X-Mailer: Apple Mail (2.930.3)
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4963DB36.00CA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2009, at Jan 6, 2009, 3:02 PM, Serge E. Hallyn wrote:
> Quoting Matt Helsley (matthltc@us.ibm.com):
>> We can often specify the UTS namespace to use when starting an RPC  
>> client.
>> However sometimes no UTS namespace is available (specifically  
>> during system
>> shutdown as the last NFS mount in a container is unmounted) so fall
>> back to the initial UTS namespace.
>
> So what happens if we take this patch and do nothing else?

I thought the point of this was to prevent incorrect container  
nodenames from leaking onto the network.

> The only potential problem situation will be rpc requests
> made on behalf of a container in which the last task has
> exited, right?  So let's say a container did an nfs mount
> and then exits, causing an nfs umount request.
>
> That umount request will now be sent with the wrong nodename.
> Does that actually cause problems, will the server use the
> nodename to try and determine the client sending the request?
>
> thanks,
> -serge
>
>> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
>> Cc: Cedric Le Goater <clg@fr.ibm.com>
>> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
>> Cc: linux-nfs@vger.kernel.org
>> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
>> Cc: Chuck Lever <chuck.lever@oracle.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Linux Containers <containers@lists.osdl.org>
>>
>> ---
>> net/sunrpc/clnt.c |    7 +++++--
>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6.28/net/sunrpc/clnt.c
>> ===================================================================
>> --- linux-2.6.28.orig/net/sunrpc/clnt.c
>> +++ linux-2.6.28/net/sunrpc/clnt.c
>> @@ -128,6 +128,7 @@ static struct rpc_clnt * rpc_new_client(
>> 	struct rpc_version	*version;
>> 	struct rpc_clnt		*clnt = NULL;
>> 	struct rpc_auth		*auth;
>> +	struct new_utsname	*uts_ns = init_utsname();
>> 	int err;
>> 	size_t len;
>>
>> @@ -213,10 +214,12 @@ static struct rpc_clnt * rpc_new_client(
>> 	}
>>
>> 	/* save the nodename */
>> -	clnt->cl_nodelen = strlen(init_utsname()->nodename);
>> +	if (current->nsproxy != NULL)
>> +		uts_ns = utsname();
>> +	clnt->cl_nodelen = strlen(uts_ns->nodename);
>> 	if (clnt->cl_nodelen > UNX_MAXNODENAME)
>> 		clnt->cl_nodelen = UNX_MAXNODENAME;
>> -	memcpy(clnt->cl_nodename, init_utsname()->nodename, clnt- 
>> >cl_nodelen);
>> +	memcpy(clnt->cl_nodename, uts_ns->nodename, clnt->cl_nodelen);
>> 	rpc_register_client(clnt);
>> 	return clnt;
>>
>>
>> -- 
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




