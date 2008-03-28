Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYC1TeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYC1TeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYC1Tdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:33:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:44497 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbYC1Tdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="224530076"
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to
	improve raid456 write performance
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080327232252.20764ac4.akpm@linux-foundation.org>
References: <20080328164351.30557.patches@notabene>
	 <1080328054528.30605@suse.de>
	 <20080327232252.20764ac4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 12:33:39 -0700
Message-Id: <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 23:22 -0700, Andrew Morton wrote:
> On Fri, 28 Mar 2008 16:45:28 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > +static ssize_t
> > +raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
> > +{
> > +     raid5_conf_t *conf = mddev_to_conf(mddev);
> > +     char *end;
> > +     int new;
> > +     if (len >= PAGE_SIZE)
> > +             return -EINVAL;
> > +     if (!conf)
> > +             return -ENODEV;
> > +
> > +     new = simple_strtoul(page, &end, 10);
> > +     if (!*page || (*end && *end != '\n'))
> > +             return -EINVAL;
> > +     if (new > conf->max_nr_stripes || new < 0)
> > +             return -EINVAL;
> > +     conf->bypass_threshold = new;
> > +     return len;
> > +}
> 
> checkpatch 0.16 (which I misfiled and have thus far failed to merge up)
> sayeth:
> 
> WARNING: consider using strict_strtoul in preference to simple_strtoul
> #258: FILE: drivers/md/raid5.c:4090:
> +       new = simple_strtoul(page, &end, 10);
> 
> the reason being that code which uses simple_strtoul() can treat
> "42-what-a-todo" as "42", which seems a bit sloppy.
> 
> Your code won't have that failing, because it explicitly checks that the
> input ended in \0 or \n.  But strict_strtoul() internally does that, so this
> open-coded test could be removed.

How about the following:
-------snip------>

Subject: md: raid5.c convert simple_strtoul to strict_strtoul

From: Dan Williams <dan.j.williams@intel.com>

strict_strtoul handles the open-coded sanity checks in
raid5_store_stripe_cache_size and raid5_store_preread_threshold

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc39369..49f1265 100644
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
+	if (new > conf->max_nr_stripes || (int) new < 0)
 		return -EINVAL;
 	conf->bypass_threshold = new;
 	return len;


