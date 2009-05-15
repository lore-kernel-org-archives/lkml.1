Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZEOVtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZEOVtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZEOVte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:49:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZEOVtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:49:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
Date: Fri, 15 May 2009 23:48:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: John Linville <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <49E065CF.6040408@tuffmail.co.uk> <49F6DA14.7030608@tuffmail.co.uk> <49F83699.3000307@tuffmail.co.uk>
In-Reply-To: <49F83699.3000307@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905152348.56449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Alan Jenkins wrote:
> Alan Jenkins wrote:
> > Johannes Berg wrote:
> >   
> >> That doesn't seem relevant, this just does some initialisation. However,
> >> you definitely missed adding a call to wep_free().
> >>   
> >>     
> >
> > Hah, I should have realized something was wrong when I noticed I was
> > removing more lines that I added. 
> >
> > The crypto init does cause the module load:
> >
> > wait_for_completion
> > call_usermodehelper_exec
> > __request_module
> > crypto_larval_lookup
> > ? extract_entropy
> > crypto_alg_mod_lookup
> > crypto_alloc_base
> > ieee80211_wep_init
> > ieee80211_register_hw
> >   
> 
> Here's a corrected patch complete with changelog.  If there are no other
> problems with it, can you please  apply this for 2.6.30 to keep my EeePC
> regression-free?
> 
> Thanks
> Alan
> 
> ------>
> From c5e9dc036247e70956d1a28e8850c3810385dda0 Mon Sep 17 00:00:00 2001
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date: Wed, 29 Apr 2009 11:41:24 +0100
> Subject: [PATCH] mac80211: fix modprobe deadlock by not calling wep_init under rtnl_lock
> 
>  - ieee80211_wep_init(), which is called with rtnl_lock held, blocks in
>    request_module() [waiting for modprobe to load a crypto module].
> 
>  - modprobe blocks in a call to flush_workqueue(), when it closes a TTY
>    [presumably when it exits].
> 
>  - The workqueue item linkwatch_event() blocks on rtnl_lock.
> 
> There's no reason for wep_init() to be called with rtnl_lock held, so
> just move it outside the critical section.

Has it been merged already or is it queued up for merging?

Rafael


> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  net/mac80211/main.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index fbcbed6..00968c2 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -909,6 +909,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	if (result < 0)
>  		goto fail_sta_info;
>  
> +	result = ieee80211_wep_init(local);
> +	if (result < 0) {
> +		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
> +		       wiphy_name(local->hw.wiphy), result);
> +		goto fail_wep;
> +	}
> +
>  	rtnl_lock();
>  	result = dev_alloc_name(local->mdev, local->mdev->name);
>  	if (result < 0)
> @@ -930,14 +937,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		goto fail_rate;
>  	}
>  
> -	result = ieee80211_wep_init(local);
> -
> -	if (result < 0) {
> -		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
> -		       wiphy_name(local->hw.wiphy), result);
> -		goto fail_wep;
> -	}
> -
>  	/* add one default STA interface if supported */
>  	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
>  		result = ieee80211_if_add(local, "wlan%d", NULL,
> @@ -967,13 +966,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  
>  	return 0;
>  
> -fail_wep:
> -	rate_control_deinitialize(local);
>  fail_rate:
>  	unregister_netdevice(local->mdev);
>  	local->mdev = NULL;
>  fail_dev:
>  	rtnl_unlock();
> +	ieee80211_wep_free(local);
> +fail_wep:
>  	sta_info_stop(local);
>  fail_sta_info:
>  	debugfs_hw_del(local);


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
