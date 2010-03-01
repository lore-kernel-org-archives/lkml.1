Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885Ab0CAIaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:30:08 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44711 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0CAIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:30:05 -0500
Date: Mon, 1 Mar 2010 09:29:16 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Avi Kivity <avi@redhat.com>, Reg Clemens <clemens@dwf.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-doc@vger.kernel.org
Message-ID: <20100301082916.GJ3671@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
	john stultz <johnstul@us.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	Avi Kivity <avi@redhat.com>, Reg Clemens <clemens@dwf.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
	linux-doc@vger.kernel.org
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
 <84b05b9e8dc74f46c99de1728dc5baf24d85d9cc.1267008049.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84b05b9e8dc74f46c99de1728dc5baf24d85d9cc.1267008049.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv2 4/6] pps: add kernel consumer support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:28:15PM +0300, Alexander Gordeev wrote:
> Add an optional feature of PPSAPI, kernel consumer support, which uses
> the added hardpps() function.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

However see the note below.

> ---
>  Documentation/ioctl/ioctl-number.txt |    2 +-
>  drivers/pps/kapi.c                   |   26 +++++++++++++
>  drivers/pps/pps.c                    |   67 +++++++++++++++++++++++++++++++++-
>  include/linux/pps.h                  |    7 ++++
>  include/linux/pps_kernel.h           |    6 +++
>  5 files changed, 106 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 9473749..d68718b 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -152,7 +152,7 @@ Code	Seq#	Include File		Comments
>  'p'	40-7F	linux/nvram.h
>  'p'	80-9F				user-space parport
>  					<mailto:tim@cyberelk.net>
> -'p'	a1-a4	linux/pps.h		LinuxPPS
> +'p'	a1-a5	linux/pps.h		LinuxPPS
>  					<mailto:giometti@linux.it>
>  'q'	00-1F	linux/serio.h
>  'q'	80-FF				Internet PhoneJACK, Internet LineJACK
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index b87f699..5871744 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -25,6 +25,7 @@
>  #include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/time.h>
> +#include <linux/timex.h>
>  #include <linux/spinlock.h>
>  #include <linux/idr.h>
>  #include <linux/fs.h>
> @@ -37,6 +38,12 @@
>  DEFINE_SPINLOCK(pps_idr_lock);
>  DEFINE_IDR(pps_idr);
>  
> +/* state variables to bind kernel consumer */
> +/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
> +DEFINE_SPINLOCK(pps_kc_hardpps_lock);
> +void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
> +int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
> +
>  /*
>   * Local functions
>   */
> @@ -248,6 +255,15 @@ void pps_unregister_source(int source)
>  	}
>  	spin_unlock_irq(&pps_idr_lock);
>  
> +	spin_lock_irq(&pps_kc_hardpps_lock);
> +	if (pps == pps_kc_hardpps_dev) {
> +		pps_kc_hardpps_mode = 0;
> +		pps_kc_hardpps_dev = NULL;
> +		spin_unlock_irq(&pps_kc_hardpps_lock);
> +		pr_info("unbound kernel consumer on device removal\n");
> +	} else
> +		spin_unlock_irq(&pps_kc_hardpps_lock);
> +

I suppose you are using such if-else schema due the fact pr_info is
too slow to be executed with helded spinlock, arent't you? :)

>  	pps_unregister_cdev(pps);
>  	pps_put_source(pps);
>  }
> @@ -325,6 +341,16 @@ void pps_event(int source, struct pps_event_time *ts, int event, void *data)
>  
>  		captured = ~0;
>  	}
> +	spin_lock(&pps_kc_hardpps_lock);
> +	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode) {
> +		struct timespec p_ts = {
> +			.tv_sec = ts->ts_real.sec,
> +			.tv_nsec = ts->ts_real.nsec
> +		};
> +
> +		hardpps(&p_ts, &ts->ts_raw);
> +	}
> +	spin_unlock(&pps_kc_hardpps_lock);
>  
>  	/* Wake up iif captured somthing */
>  	if (captured) {
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index ca5183b..22fdcfe 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -62,6 +62,8 @@ static long pps_cdev_ioctl(struct file *file,
>  	struct pps_device *pps = file->private_data;
>  	struct pps_kparams params;
>  	struct pps_fdata fdata;
> +	struct pps_bind_args bind_args;
> +	unsigned long irq_flags;
>  	unsigned long ticks;
>  	void __user *uarg = (void __user *) arg;
>  	int __user *iuarg = (int __user *) arg;
> @@ -186,9 +188,72 @@ static long pps_cdev_ioctl(struct file *file,
>  
>  		break;
>  
> +	case PPS_KC_BIND:
> +		pr_info("PPS_KC_BIND: source %d\n", pps->id);
> +
> +		/* Check the capabilities */
> +		if (!capable(CAP_SYS_TIME))
> +			return -EPERM;
> +
> +		if (copy_from_user(&bind_args, uarg,
> +					sizeof(struct pps_bind_args)))
> +			return -EFAULT;
> +
> +		/* Check for supported capabilities */
> +		if ((bind_args.edge & ~pps->info.mode) != 0) {
> +			pr_err("PPS_KC_BIND: "
> +					"unsupported capabilities (%x)\n",
> +					bind_args.edge);
> +			return -EINVAL;
> +		}
> +
> +		/* Validate parameters roughly */
> +		if (bind_args.tsformat != PPS_TSFMT_TSPEC ||
> +				(bind_args.edge & ~PPS_CAPTUREBOTH) != 0 ||
> +				bind_args.consumer != PPS_KC_HARDPPS) {
> +			pr_err("PPS_KC_BIND: "
> +					"invalid kcbind parameters (%x)\n",
> +					bind_args.edge);
> +			return -EINVAL;
> +		}
> +
> +		/* Check if another consumer is already bound */
> +		spin_lock_irqsave(&pps_kc_hardpps_lock, irq_flags);
> +
> +		if (bind_args.edge == 0)
> +			if (pps_kc_hardpps_dev == pps) {
> +				pps_kc_hardpps_mode = 0;
> +				pps_kc_hardpps_dev = NULL;
> +				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
> +						irq_flags);
> +				pr_info("unbound kernel consumer\n");
> +			} else {
> +				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
> +						irq_flags);
> +				pr_err("selected kernel consumer"
> +						" is not bound\n");
> +				return -EINVAL;
> +			}
> +		else
> +			if (pps_kc_hardpps_dev == NULL ||
> +					pps_kc_hardpps_dev == pps) {
> +				pps_kc_hardpps_mode = bind_args.edge;
> +				pps_kc_hardpps_dev = pps;
> +				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
> +						irq_flags);
> +				pr_info("bound kernel consumer: dev=%p, "
> +					"edge=0x%x\n", pps, bind_args.edge);
> +			} else {
> +				spin_unlock_irqrestore(&pps_kc_hardpps_lock,
> +						irq_flags);
> +				pr_err("another kernel consumer"
> +						" is already bound\n");
> +				return -EINVAL;
> +			}
> +		break;
> +
>  	default:
>  		return -ENOTTY;
> -		break;
>  	}
>  
>  	return 0;
> diff --git a/include/linux/pps.h b/include/linux/pps.h
> index 0194ab0..a9bb1d9 100644
> --- a/include/linux/pps.h
> +++ b/include/linux/pps.h
> @@ -114,11 +114,18 @@ struct pps_fdata {
>  	struct pps_ktime timeout;
>  };
>  
> +struct pps_bind_args {
> +	int tsformat;	/* format of time stamps */
> +	int edge;	/* selected event type */
> +	int consumer;	/* selected kernel consumer */
> +};
> +
>  #include <linux/ioctl.h>
>  
>  #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
>  #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
>  #define PPS_GETCAP		_IOR('p', 0xa3, int *)
>  #define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
> +#define PPS_KC_BIND		_IOW('p', 0xa5, struct pps_bind_args *)
>  
>  #endif /* _PPS_H_ */
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index 9bda892..2b203cd 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -80,6 +80,12 @@ extern struct timespec pps_irq_ts[];
>  
>  extern struct device_attribute pps_attrs[];
>  
> +/* state variables to bind kernel consumer */
> +/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
> +extern spinlock_t pps_kc_hardpps_lock;
> +extern void *pps_kc_hardpps_dev;	/* some unique pointer to device */
> +extern int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
> +
>  /*
>   * Exported functions
>   */
> -- 
> 1.6.6.1
> 

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
