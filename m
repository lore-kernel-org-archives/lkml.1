Return-Path: <linux-kernel-owner+w=401wt.eu-S1767718AbXCJBuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767718AbXCJBuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767719AbXCJBuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:50:17 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:36417 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767718AbXCJBuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:50:15 -0500
Date: Sat, 10 Mar 2007 02:49:59 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mauro <mchehab@infradead.org>,
       Andreas Oberritter <obi@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org
Message-ID: <20070310014959.GA4147@linuxtv.org>
References: <45DCB3A3.3060705@simon.arlott.org.uk> <45E08886.50606@linuxtv.org> <45E08BFD.3080203@simon.arlott.org.uk> <45E9D923.7040707@simon.arlott.org.uk> <45EAE894.1010000@linuxtv.org> <45EB05D2.90608@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EB05D2.90608@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.98.17
Subject: Re: [PATCH] dvb-core: Fix several locking related problems.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 05:45:54PM +0000, Simon Arlott wrote:
> Fix several instances of dvb-core functions using mutex_lock_interruptible 
> and returning -ERESTARTSYS where the calling function will either never 
> retry or never check the return value.
> 
> These cause a race condition with dvb_dmxdev_filter_free and 
> dvb_dvr_release, both of which are filesystem release functions whose 
> return value is ignored and will never be retried. When this happens it 
> becomes impossible to open dvr0 again (-EBUSY) since it has not been 
> released properly.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Acked-By: Johannes Stezenbach <js@linuxtv.org>

I can't test this but to me it looks good.
Mauro, could you please pick it up and keep it in the
linuxtv.org repository for a while for testing?


Thanks,
Johannes


> ---
> On 04/03/07 15:41, Andreas Oberritter wrote:
> >please send an updated patch together with
> >Signed-off-by line to Mauro <mchehab@infradead.org> and ask him to apply
> >it for inclusion into the -mm tree for further testing.
> 
> Unless there are other -mm trees I've not heard about, presumably I should 
> just do this myself. Doesn't linux-dvb have it's own development tree this 
> would get better tested in?
> 
> The dvb_dvr_release change has been working for me for 6 months and the 
> dvb_dmxdev_filter_free (dvb_dmxdev_filter_free) change looks equivalent.
> See http://www.linuxtv.org/pipermail/linux-dvb/2007-February/016120.html 
> for an example of the bug before and after fixing.
> 
> All the other changes run ok for me but should have lockdep enabled when 
> testing (if there's a possible deadlock somewhere, using _interruptible 
> will hide it).
> 
> drivers/media/dvb/dvb-core/dmxdev.c    |   12 +++---------
> drivers/media/dvb/dvb-core/dvb_demux.c |   21 +++++++--------------
> drivers/media/dvb/dvb-core/dvbdev.c    |    9 +++------
> 3 files changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dmxdev.c 
> b/drivers/media/dvb/dvb-core/dmxdev.c
> index fc77de4..a5c0e1a 100644
> --- a/drivers/media/dvb/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb/dvb-core/dmxdev.c
> @@ -180,8 +180,7 @@ static int dvb_dvr_release(struct inode *inode, struct 
> file *file)
> 	struct dvb_device *dvbdev = file->private_data;
> 	struct dmxdev *dmxdev = dvbdev->priv;
> 
> -	if (mutex_lock_interruptible(&dmxdev->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dmxdev->mutex);
> 
> 	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
> 		dmxdev->demux->disconnect_frontend(dmxdev->demux);
> @@ -673,13 +672,8 @@ static int dvb_demux_open(struct inode *inode, struct 
> file *file)
> static int dvb_dmxdev_filter_free(struct dmxdev *dmxdev,
> 				  struct dmxdev_filter *dmxdevfilter)
> {
> -	if (mutex_lock_interruptible(&dmxdev->mutex))
> -		return -ERESTARTSYS;
> -
> -	if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
> -		mutex_unlock(&dmxdev->mutex);
> -		return -ERESTARTSYS;
> -	}
> +	mutex_lock(&dmxdev->mutex);
> +	mutex_lock(&dmxdevfilter->mutex);
> 
> 	dvb_dmxdev_filter_stop(dmxdevfilter);
> 	dvb_dmxdev_filter_reset(dmxdevfilter);
> diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c 
> b/drivers/media/dvb/dvb-core/dvb_demux.c
> index fcff5ea..6d8d1c3 100644
> --- a/drivers/media/dvb/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb/dvb-core/dvb_demux.c
> @@ -673,8 +673,7 @@ static int dmx_ts_feed_stop_filtering(struct 
> dmx_ts_feed *ts_feed)
> 	struct dvb_demux *demux = feed->demux;
> 	int ret;
> 
> -	if (mutex_lock_interruptible(&demux->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&demux->mutex);
> 
> 	if (feed->state < DMX_STATE_GO) {
> 		mutex_unlock(&demux->mutex);
> @@ -748,8 +747,7 @@ static int dvbdmx_release_ts_feed(struct dmx_demux *dmx,
> 	struct dvb_demux *demux = (struct dvb_demux *)dmx;
> 	struct dvb_demux_feed *feed = (struct dvb_demux_feed *)ts_feed;
> 
> -	if (mutex_lock_interruptible(&demux->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&demux->mutex);
> 
> 	if (feed->state == DMX_STATE_FREE) {
> 		mutex_unlock(&demux->mutex);
> @@ -916,8 +914,7 @@ static int dmx_section_feed_stop_filtering(struct 
> dmx_section_feed *feed)
> 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
> 	int ret;
> 
> -	if (mutex_lock_interruptible(&dvbdmx->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdmx->mutex);
> 
> 	if (!dvbdmx->stop_feed) {
> 		mutex_unlock(&dvbdmx->mutex);
> @@ -942,8 +939,7 @@ static int dmx_section_feed_release_filter(struct 
> dmx_section_feed *feed,
> 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)feed;
> 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
> 
> -	if (mutex_lock_interruptible(&dvbdmx->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdmx->mutex);
> 
> 	if (dvbdmxfilter->feed != dvbdmxfeed) {
> 		mutex_unlock(&dvbdmx->mutex);
> @@ -1016,8 +1012,7 @@ static int dvbdmx_release_section_feed(struct 
> dmx_demux *demux,
> 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)feed;
> 	struct dvb_demux *dvbdmx = (struct dvb_demux *)demux;
> 
> -	if (mutex_lock_interruptible(&dvbdmx->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdmx->mutex);
> 
> 	if (dvbdmxfeed->state == DMX_STATE_FREE) {
> 		mutex_unlock(&dvbdmx->mutex);
> @@ -1126,8 +1121,7 @@ static int dvbdmx_connect_frontend(struct dmx_demux 
> *demux,
> 	if (demux->frontend)
> 		return -EINVAL;
> 
> -	if (mutex_lock_interruptible(&dvbdemux->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdemux->mutex);
> 
> 	demux->frontend = frontend;
> 	mutex_unlock(&dvbdemux->mutex);
> @@ -1138,8 +1132,7 @@ static int dvbdmx_disconnect_frontend(struct 
> dmx_demux *demux)
> {
> 	struct dvb_demux *dvbdemux = (struct dvb_demux *)demux;
> 
> -	if (mutex_lock_interruptible(&dvbdemux->mutex))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdemux->mutex);
> 
> 	demux->frontend = NULL;
> 	mutex_unlock(&dvbdemux->mutex);
> diff --git a/drivers/media/dvb/dvb-core/dvbdev.c 
> b/drivers/media/dvb/dvb-core/dvbdev.c
> index b4553ae..1e0f01a 100644
> --- a/drivers/media/dvb/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb/dvb-core/dvbdev.c
> @@ -203,8 +203,7 @@ int dvb_register_device(struct dvb_adapter *adap, 
> struct dvb_device **pdvbdev,
> 
> 	int id;
> 
> -	if (mutex_lock_interruptible(&dvbdev_register_lock))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdev_register_lock);
> 
> 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
> 		mutex_unlock(&dvbdev_register_lock);
> @@ -294,8 +293,7 @@ int dvb_register_adapter(struct dvb_adapter *adap, 
> const char *name, struct modu
> {
> 	int num;
> 
> -	if (mutex_lock_interruptible(&dvbdev_register_lock))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdev_register_lock);
> 
> 	if ((num = dvbdev_get_free_adapter_num ()) < 0) {
> 		mutex_unlock(&dvbdev_register_lock);
> @@ -323,8 +321,7 @@ EXPORT_SYMBOL(dvb_register_adapter);
> 
> int dvb_unregister_adapter(struct dvb_adapter *adap)
> {
> -	if (mutex_lock_interruptible(&dvbdev_register_lock))
> -		return -ERESTARTSYS;
> +	mutex_lock(&dvbdev_register_lock);
> 	list_del (&adap->list_head);
> 	mutex_unlock(&dvbdev_register_lock);
> 	return 0;
> -- 
> 1.5.0.1
> 
> -- 
> Simon Arlott
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
