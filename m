Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbXJCJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbXJCJfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXJCJfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:35:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbXJCJfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:35:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Date: Wed, 3 Oct 2007 11:34:56 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
References: <20071002073943.GC5236@kernel.dk> <20071002083758.GD5236@kernel.dk> <20071002092856.GG5236@kernel.dk>
In-Reply-To: <20071002092856.GG5236@kernel.dk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031134.56940.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+oucsEwl6C+78G/TyehFNx9EJGByfb3QiWYG4
 MoPKXm/b99mopgQvdN3kw2hJ1/wkDssZTSy8k/zZeTjFKVFc7Y
 l5I7A8QADyeZBcn61Ttng==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007, Jens Axboe wrote:
> Hi Arnd,
> 
> Updated patch below. I kept the code in compat_ioctl.c, to me it seems
> like the cleanest approach. I need the BLKTRACESETUP32 define both in
> compat_ioctl.c and blktrace.c if I move it, and I need to hard-core the
> struct size or define it in both places. And guard the code in
> blktrace.c with an ifdef for CONFIG_COMPAT. Not pretty, imho.
> 
> I haven't tested this one yet, but at least it compiles and the sizing
> seems right. The u16 padding was an artifact of the
> __attribute__((packed)) so that could be removed.

The sizes are ok now, but I still don't like the idea of adding more
stuff to fs/compat_ioctl.c. I also noticed another problem now, see below.

The preferred way to define compat_ioctl handlers is to use a ->compat_ioctl
file operation so you don't need any code in compat_ioctl.c at all.
You still need the #ifdef in blktrace.c though if you want to building extra
code on the architectures that don't need it.

> +static int blktrace32_setup(int fd, unsigned cmd, unsigned long arg)
> +{
> +	struct blk_user_trace_setup __user *buts = compat_alloc_user_space(sizeof(*buts));
> +	struct blk_user_trace_setup32 __user *buts32 = compat_ptr(arg);
> +	int err;
> +
> +	if (copy_in_user(&buts->name, &buts32->name, 32) ||
> +	    get_user(buts->act_mask, &buts32->act_mask) ||
> +	    get_user(buts->buf_size, &buts32->buf_size) ||
> +	    get_user(buts->buf_nr, &buts32->buf_nr) ||
> +	    get_user(buts->start_lba, &buts32->start_lba) ||
> +	    get_user(buts->end_lba, &buts32->end_lba) ||
> +	    get_user(buts->pid, &buts32->pid))
> +		return -EFAULT;

You are dereferencing 'buts' here, which is a user space pointer. This is
broken and cannot work on architectures that have split kernel/user address
spaces, and a potential security hole on those that don't.
sparse would warn about this kind of bug, but of course one of the problems
with fs/compat_ioctl.c is that it isn't sparse clean in the first place.

> +	err = sys_ioctl(fd, cmd, (unsigned long) buts);
> +	if (err)
> +		return err;
> +
> +	if (copy_to_user(&buts32->name, &buts->name, 32))
> +		return -EFAULT;

Same here, this needs to be copy_in_user.

	Arnd <><
