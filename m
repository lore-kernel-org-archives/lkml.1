Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYC2QfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYC2QfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 12:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYC2QfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 12:35:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:44507 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYC2QfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 12:35:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,575,1199692800"; 
   d="scan'208";a="224810472"
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to     
	improve raid456 write performance
From: Dan Williams <dan.j.williams@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
References: <20080328164351.30557.patches@notabene>
	 <1080328054528.30605@suse.de>
	 <20080327232252.20764ac4.akpm@linux-foundation.org>
	 <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
	 <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 09:33:22 -0700
Message-Id: <1206808402.28946.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 14:10 -0700, NeilBrown wrote:
> On Sat, March 29, 2008 6:33 am, Dan Williams wrote:
> >  raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t
> > len)
> >  {
> >       raid5_conf_t *conf = mddev_to_conf(mddev);
> > -     char *end;
> > -     int new;
> > +     unsigned long new;
> >       if (len >= PAGE_SIZE)
> >               return -EINVAL;
> >       if (!conf)
> >               return -ENODEV;
> >
> > -     new = simple_strtoul(page, &end, 10);
> > -     if (!*page || (*end && *end != '\n'))
> > +     if (strict_strtoul(page, 10, &new))
> >               return -EINVAL;
> > -     if (new > conf->max_nr_stripes || new < 0)
> > +     if (new > conf->max_nr_stripes || (int) new < 0)
> 
> I had suggested that "new < 0" test when I saw that 'new' was an 'int'.
> A better suggestion would have been to make 'new' 'unsigned'.
> Now that you have done that, the "< 0" it pointless and
> should go.

Yeah, ->max_nr_stripes will always be less than (1 << 63).

> Otherwise
>   Acked-By: NeilBrown <neilb@suse.de>

Thanks, new patch follows,
Dan

------snip------>
Subject: md: raid5.c convert simple_strtoul to strict_strtoul

From: Dan Williams <dan.j.williams@intel.com>

strict_strtoul handles the open-coded sanity checks in
raid5_store_stripe_cache_size and raid5_store_preread_threshold

Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc39369..e43e27a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4034,15 +4034,13 @@ static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n') )
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
 	if (new <= 16 || new > 32768)
 		return -EINVAL;
@@ -4080,17 +4078,15 @@ static ssize_t
 raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n'))
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
-	if (new > conf->max_nr_stripes || new < 0)
+	if (new > conf->max_nr_stripes)
 		return -EINVAL;
 	conf->bypass_threshold = new;
 	return len;


