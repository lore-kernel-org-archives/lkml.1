Return-Path: <linux-kernel-owner+w=401wt.eu-S1161155AbXECJra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155AbXECJra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXECJra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:47:30 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:19437 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030772AbXECJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:47:29 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <4639AF91.8080200@amd.com>
Date: Thu, 03 May 2007 11:46:57 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org,
       "Dominik Brodowski" <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia/pccard deadlock fix
References: <45DB0EDB.3090803@amd.com>
 <20070502142014.b1f1d77e.akpm@linux-foundation.org>
In-Reply-To: <20070502142014.b1f1d77e.akpm@linux-foundation.org>
X-OriginalArrivalTime: 03 May 2007 09:46:16.0823 (UTC)
 FILETIME=[E51AB870:01C78D67]
X-WSS-ID: 6A27701520G1238447-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Tue, 20 Feb 2007 16:08:11 +0100
>>     
>
> 20 Feb was a long time ago, sorry.  I was hoping to feed the pcmcia patches
> through Dominik but I think he's busy with exams or such.  So I get to
> pretend to be pcmcia maintainer.
>
> "Markus Rechberger" <markus.rechberger@amd.com> wrote:
>
>   
>> following patch prevents a mutex/semaphore deadlock within the pcmcia
>> framework when ejecting devices multiple times using pccardctl eject.
>>
>> For some more details see:
>> http://lkml.org/lkml/2007/2/19/58
>>
>> Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
>>
>> -- 
>> Markus Rechberger
>> Operating System Research Center
>> AMD Saxony LLC & Co. KG
>>
>>
>>
>> [pcmcia-pccard-deadlock-fix.diff  text/plain (757B)]
>> index ac00424..c02bf0d 100644
>> --- a/drivers/pcmcia/cs.c
>> +++ b/drivers/pcmcia/cs.c
>> @@ -856,7 +856,8 @@ int pcmcia_eject_card(struct pcmcia_socket *skt)
>>      
>>  	cs_dbg(skt, 1, "user eject request\n");
>>  
>> -	mutex_lock(&skt->skt_mutex);
>> +	if (!mutex_trylock(&skt->skt_mutex)) 
>> +		return -EAGAIN;
>>  	do {
>>  		if (!(skt->state & SOCKET_PRESENT)) {
>>  			ret = -ENODEV;
>> index 18e111e..b9d3440 100644
>> --- a/drivers/pcmcia/ds.c
>> +++ b/drivers/pcmcia/ds.c
>> @@ -1100,7 +1100,9 @@ static ssize_t pcmcia_store_allow_func_id_match(struct device *dev,
>>  	if (!count)
>>  		return -EINVAL;
>>  
>> -	mutex_lock(&p_dev->socket->skt_mutex);
>> +	if (!mutex_trylock(&p_dev->socket->skt_mutex)) 
>> +		return -EAGAIN;
>> +
>>  	p_dev->allow_func_id_match = 1;
>>  	mutex_unlock(&p_dev->socket->skt_mutex);
>>  
>>     
>
> This is a pretty sad-looking solution.  Does it not mean that sometimes
> user-initiated actions will mysteriously fail?
>   
The userspace application should return the appropriate error then. It 
can really happen any time when someone tries to eject the pcmcia device 
(any time as within 1 minute - never in a normal scenario)

> Are you able to provide a more detailed description of why/how the deadlock
> actually occurs so that perhaps a more robust fix can be implemented?
>
>   
There's a description about it in following Email:
http://lkml.org/lkml/2007/2/19/58

Markus


