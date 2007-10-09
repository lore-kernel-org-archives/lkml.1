Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbXJIPAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbXJIPAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXJIPAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:00:05 -0400
Received: from mx2.netapp.com ([216.240.18.37]:56531 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXJIPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:00:04 -0400
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="112250133"
Subject: Re: [patch 08/12] NLM: Fix a circular lock dependency in lockd
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <470A8C7D.70303@tiscali.nl>
References: <20071008180406.052382073@mini.kroah.org>
	 <20071008180629.GI7627@kroah.com>  <470A8C7D.70303@tiscali.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 09 Oct 2007 11:00:28 -0400
Message-Id: <1191942028.8739.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 09 Oct 2007 14:59:39.0662 (UTC) FILETIME=[042682E0:01C80A85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 22:01 +0200, Roel Kluin wrote:
> Greg KH wrote:
> 
> @@ -477,10 +479,15 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
>  
>  	if (block == NULL) {
>  		struct file_lock *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> +		struct nlm_host	*host;
>  
>  		if (conf == NULL)
>  			return nlm_granted;
> -		block = nlmsvc_create_block(rqstp, file, lock, cookie);
> +		/* Create host handle for callback */
> +		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
> +		if (host == NULL)
> +			return nlm_lck_denied_nolocks;
> +		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
>  		if (block == NULL) {
>  			kfree(conf);
>  			return nlm_granted;
> 
> To be frankly I don't know what this is about, but shouldn't conf be freed if host == NULL?

Thanks for spotting this!

Greg, should I resend this patch, or would you prefer an incremental
fix?

Cheers
  Trond
