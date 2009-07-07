Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZGGLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZGGLvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZGGLux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:50:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60259 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbZGGLuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:50:52 -0400
Message-ID: <4A53372E.6090509@redhat.com>
Date: Tue, 07 Jul 2009 14:53:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com>
In-Reply-To: <20090707112024.GA3647@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Davide, there's a small comment for you in the middle, search 
for eventfd)

On 07/07/2009 02:20 PM, Michael S. Tsirkin wrote:
>
>> @@ -307,6 +307,19 @@ struct kvm_guest_debug {
>>   	struct kvm_guest_debug_arch arch;
>>   };
>>
>> +#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1<<  0) /* trigger is valid */
>>      
>
> can we rename trigger ->  value?
>    

Or maybe data_match?

Speaking of renames, how about IOSIGNALFD -> IOEVENTFD?  I have some 
vague uneasiness seeing signals all the time.

>> +#define KVM_IOSIGNALFD_FLAG_PIO       (1<<  1) /* is a pio (otherwise mmio) */
>> +#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1<<  2)
>> +
>> +struct kvm_iosignalfd {
>> +	__u64 trigger;
>>      
>
> for length<8, it's the 8*len least significant bits that are used, right?
> That's a bit ugly ... Maybe just put an 8 byte array here instead, then
> the first len bytes are valid.
>
>    

We're matching the value as the guest wrote it.  I think this is fine.

>> +	struct kvm_io_device dev;
>> +	int                  wildcard:1;
>>      
>
> don't use bitfields
>    

Yeah, bool is better.

>> +		/* address-range must be precise for a hit */
>>      
>
> So there's apparently no way to specify that
> you want 1,2, or 4 byte writes at address X?
>    

Why would you want that?


>    
>> +		return false;
>> +
>> +	if (p->wildcard)
>> +		/* all else equal, wildcard is always a hit */
>> +		return true;
>> +
>> +	/* otherwise, we have to actually compare the data */
>> +
>> +	BUG_ON(!IS_ALIGNED((unsigned long)val, len));
>> +
>> +	switch (len) {
>> +	case 1:
>> +		_val = *(u8 *)val;
>> +		break;
>> +	case 2:
>> +		_val = *(u16 *)val;
>> +		break;
>> +	case 4:
>> +		_val = *(u32 *)val;
>> +		break;
>> +	case 8:
>> +		_val = *(u64 *)val;
>> +		break;
>> +	default:
>> +		return false;
>> +	}
>> +
>> +	return _val == p->match ? true : false;
>>      
>
> Life be simpler if we use an 8 byte array for match
> and just do memcmp here.
>    

My plan is to change the io_dev interface to pass a u64.

>> +
>> +	eventfd = eventfd_ctx_fdget(args->fd);
>> +	if (IS_ERR(eventfd))
>> +		return PTR_ERR(eventfd);
>>      
>
> since this eventfd is kept around indefinitely, we should keep the
> file * around as well, so that this eventfd is accounted for
> properly with # of open files limit set by the admin.
>    

Won't all eventfd_ctx_get() uses suffer from that?

Davide, I think this is better handled in eventfd.  Or else we can 
ignore it and trust whoever holds the eventfd_ctx to limit the mount of 
objects.

>> +
>> +int
>> +kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +	if (args->flags&  KVM_IOSIGNALFD_FLAG_DEASSIGN)
>> +		return kvm_deassign_iosignalfd(kvm, args);
>>      
>
> Better check that only known flag values are present.
> Otherwise when you add more flags things just break
> silently.
>    

Good comment and something that we miss a lot.

>> +	case KVM_IOSIGNALFD: {
>> +		struct kvm_iosignalfd data;
>> +
>> +		r = -EFAULT;
>>      
>
> this trick is nice, it saves a line of code for the closing brace
> but why waste it on an empty line above then?
>    

Traditionally C code separates declarations from code.

-- 
error compiling committee.c: too many arguments to function

