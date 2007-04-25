Return-Path: <linux-kernel-owner+w=401wt.eu-S2992911AbXDYSpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992911AbXDYSpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992913AbXDYSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:45:19 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:31164 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992911AbXDYSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:45:17 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 14:45:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pEMsSLHmygRLekOh8mOErsxbUouJp2v40snvk9IUrauZNM28T5lAZIbjUcQuUDFXRH0CRjcM60pzQ8oA4eIIXGtt6wls6dWw1Svp+1gcZqX0NE8/kHHbJbhrTHdY13sLdzVVB5C6NVRBOMwgtvGhKwOgJZLCfryf1QfINAa1DE0=  ;
Message-ID: <20070425183836.5115.qmail@web50109.mail.re2.yahoo.com>
X-YMail-OSG: 3pS7IPQVM1m17cvHXGjl28SzU2VwAC3skpMhXPIKUj6KwuwZU.hMtl3j5BrRuI6LA9X67IVGU1LLnL_RcwWPNejvUc7LVDN2gK8NjJgz1W2xY4swPQz_UOwQ4NQkAQ--
Date: Wed, 25 Apr 2007 11:38:36 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] use mutex instead of semaphore in EDAC core
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, norsk5@xmission.com,
       bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070425134917.GL6798@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I will have to modify this, as the edac_mc.c has been
re-written in a patch I have in my queue, but not net pushed up stream.
I will generate a new quilt patch with your named acknowledged.

thanks

doug thompson


--- Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> the EDAC core code uses a semaphore as mutex. use the mutex API
> instead of the (binary) semaphore
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> --
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 7b62230..f217750 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -50,7 +50,7 @@ static int panic_on_ue;
>  static int poll_msec = 1000;
>  
>  /* lock to memory controller's control array */
> -static DECLARE_MUTEX(mem_ctls_mutex);
> +static DEFINE_MUTEX(mem_ctls_mutex);
>  static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
>  
>  static struct task_struct *edac_thread;
> @@ -1489,7 +1489,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci,
> int mc_idx)
>  		}
>  	}
>  #endif
> -	down(&mem_ctls_mutex);
> +	mutex_lock(&mem_ctls_mutex);
>  
>  	if (add_mc_to_global_list(mci))
>  		goto fail0;
> @@ -1507,14 +1507,14 @@ int edac_mc_add_mc(struct mem_ctl_info *mci,
> int mc_idx)
>  	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV
> %s\n",
>  		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
>  
> -	up(&mem_ctls_mutex);
> +	mutex_unlock(&mem_ctls_mutex);
>  	return 0;
>  
>  fail1:
>  	del_mc_from_global_list(mci);
>  
>  fail0:
> -	up(&mem_ctls_mutex);
> +	mutex_unlock(&mem_ctls_mutex);
>  	return 1;
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_add_mc);
> @@ -1531,16 +1531,16 @@ struct mem_ctl_info * edac_mc_del_mc(struct
> device *dev)
>  	struct mem_ctl_info *mci;
>  
>  	debugf0("MC: %s()\n", __func__);
> -	down(&mem_ctls_mutex);
> +	mutex_lock(&mem_ctls_mutex);
>  
>  	if ((mci = find_mci_by_dev(dev)) == NULL) {
> -		up(&mem_ctls_mutex);
> +		mutex_unlock(&mem_ctls_mutex);
>  		return NULL;
>  	}
>  
>  	edac_remove_sysfs_mci_device(mci);
>  	del_mc_from_global_list(mci);
> -	up(&mem_ctls_mutex);
> +	mutex_unlock(&mem_ctls_mutex);
>  	edac_printk(KERN_INFO, EDAC_MC,
>  		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
>  		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
> @@ -1877,7 +1877,7 @@ static inline void check_mc_devices(void)
>  	struct mem_ctl_info *mci;
>  
>  	debugf3("%s()\n", __func__);
> -	down(&mem_ctls_mutex);
> +	mutex_lock(&mem_ctls_mutex);
>  
>  	list_for_each(item, &mc_devices) {
>  		mci = list_entry(item, struct mem_ctl_info, link);
> @@ -1886,7 +1886,7 @@ static inline void check_mc_devices(void)
>  			mci->edac_check(mci);
>  	}
>  
> -	up(&mem_ctls_mutex);
> +	mutex_unlock(&mem_ctls_mutex);
>  }
>  
>  /*
>  
> -- 
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
> 
>                 Don't walk behind me, I may not lead
>              Don't walk in front of me, I may not follow
>                 Just walk beside me and be my friend
>                           (Albert Camus)
>                                                                 
> .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :' 
> :
>                                                                 `.
> `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> 

