Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXJBIQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXJBIQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXJBIP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:15:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:62470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXJBIP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:15:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Date: Tue, 2 Oct 2007 10:15:32 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071002073943.GC5236@kernel.dk>
In-Reply-To: <20071002073943.GC5236@kernel.dk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021015.33203.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+qcKnIru+n78k47SCpT2Pj7/IXmWFiUVPYrw1
 0ejLG4P5kBvU35nT5Nyb/v1H/RLcgtLKn+eNSObHUm51EYoeCJ
 EJ9JGm5Kp3osYAskcja1Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007, Jens Axboe wrote:
> 
> The layout of struct blk_user_trace_setup is a bit unfortunate, it gets
> padded differently on 32-bit and 64-bit archs. So right now it's not
> possible to trace 64-bit kernels with a 32-bit app. This patch fixes
> that up by adding a compat ioctl handler for BLKTRACESETUP.

actually, I would guess that it is currently working on s390, sparc64,
powerpc, parisc and mips, but your patch breaks it :(.

> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 5a5b711..b18b9cc 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c

I'd prefer to not add anything to fs/compat_ioctl.c at all, but always
handle these in the places where the native version is handled.

In your case, I'd either mark BLKTRACESETUP32 as COMPATIBLE_IOCTL() and
handle it from inside of blk_trace_ioctl(), or handle it in
compat_blkdev_ioctl.

> @@ -2052,6 +2052,51 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
>          }
>          return ret;
>  }
> +
> +struct blk_user_trace_setup32 {
> +	char name[32];
> +	u16 act_mask;
> +	u16 pad;
> +	u32 buf_size;
> +	u32 buf_nr;
> +	u64 start_lba;
> +	u64 end_lba;
> +	u32 pid;
> +} __attribute__((packed));

Errm, no. Everyone makes that mistake once, so you're in good company,
but the packed attribute makes this incorrect on every architecture
except x86_64 and ia64, because only i386 has no padding before the u64
and after the last member.

We now have the compat_u64 type that behaves like the 32 bit user space
version of an unsigned long long. If you use that to define 
compat_blk_user_trace_setup, you don't need the attribute.

> +#define BLKTRACESETUP32 _IOWR(0x12,115,struct blk_user_trace_setup32)
> +
> +static int blktrace32_setup(int fd, unsigned cmd, unsigned long arg)

The naming convention these days is to use a 'compat_' prefix, not a '32'
postfix.

> +{
> +	struct blk_user_trace_setup __user *buts = compat_alloc_user_space(sizeof(*buts));
> +	struct blk_user_trace_setup32 __user *buts32 = compat_ptr(arg);
> +	int err;
> +
> +	if (copy_in_user(&buts->name, &buts32->name, BDEVNAME_SIZE) ||
> +	    get_user(buts->act_mask, &buts32->act_mask) ||
> +	    get_user(buts->buf_size, &buts32->buf_size) ||
> +	    get_user(buts->buf_nr, &buts32->buf_nr) ||
> +	    get_user(buts->start_lba, &buts32->start_lba) ||
> +	    get_user(buts->end_lba, &buts32->end_lba) ||
> +	    get_user(buts->pid, &buts32->pid))
> +		return -EFAULT;
> +
> +	err = sys_ioctl(fd, BLKTRACESETUP, (unsigned long) buts);
> +	if (err)
> +		return err;
> +
> +	if (copy_to_user(&buts32->name, &buts->name, BDEVNAME_SIZE) ||
> +	    put_user(buts32->act_mask, &buts->act_mask) ||
> +	    put_user(buts32->buf_size, &buts->buf_size) ||
> +	    put_user(buts32->buf_nr, &buts->buf_nr) ||
> +	    put_user(buts32->start_lba, &buts->start_lba) ||
> +	    put_user(buts32->end_lba, &buts->end_lba) ||
> +	    put_user(buts32->pid, &buts->pid))
> +		return -EFAULT;
> +
> +	return err;

Most of these fields are read-only for the kernel, so you should only need
the first copy_to_user. I think you should split the blk_trace_setup function
to have the common code take a struct blk_user_trace_setup kernel pointer,
and one or two versions that just do the copy_{to,from}_user.

	Arnd <><
