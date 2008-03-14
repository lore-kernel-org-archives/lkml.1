Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYCNU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYCNU0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYCNU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:26:26 -0400
Received: from homer.mvista.com ([63.81.120.158]:59515 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYCNU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:26:25 -0400
Subject: Re: [PATCH v1] change likeliness accounting
From: Daniel Walker <dwalker@mvista.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, Hua Zhong <hzhong@gmail.com>,
       akpm@linux-foundation.org
In-Reply-To: <47D9B35C.9@tiscali.nl>
References: <47D9B35C.9@tiscali.nl>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:26:23 -0700
Message-Id: <1205526383.10894.119.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 00:06 +0100, Roel Kluin wrote:

>  #define __check_likely(exp, is_likely)					\
>  	({								\
>  		static struct likeliness likeliness = {			\
> -			.func = __func__,				\
> -			.file = __FILE__,				\
> -			.line = __LINE__,				\
> -			.type = is_likely | LP_UNSEEN,			\
> +			.label = __LINE__ << LP_LINE_SHIFT |		\
> +						LP_UNSEEN | is_likely,	\
>  		};							\
> -		do_check_likely(&likeliness, !!(exp));			\
> +									\
> +		if (likeliness.label & LP_UNSEEN)			\
> +			do_check_likely(&likeliness);			\

On second look, your actually break even on size (if not a little worse)
cause you adding some addition code into the macro which effectively
inlines it at all the likely/unlikely locations .. I'm not sure that's
really necessary .. 

Also by not including the file name you have situation like the
following,

+unlikely |   208324|  4010128| do_sys_open+0x2a/0xb2()@:34

Where do_sys_open is on line 1076 in file fs/open.c , but the likely
location is actual on like 34 in file include/linux/err.h ..

So I think saving of the EIP does help in finding the actually caller,
but I do think we loose something by removing the file name..

Daniel

