Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646Ab0A0CFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0A0CFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616Ab0A0CFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:05:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:34818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0A0CFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:05:15 -0500
Date: Tue, 26 Jan 2010 18:03:06 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [50/98] [SCSI] libfc: fix free of fc_rport_priv with timer
 pending
Message-ID: <20100127020306.GA12276@suse.de>
References: <20100126233927.458130052@mini.kroah.org>
 <4B5F82C1.6050108@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5F82C1.6050108@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:03:13PM -0800, Joe Eykholt wrote:
> Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Joe Eykholt <jeykholt@cisco.com>
> > 
> > commit b4a9c7ede96e90f7b1ec009ce7256059295e76df upstream.
> > 
> > Timer crashes were caused by freeing a struct fc_rport_priv
> > with a timer pending, causing the timer facility list to be
> > corrupted.  This was during FC uplink flap tests with a lot
> > of targets.
> > 
> > After discovery, we were doing an PLOGI on an rdata that was
> > in DELETE state but not yet removed from the lookup list.
> > This moved the rdata from DELETE state to PLOGI state.
> > If the PLOGI exchange allocation failed and needed to be
> > retried, the timer scheduling could race with the free
> > being done by fc_rport_work().
> > 
> > When fc_rport_login() is called on a rport in DELETE state,
> > move it to a new state RESTART.  In fc_rport_work, when
> > handling a LOGO, STOPPED or FAILED event, look for restart
> > state.  In the RESTART case, don't take the rdata off the
> > list and after the transport remote port is deleted and
> > exchanges are reset, re-login to the remote port.
> > 
> > Note that the new RESTART state also corrects a problem we
> > had when re-discovering a port that had moved to DELETE state.
> > In that case, a new rdata was created, but the old rdata
> > would do an exchange manager reset affecting the FC_ID
> > for both the new rdata and old rdata.  With the new state,
> > the new port isn't logged into until after any old exchanges
> > are reset.
> > 
> > Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
> > Signed-off-by: Robert Love <robert.w.love@intel.com>
> > Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/scsi/libfc/fc_rport.c |   69 ++++++++++++++++++++++++++++++------------
> >  include/scsi/libfc.h          |    1 
> >  2 files changed, 51 insertions(+), 19 deletions(-)
> > 
> > --- a/drivers/scsi/libfc/fc_rport.c
> > +++ b/drivers/scsi/libfc/fc_rport.c
> > @@ -86,6 +86,7 @@ static const char *fc_rport_state_names[
> >  	[RPORT_ST_LOGO] = "LOGO",
> >  	[RPORT_ST_ADISC] = "ADISC",
> >  	[RPORT_ST_DELETE] = "Delete",
> > +	[RPORT_ST_RESTART] = "Restart",
> >  };
> >  
> >  /**
> > @@ -99,8 +100,7 @@ static struct fc_rport_priv *fc_rport_lo
> >  	struct fc_rport_priv *rdata;
> >  
> >  	list_for_each_entry(rdata, &lport->disc.rports, peers)
> > -		if (rdata->ids.port_id == port_id &&
> > -		    rdata->rp_state != RPORT_ST_DELETE)
> > +		if (rdata->ids.port_id == port_id)
> >  			return rdata;
> >  	return NULL;
> >  }
> > @@ -235,6 +235,7 @@ static void fc_rport_work(struct work_st
> >  	struct fc_rport_operations *rport_ops;
> >  	struct fc_rport_identifiers ids;
> >  	struct fc_rport *rport;
> > +	int restart = 0;
> >  
> >  	mutex_lock(&rdata->rp_mutex);
> >  	event = rdata->event;
> > @@ -287,8 +288,19 @@ static void fc_rport_work(struct work_st
> >  		mutex_unlock(&rdata->rp_mutex);
> >  
> >  		if (port_id != FC_FID_DIR_SERV) {
> > +			/*
> > +			 * We must drop rp_mutex before taking disc_mutex.
> > +			 * Re-evaluate state to allow for restart.
> > +			 * A transition to RESTART state must only happen
> > +			 * while disc_mutex is held and rdata is on the list.
> > +			 */
> >  			mutex_lock(&lport->disc.disc_mutex);
> > -			list_del(&rdata->peers);
> > +			mutex_lock(&rdata->rp_mutex);
> > +			if (rdata->rp_state == RPORT_ST_RESTART)
> > +				restart = 1;
> > +			else
> > +				list_del(&rdata->peers);
> 
> There is a follow-up patch that adds this line at this point:
> 
>                          rdata->event = RPORT_EV_NONE;
> 
> If this patch is integrated, that one should be integrated
> as well.  That patch is:
> 
> commit 5543c72e2bbb30e5ba5938b18ec26617b8b3fb04
> Author: Abhijeet Joglekar <abjoglek@cisco.com>
> Date:   Thu Dec 10 09:59:20 2009 -0800
> 
> [SCSI] libfc: remote port gets stuck in restart state without really restarting

Thank you so much for the information, I have queued up this patch as
well for the .32 tree.

thanks for the review,

greg k-h
