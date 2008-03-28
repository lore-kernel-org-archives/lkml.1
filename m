Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYC1GXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYC1GXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYC1GW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:22:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYC1GW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:22:58 -0400
Date: Thu, 27 Mar 2008 23:22:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to improve
 raid456 write performance
Message-Id: <20080327232252.20764ac4.akpm@linux-foundation.org>
In-Reply-To: <1080328054528.30605@suse.de>
References: <20080328164351.30557.patches@notabene>
	<1080328054528.30605@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 16:45:28 +1100 NeilBrown <neilb@suse.de> wrote:

> +static ssize_t
> +raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
> +{
> +	raid5_conf_t *conf = mddev_to_conf(mddev);
> +	char *end;
> +	int new;
> +	if (len >= PAGE_SIZE)
> +		return -EINVAL;
> +	if (!conf)
> +		return -ENODEV;
> +
> +	new = simple_strtoul(page, &end, 10);
> +	if (!*page || (*end && *end != '\n'))
> +		return -EINVAL;
> +	if (new > conf->max_nr_stripes || new < 0)
> +		return -EINVAL;
> +	conf->bypass_threshold = new;
> +	return len;
> +}

checkpatch 0.16 (which I misfiled and have thus far failed to merge up)
sayeth:

WARNING: consider using strict_strtoul in preference to simple_strtoul
#258: FILE: drivers/md/raid5.c:4090:
+       new = simple_strtoul(page, &end, 10);

the reason being that code which uses simple_strtoul() can treat
"42-what-a-todo" as "42", which seems a bit sloppy.

Your code won't have that failing, because it explicitly checks that the
input ended in \0 or \n.  But strict_strtoul() internally does that, so this
open-coded test could be removed.

