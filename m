Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0CKDUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:20:38 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:52735 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0CKDUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:20:36 -0500
Date: Thu, 11 Mar 2010 14:20:34 +1100
From: Simon Horman <horms@verge.net.au>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "ss@aao.gov.au" <ss@aao.gov.au>
Subject: Re: [PATCH] staging/dt3155: make copy_{to/from}_user and put_user
 typesafe
Message-ID: <20100311032034.GB3023@verge.net.au>
References: <201003041020.19046.hartleys@visionengravers.com>
 <20100311000109.GA12006@verge.net.au>
 <0D753D10438DA54287A00B027084269763683A7936@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269763683A7936@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 06:19:32PM -0600, H Hartley Sweeten wrote:
> On Wednesday, March 10, 2010 5:01 PM, Simon Horman wrote:
> > On Thu, Mar 04, 2010 at 10:20:18AM -0700, H Hartley Sweeten wrote:
> >> This makes the kernel to user space data transfers typesafe and removes
> >> a number of unnecessary (void *) casts.
> >
> > Could you be more specific about what you mean by typesafe?
> > There still seem to be casts in there. Although fewer than before :-)
> 
> >From include/asm-generic/uaccess.h
> 
> static inline long copy_from_user(void *to,
> 		const void __user * from, unsigned long n)
> {
> 	might_sleep();
> 	if (access_ok(VERIFY_READ, from, n))
> 		return __copy_from_user(to, from, n);
> 	else
> 		return n;
> }
> 
> static inline long copy_to_user(void __user *to,
> 		const void *from, unsigned long n)
> {
> 	might_sleep();
> 	if (access_ok(VERIFY_WRITE, to, n))
> 		return __copy_to_user(to, from, n);
> 	else
> 		return n;
> }
> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Greg Kroah-Hartman <greg@kroah.com>
> >> Cc: Scott Smedley <ss@aao.gov.au>
> >> 
> >> ---
> >> 
> >> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> >> index a67c622..76c9d94 100644
> >> --- a/drivers/staging/dt3155/dt3155_drv.c
> >> +++ b/drivers/staging/dt3155/dt3155_drv.c
> >> @@ -528,6 +528,7 @@ static int dt3155_ioctl(struct inode *inode,
> >>  			unsigned long arg)
> >>  {
> >>    int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
> >> +  void __user *up = (void __user *)arg;
> 
> This cast is needed, and common, since 'arg' is passed as an unsigned long.
> The cast to __user memory space does not produce a sparse error.
> 
> >>  
> >>    if ( minor >= MAXBOARDS || minor < 0 )
> >>      return -ENODEV;
> >> @@ -554,7 +555,7 @@ static int dt3155_ioctl(struct inode *inode,
> >>  
> >>  	{
> >>  	  struct dt3155_config_s tmp;
> >> -	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
> 
> The fist void * cast is unnecessary, the second produces a sparse warning
> since copy_from_user expects 'arg' to be a __user space pointer.
> 
> >> +	  if (copy_from_user(&tmp, up, sizeof(tmp)))
> 
> Using the 'up' (user pointer) variable quiets the warning and makes the
> function call typesafe (ok maybe that's the wrong term...).
> 
> >>  	      return -EFAULT;
> >>  	  /* check for valid settings */
> >>  	  if (tmp.rows > DT3155_MAX_ROWS ||
> >> @@ -572,8 +573,7 @@ static int dt3155_ioctl(struct inode *inode,
> >>        }
> >>      case DT3155_GET_CONFIG:
> >>        {
> >> -	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
> >> -		     sizeof(dt3155_status_t) ))
> 
> Here 'arg' should be a __user space pointer and the second cast is not
> necessary.
> 
> >> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
> 
> Again, using 'up' fixes the sparse warning.
> 
> The two below are the same.
> 
> >>  	    return -EFAULT;
> >>  	return 0;
> >>        }
> >> @@ -593,8 +593,7 @@ static int dt3155_ioctl(struct inode *inode,
> >>  	  return 0;
> >>  
> >>  	quick_stop(minor);
> >> -	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
> >> -		     sizeof(dt3155_status_t)))
> >> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
> >>  	    return -EFAULT;
> >>  	return 0;
> >>        }
> >> @@ -617,8 +616,7 @@ static int dt3155_ioctl(struct inode *inode,
> >>  	  }
> >>  
> >>  	dt3155_init_isr(minor);
> >> -	if (copy_to_user( (void *) arg, (void *) &dt3155_status[minor],
> >> -		      sizeof(dt3155_status_t)))
> >> +	if (copy_to_user(up, &dt3155_status[minor], sizeof(dt3155_status_t)))
> >>  	    return -EFAULT;
> >>  	return 0;
> >>        }
> >> @@ -819,11 +817,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
> >>    /* make this an offset */
> >>    offset = frame_info_p->addr - dt3155_status[minor].mem_addr;
> >>  
> >> -  put_user(offset, (unsigned int *) buf);
> >> +  put_user(offset, (unsigned int __user *)buf);
> 
> For put_user, the second argument should be a __user pointer. 'buf' comes into the
> function correctly (char __user *) but needs the cast here so that the correct
> 'size' of data is copied to __user space.  Same below.
> 
> >>    buf += sizeof(u32);
> >> -  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
> >> +  put_user( dt3155_status[minor].fbuffer.frame_count, (unsigned int __user *)buf);
> >>    buf += sizeof(u32);
> >> -  put_user(dt3155_status[minor].state, (unsigned int *) buf);
> >> +  put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
> >>    buf += sizeof(u32);
> >>    if (copy_to_user(buf, frame_info_p, sizeof(frame_info_t)))
> >>        return -EFAULT;
> 
> All of this seems pretty common in other kernel code.  And it removes a
> number of the sparse warnings generated by this file.

Hi,

thanks for the clarification. I agree that your patch is an improvement
and I don't see any problems with it (other than typesafe possibly being the
wrong term).

