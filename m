Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYGSKdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYGSKdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYGSKdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:33:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYGSKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:33:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4881C2C3.1070004@s5r6.in-berlin.de>
Date: Sat, 19 Jul 2008 12:32:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, krh@redhat.com
Subject: Re: PATCH] firewire: add padding to some struct
References: <416384276.24780@ustc.edu.cn>	<416443505.10974@ustc.edu.cn> <416453387.04151@ustc.edu.cn>
In-Reply-To: <416453387.04151@ustc.edu.cn>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JiSheng Zhang wrote:
> On Fri, 18 Jul 2008 17:27:44 +0200
> Mikael Pettersson <mikpe@it.uu.se> wrote:
>> JiSheng Zhang writes:
>>  > --- old/drivers/firewire/fw-cdev.c	2008-07-14 05:51:29.000000000 +0800
>>  > +++ new/drivers/firewire/fw-cdev.c	2008-07-18 20:20:45.841328585 +0800
>>  > @@ -382,9 +382,9 @@
>>  >  
>>  >  	response->response.type   = FW_CDEV_EVENT_RESPONSE;
>>  >  	response->response.rcode  = rcode;
>>  > -	queue_event(client, &response->event,
>>  > -		    &response->response, sizeof(response->response),
>>  > -		    response->response.data, response->response.length);
>>  > +	queue_event(client, &response->event, &response->response, 
>>  > +		    sizeof(response->response) + response->response.length,
>>  > +		    NULL, 0);
>>  >  }
>>
>> Neither of these look correct.
>> If sizeof(struct ...) != offsetof(struct ..., data) as you claim is possible,
>> then the old code will copy too much to/from ->response but the correct amount
>> to/from ->response.data, and the new code will copy too much to/from ->response.data.
> 
> The old code will copy 4 extra bytes totally on some platforms, the new code
> is correct. The old one queue like this:
> struct ...(excluding the padding bytes)|4 padding bytes|4 padding bytes|data
> 
>> That's why C has offsetof():
>>
>> 	queue_event(client, &response->event,
>> 		   &response->response,
>> 		   offsetof(typeof(*response->responce), data), // I don't know the struct name
>> 		   response->response.data, response->response.length);

sizeof(struct ...) != offsetof(struct ..., data) happens for example on 
x86-64.

This is what I get with the current firewire drivers in a block read 
response from firecontrol on i686:

	Command: r . 0 0xfffff0000400 20
	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
	read succeeded. Data follows (hex):
	04 04 04 8F
	31 33 39 34
	F0 00 A2 22
	00 10 DC 56
	00 FE D2 D4
	Ack code: complete

And the same on x86-64:

	Command: r . 0 0xfffff0000400 20
	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
	read succeeded. Data follows (hex):
	04 04 04 8F
	04 04 04 8F
	31 33 39 34
	F0 00 A2 22
	00 10 DC 56
	Ack code: complete

	Command: r . 0 0xfffff0000400 24
	reading from node 0, bus 1023, offset 0XFFFFF0000400 20 bytes
	read succeeded. Data follows (hex):
	04 04 04 8F
	04 04 04 8F
	31 33 39 34
	F0 00 A2 22
	00 10 DC 56
	00 FE D2 D4
	Ack code: complete

I used libraw1394 from Dan's git repo.  Gscanbus shows exactly the same 
results.  So, x86-64 and all other architectures where struct 
fw_cdev_event* are aligned on u64 boundaries are currently seriously 
broken... but nobody noticed it before.  The only breakage which I saw 
(and is obviously the result of this bug) is that gscanbus shows a wrong 
bus topology on x86-64 but the correct one on i686.  The damage from 
this bug is limited though because
   - most applications send requests which get responses with 0 or 4
     bytes payload,
   - no application (which can run on both old and new stack without
     change) uses address range mappings, i.e. get incoming requests.

I'll look further into your proposed fix.
-- 
Stefan Richter
-=====-==--- -=== =--==
http://arcgraph.de/sr/
