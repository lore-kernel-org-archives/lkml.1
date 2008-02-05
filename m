Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbYBEQBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbYBEQBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYBEQBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:01:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:49140 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758597AbYBEQBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:01:16 -0500
Date: Tue, 5 Feb 2008 17:01:15 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] udf: remove unneeded kernel_timestamp type
Message-ID: <20080205160115.GJ25464@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-6-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202063771-18172-6-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:36:10, marcin.slusarz@gmail.com wrote:
> remove now unneeded kernel_timestamp type with conversion functions
  OK. Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/ecma_167.h |   13 -------------
>  fs/udf/super.c    |    9 +++++----
>  fs/udf/udfend.h   |   22 ----------------------
>  3 files changed, 5 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
> index 5638771..a0974df 100644
> --- a/fs/udf/ecma_167.h
> +++ b/fs/udf/ecma_167.h
> @@ -70,19 +70,6 @@ typedef struct {
>  	uint8_t		microseconds;
>  } __attribute__ ((packed)) timestamp;
>  
> -typedef struct {
> -	uint16_t	typeAndTimezone;
> -	int16_t		year;
> -	uint8_t		month;
> -	uint8_t		day;
> -	uint8_t		hour;
> -	uint8_t		minute;
> -	uint8_t		second;
> -	uint8_t		centiseconds;
> -	uint8_t		hundredsOfMicroseconds;
> -	uint8_t		microseconds;
> -} __attribute__ ((packed)) kernel_timestamp;
> -
>  /* Type and Time Zone (ECMA 167r3 1/7.3.1) */
>  #define TIMESTAMP_TYPE_MASK		0xF000
>  #define TIMESTAMP_TYPE_CUT		0x0000
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 8a98a2e..3a7faad 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -916,12 +916,13 @@ static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
>  
>  	if (udf_stamp_to_time(&UDF_SB(sb)->s_record_time,
>  			      pvoldesc->recordingDateAndTime)) {
> -		kernel_timestamp ts;
> -		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
> +#ifdef UDFFS_DEBUG
> +		timestamp *ts = &pvoldesc->recordingDateAndTime;
>  		udf_debug("recording time %04u/%02u/%02u"
>  			  " %02u:%02u (%x)\n",
> -			  ts.year, ts.month, ts.day, ts.hour,
> -			  ts.minute, ts.typeAndTimezone);
> +			  le16_to_cpu(ts->year), ts->month, ts->day, ts->hour,
> +			  ts->minute, le16_to_cpu(ts->typeAndTimezone));
> +#endif
>  	}
>  
>  	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
> diff --git a/fs/udf/udfend.h b/fs/udf/udfend.h
> index c4bd120..489f52f 100644
> --- a/fs/udf/udfend.h
> +++ b/fs/udf/udfend.h
> @@ -24,17 +24,6 @@ static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
>  	return out;
>  }
>  
> -static inline kernel_timestamp lets_to_cpu(timestamp in)
> -{
> -	kernel_timestamp out;
> -
> -	memcpy(&out, &in, sizeof(timestamp));
> -	out.typeAndTimezone = le16_to_cpu(in.typeAndTimezone);
> -	out.year = le16_to_cpu(in.year);
> -
> -	return out;
> -}
> -
>  static inline short_ad lesa_to_cpu(short_ad in)
>  {
>  	short_ad out;
> @@ -85,15 +74,4 @@ static inline kernel_extent_ad leea_to_cpu(extent_ad in)
>  	return out;
>  }
>  
> -static inline timestamp cpu_to_lets(kernel_timestamp in)
> -{
> -	timestamp out;
> -
> -	memcpy(&out, &in, sizeof(timestamp));
> -	out.typeAndTimezone = cpu_to_le16(in.typeAndTimezone);
> -	out.year = cpu_to_le16(in.year);
> -
> -	return out;
> -}
> -
>  #endif /* __UDF_ENDIAN_H */
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
