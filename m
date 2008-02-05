Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYBEQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYBEQAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYBEP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:59:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:38062 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751639AbYBEP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:59:58 -0500
Date: Tue, 5 Feb 2008 16:59:56 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] udf: convert udf_stamp_to_time and
	udf_time_to_stamp to use timestamps
Message-ID: <20080205155956.GI25464@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202063771-18172-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:36:09, marcin.slusarz@gmail.com wrote:
> kernel_timestamp type was almost unused - only callers of udf_stamp_to_time
> and udf_time_to_stamp used it, so let these functions handle endianness
> internally and don't clutter code with conversions
  OK, but please also rename the functions to something like
udf_disk_stamp_to_time() and udf_time_to_disk_stamp() so that the name
suggests that it internally handles endianess...

								Honza
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/inode.c   |   43 ++++++++++++++-----------------------------
>  fs/udf/super.c   |   16 ++++++----------
>  fs/udf/udfdecl.h |    4 ++--
>  fs/udf/udftime.c |   22 ++++++++++++----------
>  4 files changed, 34 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 252efe0..654b504 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1242,16 +1242,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
>  			(inode->i_sb->s_blocksize_bits - 9);
>  
> -		if (!udf_stamp_to_time(&inode->i_atime,
> -					lets_to_cpu(fe->accessTime)))
> +		if (!udf_stamp_to_time(&inode->i_atime, fe->accessTime))
>  			inode->i_atime = sbi->s_record_time;
>  
> -		if (!udf_stamp_to_time(&inode->i_mtime,
> -					lets_to_cpu(fe->modificationTime)))
> +		if (!udf_stamp_to_time(&inode->i_mtime, fe->modificationTime))
>  			inode->i_mtime = sbi->s_record_time;
>  
> -		if (!udf_stamp_to_time(&inode->i_ctime,
> -					lets_to_cpu(fe->attrTime)))
> +		if (!udf_stamp_to_time(&inode->i_ctime, fe->attrTime))
>  			inode->i_ctime = sbi->s_record_time;
>  
>  		iinfo->i_unique = le64_to_cpu(fe->uniqueID);
> @@ -1262,20 +1259,16 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
>  		    (inode->i_sb->s_blocksize_bits - 9);
>  
> -		if (!udf_stamp_to_time(&inode->i_atime,
> -					lets_to_cpu(efe->accessTime)))
> +		if (!udf_stamp_to_time(&inode->i_atime, efe->accessTime))
>  			inode->i_atime = sbi->s_record_time;
>  
> -		if (!udf_stamp_to_time(&inode->i_mtime,
> -					lets_to_cpu(efe->modificationTime)))
> +		if (!udf_stamp_to_time(&inode->i_mtime, efe->modificationTime))
>  			inode->i_mtime = sbi->s_record_time;
>  
> -		if (!udf_stamp_to_time(&iinfo->i_crtime,
> -					lets_to_cpu(efe->createTime)))
> +		if (!udf_stamp_to_time(&iinfo->i_crtime, efe->createTime))
>  			iinfo->i_crtime = sbi->s_record_time;
>  
> -		if (!udf_stamp_to_time(&inode->i_ctime,
> -					lets_to_cpu(efe->attrTime)))
> +		if (!udf_stamp_to_time(&inode->i_ctime, efe->attrTime))
>  			inode->i_ctime = sbi->s_record_time;
>  
>  		iinfo->i_unique = le64_to_cpu(efe->uniqueID);
> @@ -1412,7 +1405,6 @@ static int udf_update_inode(struct inode *inode, int do_sync)
>  	uint32_t udfperms;
>  	uint16_t icbflags;
>  	uint16_t crclen;
> -	kernel_timestamp cpu_time;
>  	int err = 0;
>  	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
>  	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
> @@ -1515,12 +1507,9 @@ static int udf_update_inode(struct inode *inode, int do_sync)
>  			(inode->i_blocks + (1 << (blocksize_bits - 9)) - 1) >>
>  			(blocksize_bits - 9));
>  
> -		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
> -			fe->accessTime = cpu_to_lets(cpu_time);
> -		if (udf_time_to_stamp(&cpu_time, inode->i_mtime))
> -			fe->modificationTime = cpu_to_lets(cpu_time);
> -		if (udf_time_to_stamp(&cpu_time, inode->i_ctime))
> -			fe->attrTime = cpu_to_lets(cpu_time);
> +		udf_time_to_stamp(&fe->accessTime, inode->i_atime);
> +		udf_time_to_stamp(&fe->modificationTime, inode->i_mtime);
> +		udf_time_to_stamp(&fe->attrTime, inode->i_ctime);
>  		memset(&(fe->impIdent), 0, sizeof(regid));
>  		strcpy(fe->impIdent.ident, UDF_ID_DEVELOPER);
>  		fe->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
> @@ -1555,14 +1544,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
>  		     iinfo->i_crtime.tv_nsec > inode->i_ctime.tv_nsec))
>  			iinfo->i_crtime = inode->i_ctime;
>  
> -		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
> -			efe->accessTime = cpu_to_lets(cpu_time);
> -		if (udf_time_to_stamp(&cpu_time, inode->i_mtime))
> -			efe->modificationTime = cpu_to_lets(cpu_time);
> -		if (udf_time_to_stamp(&cpu_time, iinfo->i_crtime))
> -			efe->createTime = cpu_to_lets(cpu_time);
> -		if (udf_time_to_stamp(&cpu_time, inode->i_ctime))
> -			efe->attrTime = cpu_to_lets(cpu_time);
> +		udf_time_to_stamp(&efe->accessTime, inode->i_atime);
> +		udf_time_to_stamp(&efe->modificationTime, inode->i_mtime);
> +		udf_time_to_stamp(&efe->createTime, iinfo->i_crtime);
> +		udf_time_to_stamp(&efe->attrTime, inode->i_ctime);
>  
>  		memset(&(efe->impIdent), 0, sizeof(regid));
>  		strcpy(efe->impIdent.ident, UDF_ID_DEVELOPER);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 9f565a9..8a98a2e 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -915,7 +915,7 @@ static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
>  	pvoldesc = (struct primaryVolDesc *)bh->b_data;
>  
>  	if (udf_stamp_to_time(&UDF_SB(sb)->s_record_time,
> -			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
> +			      pvoldesc->recordingDateAndTime)) {
>  		kernel_timestamp ts;
>  		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
>  		udf_debug("recording time %04u/%02u/%02u"
> @@ -1561,7 +1561,6 @@ static void udf_open_lvid(struct super_block *sb)
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct buffer_head *bh = sbi->s_lvid_bh;
>  	if (bh) {
> -		kernel_timestamp cpu_time;
>  		struct logicalVolIntegrityDesc *lvid =
>  				(struct logicalVolIntegrityDesc *)bh->b_data;
>  		struct logicalVolIntegrityDescImpUse *lvidiu =
> @@ -1569,8 +1568,7 @@ static void udf_open_lvid(struct super_block *sb)
>  
>  		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
>  		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> -		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
> -			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
> +		udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
>  		lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
>  
>  		lvid->descTag.descCRC = cpu_to_le16(
> @@ -1585,7 +1583,6 @@ static void udf_open_lvid(struct super_block *sb)
>  
>  static void udf_close_lvid(struct super_block *sb)
>  {
> -	kernel_timestamp cpu_time;
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct buffer_head *bh = sbi->s_lvid_bh;
>  	struct logicalVolIntegrityDesc *lvid;
> @@ -1600,8 +1597,7 @@ static void udf_close_lvid(struct super_block *sb)
>  							udf_sb_lvidiu(sbi);
>  		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
>  		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
> -		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
> -			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
> +		udf_time_to_stamp(&lvid->recordingDateAndTime, CURRENT_TIME);
>  		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
>  			lvidiu->maxUDFWriteRev =
>  					cpu_to_le16(UDF_MAX_WRITE_VERSION);
> @@ -1786,12 +1782,12 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  	}
>  
>  	if (!silent) {
> -		kernel_timestamp ts;
> +		timestamp ts;
>  		udf_time_to_stamp(&ts, sbi->s_record_time);
>  		udf_info("UDF: Mounting volume '%s', "
>  			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
> -			 sbi->s_volume_ident, ts.year, ts.month, ts.day,
> -			 ts.hour, ts.minute, ts.typeAndTimezone);
> +			 sbi->s_volume_ident, le16_to_cpu(ts.year), ts.month, ts.day,
> +			 ts.hour, ts.minute, le16_to_cpu(ts.typeAndTimezone));
>  	}
>  	if (!(sb->s_flags & MS_RDONLY))
>  		udf_open_lvid(sb);
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 508be85..2dd04bb 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -204,7 +204,7 @@ extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
>  extern uint16_t udf_crc(const uint8_t *, uint32_t, uint16_t);
>  
>  /* udftime.c */
> -extern struct timespec *udf_stamp_to_time(struct timespec *dest, kernel_timestamp src);
> -extern kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec src);
> +extern struct timespec *udf_stamp_to_time(struct timespec *dest, timestamp src);
> +extern timestamp *udf_time_to_stamp(timestamp *dest, struct timespec src);
>  
>  #endif				/* __UDF_DECL_H */
> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
> index 12fae6c..d125bd9 100644
> --- a/fs/udf/udftime.c
> +++ b/fs/udf/udftime.c
> @@ -85,14 +85,16 @@ extern struct timezone sys_tz;
>  #define SECS_PER_HOUR	(60 * 60)
>  #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
>  
> -struct timespec *udf_stamp_to_time(struct timespec *dest, kernel_timestamp src)
> +struct timespec *udf_stamp_to_time(struct timespec *dest, timestamp src)
>  {
>  	int yday;
> -	uint8_t type = src.typeAndTimezone >> 12;
> +	u16 typeAndTimezone = le16_to_cpu(src.typeAndTimezone);
> +	u16 year = le16_to_cpu(src.year);
> +	uint8_t type = typeAndTimezone >> 12;
>  	int16_t offset;
>  
>  	if (type == 1) {
> -		offset = src.typeAndTimezone << 4;
> +		offset = typeAndTimezone << 4;
>  		/* sign extent offset */
>  		offset = (offset >> 4);
>  		if (offset == -2047) /* unspecified offset */
> @@ -100,21 +102,21 @@ struct timespec *udf_stamp_to_time(struct timespec *dest, kernel_timestamp src)
>  	} else
>  		offset = 0;
>  
> -	if ((src.year < EPOCH_YEAR) ||
> -	    (src.year >= EPOCH_YEAR + MAX_YEAR_SECONDS)) {
> +	if ((year < EPOCH_YEAR) ||
> +	    (year >= EPOCH_YEAR + MAX_YEAR_SECONDS)) {
>  		return NULL;
>  	}
> -	dest->tv_sec = year_seconds[src.year - EPOCH_YEAR];
> +	dest->tv_sec = year_seconds[year - EPOCH_YEAR];
>  	dest->tv_sec -= offset * 60;
>  
> -	yday = ((__mon_yday[__isleap(src.year)][src.month - 1]) + src.day - 1);
> +	yday = ((__mon_yday[__isleap(year)][src.month - 1]) + src.day - 1);
>  	dest->tv_sec += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
>  	dest->tv_nsec = 1000 * (src.centiseconds * 10000 +
>  			src.hundredsOfMicroseconds * 100 + src.microseconds);
>  	return dest;
>  }
>  
> -kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
> +timestamp *udf_time_to_stamp(timestamp *dest, struct timespec ts)
>  {
>  	long int days, rem, y;
>  	const unsigned short int *ip;
> @@ -125,7 +127,7 @@ kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
>  	if (!dest)
>  		return NULL;
>  
> -	dest->typeAndTimezone = 0x1000 | (offset & 0x0FFF);
> +	dest->typeAndTimezone = cpu_to_le16(0x1000 | (offset & 0x0FFF));
>  
>  	ts.tv_sec += offset * 60;
>  	days = ts.tv_sec / SECS_PER_DAY;
> @@ -148,7 +150,7 @@ kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
>  			 - LEAPS_THRU_END_OF(y - 1));
>  		y = yg;
>  	}
> -	dest->year = y;
> +	dest->year = cpu_to_le16(y);
>  	ip = __mon_yday[__isleap(y)];
>  	for (y = 11; days < (long int)ip[y]; --y)
>  		continue;
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
