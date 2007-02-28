Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbXB1BoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbXB1BoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXB1BoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:44:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:59966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXB1BoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:44:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Wed, 28 Feb 2007 02:44:12 +0100
User-Agent: KMail/1.9.6
Cc: Maynard Johnson <maynardj@us.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Mike Perks <mperks@us.ibm.com>, oprofile-list@lists.sourceforge.net
References: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com> <200702270051.00393.arnd@arndb.de> <45E461D4.6050807@us.ibm.com>
In-Reply-To: <45E461D4.6050807@us.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702280244.12844.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/EIo5rZFYb84m+vLSXKcz3emVE4hWP76jlam2
 mFbxz6CQ2gOSClwvtOlI35LBlzUx9ebIZ6ace+05KrL+nY7vIA
 VjF0puZ3yWJHOayLc7KBQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007, Maynard Johnson wrote:
> I have applied the "cleanup" patch that Arnd sent, but had to fix up a 
> few things:
>    -  Bug fix:  Initialize retval in spu_task_sync.c, line 95, otherwise 
> OProfile this function returns non-zero and OProfile fails.
>    -  Remove unused codes in include/linux/oprofile.h
>    -  Compile warnings:  Initialize offset and spu_cookie at lines 283 
> and 284 in spu_task_sync.c
> 
> With these changes and some userspace changes that were necessary to 
> correspond with Arnd's changes, our testing was successful.
> 
> A fixup patch is attached.
> 

The patch does not contain any of the metadata I need to apply it
(subject, description, signed-off-by).

> @@ -280,8 +280,8 @@ static int process_context_switch(struct
>  {
>         unsigned long flags;
>         int retval;
> -       unsigned int offset;
> -       unsigned long spu_cookie, app_dcookie;
> +       unsigned int offset = 0;
> +       unsigned long spu_cookie = 0, app_dcookie;
>         retval = prepare_cached_spu_info(spu, objectId);
>         if (retval)
>                 goto out;

No, this is wrong. Leaving the variables uninitialized at least warns
you about the bug you have in this function: when there is anything wrong,
you just continue writing the record with zero offset and dcookie values
in it. Instead, you should get handle the error condition somewhere
down the code.

It's harmless most of the time, but you really should not be painting
over your bugs by blindly initializing variables.

> diff -paur linux-orig/include/linux/oprofile.h linux-new/include/linux/oprofile.h
> --- linux-orig/include/linux/oprofile.h 2007-02-27 14:41:29.000000000 -0600
> +++ linux-new/include/linux/oprofile.h  2007-02-27 14:43:18.000000000 -0600
> @@ -36,9 +36,6 @@
>  #define XEN_ENTER_SWITCH_CODE          10
>  #define SPU_PROFILING_CODE             11
>  #define SPU_CTX_SWITCH_CODE            12
> -#define SPU_OFFSET_CODE                13
> -#define SPU_COOKIE_CODE                14
> -#define SPU_SHLIB_COOKIE_CODE          15
>  
>  struct super_block;
>  struct dentry;
> 
Right, I forgot about this.

	Arnd <><

