Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXLMRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXLMRWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759214AbXLMRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:22:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:44034 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbXLMRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:22:07 -0500
Date: Thu, 13 Dec 2007 09:21:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 1/8] Enhanced partition statistics: core statistics
Message-Id: <20071213092118.3640a49b.randy.dunlap@oracle.com>
In-Reply-To: <47615B1A.7040805@redhat.com>
References: <47615B1A.7040805@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 17:17:30 +0100 Jerome Marchand wrote:

> This patch contain the core infrastructure of enhanced partition statistics.
> It adds to struct hd_struct the same stats data as struct gendisk and define basics function to manipulate them.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  genhd.h |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 128 insertions(+), 1 deletion(-)

Please use "diffstat -p1 -w70" (Documentation/SubmittingPatches).

> diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
> --- linux-2.6.orig/include/linux/genhd.h	2007-12-05 12:17:42.000000000 +0100
> +++ linux-2.6/include/linux/genhd.h	2007-12-05 12:17:53.000000000 +0100
> @@ -91,6 +91,13 @@ struct hd_struct {
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	int make_it_fail;
>  #endif
> +	unsigned long stamp;
> +	int in_flight;
> +#ifdef	CONFIG_SMP
> +	struct disk_stats *dkstats;
> +#else
> +	struct disk_stats dkstats;
> +#endif
>  };
>  
>  #define GENHD_FL_REMOVABLE			1
> @@ -156,6 +163,19 @@ struct disk_attribute {
>   * The __ variants should only be called in critical sections. The full
>   * variants disable/enable preemption.
>   */
> +static inline struct hd_struct *get_part(struct gendisk *gendiskp, sector_t sector)
> +{
> +	struct hd_struct *part;
> +	int i;
> +	for (i=0; i < gendiskp->minors - 1; i++){

	for (i = 0; i < gendiskp->minors - 1; i++) {

> +		part = gendiskp->part[i];
> +		if (part && part->start_sect <= sector
> +		    && sector <= part->start_sect + part->nr_sects)

I expect that the second comparison should just be <, not <=.

> +			return part;
> +	}
> +	return NULL;
> +}
> +
>  #ifdef	CONFIG_SMP
>  #define __disk_stat_add(gendiskp, field, addnd) 	\
>  	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
> @@ -175,15 +195,60 @@ static inline void disk_stat_set_all(str
>  		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
>  				sizeof (struct disk_stats));
>  }		
> +
> +#define __part_stat_add(part, field, addnd)				\
> +	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
> +
> +#define __all_stat_add(gendiskp, field, addnd, sector)		\
> +({								\
> +	struct hd_struct *part = get_part(gendiskp, sector);	\
> +	if (part) __part_stat_add(part, field, addnd);		\

	if (part)						\
		__part_stat_add(part, field, addnd);		\

> +	__disk_stat_add(gendiskp, field, addnd);		\
> +})
> +
> +#define part_stat_read(part, field)					\
> +({									\
> +	typeof(part->dkstats->field) res = 0;				\
> +	int i;								\
> +	for_each_possible_cpu(i)					\
> +		res += per_cpu_ptr(part->dkstats, i)->field;		\
> +	res;								\
> +})
> +
> +static inline void part_stat_set_all(struct hd_struct *part, int value)	{
> +	int i;
> +	for_each_possible_cpu(i)
> +		memset(per_cpu_ptr(part->dkstats, i), value,
> +		       sizeof (struct disk_stats));
> +}
>  				
>  #else
>  #define __disk_stat_add(gendiskp, field, addnd) \
>  				(gendiskp->dkstats.field += addnd)
>  #define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
>  
> -static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
> +static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
> +{
>  	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
>  }
> +
> +#define __part_stat_add(part, field, addnd) \
> +	(part->dkstats.field += addnd)
> +
> +#define __all_stat_add(gendiskp, field, addnd, sector)		\
> +({								\
> +	struct hd_struct *part = get_part(gendiskp, sector);	\
> +	if (part) part->dkstats.field += addnd;			\

if-condition + following statement on separate lines, please.

> +	__disk_stat_add(gendiskp, field, addnd);		\
> +})
> +
> +#define part_stat_read(part, field)	(part->dkstats.field)
> +
> +static inline void part_stat_set_all(struct hd_struct *part, int value)
> +{
> +	memset(&part->dkstats, value, sizeof (struct disk_stats));
> +}
> +
>  #endif
>  
>  #define disk_stat_add(gendiskp, field, addnd)			\

---
~Randy
