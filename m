Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0CAISr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:18:47 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45077 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0CAISp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:18:45 -0500
Date: Mon, 1 Mar 2010 09:18:40 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Reg Clemens <clemens@dwf.com>
Message-ID: <20100301081839.GH3671@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Reg Clemens <clemens@dwf.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
 <c44b39b1a3744ef3e93d5b55324d539f5688a6de.1267008049.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c44b39b1a3744ef3e93d5b55324d539f5688a6de.1267008049.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv2 2/6] pps: unify timestamp gathering
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:28:13PM +0300, Alexander Gordeev wrote:
> Add a helper function to gather timestamps. This way clients don't have
> to duplicate it.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

> ---
>  drivers/pps/kapi.c         |   15 +++++++++------
>  include/linux/pps_kernel.h |   23 ++++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index 2d414e2..b87f699 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -267,7 +267,7 @@ EXPORT_SYMBOL(pps_unregister_source);
>   *	pps->info.echo(source, event, data);
>   */
>  
> -void pps_event(int source, struct pps_ktime *ts, int event, void *data)
> +void pps_event(int source, struct pps_event_time *ts, int event, void *data)
>  {
>  	struct pps_device *pps;
>  	unsigned long flags;
> @@ -284,7 +284,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
>  		return;
>  
>  	pr_debug("PPS event on source %d at %llu.%06u\n",
> -			pps->id, (unsigned long long) ts->sec, ts->nsec);
> +			pps->id, (unsigned long long) ts->ts_real.sec,
> +			ts->ts_real.nsec);
>  
>  	spin_lock_irqsave(&pps->lock, flags);
>  
> @@ -298,10 +299,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
>  			(pps->params.mode & PPS_CAPTUREASSERT)) {
>  		/* We have to add an offset? */
>  		if (pps->params.mode & PPS_OFFSETASSERT)
> -			pps_add_offset(ts, &pps->params.assert_off_tu);
> +			pps_add_offset(&ts->ts_real,
> +					&pps->params.assert_off_tu);
>  
>  		/* Save the time stamp */
> -		pps->assert_tu = *ts;
> +		pps->assert_tu = ts->ts_real;
>  		pps->assert_sequence++;
>  		pr_debug("capture assert seq #%u for source %d\n",
>  			pps->assert_sequence, source);
> @@ -312,10 +314,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
>  			(pps->params.mode & PPS_CAPTURECLEAR)) {
>  		/* We have to add an offset? */
>  		if (pps->params.mode & PPS_OFFSETCLEAR)
> -			pps_add_offset(ts, &pps->params.clear_off_tu);
> +			pps_add_offset(&ts->ts_real,
> +					&pps->params.clear_off_tu);
>  
>  		/* Save the time stamp */
> -		pps->clear_tu = *ts;
> +		pps->clear_tu = ts->ts_real;
>  		pps->clear_sequence++;
>  		pr_debug("capture clear seq #%u for source %d\n",
>  			pps->clear_sequence, source);
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index e0a193f..a2804c1 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -40,6 +40,10 @@ struct pps_source_info {
>  	struct device *dev;
>  };
>  
> +struct pps_event_time {
> +	struct pps_ktime ts_real;
> +};
> +
>  /* The main struct */
>  struct pps_device {
>  	struct pps_source_info info;		/* PSS source info */
> @@ -86,4 +90,21 @@ extern int pps_register_source(struct pps_source_info *info,
>  extern void pps_unregister_source(int source);
>  extern int pps_register_cdev(struct pps_device *pps);
>  extern void pps_unregister_cdev(struct pps_device *pps);
> -extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
> +extern void pps_event(int source, struct pps_event_time *ts, int event,
> +		void *data);
> +
> +static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
> +		struct timespec ts)
> +{
> +	kt->sec = ts.tv_sec;
> +	kt->nsec = ts.tv_nsec;
> +}
> +
> +static inline void pps_get_ts(struct pps_event_time *ts)
> +{
> +	struct timespec ts_real;
> +
> +	getnstimeofday(&ts_real);
> +	timespec_to_pps_ktime(&ts->ts_real, ts_real);
> +}
> +
> -- 
> 1.6.6.1
> 

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
