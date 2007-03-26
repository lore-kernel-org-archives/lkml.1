Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbXCZEUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbXCZEUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCZEUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:20:06 -0400
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:65160 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933570AbXCZEUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:20:03 -0400
X-Greylist: delayed 889 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 00:20:03 EDT
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Paul Collins <paul@briny.ondioline.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat/vfat: optionally ignore system timezone offset when reading/writing
 timestamps
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 5.0.12   February 13, 2003
Message-ID: <OFE734E183.0E10CA2B-ON492572AA.00132685-492572AA.0016700F@hq.scei.sony.co.jp>
From: Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp>
Date: Mon, 26 Mar 2007 13:05:10 +0900
X-MIMETrack: Serialize by Router on SCE_MGW01/SCEI(Release 7.0.2FP1|January 10, 2007) at
 2007/03/26 13:05:11,
	Serialize complete at 2007/03/26 13:05:11
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HI OGAWA-san and Paul-san,

Sorry late response,

I'm not famillar with recent fat code, but code itself looks good for
just turn on/off time adjusting. On the other hand, I feel we need more 
consideration on use cases/requirements. I feel that turning off
time adjustment is a just ad-hoc solution to issues like Paul san 
brought up.

Thanks,
Hiroyuki
 

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote on 2007/03/19 23:31:06:
> Paul Collins <paul@briny.ondioline.org> writes:
> 
> > Hello,
> 
> Hello,
> 
> > Here is a patch that adds a mount option named "posixtime" that, when
> > enabled, causes the fat/vfat code to not adjust timestamps as they are
> > read/written to/from disk.  The intent of the adjustment as performed
> > by the existing code appears to be to present correct timestamps to
> > Windows and friends, which treat the timestamp values as local time.
> >
> > However, the systems that I use to update my FAT32 filesystems are all
> > running Linux, and as such will process POSIX timestamps correctly.
> > (The filesystems are on disks in digital audio players, which do not
> > process timestamps except to check if they have changed.)  Due to the
> > aforementioned adjustment on read/write, after a Daylight Savings
> > transition I must update the file timestamps on the filesystems so
> > that rsync does not needlessly re-copy files.
> >
> > Please review and consider applying this patch.
> 
> Thanks. Looks good to me as start. IIRC, Machida-san did this few
> years ago. Machida-san, do you have any comment?
> 
> > diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> > index c16af24..d6c0a7f 100644
> > --- a/fs/fat/dir.c
> > +++ b/fs/fat/dir.c
> > @@ -1064,7 +1064,7 @@ int fat_alloc_new_dir(struct inode *dir, struct 
> timespec *ts)
> >    goto error_free;
> >   }
> >
> > - fat_date_unix2dos(ts->tv_sec, &time, &date);
> > + fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.adjust);
> >
> >   de = (struct msdos_dir_entry *)bhs[0]->b_data;
> >   /* filling the new directory slots ("." and ".." entries) */
> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> > index a9e4688..02d9225 100644
> > --- a/fs/fat/inode.c
> > +++ b/fs/fat/inode.c
> > @@ -374,17 +374,20 @@ static int fat_fill_inode(struct inode *inode, 
> struct msdos_dir_entry *de)
> >   inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
> >        & ~((loff_t)sbi->cluster_size - 1)) >> 9;
> >   inode->i_mtime.tv_sec =
> > -  date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date));
> > +  date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date),
> > +         sbi->options.adjust);
> >   inode->i_mtime.tv_nsec = 0;
> >   if (sbi->options.isvfat) {
> >    int secs = de->ctime_cs / 100;
> >    int csecs = de->ctime_cs % 100;
> >    inode->i_ctime.tv_sec  =
> >     date_dos2unix(le16_to_cpu(de->ctime),
> > -          le16_to_cpu(de->cdate)) + secs;
> > +          le16_to_cpu(de->cdate),
> > +          sbi->options.adjust) + secs;
> >    inode->i_ctime.tv_nsec = csecs * 10000000;
> >    inode->i_atime.tv_sec =
> > -   date_dos2unix(0, le16_to_cpu(de->adate));
> > +   date_dos2unix(0, le16_to_cpu(de->adate),
> > +          sbi->options.adjust);
> >    inode->i_atime.tv_nsec = 0;
> >   } else
> >    inode->i_ctime = inode->i_atime = inode->i_mtime;
> > @@ -592,11 +595,14 @@ retry:
> >   raw_entry->attr = fat_attr(inode);
> >   raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
> >   raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
> > - fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, 
> &raw_entry->date);
> > + fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, 
> &raw_entry->date,
> > +     sbi->options.adjust);
> >   if (sbi->options.isvfat) {
> >    __le16 atime;
> > - 
> fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cd
> ate);
> > -  fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate);
> > + 
> fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cd
> ate,
> > +      sbi->options.adjust);
> > +  fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate,
> > +      sbi->options.adjust);
> >    raw_entry->ctime_cs = (inode->i_ctime.tv_sec & 1) * 100 +
> >     inode->i_ctime.tv_nsec / 10000000;
> >   }
> > @@ -854,7 +860,7 @@ enum {
> >   Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
> >   Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
> >   Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
> > - Opt_obsolate, Opt_flush, Opt_err,
> > + Opt_obsolate, Opt_flush, Opt_posixtime, Opt_err,
> >  };
> >
> >  static match_table_t fat_tokens = {
> > @@ -887,6 +893,7 @@ static match_table_t fat_tokens = {
> >   {Opt_obsolate, "cvf_options=%100s"},
> >   {Opt_obsolate, "posix"},
> >   {Opt_flush, "flush"},
> > + {Opt_posixtime, "posixtime"},
> >   {Opt_err, NULL},
> >  };
> >  static match_table_t msdos_tokens = {
> > @@ -950,6 +957,7 @@ static int parse_options(char *options, int 
> is_vfat, int silent, int *debug,
> >   opts->utf8 = opts->unicode_xlate = 0;
> >   opts->numtail = 1;
> >   opts->nocase = 0;
> > + opts->adjust = 1;
> >   *debug = 0;
> >
> >   if (!options)
> > @@ -1032,6 +1040,10 @@ static int parse_options(char *options, int 
> is_vfat, int silent, int *debug,
> >     opts->flush = 1;
> >     break;
> >
> > +  case Opt_posixtime:
> > +   opts->adjust = 0;
> > +   break;
> > +
> >    /* msdos specific */
> >    case Opt_dots:
> >     opts->dotsOK = 1;
> > diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> > index 308f2b6..72a1a29 100644
> > --- a/fs/fat/misc.c
> > +++ b/fs/fat/misc.c
> > @@ -143,7 +143,7 @@ static int day_n[] = {
> >  };
> >
> >  /* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 
> 70). */
> > -int date_dos2unix(unsigned short time, unsigned short date)
> > +int date_dos2unix(unsigned short time, unsigned short date, int 
> adjust)
> >  {
> >   int month, year, secs;
> >
> > @@ -157,16 +157,18 @@ int date_dos2unix(unsigned short time, unsigned 
> short date)
> >       ((date & 31)-1+day_n[month]+(year/4)+year*365-((year & 3) == 0 
> &&
> >       month < 2 ? 1 : 0)+3653);
> >     /* days since 1.1.70 plus 80's leap day */
> > - secs += sys_tz.tz_minuteswest*60;
> > + if (adjust)
> > +  secs += sys_tz.tz_minuteswest*60;
> >   return secs;
> >  }
> >
> >  /* Convert linear UNIX date to a MS-DOS time/date pair. */
> > -void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date)
> > +void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, 
> int adjust)
> >  {
> >   int day, year, nl_day, month;
> >
> > - unix_date -= sys_tz.tz_minuteswest*60;
> > + if (adjust)
> > +  unix_date -= sys_tz.tz_minuteswest*60;
> >
> >   /* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
> >   if (unix_date < 315532800)
> > diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
> > index 0afd745..7e5487b 100644
> > --- a/fs/vfat/namei.c
> > +++ b/fs/vfat/namei.c
> > @@ -626,7 +626,7 @@ shortname:
> >   memcpy(de->name, msdos_name, MSDOS_NAME);
> >   de->attr = is_dir ? ATTR_DIR : ATTR_ARCH;
> >   de->lcase = lcase;
> > - fat_date_unix2dos(ts->tv_sec, &time, &date);
> > + fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.adjust);
> >   de->time = de->ctime = time;
> >   de->date = de->cdate = de->adate = date;
> >   de->ctime_cs = 0;
> > diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> > index 24a9ef1..b3eeec8 100644
> > --- a/include/linux/msdos_fs.h
> > +++ b/include/linux/msdos_fs.h
> > @@ -205,7 +205,8 @@ struct fat_mount_options {
> >     numtail:1,       /* Does first alias have a numeric '~1' type 
> tail? */
> >     atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
> >     flush:1,   /* write things quickly */
> > -   nocase:1;   /* Does this need case conversion? 0=need case 
> conversion*/
> > +   nocase:1,   /* Does this need case conversion? 0=need case 
> conversion*/
> > +   adjust:1;   /* Adjust time and date based on sys_tz?*/
> >  };
> >
> >  #define FAT_HASH_BITS 8
> > @@ -421,8 +422,8 @@ extern int fat_flush_inodes(struct super_block 
> *sb, struct inode *i1,
> >  extern void fat_fs_panic(struct super_block *s, const char *fmt, 
> ...);
> >  extern void fat_clusters_flush(struct super_block *sb);
> >  extern int fat_chain_add(struct inode *inode, int new_dclus, int 
> nr_cluster);
> > -extern int date_dos2unix(unsigned short time, unsigned short date);
> > -extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 
> *date);
> > +extern int date_dos2unix(unsigned short time, unsigned short date, 
> int adjust);
> > +extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 
> *date, int adjust);
> >  extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
> >
> >  int fat_cache_init(void);
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

