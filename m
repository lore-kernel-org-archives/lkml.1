Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbXDBJnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbXDBJnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965320AbXDBJnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:43:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23028 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbXDBJnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:43:49 -0400
Date: Mon, 2 Apr 2007 11:42:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Rene Herman <rene.herman@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Message-ID: <20070402094243.GH11996@kernel.dk>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <4610CDB4.4050708@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4610CDB4.4050708@panasas.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02 2007, Boaz Harrosh wrote:
> Pekka J Enberg wrote:
> > On Mon, 2 Apr 2007, Jens Axboe wrote:
> >> But as I wrote earlier, it'll take lots more to make this driver close 
> >> to functional.
> > 
> > Heh, looking at the driver, that's quite an understatement =). Rene, 
> > here's an untested attempt to use a mutex instead of the horribly broken 
> > waitqueue "synchronization" in mcdx. It may or may not help so give it a 
> > spin if you want.
> > 
> > 			Pekka
> > 
> > ---
> >  drivers/cdrom/mcdx.c |  121 ++++++++++++++++++---------------------------------
> >  1 file changed, 44 insertions(+), 77 deletions(-)
> > 
> > Index: 2.6/drivers/cdrom/mcdx.c
> > ===================================================================
> > --- 2.6.orig/drivers/cdrom/mcdx.c	2007-04-02 11:50:40.000000000 +0300
> > +++ 2.6/drivers/cdrom/mcdx.c	2007-04-02 11:51:20.000000000 +0300
> > @@ -58,6 +58,7 @@     = "$Id: mcdx.c,v 1.21 1997/01/26 07:
> >  
> >  #include <linux/module.h>
> >  
> > +#include <linux/delay.h>
> >  #include <linux/errno.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/fs.h>
> > @@ -151,15 +152,14 @@ struct s_version {
> >  /* Per drive/controller stuff **************************************/
> >  
> >  struct s_drive_stuff {
> > +	struct mutex mutex;
> > +
> >  	/* waitqueues */
> >  	wait_queue_head_t busyq;
> > -	wait_queue_head_t lockq;
> > -	wait_queue_head_t sleepq;
> >  
> >  	/* flags */
> >  	volatile int introk;	/* status of last irq operation */
> >  	volatile int busy;	/* drive performs an operation */
> > -	volatile int lock;	/* exclusive usage */
> >  
> >  	/* cd infos */
> >  	struct s_diskinfo di;
> > @@ -266,7 +266,6 @@ static unsigned int uint2bcd(unsigned in
> >  static unsigned int bcd2uint(unsigned char);
> >  static unsigned port(int *);
> >  static int irq(int *);
> > -static void mcdx_delay(struct s_drive_stuff *, long jifs);
> >  static int mcdx_transfer(struct s_drive_stuff *, char *buf, int sector,
> >  			 int nr_sectors);
> >  static int mcdx_xfer(struct s_drive_stuff *, char *buf, int sector,
> > @@ -287,7 +286,7 @@ static int mcdx_requestmultidiskinfo(str
> >  static int mcdx_requesttocdata(struct s_drive_stuff *, struct s_diskinfo *,
> >  			       int);
> >  static int mcdx_getstatus(struct s_drive_stuff *, int);
> > -static int mcdx_getval(struct s_drive_stuff *, int to, int delay, char *);
> > +static int mcdx_getval(struct s_drive_stuff *, int to, int delay_sec, char *);
> >  static int mcdx_talk(struct s_drive_stuff *,
> >  		     const unsigned char *cmd, size_t,
> >  		     void *buffer, size_t size, unsigned int timeout, int);
> > @@ -577,56 +576,57 @@ static void do_mcdx_request(request_queu
> >  	if (!req)
> >  		return;
> >  
> > +	if (!blk_fs_request(req)) {
> > +		end_request(req, 0);
> > +		goto again;
> > +	}
> > +
> >  	stuffp = req->rq_disk->private_data;
> >  
> >  	if (!stuffp->present) {
> >  		xwarn("do_request(): bad device: %s\n",req->rq_disk->disk_name);
> >  		xtrace(REQUEST, "end_request(0): bad device\n");
> >  		end_request(req, 0);
> > -		return;
> > +		goto again;
> >  	}
> >  
> >  	if (stuffp->audio) {
> >  		xwarn("do_request() attempt to read from audio cd\n");
> >  		xtrace(REQUEST, "end_request(0): read from audio\n");
> >  		end_request(req, 0);
> > -		return;
> > +		goto again;
> >  	}
> >  
> >  	xtrace(REQUEST, "do_request() (%lu + %lu)\n",
> >  	       req->sector, req->nr_sectors);
> >  
> > -	if (req->cmd != READ) {
> > +	if (rq_data_dir(req) != READ) {
> >  		xwarn("do_request(): non-read command to cd!!\n");
> >  		xtrace(REQUEST, "end_request(0): write\n");
> >  		end_request(req, 0);
> > -		return;
> > -	}
> > -	else {
> > -		stuffp->status = 0;
> > -		while (req->nr_sectors) {
> > -			int i;
> > -
> > -			i = mcdx_transfer(stuffp,
> > -					  req->buffer,
> > -					  req->sector,
> > -					  req->nr_sectors);
> > -
> > -			if (i == -1) {
> > -				end_request(req, 0);
> > -				goto again;
> > -			}
> > -			req->sector += i;
> > -			req->nr_sectors -= i;
> > -			req->buffer += (i * 512);
> > -		}
> > -		end_request(req, 1);
> >  		goto again;
> > -
> > -		xtrace(REQUEST, "end_request(1)\n");
> > -		end_request(req, 1);
> >  	}
> >  
> > +	stuffp->status = 0;
> > +	while (req->nr_sectors) {
> > +		int i;
> > +
> > +		spin_unlock_irq(q->queue_lock);
> > +		i = mcdx_transfer(stuffp,
> > +				  req->buffer,
> > +				  req->sector,
> > +				  req->nr_sectors);
> > +		spin_lock_irq(q->queue_lock);
> > +
> > +		if (i == -1) {
> > +			end_request(req, 0);
> > +			goto again;
> > +		}
> > +		req->sector += i;
> > +		req->nr_sectors -= i;
> > +		req->buffer += (i * 512);
> > +	}
> > +	end_request(req, 1);
> >  	goto again;
> >  }
> >  
> > @@ -825,26 +825,6 @@ __setup("mcdx=", mcdx_setup);
> >  
> >  /* DIRTY PART ******************************************************/
> >  
> > -static void mcdx_delay(struct s_drive_stuff *stuff, long jifs)
> > -/* This routine is used for sleeping.
> > - * A jifs value <0 means NO sleeping,
> > - *              =0 means minimal sleeping (let the kernel
> > - *                 run for other processes)
> > - *              >0 means at least sleep for that amount.
> > - *	May be we could use a simple count loop w/ jumps to itself, but
> > - *	I wanna make this independent of cpu speed. [1 jiffy is 1/HZ] sec */
> > -{
> > -	if (jifs < 0)
> > -		return;
> > -
> > -	xtrace(SLEEP, "*** delay: sleepq\n");
> > -	interruptible_sleep_on_timeout(&stuff->sleepq, jifs);
> > -	xtrace(SLEEP, "delay awoken\n");
> > -	if (signal_pending(current)) {
> > -		xtrace(SLEEP, "got signal\n");
> > -	}
> > -}
> > -
> >  static irqreturn_t mcdx_intr(int irq, void *dev_id)
> >  {
> >  	struct s_drive_stuff *stuffp = dev_id;
> > @@ -902,13 +882,7 @@ static int mcdx_talk(struct s_drive_stuf
> >  	if ((discard = (buffer == NULL)))
> >  		buffer = &c;
> >  
> > -	while (stuffp->lock) {
> > -		xtrace(SLEEP, "*** talk: lockq\n");
> > -		interruptible_sleep_on(&stuffp->lockq);
> > -		xtrace(SLEEP, "talk: awoken\n");
> > -	}
> > -
> > -	stuffp->lock = 1;
> > +	mutex_lock(&stuffp->mutex);
> >  
> >  	/* An operation other then reading data destroys the
> >  	   * data already requested and remembered in stuffp->request, ... */
> > @@ -992,8 +966,7 @@ 			xtrace(TALK, "talk() got 0x%02x\n", *
> >  		xinfo("talk() giving up\n");
> >  #endif
> >  
> > -	stuffp->lock = 0;
> > -	wake_up_interruptible(&stuffp->lockq);
> > +	mutex_unlock(&stuffp->mutex);
> >  
> >  	xtrace(TALK, "talk() done with 0x%02x\n", st);
> >  	return st;
> > @@ -1106,9 +1079,9 @@ 	stuffp->present = 0;	/* this should be 
> >  	stuffp->wreg_hcon = stuffp->wreg_reset + 1;
> >  	stuffp->wreg_chn = stuffp->wreg_hcon + 1;
> >  
> > +	mutex_init(&stuffp->mutex);
> > +
> >  	init_waitqueue_head(&stuffp->busyq);
> > -	init_waitqueue_head(&stuffp->lockq);
> > -	init_waitqueue_head(&stuffp->sleepq);
> >  
> >  	/* check if i/o addresses are available */
> >  	if (!request_region(stuffp->wreg_data, MCDX_IO_SIZE, "mcdx")) {
> > @@ -1203,7 +1176,7 @@ 		return 0;
> >  	xtrace(INIT, "init() get garbage\n");
> >  	{
> >  		int i;
> > -		mcdx_delay(stuffp, HZ / 2);
> > +		msleep_interruptible(500);
> >  		for (i = 100; i; i--)
> >  			(void) inb(stuffp->rreg_status);
> >  	}
> > @@ -1327,10 +1300,6 @@ 	int done = 0;
> >  		return -1;
> >  	}
> >  
> > -	while (stuffp->lock) {
> > -		interruptible_sleep_on(&stuffp->lockq);
> > -	}
> > -
> >  	if (stuffp->valid && (sector >= stuffp->pending)
> >  	    && (sector < stuffp->low_border)) {
> >  
> > @@ -1346,7 +1315,7 @@ 	int done = 0;
> >  						sector + nr_sectors)
> >  		    ? stuffp->high_border : border;
> >  
> > -		stuffp->lock = current->pid;
> > +		mutex_lock(&stuffp->mutex);
> >  
> >  		do {
> >  
> > @@ -1366,11 +1335,11 @@ 	int done = 0;
> >  				} else
> >  					continue;
> >  
> > -				stuffp->lock = 0;
> > +				mutex_unlock(&stuffp->mutex);
> > +
> >  				stuffp->busy = 0;
> >  				stuffp->valid = 0;
> >  
> > -				wake_up_interruptible(&stuffp->lockq);
> >  				xtrace(XFER, "transfer() done (-1)\n");
> >  				return -1;
> >  			}
> > @@ -1405,9 +1374,7 @@ 				insb(stuffp->rreg_data, &dummy[0], C
> >  			}
> >  		} while (++(stuffp->pending) < border);
> >  
> > -		stuffp->lock = 0;
> > -		wake_up_interruptible(&stuffp->lockq);
> > -
> > +		mutex_unlock(&stuffp->mutex);
> >  	} else {
> >  
> >  		/* The requested sector(s) is/are out of the
> > @@ -1654,7 +1621,7 @@ 	       cmd[0], cmd[1], cmd[2], cmd[3], 
> >  
> >  	outsb(stuffp->wreg_data, cmd, sizeof cmd);
> >  
> > -	if (-1 == mcdx_getval(stuffp, 3 * HZ, 0, NULL)) {
> > +	if (-1 == mcdx_getval(stuffp, 3, 0, NULL)) {
> >  		xwarn("playmsf() timeout\n");
> >  		return -1;
> >  	}
> > @@ -1907,7 +1874,7 @@ 	return mcdx_talk(stuffp, "\x40", 1, NUL
> >  }
> >  
> >  static int
> > -mcdx_getval(struct s_drive_stuff *stuffp, int to, int delay, char *buf)
> > +mcdx_getval(struct s_drive_stuff *stuffp, int to, int delay_sec, char *buf)
> >  {
> >  	unsigned long timeout = to + jiffies;
> >  	char c;
> > @@ -1918,7 +1885,7 @@ mcdx_getval(struct s_drive_stuff *stuffp
> >  	while (inb(stuffp->rreg_status) & MCDX_RBIT_STEN) {
> >  		if (time_after(jiffies, timeout))
> >  			return -1;
> > -		mcdx_delay(stuffp, delay);
> > +		msleep_interruptible(delay_sec * 1000);
> >  	}
> >  
> >  	*buf = (unsigned char) inb(stuffp->rreg_data) & 0xff;
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> NACK
> 
> Why are you using req->buffer in new code. req->buffer is a leftover from a
> very old block pc era and is supposed to be killed. Please do not use it in
> any new code.
> you should use bio_data(rq->bio) and if you must have a virtual memory pointer
> hanging around than keep it in private space.

While that is true, this is ancient crap code and there's not much point
in rewriting that part as well. I somehow doubt that the cards are
capable of highmem addressing in the first place :-)

-- 
Jens Axboe

