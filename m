Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZJPUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZJPUET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZJPUES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 16:04:18 -0400
Received: from maila.microsoft.com ([131.107.115.212]:18958 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZJPUER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 16:04:17 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <gregkh@suse.de>
CC: Tom Hanrahan <hanrahat@microsoft.com>, Hashir Abdi <habdi@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AQHKTpvI2Qt/IH8WRE6NME3Av5PQZw==
Date: Fri, 16 Oct 2009 20:03:35 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7B5EA9@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20091012153013.GA2062@suse.de>
	 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 <20091012172953.GA10557@suse.de>
	 <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <84144f020910122208k1fde7e60hce873e81a6436f57@mail.gmail.com>
In-Reply-To: <84144f020910122208k1fde7e60hce873e81a6436f57@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg / Pecca,

>We don't merge fixes to the kernel unless we understand _why_ they fix
>things. It's pretty likely that the problem here is that one or more
>of the structs you are putting under "#pragma pack" just need to be
>annotated with "attribute packed".

We have figured out what the problem is with it. 

It seems that the #pragma pack(push,1) doesn't change the size 
of "enum vmbus_channel_message_type", the size remains as 4 bytes, 
which is the default. I do not know if this is the result of
a gcc bug.

If you add __attribute__((packed)) here, the size becomes 1 byte, 
which couldn't be accepted by HyperV host, and causes vmbus load 
to hang.

So, the different behavior of #pragma pack(push,1) v.s.  
__attribute__((packed)) on the data struct, "enum vmbus_channel_message_type",
caused this bug. The fix is to remove __attribute__((packed)) of this data. 
We don't need to add #pragma pack(push,1) or #pragma pack(pop) here, since 
it has no effect on this structure. (BTW, seems it's a bug of gcc's 
handling of pragma pack().)

I will submit a patch later today that corrects the bug.

This patch in effect removes part of a previous patch somebody else 
Submitted that introduced this problem.

This bug masked another problem we encountered as soon as we fixed this
Problem. I am getting a NULL pointer problem on insertion of the hv_vmbus
Driver. I will write a more detailed description of that problem and send 
It to the list.

I checked the originally submitted code, and made that work with 2.6.32.
And that does run okay. 

Thanks,

Hank.

