Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbYCUOzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbYCUOzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYCUOzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:55:38 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:38528 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYCUOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:55:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkFAKxo40fEAmHEZGdsb2JhbACRABwpmFc
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Date: Fri, 21 Mar 2008 16:55:30 +0200
User-Agent: KMail/1.9.9
Cc: Robert Fitzsimons <robfitz@273k.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <200803172351.56717.bonganilinux@mweb.co.za> <20080320142212.2361f6d8@gaivota>
In-Reply-To: <20080320142212.2361f6d8@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211655.31085.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
X-Scan-Signature: 14903c0132c7a84a2dd22db62a26812f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 19:22:12 Mauro Carvalho Chehab wrote:
> On Mon, 17 Mar 2008 23:51:56 +0200
>
8<
>
> Could you please test this small patch?
>
> diff -r 134d43b48b4a linux/drivers/media/video/bt8xx/bttv-driver.c
> --- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Tue Mar 18 23:46:37
> 2008 +0000 +++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Mar 20
> 14:20:54 2008 -0300 @@ -3288,6 +3288,7 @@ static int bttv_open(struct inode
> *inode
>  		return -ENOMEM;
>  	file->private_data = fh;
>  	*fh = btv->init;
> +	fh->btv = btv;
>  	fh->type = type;
>  	fh->ov.setup_ok = 0;
>  	v4l2_prio_open(&btv->prio,&fh->prio);
>
>
> Cheers,
> Mauro

Latest git with or without your patch still causes the oops..

The call trace that seems to be causing this oops is

radio
|-> ioctl(
       |->videodev.c:__video_do_ioctl
          |->v4l1-compat.c:v4l_compat_translate_ioctl
          |  case VIDIOCGTUNER: /*  get tuner information  */
          | {
          |      struct video_tuner      *tun = arg;
          |
          |      memset(&tun2,0,sizeof(tun2));
          |__ err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
               |->videodev.c:__video_do_ioctl
               |   case VIDIOC_G_TUNER:
               |   {
               |      struct v4l2_tuner *p=arg;
               |     __u32 index=p->index;
               |
               |      if (!vfd->vidioc_g_tuner)
               |          break;
               |
               |     memset(p,0,sizeof(*p));
               |     p->index=index;
               |
               |     ret=vfd->vidioc_g_tuner(file, fh, p);
               |_
                  |-> bttv_driver.c:radio_g_tuner
                  |  struct bttv_fh *fh = priv;
                  |  struct bttv *btv = fh->btv;
                  |  
                  |  if (UNSET == bttv_tvcards[btv->c.type].tuner)
                  |      return -EINVAL;
                  |  if (0 != t->index)
                  |    return -EINVAL;
                  |  mutex_lock(&btv->lock); 
                  |__
                       |-> mutex.c:__mutex_lock_common 
                       |  struct task_struct *task = current;
                       |  struct mutex_waiter waiter;
                       |  unsigned int old_val;
                       |  unsigned long flags;
                       |
                       |  spin_lock_mutex(&lock->wait_lock, flags);
                       |
                       |  debug_mutex_lock_common(lock, &waiter);
                       |  mutex_acquire(&lock->dep_map, subclass, 0, ip);
                       |  debug_mutex_add_waiter(lock, &waiter, 
task_thread_info(task));
                       |
                       |        /* add waiting tasks to the end of the 
waitqueue (FIFO): */
                       | list_add_tail(&waiter.list, &lock->wait_list); 
                         ^^^^
This is where it oops because lock->wait_list->next is NULL.

BUT, changing: 
memset(&tun2,0,sizeof(tun2));
to
memset(&tun2,-1,sizeof(tun2));
in
v4l1-compat.c:v4l_compat_translate_ioctl
...
 case VIDIOCGTUNER:

changes
lock->wait_list->next from being NULL to something else, and the oops move to 
the next case statement i.e. VIDIOCGFREQ





