Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZGTQEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZGTQEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZGTQEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:04:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbZGTQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:04:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] hibernate / memory hotplug: always use for_each_populated_zone()
Date: Mon, 20 Jul 2009 18:04:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1248103551.23961.0.camel@localhost.localdomain>
In-Reply-To: <1248103551.23961.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201804.59851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 July 2009, Gerald Schaefer wrote:
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> Use for_each_populated_zone() instead of for_each_zone() in hibernation
> code. This fixes a bug on s390, where we allow both config options
> HIBERNATION and MEMORY_HOTPLUG, so that we also have a ZONE_MOVABLE
> here. We only allow hibernation if no memory hotplug operation was
> performed, so in fact both features can only be used exclusively, but
> this way we don't need 2 differently configured (distribution) kernels.
> 
> If we have an unpopulated ZONE_MOVABLE, we allow hibernation but run
> into a BUG_ON() in memory_bm_test/set/clear_bit() because hibernation
> code iterates through all zones, not only the populated zones, in
> several places. For example, swsusp_free() does for_each_zone() and
> then checks for pfn_valid(), which is true even if the zone is not
> populated, resulting in a BUG_ON() later because the pfn cannot be
> found in the memory bitmap.
> 
> Replacing all occurences of for_each_zone() in hibernation code with
> for_each_populated_zone() would fix this issue.

Thanks for the patch, I'm going to add it to my 2.6.32 queue.

Best,
Rafael


> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
>  kernel/power/snapshot.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6-work/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6-work.orig/kernel/power/snapshot.c
> +++ linux-2.6-work/kernel/power/snapshot.c
> @@ -853,7 +853,7 @@ static unsigned int count_highmem_pages(
>  	struct zone *zone;
>  	unsigned int n = 0;
>  
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		unsigned long pfn, max_zone_pfn;
>  
>  		if (!is_highmem(zone))
> @@ -916,7 +916,7 @@ static unsigned int count_data_pages(voi
>  	unsigned long pfn, max_zone_pfn;
>  	unsigned int n = 0;
>  
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		if (is_highmem(zone))
>  			continue;
>  
> @@ -1010,7 +1010,7 @@ copy_data_pages(struct memory_bitmap *co
>  	struct zone *zone;
>  	unsigned long pfn;
>  
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		unsigned long max_zone_pfn;
>  
>  		mark_free_pages(zone);
> @@ -1046,7 +1046,7 @@ void swsusp_free(void)
>  	struct zone *zone;
>  	unsigned long pfn, max_zone_pfn;
>  
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
>  		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
>  			if (pfn_valid(pfn)) {
> @@ -1166,7 +1166,7 @@ static int enough_free_mem(unsigned int 
>  	struct zone *zone;
>  	unsigned int free = 0, meta = 0;
>  
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		meta += snapshot_additional_pages(zone);
>  		if (!is_highmem(zone))
>  			free += zone_page_state(zone, NR_FREE_PAGES);
> @@ -1474,7 +1474,7 @@ static int mark_unsafe_pages(struct memo
>  	unsigned long pfn, max_zone_pfn;
>  
>  	/* Clear page flags */
> -	for_each_zone(zone) {
> +	for_each_populated_zone(zone) {
>  		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
>  		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
>  			if (pfn_valid(pfn))
> 
> 
> 
