Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYHHMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYHHMOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYHHMOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:14:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYHHMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:14:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 3/4] checkpoint/restart: memory management
Date: Fri, 8 Aug 2008 14:12:17 +0200
User-Agent: KMail/1.9.9
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <20080807224037.44DA0DB8@kernel>
In-Reply-To: <20080807224037.44DA0DB8@kernel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081412.18268.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/EkBv93dmtuRItRDBuzxHKqvA71WA50vtvFLb
 uOLwXY3kQdZA8O41nAKhAjGqTyL9WBfwRtGJNNZ3gQzRQ6ERPv
 VGQMzG5mwEwhm1/wfMk/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Dave Hansen wrote:
> 
> diff -puN ckpt/ckpt_hdr.h~memory_part ckpt/ckpt_hdr.h
> --- linux-2.6.git/ckpt/ckpt_hdr.h~memory_part	2008-08-05 08:37:29.000000000 -0700
> +++ linux-2.6.git-dave/ckpt/ckpt_hdr.h	2008-08-05 08:37:29.000000000 -0700
> @@ -67,3 +67,24 @@ struct cr_hdr_task {
>  };
>  
>  
> +
> +struct cr_hdr_mm {
> +	__u32 tag;	/* sharing identifier */
> +	__u64 start_code, end_code, start_data, end_data;
> +	__u64 start_brk, brk, start_stack;
> +	__u64 arg_start, arg_end, env_start, env_end;
> +	__s16 map_count;
> +};

Another structure that is not 32/64 bit ABI safe on x86. It would be safe
if you reorder the members as

struct cr_hdr_mm {
	__u32 tag;	/* sharing identifier */
	__s16 map_count;
	__u16 pad; /* not actually needed, but better to make it explicit */
	__u64 start_code, end_code, start_data, end_data;
	__u64 start_brk, brk, start_stack;
	__u64 arg_start, arg_end, env_start, env_end;
};

> +struct cr_hdr_vma {
> +	__u32 how;
> +
> +	__u64 vm_start;
> +	__u64 vm_end;
> +	__u64 vm_page_prot;
> +	__u64 vm_flags;
> +	__u64 vm_pgoff;
> +
> +	__s16 npages;
> +	__s16 namelen;
> +};

same here.


	Arnd <><
