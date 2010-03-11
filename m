Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0CKAUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:20:50 -0500
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:33627 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0CKAUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:20:49 -0500
X-MXL-Hash: 4b9837615628a90d-66aa466ac261ef54f8b8025d4536028c6cf0e35d
X-MXL-Hash: 4b98375923699eff-83716b2de24a0b7f2af80471cb28f51184d9dc06
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Simon Horman <horms@verge.net.au>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Wed, 10 Mar 2010 18:19:32 -0600
Subject: RE: [PATCH] staging/dt3155: make copy_{to/from}_user and put_user
 typesafe
Thread-Topic: [PATCH] staging/dt3155: make copy_{to/from}_user and put_user
 typesafe
Thread-Index: AcrArfcEZiwhOHIFQ06pbl8vnzwcBgAACMew
Message-ID: <0D753D10438DA54287A00B027084269763683A7936@AUSP01VMBX24.collaborationhost.net>
References: <201003041020.19046.hartleys@visionengravers.com>
 <20100311000109.GA12006@verge.net.au>
In-Reply-To: <20100311000109.GA12006@verge.net.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010030401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=5jEx8N6jqDYA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=2C6]
X-AnalysisOut: [YHBdLAAAA:8 a=F1UDBTwzT0NH2g3HLzMA:9 a=oinUovWEchMcdGqqAdI]
X-AnalysisOut: [A:7 a=QxHM6xBcHvm8wyTKiYvN8vP-bSsA:4 a=CjuIK1q_8ugA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10 a=mJMriH8CDpcA:10 a=9kwkbYWsJh5UlzMw:21 a=q]
X-AnalysisOut: [bed02UMcN947_fW:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 10, 2010 5:01 PM, Simon Horman wrote:
> On Thu, Mar 04, 2010 at 10:20:18AM -0700, H Hartley Sweeten wrote:
>> This makes the kernel to user space data transfers typesafe and removes
>> a number of unnecessary (void *) casts.
>
> Could you be more specific about what you mean by typesafe?
> There still seem to be casts in there. Although fewer than before :-)

>From include/asm-generic/uaccess.h

static inline long copy_from_user(void *to,
		const void __user * from, unsigned long n)
{
	might_sleep();
	if (access_ok(VERIFY_READ, from, n))
		return __copy_from_user(to, from, n);
	else
		return n;
}

static inline long copy_to_user(void __user *to,
		const void *from, unsigned long n)
{
	might_sleep();
	if (access_ok(VERIFY_WRITE, to, n))
		return __copy_to_user(to, from, n);
	else
		return n;
}

>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Greg Kroah-Hartman <greg@kroah.com>
>> Cc: Scott Smedley <ss@aao.gov.au>
>> 
>> ---
>> 
>> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
>> index a67c622..76c9d94 100644
>> --- a/drivers/staging/dt3155/dt3155_drv.c
>> +++ b/drivers/staging/dt3155/dt3155_drv.c
>> @@ -528,6 +528,7 @@ static int dt3155_ioctl(struct inode *inode,
>>  			unsigned long arg)
>>  {
>>    int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
>> +  void __user *up = (void __user *)arg;

This cast is needed, and common, since 'arg' is passed as an unsigned long.
The cast to __user memory space does not produce a sparse error.

>>  
>>    if ( minor >= MAXBOARDS || minor < 0 )
>>      return -ENODEV;
>> @@ -554,7 +555,7 @@ static int dt3155_ioctl(struct inode *inode,
>>  
>>  	{
>>  	  struct dt3155_config_s tmp;
>> -	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))

The fist void * cast is unnecessary, the second produces a sparse warning
since copy_from_user expects 'arg' to be a __user space pointer.

>> +	  if (copy_from_user(&tmp, up, sizeof(tmp)))

Using the 'up' (user pointer) variable quiets the warning and makes the
function call typesafe (ok maybe that's the wrong term...).

>>  	      return -EFAULT;
>>  	  /* check for valid settings */
>>  	  if (tmp.rows > DT3155_MAX_ROWS ||
>> @@ -572,8 +573,7 @@ static int dt3155_ioctl(struct inode *inode,
>>        }
>>      case DT3155_GET_CONFIG:
>>        {
>> -	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
>> -		     sizeof(dt3155_status_t) ))

Here 'arg' should be a __user space pointer and the second cast is not
necessary.

>> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))

Again, using 'up' fixes the sparse warning.

The two below are the same.

>>  	    return -EFAULT;
>>  	return 0;
>>        }
>> @@ -593,8 +593,7 @@ static int dt3155_ioctl(struct inode *inode,
>>  	  return 0;
>>  
>>  	quick_stop(minor);
>> -	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
>> -		     sizeof(dt3155_status_t)))
>> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
>>  	    return -EFAULT;
>>  	return 0;
>>        }
>> @@ -617,8 +616,7 @@ static int dt3155_ioctl(struct inode *inode,
>>  	  }
>>  
>>  	dt3155_init_isr(minor);
>> -	if (copy_to_user( (void *) arg, (void *) &dt3155_status[minor],
>> -		      sizeof(dt3155_status_t)))
>> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
>>  	    return -EFAULT;
>>  	return 0;
>>        }
>> @@ -819,11 +817,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
>>    /* make this an offset */
>>    offset = frame_info_p->addr - dt3155_status[minor].mem_addr;
>>  
>> -  put_user(offset, (unsigned int *) buf);
>> +  put_user(offset, (unsigned int __user *)buf);

For put_user, the second argument should be a __user pointer. 'buf' comes into the
function correctly (char __user *) but needs the cast here so that the correct
'size' of data is copied to __user space.  Same below.

>>    buf += sizeof(u32);
>> -  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
>> +  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int __user *)buf);
>>    buf += sizeof(u32);
>> -  put_user(dt3155_status[minor].state, (unsigned int *) buf);
>> +  put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
>>    buf += sizeof(u32);
>>    if (copy_to_user(buf, frame_info_p, sizeof(frame_info_t)))
>>        return -EFAULT;

All of this seems pretty common in other kernel code.  And it removes a number of
the sparse warnings generated by this file.

Regards,
Hartley
