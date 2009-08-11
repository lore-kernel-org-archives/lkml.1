Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbZHKXsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbZHKXsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZHKXsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:48:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:51436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZHKXsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ocUxY3WxuthlKvsVppndXJSqrJL7QM25NDV2uh6OI59fzvNA6urd4y//2X+/iKEnwG
         fNCtIjz7wlJGNMC9WkuNYVPtwJCEzvIDEVth9UIyqtpllFHZWphjna2UzbG46eMCg27B
         RZ4baPRx26XVh1PXb2n5g+PblgKArSULPUq30=
Date: Wed, 12 Aug 2009 07:48:38 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       gregkh@suse.de
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-ID: <20090811234838.GA2008@darkstar>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org> <20090807134659.GA2093@darkstar> <20090807094944.eed4bfb8.akpm@linux-foundation.org> <a8e1da0908080313k65f51185u7329e293a95861a7@mail.gmail.com> <20090811140824.GA2067@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090811140824.GA2067@darkstar>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:08:24PM +0800, Dave Young wrote:
> On Sat, Aug 08, 2009 at 06:13:53PM +0800, Dave Young wrote:
> > On Sat, Aug 8, 2009 at 12:49 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > > On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > >> Hi, andrew
> > >>
> > >> Booting with this release, init (maybe getty?) reports something like:
> > >>
> > >> INIT: open /dev/console failed with input/output error
> > >>
> > >> 2.6.31-rc5 is fine.
> > >>
> > >> Any hints to find the root problem?
> > >
> > > Not really, sorry.  Might be tty changes in linux-next?
> > 
> > I bisected linux-next, find following patch as a result
> > 
> > commit 65b8c7d9be5862ff8ac839607b444b6f6b11d2fb
> > Author: Alan Cox <alan@linux.intel.com>
> > Date:   Thu Aug 6 09:58:02 2009 +1000
> > 
> >     cyclades: use the full port_close function
> > 
> > But, I did not select cyclades in my .config, nor do i have the hardware. Weird.
> 
> The above result is wrong, it's a mistake.
> 
> After a whole day's testing and debugging with linux-2.6 git tree and tty patch series, I found the patch causing this issue. 
> --
> From: Alan Cox <alan@linux.intel.com>
> Subject: tty: make the kref destructor occur asynchronously
> --
> 
> If we make the tty release in a work queue, then tty_reopen might fail with -EIO. I read the sysvinit source code, it will retry 5 times, if still failed, it will warning, then no output before login.
> 
> My distribution is slackware 12.2
> 
> I tested with following debug patch.
> 
> --- linux-2.6.orig/drivers/char/tty_io.c	2009-08-11 21:29:03.000000000 +0800
> +++ linux-2.6/drivers/char/tty_io.c	2009-08-11 21:40:01.000000000 +0800
> @@ -1246,8 +1246,10 @@ static int tty_reopen(struct tty_struct 
>  {
>  	struct tty_driver *driver = tty->driver;
>  
> -	if (test_bit(TTY_CLOSING, &tty->flags))
> +	if (test_bit(TTY_CLOSING, &tty->flags)) {
> +		printk(KERN_INFO "tty_io.c: closing\n");
>  		return -EIO;
> +	}
>  
>  	if (driver->type == TTY_DRIVER_TYPE_PTY &&
>  	    driver->subtype == PTY_TYPE_MASTER) {
> @@ -1255,8 +1257,10 @@ static int tty_reopen(struct tty_struct 
>  		 * special case for PTY masters: only one open permitted,
>  		 * and the slave side open count is incremented as well.
>  		 */
> -		if (tty->count)
> +		if (tty->count) {
> +			printk(KERN_INFO "tty_io.c: open count %d\n", tty->count);
>  			return -EIO;
> +		}
>  
>  		tty->link->count++;
>  	}
> @@ -1705,6 +1709,7 @@ static int __tty_open(struct inode *inod
>  	int index;
>  	dev_t device = inode->i_rdev;
>  	unsigned saved_flags = filp->f_flags;
> +	static int t;
>  
>  	nonseekable_open(inode, filp);
>  
> @@ -1778,8 +1783,15 @@ got_driver:
>  
>  	mutex_unlock(&tty_mutex);
>  	tty_driver_kref_put(driver);
> -	if (IS_ERR(tty))
> +	if (IS_ERR(tty)) {
> +		int r = PTR_ERR(tty);
> +		if (t == 5) {
> +			printk(KERN_INFO "%s: %d, %d, retval: %d\n", __FILE__, __LINE__, r, retval);
> +			t =0;
> +		} else
> +			t++;
>  		return PTR_ERR(tty);
> +	}
>  
>  	filp->private_data = tty;
>  	file_move(filp, &tty->tty_files);
> 
> 

Here is a fix for that issue, please help to review.
--

Due to tty release routines runs in workqueue now,
error like following will be reported while booting:

INIT open /dev/console input/output error

Opening a tty while closing not finished is what cause such problem.

Fix it by flush hangup_work in such case and then call tty_init_dev.


Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
--
drivers/char/tty_io.c |   11 ++++++++---
1 file changed, 8 insertions(+), 3 deletions(-)

--- linux-2.6.orig/drivers/char/tty_io.c	2009-08-12 07:12:31.000000000 +0800
+++ linux-2.6/drivers/char/tty_io.c	2009-08-12 07:31:30.000000000 +0800
@@ -1770,9 +1770,14 @@ got_driver:
 	}
 
 	if (tty) {
-		retval = tty_reopen(tty);
-		if (retval)
-			tty = ERR_PTR(retval);
+		if (test_bit(TTY_CLOSING, &tty->flags)) {
+			flush_work(&tty->hangup_work);
+			tty = tty_init_dev(driver, index, 0);
+		} else {
+			retval = tty_reopen(tty);
+			if (retval)
+				tty = ERR_PTR(retval);
+		}
 	} else
 		tty = tty_init_dev(driver, index, 0);
 
