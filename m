Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbXEYQSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbXEYQSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXEYQS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:18:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXEYQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:18:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
Date: Fri, 25 May 2007 18:18:03 +0200
User-Agent: KMail/1.9.6
Cc: Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <20070525083632.474400000@sonycom.com>
In-Reply-To: <20070525083632.474400000@sonycom.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251818.03964.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+LLMU4m1Qouv209eqwjvXWd3/5G5w4pSnvIBl
 OAEPJSXI1J9jHxP4GFzvyFkfTlDo/wYGVAxhtlhGUFhJPLxeki
 5QHaGHKpfOofUlWY/aEEQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> Add storage driver probing.
> New storage devices are detected and added by a kthread.

Hi Geert,

the driver looks pretty good, just a few details I noticed:

> +static u64 ps3stor_wait_for_completion(u64 devid, u64 tag,
> +				       unsigned int timeout)
> +{
> +	unsigned int retries = 0;
> +	u64 res = -1, status;
> +
> +	for (retries = 0; retries < timeout; retries++) {
> +		res = lv1_storage_check_async_status(NOTIFICATION_DEVID, tag,
> +						     &status);
> +		if (!res)
> +			break;
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(1);
> +	}

Any reason not to use msleep(1) instead of the schedule_timeout?

> +	switch (dev_type) {
> +	case PS3_DEV_TYPE_STOR_DISK:
> +		match_id = PS3_MATCH_ID_STOR_DISK;
> +		break;
> +
> +	case PS3_DEV_TYPE_STOR_ROM:
> +		match_id = PS3_MATCH_ID_STOR_ROM;
> +		break;
> +
> +	case PS3_DEV_TYPE_STOR_FLASH:
> +		match_id = PS3_MATCH_ID_STOR_FLASH;
> +		break;
> +
> +	default:
> +		return 0;
> +	}

Why do you have separate constants for PS3_DEV_TYPE_* and
PS3_MATCH_ID_*? If you don't do any conversion, this driver
will immediately work for additional types as well, if more
get added later.

> +
> +//		pr_debug("%s:%u: Checking for new storage devices...\n",
> +//			 __func__, __LINE__);

Should be removed, or not in comments, either way is fine, as pr_debug
normally does not get compiled in anyway.

> +
> +		msleep_interruptible(ms);
> +		if (ms < 60000)
> +			ms <<= 1;

Is this timeout only for the disk spinup, or also for detecting media
added at run time, like inserting a DVD? One minute timeout for
detecting a DVD would sound very long to me.

	Arnd <><
