Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZLARgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZLARgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZLARgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:36:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52772 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZLARgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkOxeD8cg+efbZi43jMWxPNuvsvYSJlnG8QXHkGj1WpAX7OoNK60DzYhy5XuTcVNbX
         FEeNTNKriwQmqL8ewp/pQearTuoQ5lPBakXxdqeD0qtp1BwAkl3ZsfrzraeskSX0uUYm
         SyrKg96EjGqr+rE5N52ZuwUAVZL4kNCWjiwlo=
Date: Tue, 1 Dec 2009 18:36:35 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/floppy.c: stylistic cleanups
Message-ID: <20091201173635.GB2688@joi.lan>
References: <1259001504.16503.79.camel@Joe-Laptop.home>
 <20091123.104130.117837098.davem@davemloft.net>
 <1259528449.29779.194.camel@Joe-Laptop.home>
 <20091129.165557.84377714.davem@davemloft.net>
 <20091130092837.4998f961@nehalam>
 <1259640820.13592.37.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259640820.13592.37.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 08:13:40PM -0800, Joe Perches wrote:
> On Mon, 2009-11-30 at 09:28 -0800, Stephen Hemminger wrote:
> > Rather than playing with the dangling operator format which seems to be a coding
> > style that only David cares about. Why not go through and fix the really ugly old
> > drivers that need it. For a good horror experience, go look at the floppy driver.
> 
> Just for you Stephen, here's a cleaned up version.
> Now to see if it gets applied, which I rather doubt.
> 
> Changes:
> 
> Removed macro definitions and uses of
> 	IN, OUT, LAST_OUT, CLEARSTRUCT, and CHECK_RESET
> Used C99 initializers
> Removed assigns from if statements
> Converted printks without KERN_ levels to pr_info and pr_cont
> Removed unnecessary braces
> Used print_hex_dump
> Moved leading logical tests to end of previous line
> Surrounded still ugly CALL and ECALL macro with do {} while (0)
> 
> Checkpatch complaints before:
> total: 393 errors, 132 warnings, 4647 lines checked
> 
> after:
> total: 1 errors, 11 warnings, 5352 lines checked
> 
> Compile tested only, x86 allyesconfig
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  drivers/block/floppy.c | 1853 +++++++++++++++++++++++++++++++++---------------
>  1 files changed, 1279 insertions(+), 574 deletions(-)
> 
>
...
> @@ -515,11 +1035,12 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
>  static DECLARE_WAIT_QUEUE_HEAD(command_done);
>  
>  #define NO_SIGNAL (!interruptible || !signal_pending(current))
> -#define CALL(x) if ((x) == -EINTR) return -EINTR
> -#define ECALL(x) if ((ret = (x))) return ret;
> -#define _WAIT(x,i) CALL(ret=wait_til_done((x),i))
> -#define WAIT(x) _WAIT((x),interruptible)
> -#define IWAIT(x) _WAIT((x),1)
> +
> +#define CALL(x)		do { if ((x) == -EINTR) return -EINTR; } while (0)
> +#define ECALL(x)	do { if ((ret = (x))) return ret; } while (0)
> +#define _WAIT(x, i)	CALL(ret = wait_til_done((x), i))
> +#define WAIT(x)		_WAIT((x), interruptible)
> +#define IWAIT(x)	_WAIT((x), 1)

why not remove these macros too? (probably in a seperate patch)
macros which hide "return" are very annoying...

...
> @@ -909,10 +1431,12 @@ static int _lock_fdc(int drive, int interruptible, int line)
>  	return 0;
>  }
>  
> -#define lock_fdc(drive,interruptible) _lock_fdc(drive,interruptible, __LINE__)
> +#define lock_fdc(drive, interruptible)			\
> +	_lock_fdc(drive, interruptible, __LINE__)
>  
> -#define LOCK_FDC(drive,interruptible) \
> -if (lock_fdc(drive,interruptible)) return -EINTR;
> +#define LOCK_FDC(drive, interruptible)	    \
> +	if (lock_fdc(drive, interruptible)) \
> +		return -EINTR;

another annoying macro
  
>  /* unlocks the driver */
>  static inline void unlock_fdc(void)
...
> @@ -1809,7 +2339,10 @@ static void recalibrate_floppy(void)
>  	debugt("recalibrate floppy:");
>  	do_floppy = recal_interrupt;
>  	output_byte(FD_RECALIBRATE);
> -	LAST_OUT(UNIT(current_drive));
> +	if (UNIT(current_drive) < 0) {
> +		reset_fdc();
> +		return;
> +	}
>  }

unneeded return

>  
>  /*
...
> @@ -3479,143 +4010,163 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
>  	/* convert compatibility eject ioctls into floppy eject ioctl.
>  	 * We do this in order to provide a means to eject floppy disks before
>  	 * installing the new fdutils package */
> -	if (cmd == CDROMEJECT ||	/* CD-ROM eject */
> -	    cmd == 0x6470 /* SunOS floppy eject */ ) {
> +	if (cmd == CDROMEJECT || cmd == 0x6470) {

please add descriptive constant

>  		DPRINT("obsolete eject ioctl\n");
>  		DPRINT("please use floppycontrol --eject\n");
>  		cmd = FDEJECT;
>  	}

