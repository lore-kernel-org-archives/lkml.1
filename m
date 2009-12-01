Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZLASlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZLASlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZLASlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:41:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54815 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZLASlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=iCaeY4melTUzJ6vibCGO8iZxgvTgwAfgEw6vAb1b/ZV+ynbi4QGb1j2GjDYlsqJ4Hg
         hloZFYZhLdacCICnBdaKDB9ojVnlRpHunFzfe8ZeTPxeD73wsOigactZ2XCm2r85v95J
         mzQWWpTdqgtteCPWM4y/JcSY/kGb67DQr6TzA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] drivers/block/floppy.c: stylistic cleanups
Date: Tue, 1 Dec 2009 19:39:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1259001504.16503.79.camel@Joe-Laptop.home> <20091130092837.4998f961@nehalam> <1259640820.13592.37.camel@Joe-Laptop.home>
In-Reply-To: <1259640820.13592.37.camel@Joe-Laptop.home>
MIME-Version: 1.0
Message-Id: <200912011939.45158.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009 05:13:40 am Joe Perches wrote:
> On Mon, 2009-11-30 at 09:28 -0800, Stephen Hemminger wrote:
> > Rather than playing with the dangling operator format which seems to be a coding
> > style that only David cares about. Why not go through and fix the really ugly old
> > drivers that need it. For a good horror experience, go look at the floppy driver.
> 
> Just for you Stephen, here's a cleaned up version.
> Now to see if it gets applied, which I rather doubt.


>  drivers/block/floppy.c | 1853 +++++++++++++++++++++++++++++++++---------------
>  1 files changed, 1279 insertions(+), 574 deletions(-)

+700 LOC for cleanup patch is a bit excessive, I like macro removals and other
improvements from your patch but the following change is an insanity:

>  /*
>   * this struct defines the different floppy drive types.
>   */
> -static struct {
> +struct drive_params {
>  	struct floppy_drive_params params;
>  	const char *name;	/* name printed while booting */
> -} default_drive_params[] = {
> -/* NOTE: the time values in jiffies should be in msec!
> - CMOS drive type
> -  |     Maximum data rate supported by drive type
> -  |     |   Head load time, msec
> -  |     |   |   Head unload time, msec (not used)
> -  |     |   |   |     Step rate interval, usec
> -  |     |   |   |     |       Time needed for spinup time (jiffies)
> -  |     |   |   |     |       |      Timeout for spinning down (jiffies)
> -  |     |   |   |     |       |      |   Spindown offset (where disk stops)
> -  |     |   |   |     |       |      |   |     Select delay
> -  |     |   |   |     |       |      |   |     |     RPS
> -  |     |   |   |     |       |      |   |     |     |    Max number of tracks
> -  |     |   |   |     |       |      |   |     |     |    |     Interrupt timeout
> -  |     |   |   |     |       |      |   |     |     |    |     |   Max nonintlv. sectors
> -  |     |   |   |     |       |      |   |     |     |    |     |   | -Max Errors- flags */
> -{{0,  500, 16, 16, 8000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  80, 3*HZ, 20, {3,1,2,0,2}, 0,
> -      0, { 7, 4, 8, 2, 1, 5, 3,10}, 3*HZ/2, 0 }, "unknown" },
> -
> -{{1,  300, 16, 16, 8000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  40, 3*HZ, 17, {3,1,2,0,2}, 0,
> -      0, { 1, 0, 0, 0, 0, 0, 0, 0}, 3*HZ/2, 1 }, "360K PC" }, /*5 1/4 360 KB PC*/
> -
> -{{2,  500, 16, 16, 6000, 4*HZ/10, 3*HZ, 14, SEL_DLY, 6,  83, 3*HZ, 17, {3,1,2,0,2}, 0,
> -      0, { 2, 5, 6,23,10,20,12, 0}, 3*HZ/2, 2 }, "1.2M" }, /*5 1/4 HD AT*/
> -
> -{{3,  250, 16, 16, 3000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  83, 3*HZ, 20, {3,1,2,0,2}, 0,
> -      0, { 4,22,21,30, 3, 0, 0, 0}, 3*HZ/2, 4 }, "720k" }, /*3 1/2 DD*/
> -
> -{{4,  500, 16, 16, 4000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 20, {3,1,2,0,2}, 0,
> -      0, { 7, 4,25,22,31,21,29,11}, 3*HZ/2, 7 }, "1.44M" }, /*3 1/2 HD*/
> -
> -{{5, 1000, 15,  8, 3000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 40, {3,1,2,0,2}, 0,
> -      0, { 7, 8, 4,25,28,22,31,21}, 3*HZ/2, 8 }, "2.88M AMI BIOS" }, /*3 1/2 ED*/
> -
> -{{6, 1000, 15,  8, 3000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 40, {3,1,2,0,2}, 0,
> -      0, { 7, 8, 4,25,28,22,31,21}, 3*HZ/2, 8 }, "2.88M" } /*3 1/2 ED*/
> -/*    |  --autodetected formats---    |      |      |
> - *    read_track                      |      |    Name printed when booting
> - *				      |     Native format
> - *	            Frequency of disk change checks */
> +};
> +
> +static struct drive_params default_drive_params[] = {
> +/* NOTE: the time values in jiffies should be in msec! */
> +	{
> +		.params = {
> +			.cmos = 0,
> +			.max_dtr = 500,
> +			.hlt = 16,
> +			.hut = 16,
> +			.srt = 8000,
> +			.spinup = 1 * HZ,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 0,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 80,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 20,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {7, 4, 8, 2, 1, 5, 3, 10},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 0
> +		},
> +		.name = "unknown"
> +	},
> +
> +	{				/*5 1/4 360 KB PC */
> +		.params = {
> +			.cmos = 1,
> +			.max_dtr = 300,
> +			.hlt = 16,
> +			.hut = 16,
> +			.srt = 8000,
> +			.spinup = 1 * HZ,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 0,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 40,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 17,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {1, 0, 0, 0, 0, 0, 0, 0},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 1
> +		},
> +		.name = "360K PC"
> +	},
> +
> +	{				/*5 1/4 HD AT */
> +		.params = {
> +			.cmos = 2,
> +			.max_dtr = 500,
> +			.hlt = 16,
> +			.hut = 16,
> +			.srt = 6000,
> +			.spinup = 4 * HZ / 10,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 14,
> +			.select_delay = SEL_DLY,
> +			.rps = 6,
> +			.tracks = 83,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 17,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {2, 5, 6, 23, 10, 20, 12, 0},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 2
> +		},
> +		.name = "1.2M"
> +	},
> +
> +	{				/*3 1/2 DD */
> +		.params = {
> +			.cmos = 3,
> +			.max_dtr = 250,
> +			.hlt = 16,
> +			.hut = 16,
> +			.srt = 3000,
> +			.spinup = 1 * HZ,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 0,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 83,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 20,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {4, 22, 21, 30, 3, 0, 0, 0},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 4
> +		},
> +		.name = "720k"
> +	},
> +
> +	{				/*3 1/2 HD */
> +		.params = {
> +			.cmos = 4,
> +			.max_dtr = 500,
> +			.hlt = 16,
> +			.hut = 16,
> +			.srt = 4000,
> +			.spinup = 4 * HZ / 10,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 10,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 83,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 20,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {7, 4, 25, 22, 31, 21, 29, 11},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 7
> +		},
> +		.name = "1.44M"
> +	},
> +
> +	{				/*3 1/2 ED */
> +		.params = {
> +			.cmos = 5,
> +			.max_dtr = 1000,
> +			.hlt = 15,
> +			.hut = 8,
> +			.srt = 3000,
> +			.spinup = 4 * HZ / 10,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 10,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 83,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 40,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {7, 8, 4, 25, 28, 22, 31, 21},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 8
> +		},
> +		.name = "2.88M AMI BIOS"
> +	},
> +
> +	{				/*3 1/2 ED */
> +		.params = {
> +			.cmos = 6,
> +			.max_dtr = 1000,
> +			.hlt = 15,
> +			.hut = 8,
> +			.srt = 3000,
> +			.spinup = 4 * HZ / 10,
> +			.spindown = 3 * HZ,
> +			.spindown_offset = 10,
> +			.select_delay = SEL_DLY,
> +			.rps = 5,
> +			.tracks = 83,
> +			.timeout = 3 * HZ,
> +			.interleave_sect = 40,
> +			.max_errors = {
> +				.abort = 3,
> +				.read_track = 1,
> +				.reset = 2,
> +				.recal = 0,
> +				.reporting = 2
> +			},
> +			.flags = 0,
> +			.read_track = 0,
> +			.autodetect = {7, 8, 4, 25, 28, 22, 31, 21},
> +			.checkfreq = 3 * HZ / 2,
> +			.native_format = 8
> +		},
> +		.name = "2.88M"
> +	}
>  };
>  
>  static struct floppy_drive_params drive_params[N_DRIVE];
> @@ -434,52 +615,391 @@ static struct floppy_raw_cmd *raw_cmd, default_raw_cmd;
>   *
>   * Other parameters should be self-explanatory (see also setfdprm(8)).
>   */
> -/*
> -	    Size
> -	     |  Sectors per track
> -	     |  | Head
> -	     |  | |  Tracks
> -	     |  | |  | Stretch
> -	     |  | |  | |  Gap 1 size
> -	     |  | |  | |    |  Data rate, | 0x40 for perp
> -	     |  | |  | |    |    |  Spec1 (stepping rate, head unload
> -	     |  | |  | |    |    |    |    /fmt gap (gap2) */
> -static struct floppy_struct floppy_type[32] = {
> -	{    0, 0,0, 0,0,0x00,0x00,0x00,0x00,NULL    },	/*  0 no testing    */
> -	{  720, 9,2,40,0,0x2A,0x02,0xDF,0x50,"d360"  }, /*  1 360KB PC      */
> -	{ 2400,15,2,80,0,0x1B,0x00,0xDF,0x54,"h1200" },	/*  2 1.2MB AT      */
> -	{  720, 9,1,80,0,0x2A,0x02,0xDF,0x50,"D360"  },	/*  3 360KB SS 3.5" */
> -	{ 1440, 9,2,80,0,0x2A,0x02,0xDF,0x50,"D720"  },	/*  4 720KB 3.5"    */
> -	{  720, 9,2,40,1,0x23,0x01,0xDF,0x50,"h360"  },	/*  5 360KB AT      */
> -	{ 1440, 9,2,80,0,0x23,0x01,0xDF,0x50,"h720"  },	/*  6 720KB AT      */
> -	{ 2880,18,2,80,0,0x1B,0x00,0xCF,0x6C,"H1440" },	/*  7 1.44MB 3.5"   */
> -	{ 5760,36,2,80,0,0x1B,0x43,0xAF,0x54,"E2880" },	/*  8 2.88MB 3.5"   */
> -	{ 6240,39,2,80,0,0x1B,0x43,0xAF,0x28,"E3120" },	/*  9 3.12MB 3.5"   */
> -
> -	{ 2880,18,2,80,0,0x25,0x00,0xDF,0x02,"h1440" }, /* 10 1.44MB 5.25"  */
> -	{ 3360,21,2,80,0,0x1C,0x00,0xCF,0x0C,"H1680" }, /* 11 1.68MB 3.5"   */
> -	{  820,10,2,41,1,0x25,0x01,0xDF,0x2E,"h410"  },	/* 12 410KB 5.25"   */
> -	{ 1640,10,2,82,0,0x25,0x02,0xDF,0x2E,"H820"  },	/* 13 820KB 3.5"    */
> -	{ 2952,18,2,82,0,0x25,0x00,0xDF,0x02,"h1476" },	/* 14 1.48MB 5.25"  */
> -	{ 3444,21,2,82,0,0x25,0x00,0xDF,0x0C,"H1722" },	/* 15 1.72MB 3.5"   */
> -	{  840,10,2,42,1,0x25,0x01,0xDF,0x2E,"h420"  },	/* 16 420KB 5.25"   */
> -	{ 1660,10,2,83,0,0x25,0x02,0xDF,0x2E,"H830"  },	/* 17 830KB 3.5"    */
> -	{ 2988,18,2,83,0,0x25,0x00,0xDF,0x02,"h1494" },	/* 18 1.49MB 5.25"  */
> -	{ 3486,21,2,83,0,0x25,0x00,0xDF,0x0C,"H1743" }, /* 19 1.74 MB 3.5"  */
> -
> -	{ 1760,11,2,80,0,0x1C,0x09,0xCF,0x00,"h880"  }, /* 20 880KB 5.25"   */
> -	{ 2080,13,2,80,0,0x1C,0x01,0xCF,0x00,"D1040" }, /* 21 1.04MB 3.5"   */
> -	{ 2240,14,2,80,0,0x1C,0x19,0xCF,0x00,"D1120" }, /* 22 1.12MB 3.5"   */
> -	{ 3200,20,2,80,0,0x1C,0x20,0xCF,0x2C,"h1600" }, /* 23 1.6MB 5.25"   */
> -	{ 3520,22,2,80,0,0x1C,0x08,0xCF,0x2e,"H1760" }, /* 24 1.76MB 3.5"   */
> -	{ 3840,24,2,80,0,0x1C,0x20,0xCF,0x00,"H1920" }, /* 25 1.92MB 3.5"   */
> -	{ 6400,40,2,80,0,0x25,0x5B,0xCF,0x00,"E3200" }, /* 26 3.20MB 3.5"   */
> -	{ 7040,44,2,80,0,0x25,0x5B,0xCF,0x00,"E3520" }, /* 27 3.52MB 3.5"   */
> -	{ 7680,48,2,80,0,0x25,0x63,0xCF,0x00,"E3840" }, /* 28 3.84MB 3.5"   */
> -	{ 3680,23,2,80,0,0x1C,0x10,0xCF,0x00,"H1840" }, /* 29 1.84MB 3.5"   */
> -
> -	{ 1600,10,2,80,0,0x25,0x02,0xDF,0x2E,"D800"  },	/* 30 800KB 3.5"    */
> -	{ 3200,20,2,80,0,0x1C,0x00,0xCF,0x2C,"H1600" }, /* 31 1.6MB 3.5"    */
> + static struct floppy_struct floppy_type[32] = {
> +	 {
> +		 .size = 0,
> +		 .sect = 0,
> +		 .head = 0,
> +		 .track = 0,
> +		 .stretch = 0,
> +		 .gap = 0x00,
> +		 .rate = 0x00,
> +		 .spec1 = 0x00,
> +		 .fmt_gap = 0x00,
> +		 .name = NULL
> +	 },	/*  0 no testing    */
> +	 {
> +		 .size = 720,
> +		 .sect = 9,
> +		 .head = 2,
> +		 .track = 40,
> +		 .stretch = 0,
> +		 .gap = 0x2A,
> +		 .rate = 0x02,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x50,
> +		 .name = "d360"
> +	 },	/*  1 360KB PC      */
> +	 {
> +		 .size = 2400,
> +		 .sect = 15,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1B,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x54,
> +		 .name = "h1200"
> +	 },	/*  2 1.2MB AT      */
> +	 {
> +		 .size = 720,
> +		 .sect = 9,
> +		 .head = 1,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x2A,
> +		 .rate = 0x02,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x50,
> +		 .name = "D360"
> +	 },	/*  3 360KB SS 3.5" */
> +	 {
> +		 .size = 1440,
> +		 .sect = 9,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x2A,
> +		 .rate = 0x02,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x50,
> +		 .name = "D720"
> +	 },	/*  4 720KB 3.5"    */
> +	 {
> +		 .size = 720,
> +		 .sect = 9,
> +		 .head = 2,
> +		 .track = 40,
> +		 .stretch = 1,
> +		 .gap = 0x23,
> +		 .rate = 0x01,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x50,
> +		 .name = "h360"
> +	 },	/*  5 360KB AT      */
> +	 {
> +		 .size = 1440,
> +		 .sect = 9,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x23,
> +		 .rate = 0x01,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x50,
> +		 .name = "h720"
> +	 },	/*  6 720KB AT      */
> +	 {
> +		 .size = 2880,
> +		 .sect = 18,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1B,
> +		 .rate = 0x00,
> +		 .spec1 = 0xCF,
> +		 .fmt_gap = 0x6C,
> +		 .name = "H1440"
> +	 },	/*  7 1.44MB 3.5"   */
> +	 {
> +		 .size = 5760,
> +		 .sect = 36,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1B,
> +		 .rate = 0x43,
> +		 .spec1 = 0xAF,
> +		 .fmt_gap = 0x54,
> +		 .name = "E2880"
> +	 },	/*  8 2.88MB 3.5"   */
> +	 {
> +		 .size = 6240,
> +		 .sect = 39,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1B,
> +		 .rate = 0x43,
> +		 .spec1 = 0xAF,
> +		 .fmt_gap = 0x28,
> +		 .name = "E3120"
> +	 },	/*  9 3.12MB 3.5"   */
> +	 {
> +		 .size = 2880,
> +		 .sect = 18,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x02,
> +		 .name = "h1440"
> +	 },	/* 10 1.44MB 5.25"  */
> +	 {
> +		 .size = 3360,
> +		 .sect = 21,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1C,
> +		 .rate = 0x00,
> +		 .spec1 = 0xCF,
> +		 .fmt_gap = 0x0C,
> +		 .name = "H1680"
> +	 },	/* 11 1.68MB 3.5"   */
> +	 {
> +		 .size = 820,
> +		 .sect = 10,
> +		 .head = 2,
> +		 .track = 41,
> +		 .stretch = 1,
> +		 .gap = 0x25,
> +		 .rate = 0x01,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x2E,
> +		 .name = "h410"
> +	 },	/* 12 410KB 5.25"   */
> +	 {
> +		 .size = 1640,
> +		 .sect = 10,
> +		 .head = 2,
> +		 .track = 82,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x02,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x2E,
> +		 .name = "H820"
> +	 },	/* 13 820KB 3.5"    */
> +	 {
> +		 .size = 2952,
> +		 .sect = 18,
> +		 .head = 2,
> +		 .track = 82,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x02,
> +		 .name = "h1476"
> +	 },	/* 14 1.48MB 5.25"  */
> +	 {
> +		 .size = 3444,
> +		 .sect = 21,
> +		 .head = 2,
> +		 .track = 82,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x0C,
> +		 .name = "H1722"
> +	 },	/* 15 1.72MB 3.5"   */
> +	 {
> +		 .size = 840,
> +		 .sect = 10,
> +		 .head = 2,
> +		 .track = 42,
> +		 .stretch = 1,
> +		 .gap = 0x25,
> +		 .rate = 0x01,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x2E,
> +		 .name = "h420"
> +	 },	/* 16 420KB 5.25"   */
> +	 {
> +		 .size = 1660,
> +		 .sect = 10,
> +		 .head = 2,
> +		 .track = 83,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x02,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x2E,
> +		 .name = "H830"
> +	 },	/* 17 830KB 3.5"    */
> +	 {
> +		 .size = 2988,
> +		 .sect = 18,
> +		 .head = 2,
> +		 .track = 83,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x02,
> +		 .name = "h1494"
> +	 },	/* 18 1.49MB 5.25"  */
> +	 {
> +		 .size = 3486,
> +		 .sect = 21,
> +		 .head = 2,
> +		 .track = 83,
> +		 .stretch = 0,
> +		 .gap = 0x25,
> +		 .rate = 0x00,
> +		 .spec1 = 0xDF,
> +		 .fmt_gap = 0x0C,
> +		 .name = "H1743"
> +	 },	/* 19 1.74 MB 3.5"  */
> +	 {
> +		 .size = 1760,
> +		 .sect = 11,
> +		 .head = 2,
> +		 .track = 80,
> +		 .stretch = 0,
> +		 .gap = 0x1C,
> +		 .rate = 0x09,
> +		 .spec1 = 0xCF,
> +		 .fmt_gap = 0x00,
> +		 .name = "h880"
> +	},	/* 20 880KB 5.25"   */
> +	{
> +		.size = 2080,
> +		.sect = 13,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x01,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "D1040"
> +	},	/* 21 1.04MB 3.5"   */
> +	{
> +		.size = 2240,
> +		.sect = 14,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x19,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "D1120"
> +	},	/* 22 1.12MB 3.5"   */
> +	{
> +		.size = 3200,
> +		.sect = 20,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x20,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x2C,
> +		.name = "h1600"
> +	},	/* 23 1.6MB 5.25"   */
> +	{
> +		.size = 3520,
> +		.sect = 22,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x08,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x2e,
> +		.name = "H1760"
> +	},	/* 24 1.76MB 3.5"   */
> +	{
> +		.size = 3840,
> +		.sect = 24,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x20,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "H1920"
> +	},	/* 25 1.92MB 3.5"   */
> +	{
> +		.size = 6400,
> +		.sect = 40,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x25,
> +		.rate = 0x5B,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "E3200"
> +	},	/* 26 3.20MB 3.5"   */
> +	{
> +		.size = 7040,
> +		.sect = 44,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x25,
> +		.rate = 0x5B,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "E3520"
> +	},	/* 27 3.52MB 3.5"   */
> +	{
> +		.size = 7680,
> +		.sect = 48,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x25,
> +		.rate = 0x63,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "E3840"
> +	},	/* 28 3.84MB 3.5"   */
> +	{
> +		.size = 3680,
> +		.sect = 23,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x10,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x00,
> +		.name = "H1840"
> +	},	/* 29 1.84MB 3.5"   */
> +	{
> +		.size = 1600,
> +		.sect = 10,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x25,
> +		.rate = 0x02,
> +		.spec1 = 0xDF,
> +		.fmt_gap = 0x2E,
> +		.name = "D800"
> +	},	/* 30 800KB 3.5"    */
> +	{
> +		.size = 3200,
> +		.sect = 20,
> +		.head = 2,
> +		.track = 80,
> +		.stretch = 0,
> +		.gap = 0x1C,
> +		.rate = 0x00,
> +		.spec1 = 0xCF,
> +		.fmt_gap = 0x2C,
> +		.name = "H1600"
> +	},	/* 31 1.6MB 3.5"    */
>  };

The code was far more readable before the conversion and the usage
of C99 initializers is not mandatory.  Please drop it.

--
Bartlomiej Zolnierkiewicz
