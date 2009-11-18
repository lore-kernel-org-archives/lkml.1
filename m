Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZKRPCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZKRPCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZKRPCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:02:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:38439 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZKRPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:02:24 -0500
Message-ID: <4B040C82.6070901@codemonkey.ws>
Date: Wed, 18 Nov 2009 09:02:26 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Adam Litke <agl@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver (V2)
References: <1258488996.2820.35.camel@aglitke>	<1258490189.2820.37.camel@aglitke> <200911181200.39971.rusty@rustcorp.com.au>
In-Reply-To: <200911181200.39971.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 18 Nov 2009 07:06:29 am Adam Litke wrote:
>   
>> virtio: Add memory statistics reporting to the balloon driver (V2)
>>
>> Changes since V1:
>>  - Use a virtqueue instead of the device config space
>>     
>
> Hi Adam,
>
>     If Anthony's happy, I'm happy with this approach.
>
> Couple of minor points:
>
>   
>> +static inline void update_stat(struct virtio_balloon *vb, int idx,
>> +				unsigned int tag, unsigned long val)
>> +{
>> +	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
>> +	vb->stats[idx].tag = tag;
>> +	vb->stats[idx].val = cpu_to_le32(val);
>> +}
>>     
>
> The little-endian conversion of the balloon driver is a historical mistake
> (no other driver does this).  Let's not extend it to the stats.
>   

I think the mistake is that the other drivers don't do that.

We cheat in qemu and assume that the guest is always in a fixed 
endianness but this is not always the case for all architectures.

That said, since we make this mistake everywhere, I guess I understand 
the argument to have consistency and to just admit that we're broken 
here.  But this is where the endianness bits come from.

> Here you've done one and not the other, which is even worse.  (Sparse would
> have found this, I assume).
>   

Yup, that's definitely wrong.

>> +struct virtio_balloon_stat
>> +{
>> +	__le16 tag;
>> +	__le32 val;
>> +};
>>     
>
> Is 32 bits sufficient?  A big machine might get over 4bn faults, and certainly
> 4 TB of memory isn't that far away.
>   

I think making the interface u64 and byte based would be the best 
solution.  Making assumptions about page size across guest and host is 
another thing we should try to avoid.

Regards,

Anthony Liguori
