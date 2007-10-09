Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXJIPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXJIPOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXJIPOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:14:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:49254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXJIPOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:14:06 -0400
Date: Tue, 9 Oct 2007 08:13:41 -0700
From: Greg KH <gregkh@suse.de>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 08/12] NLM: Fix a circular lock dependency in lockd
Message-ID: <20071009151341.GA5925@suse.de>
References: <20071008180406.052382073@mini.kroah.org> <20071008180629.GI7627@kroah.com> <470A8C7D.70303@tiscali.nl> <1191942028.8739.3.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191942028.8739.3.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:00:28AM -0400, Trond Myklebust wrote:
> 
> On Mon, 2007-10-08 at 22:01 +0200, Roel Kluin wrote:
> > Greg KH wrote:
> > 
> > @@ -477,10 +479,15 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
> >  
> >  	if (block == NULL) {
> >  		struct file_lock *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> > +		struct nlm_host	*host;
> >  
> >  		if (conf == NULL)
> >  			return nlm_granted;
> > -		block = nlmsvc_create_block(rqstp, file, lock, cookie);
> > +		/* Create host handle for callback */
> > +		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
> > +		if (host == NULL)
> > +			return nlm_lck_denied_nolocks;
> > +		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
> >  		if (block == NULL) {
> >  			kfree(conf);
> >  			return nlm_granted;
> > 
> > To be frankly I don't know what this is about, but shouldn't conf be freed if host == NULL?
> 
> Thanks for spotting this!
> 
> Greg, should I resend this patch, or would you prefer an incremental
> fix?

An incremental one would be best.

thanks,

greg k-h
