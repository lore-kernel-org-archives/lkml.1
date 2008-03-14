Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYCNTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYCNTxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYCNTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:53:17 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34602 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbYCNTxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:53:16 -0400
Date: Fri, 14 Mar 2008 20:53:03 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080314195303.GA4390@ics.muni.cz>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080314193350.GK2119@fieldses.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 14 Mar 2008 20:53:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 03:33:50PM -0400, J. Bruce Fields wrote:
> OK, yes, I think so.  Could you confirm whether this fixes it?

I will test it on Monday as I cannot reboot the machine right now.

Just a quick review - isn't the cache_get() call needed also on the line 185 in
the same file?
 
> diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> index 1eb771d..3e6b3f4 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -232,6 +232,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
>  		fhp->fh_dentry = dentry;
>  		fhp->fh_export = exp;
>  		nfsd_nr_verified++;
> +		cache_get(&exp->h);
>  	} else {
>  		/*
>  		 * just rechecking permissions
> @@ -241,6 +242,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
>  		dprintk("nfsd: fh_verify - just checking\n");
>  		dentry = fhp->fh_dentry;
>  		exp = fhp->fh_export;
> +		cache_get(&exp->h);
>  		/*
>  		 * Set user creds for this exportpoint; necessary even
>  		 * in the "just checking" case because this may be a
> @@ -252,8 +254,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
>  		if (error)
>  			goto out;
>  	}
> -	cache_get(&exp->h);
> -
>  
>  	error = nfsd_mode_check(rqstp, dentry->d_inode->i_mode, type);
>  	if (error)

-- 
Luká¹ Hejtmánek
