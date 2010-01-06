Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975Ab0AFATg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0AFATg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277Ab0AFATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:19:35 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:40286 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752434Ab0AFATe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:19:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] nodemask.h: change any_online_node() to a static inline
Date: Tue, 5 Jan 2010 19:19:31 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090208932F@mi8nycmail19.Mi8.com>
In-Reply-To: <alpine.DEB.2.00.1001051052100.26131@chino.kir.corp.google.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] nodemask.h: change any_online_node() to a static inline
Thread-Index: AcqOOHdQDYMaGtjJSLGZRe8TYOYe8QALAspQ
References: <201001051117.39423.hartleys@visionengravers.com> <alpine.DEB.2.00.1001051052100.26131@chino.kir.corp.google.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Rientjes" <rientjes@google.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <bfields@fieldses.org>
X-OriginalArrivalTime: 06 Jan 2010 00:19:30.0260 (UTC) FILETIME=[EA064140:01CA8E65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 05, 2010 11:54 AM, David Rientjes wrote:
> On Tue, 5 Jan 2010, H Hartley Sweeten wrote:
>
>> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
>> index 454997c..1f66e02 100644
>> --- a/include/linux/nodemask.h
>> +++ b/include/linux/nodemask.h
>> @@ -467,15 +467,6 @@ static inline int num_node_state(enum node_states state)
>>  #define node_online_map 	node_states[N_ONLINE]
>>  #define node_possible_map 	node_states[N_POSSIBLE]
>>  
>> -#define any_online_node(mask)			\
>> -({						\
>> -	int node;				\
>> -	for_each_node_mask(node, (mask))	\
>> -		if (node_online(node))		\
>> -			break;			\
>> -	node;					\
>> -})
>> -
>>  #define num_online_nodes()	num_node_state(N_ONLINE)
>>  #define num_possible_nodes()	num_node_state(N_POSSIBLE)
>>  #define node_online(node)	node_state((node), N_ONLINE)
>> @@ -484,6 +475,17 @@ static inline int num_node_state(enum node_states state)
>>  #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
>>  #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
>>  
>> +static inline int any_online_node(nodemask_t mask)
>> +{
>> +	int node;
>> +
>> +	for_each_node_mask(node, mask) {
>> +		if (node_online(node))
>> +			break;
>> +	}
>> +	return node;
>> +}
>> +
>>  /*
>>   * For nodemask scrach area.
>>   * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
>
> Could you simply remove any_online_node() and replace its callers with 
> first_node(node_online_map) instead?

No idea ;-)

My main intention with this patch was to quite some sparse noise in
net/sunrpc/svc.c.  This seemed the cleanest way to do it.

It looks like any_online_node is, currently, only called by:

arch/powerpc/mm/numa.c
  3 places, twice setting a local int variable called 'nid' and once just
  returning the 'node' from the macro.  All three call the marco as:

	... any_online_node(NODE_MASK_ALL);

net/sunrpc/svc.c
  1 place, setting a local unsigned int variable called 'node'.  Calls the
  macro as:

	... any_online_node(node_online_map);

I really don't know if the macro could be replaced by first_node(node_online_map).

Regards,
Hartley
