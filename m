Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZDPTQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZDPTQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZDPTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:16:21 -0400
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:44019 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756970AbZDPTQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:16:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] net/sunrpc/svc.c: fix sparse warning
Date: Thu, 16 Apr 2009 15:15:17 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com>
In-Reply-To: <20090416190601.GA1145@fieldses.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/sunrpc/svc.c: fix sparse warning
Thread-Index: Acm+xmO77RStCWG7Q4OdmAhbP+YM1gAAI2Wg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 19:16:18.0404 (UTC) FILETIME=[D1C75240:01C9BEC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 16, 2009 12:06 PM, J. Bruce Fields wrote:
> On Wed, Apr 15, 2009 at 03:46:13PM -0400, H Hartley Sweeten wrote:
>> Fix sparse warning in net/sunrpc/svc.c.
>> 
>> 	warning: symbol 'node' shadows an earlier one
>
> What's the other symbol?

Sorry. Left that out...

include/linux/nodemask.h

#define any_online_node(mask)			\
({						\
	int node;				\
	for_each_node_mask(node, (mask))	\
		if (node_online(node))		\
			break;			\
	node;					\
})

arch/powerpc/mm/numa.c is the only other user of that macro. In that
file the local variable is called nid, hence the name change in this
patch.

Regards,
Hartley

>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> ---
>> 
>> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
>> index 8847add..e781135 100644
>> --- a/net/sunrpc/svc.c
>> +++ b/net/sunrpc/svc.c
>> @@ -122,7 +122,7 @@ module_param_call(pool_mode, param_set_pool_mode,
>> param_get_pool_mode,
>>  static int
>>  svc_pool_map_choose_mode(void)
>>  {
>> -	unsigned int node;
>> +	unsigned int nid;
>>  
>>  	if (num_online_nodes() > 1) {
>>  		/*
>> @@ -132,8 +132,8 @@ svc_pool_map_choose_mode(void)
>>  		return SVC_POOL_PERNODE;
>>  	}
>>  
>> -	node = any_online_node(node_online_map);
>> -	if (nr_cpus_node(node) > 2) {
>> +	nid = any_online_node(node_online_map);
>> +	if (nr_cpus_node(nid) > 2) {
>>  		/*
>>  		 * Non-trivial SMP, or CONFIG_NUMA on
>>  		 * non-NUMA hardware, e.g. with a generic 
