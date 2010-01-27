Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701Ab0A0ADW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0A0ADW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673Ab0A0ADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:03:18 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8067 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab0A0ADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:03:15 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABURX0urR7H+/2dsb2JhbADDDolmAY1AgkkBgW0E
X-IronPort-AV: E=Sophos;i="4.49,348,1262563200"; 
   d="scan'208";a="473355191"
Message-ID: <4B5F82C1.6050108@cisco.com>
Date: Tue, 26 Jan 2010 16:03:13 -0800
From: Joe Eykholt <jeykholt@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [50/98] [SCSI] libfc: fix free of fc_rport_priv with timer pending
References: <20100126233927.458130052@mini.kroah.org>
In-Reply-To: <20100126233927.458130052@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Joe Eykholt <jeykholt@cisco.com>
> 
> commit b4a9c7ede96e90f7b1ec009ce7256059295e76df upstream.
> 
> Timer crashes were caused by freeing a struct fc_rport_priv
> with a timer pending, causing the timer facility list to be
> corrupted.  This was during FC uplink flap tests with a lot
> of targets.
> 
> After discovery, we were doing an PLOGI on an rdata that was
> in DELETE state but not yet removed from the lookup list.
> This moved the rdata from DELETE state to PLOGI state.
> If the PLOGI exchange allocation failed and needed to be
> retried, the timer scheduling could race with the free
> being done by fc_rport_work().
> 
> When fc_rport_login() is called on a rport in DELETE state,
> move it to a new state RESTART.  In fc_rport_work, when
> handling a LOGO, STOPPED or FAILED event, look for restart
> state.  In the RESTART case, don't take the rdata off the
> list and after the transport remote port is deleted and
> exchanges are reset, re-login to the remote port.
> 
> Note that the new RESTART state also corrects a problem we
> had when re-discovering a port that had moved to DELETE state.
> In that case, a new rdata was created, but the old rdata
> would do an exchange manager reset affecting the FC_ID
> for both the new rdata and old rdata.  With the new state,
> the new port isn't logged into until after any old exchanges
> are reset.
> 
> Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/scsi/libfc/fc_rport.c |   69 ++++++++++++++++++++++++++++++------------
>  include/scsi/libfc.h          |    1 
>  2 files changed, 51 insertions(+), 19 deletions(-)
> 
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -86,6 +86,7 @@ static const char *fc_rport_state_names[
>  	[RPORT_ST_LOGO] = "LOGO",
>  	[RPORT_ST_ADISC] = "ADISC",
>  	[RPORT_ST_DELETE] = "Delete",
> +	[RPORT_ST_RESTART] = "Restart",
>  };
>  
>  /**
> @@ -99,8 +100,7 @@ static struct fc_rport_priv *fc_rport_lo
>  	struct fc_rport_priv *rdata;
>  
>  	list_for_each_entry(rdata, &lport->disc.rports, peers)
> -		if (rdata->ids.port_id == port_id &&
> -		    rdata->rp_state != RPORT_ST_DELETE)
> +		if (rdata->ids.port_id == port_id)
>  			return rdata;
>  	return NULL;
>  }
> @@ -235,6 +235,7 @@ static void fc_rport_work(struct work_st
>  	struct fc_rport_operations *rport_ops;
>  	struct fc_rport_identifiers ids;
>  	struct fc_rport *rport;
> +	int restart = 0;
>  
>  	mutex_lock(&rdata->rp_mutex);
>  	event = rdata->event;
> @@ -287,8 +288,19 @@ static void fc_rport_work(struct work_st
>  		mutex_unlock(&rdata->rp_mutex);
>  
>  		if (port_id != FC_FID_DIR_SERV) {
> +			/*
> +			 * We must drop rp_mutex before taking disc_mutex.
> +			 * Re-evaluate state to allow for restart.
> +			 * A transition to RESTART state must only happen
> +			 * while disc_mutex is held and rdata is on the list.
> +			 */
>  			mutex_lock(&lport->disc.disc_mutex);
> -			list_del(&rdata->peers);
> +			mutex_lock(&rdata->rp_mutex);
> +			if (rdata->rp_state == RPORT_ST_RESTART)
> +				restart = 1;
> +			else
> +				list_del(&rdata->peers);

There is a follow-up patch that adds this line at this point:

                         rdata->event = RPORT_EV_NONE;

If this patch is integrated, that one should be integrated
as well.  That patch is:

commit 5543c72e2bbb30e5ba5938b18ec26617b8b3fb04
Author: Abhijeet Joglekar <abjoglek@cisco.com>
Date:   Thu Dec 10 09:59:20 2009 -0800

[SCSI] libfc: remote port gets stuck in restart state without really restarting

	Joe


> +			mutex_unlock(&rdata->rp_mutex);
>  			mutex_unlock(&lport->disc.disc_mutex);
>  		}
>  
> @@ -312,7 +324,13 @@ static void fc_rport_work(struct work_st
>  			mutex_unlock(&rdata->rp_mutex);
>  			fc_remote_port_delete(rport);
>  		}
> -		kref_put(&rdata->kref, lport->tt.rport_destroy);
> +		if (restart) {
> +			mutex_lock(&rdata->rp_mutex);
> +			FC_RPORT_DBG(rdata, "work restart\n");
> +			fc_rport_enter_plogi(rdata);
> +			mutex_unlock(&rdata->rp_mutex);
> +		} else
> +			kref_put(&rdata->kref, lport->tt.rport_destroy);
>  		break;
>  
>  	default:
> @@ -342,6 +360,12 @@ int fc_rport_login(struct fc_rport_priv 
>  		FC_RPORT_DBG(rdata, "ADISC port\n");
>  		fc_rport_enter_adisc(rdata);
>  		break;
> +	case RPORT_ST_RESTART:
> +		break;
> +	case RPORT_ST_DELETE:
> +		FC_RPORT_DBG(rdata, "Restart deleted port\n");
> +		fc_rport_state_enter(rdata, RPORT_ST_RESTART);
> +		break;
>  	default:
>  		FC_RPORT_DBG(rdata, "Login to port\n");
>  		fc_rport_enter_plogi(rdata);
> @@ -397,20 +421,21 @@ int fc_rport_logoff(struct fc_rport_priv
>  
>  	if (rdata->rp_state == RPORT_ST_DELETE) {
>  		FC_RPORT_DBG(rdata, "Port in Delete state, not removing\n");
> -		mutex_unlock(&rdata->rp_mutex);
>  		goto out;
>  	}
>  
> -	fc_rport_enter_logo(rdata);
> +	if (rdata->rp_state == RPORT_ST_RESTART)
> +		FC_RPORT_DBG(rdata, "Port in Restart state, deleting\n");
> +	else
> +		fc_rport_enter_logo(rdata);
>  
>  	/*
>  	 * Change the state to Delete so that we discard
>  	 * the response.
>  	 */
>  	fc_rport_enter_delete(rdata, RPORT_EV_STOP);
> -	mutex_unlock(&rdata->rp_mutex);
> -
>  out:
> +	mutex_unlock(&rdata->rp_mutex);
>  	return 0;
>  }
>  
> @@ -466,6 +491,7 @@ static void fc_rport_timeout(struct work
>  	case RPORT_ST_READY:
>  	case RPORT_ST_INIT:
>  	case RPORT_ST_DELETE:
> +	case RPORT_ST_RESTART:
>  		break;
>  	}
>  
> @@ -499,6 +525,7 @@ static void fc_rport_error(struct fc_rpo
>  		fc_rport_enter_logo(rdata);
>  		break;
>  	case RPORT_ST_DELETE:
> +	case RPORT_ST_RESTART:
>  	case RPORT_ST_READY:
>  	case RPORT_ST_INIT:
>  		break;
> @@ -1248,6 +1275,7 @@ static void fc_rport_recv_plogi_req(stru
>  		}
>  		break;
>  	case RPORT_ST_PRLI:
> +	case RPORT_ST_RTV:
>  	case RPORT_ST_READY:
>  	case RPORT_ST_ADISC:
>  		FC_RPORT_DBG(rdata, "Received PLOGI in logged-in state %d "
> @@ -1255,11 +1283,14 @@ static void fc_rport_recv_plogi_req(stru
>  		/* XXX TBD - should reset */
>  		break;
>  	case RPORT_ST_DELETE:
> -	default:
> -		FC_RPORT_DBG(rdata, "Received PLOGI in unexpected state %d\n",
> -			     rdata->rp_state);
> -		fc_frame_free(rx_fp);
> -		goto out;
> +	case RPORT_ST_LOGO:
> +	case RPORT_ST_RESTART:
> +		FC_RPORT_DBG(rdata, "Received PLOGI in state %s - send busy\n",
> +			     fc_rport_state(rdata));
> +		mutex_unlock(&rdata->rp_mutex);
> +		rjt_data.reason = ELS_RJT_BUSY;
> +		rjt_data.explan = ELS_EXPL_NONE;
> +		goto reject;
>  	}
>  
>  	/*
> @@ -1510,14 +1541,14 @@ static void fc_rport_recv_logo_req(struc
>  		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
>  			     fc_rport_state(rdata));
>  
> +		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
> +
>  		/*
> -		 * If the remote port was created due to discovery,
> -		 * log back in.  It may have seen a stale RSCN about us.
> +		 * If the remote port was created due to discovery, set state
> +		 * to log back in.  It may have seen a stale RSCN about us.
>  		 */
> -		if (rdata->rp_state != RPORT_ST_DELETE && rdata->disc_id)
> -			fc_rport_enter_plogi(rdata);
> -		else
> -			fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
> +		if (rdata->disc_id)
> +			fc_rport_state_enter(rdata, RPORT_ST_RESTART);
>  		mutex_unlock(&rdata->rp_mutex);
>  	} else
>  		FC_RPORT_ID_DBG(lport, sid,
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -145,6 +145,7 @@ enum fc_rport_state {
>  	RPORT_ST_LOGO,		/* port logout sent */
>  	RPORT_ST_ADISC,		/* Discover Address sent */
>  	RPORT_ST_DELETE,	/* port being deleted */
> +	RPORT_ST_RESTART,       /* remote port being deleted and will restart */
>  };
>  
>  /**
> 
> 

