Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXJHSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXJHSDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbXJHSDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:03:11 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:35114 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbXJHSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:03:09 -0400
Message-ID: <470A70DC.8000005@opengridcomputing.com>
Date: Mon, 08 Oct 2007 13:03:08 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Kanevsky, Arkady" <Arkady.Kanevsky@netapp.com>
CC: Sean Hefty <sean.hefty@intel.com>, Sean Hefty <mshefty@ichips.intel.com>,
       netdev@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v3] iw_cxgb3: Support"iwarp-only"interfacesto
 avoid 4-tuple conflicts.
References: <20070923203649.8324.64524.stgit@dell3.ogc.int><46FBF8AF.9040700@ichips.intel.com><C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com> <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com> <C98692FD98048C41885E0B0FACD9DFB80518755A@exnane01.hq.netapp.com>
In-Reply-To: <C98692FD98048C41885E0B0FACD9DFB80518755A@exnane01.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Kanevsky, Arkady wrote:
> Sean,
> IB aside,
> it looks like an ULP which is capable of being both RDMA aware and RDMA
> not-aware,
> like iSER and iSCSI, NFS-RDMA and NFS, SDP and sockets, 
> will be treated as two separete ULPs.
> Each has its own IP address, since there is a different IP address for
> iWARP
> port and "regular" Ethernet port. So it falls on the users of ULPs to
> "handle" it
> via DNS or some other services.
> Is this "acceptable" to users? I doubt it.
> 
> Recall that ULPs are going in opposite directions by having a different
> port number for RDMA aware and RDMA unaware versions of the ULP.
> This way, ULP "connection manager" handles RDMA-ness under the covers,
> while users plug an IP address for a server to connect to.
> Thanks,

NOTE: iSCSI/iSER over iWARP won't work with the current Linux RDMA/Verbs 
anyway due to the requirement that the login connection be migrated into 
RDMA mode.  That's a separate issue.  Currently there is not even a way 
to setup an RDMA connection in streaming mode, then allow streaming mode 
I/O, then transitioning the connection in to RDMA mode.  None of that is 
implemented.  Also, iSCSI/ISER does _not_ use different ports for 
streaming mode vs data-mover/rdma modes.  It is negotiated and assumes 
the same 4tuple.

But, if we assume that reasonable services should use different ports 
for tcp vs rdma connections for the same service, then maybe all thats 
needed is a way to choose ephemeral ports without colliding with the TCP 
stack.  Like maybe segmenting the ephemeral port space for TCP and RDMA 
ranges?  This could be done without impacting the core networking code I 
think.   This would still require a mvapich2 change to have the stack 
choose a port instead of randomly trying ports until one is available.

This angle doesn't solve everything either, but it avoids 2 separate 
subnets...


Steve.


> 
> Arkady Kanevsky                       email: arkady@netapp.com
> Network Appliance Inc.               phone: 781-768-5395
> 1601 Trapelo Rd. - Suite 16.        Fax: 781-895-1195
> Waltham, MA 02451                   central phone: 781-768-5300
>  
> 
>> -----Original Message-----
>> From: Sean Hefty [mailto:sean.hefty@intel.com] 
>> Sent: Thursday, September 27, 2007 3:12 PM
>> To: Kanevsky, Arkady; Sean Hefty; Steve Wise
>> Cc: netdev@vger.kernel.org; rdreier@cisco.com; 
>> linux-kernel@vger.kernel.org; general@lists.openfabrics.org
>> Subject: RE: [ofa-general] [PATCH v3] iw_cxgb3: 
>> Support"iwarp-only"interfacesto avoid 4-tuple conflicts.
>>
>>> What is the model on how client connects, say for iSCSI, when client 
>>> and server both support, iWARP and 10GbE or 1GbE, and would like to 
>>> setup "most" performant "connection" for ULP?
>> For the "most" performance connection, the ULP would use IB, 
>> and all these problems go away.  :)
>>
>> This proposal is for each iwarp interface to have its own IP 
>> address.  Clients would need an iwarp usable address of the 
>> server and would connect using rdma_connect().  If that call 
>> (or rdma_resolve_addr/route) fails, the client could try 
>> connecting using sockets, aoi, or some other interface.  I 
>> don't see that Steve's proposal changes anything from the 
>> client's perspective.
>>
>> - Sean
>> _______________________________________________
>> general mailing list
>> general@lists.openfabrics.org
>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>>
>> To unsubscribe, please visit 
>> http://openib.org/mailman/listinfo/openib-general
>>
