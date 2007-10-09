Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXJIP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXJIP1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXJIP1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:27:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:27200 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbXJIP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:27:10 -0400
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="dif'208?scan'208,208";a="112258215"
Subject: Re: [patch 08/12] NLM: Fix a circular lock dependency in lockd
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Greg KH <gregkh@suse.de>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20071009151341.GA5925@suse.de>
References: <20071008180406.052382073@mini.kroah.org>
	 <20071008180629.GI7627@kroah.com> <470A8C7D.70303@tiscali.nl>
	 <1191942028.8739.3.camel@heimdal.trondhjem.org>
	 <20071009151341.GA5925@suse.de>
Content-Type: multipart/mixed; boundary="=-jnY/IdpvVIvZI9yuYYn4"
Organization: Network Appliance Inc
Date: Tue, 09 Oct 2007 11:27:57 -0400
Message-Id: <1191943677.8739.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 09 Oct 2007 15:27:08.0487 (UTC) FILETIME=[DAED3D70:01C80A88]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jnY/IdpvVIvZI9yuYYn4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 2007-10-09 at 08:13 -0700, Greg KH wrote:
> On Tue, Oct 09, 2007 at 11:00:28AM -0400, Trond Myklebust wrote:
> > 
> > On Mon, 2007-10-08 at 22:01 +0200, Roel Kluin wrote:
> > > Greg KH wrote:
> > > 
> > > @@ -477,10 +479,15 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
> > >  
> > >  	if (block == NULL) {
> > >  		struct file_lock *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> > > +		struct nlm_host	*host;
> > >  
> > >  		if (conf == NULL)
> > >  			return nlm_granted;
> > > -		block = nlmsvc_create_block(rqstp, file, lock, cookie);
> > > +		/* Create host handle for callback */
> > > +		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
> > > +		if (host == NULL)
> > > +			return nlm_lck_denied_nolocks;
> > > +		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
> > >  		if (block == NULL) {
> > >  			kfree(conf);
> > >  			return nlm_granted;
> > > 
> > > To be frankly I don't know what this is about, but shouldn't conf be freed if host == NULL?
> > 
> > Thanks for spotting this!
> > 
> > Greg, should I resend this patch, or would you prefer an incremental
> > fix?
> 
> An incremental one would be best.
> 
> thanks,
> 
> greg k-h

Please see the attachment.

Cheers
  Trond


--=-jnY/IdpvVIvZI9yuYYn4
Content-Disposition: attachment; filename=linux-2.6.23-000-fix_memleak_in_nlmsvc_testlock.dif
Content-Type: message/rfc822; name=linux-2.6.23-000-fix_memleak_in_nlmsvc_testlock.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 9 Oct 2007 10:55:45 -0400
LOCKD: Fix a memory leak in nlmsvc_testlock
Subject: No Subject
Message-Id: <1191943677.8739.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0

The recent fix for a circular lock dependency unfortunately introduced a
potential memory leak in the event where the call to nlmsvc_lookup_host
fails for some reason.

Thanks to Roel Kluin for spotting this.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/lockd/svclock.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index d098c7a..d120ec3 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -485,8 +485,10 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 			return nlm_granted;
 		/* Create host handle for callback */
 		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
-		if (host == NULL)
+		if (host == NULL) {
+			kfree(conf);
 			return nlm_lck_denied_nolocks;
+		}
 		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
 		if (block == NULL) {
 			kfree(conf);

--=-jnY/IdpvVIvZI9yuYYn4--
