Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbZFMWko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbZFMWko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZFMWke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63716 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760326AbZFMWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:40:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 05/27] score: create head files cache.h cacheflush.h checksum.h cputime.h current.h
Date: Sun, 14 Jun 2009 00:40:05 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OF3577968C.E669F4B8-ON482575D4.0023707C-482575D4.0024726F@sunplusct.com>
In-Reply-To: <OF3577968C.E669F4B8-ON482575D4.0023707C-482575D4.0024726F@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200906140040.06017.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lwNmquVaxcUIQrmU0/rqk372xTl/Y8cIcdG6
 KZ7AzznHUrubtXLIMr3b7AHAPQLIN5akEH314jr+QpKbOtxbYM
 8PFccea+SJlckiQaX1AXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, liqin.chen@sunplusct.com wrote:
> 
> > This is a somewhat unusual way to express these functions. It seems
> > that you only have one implementation for each of them, so I wonder
> > why you keep them as function pointers. Do you plan to add more CPUs
> > in the future that do these differently?
> > 
> 
> S+core series have score7 core and score3 core, they use different ISA,
> this patch only include score7 code. We will provide score3 code latter.

Ok. Is the ISA similar enough that you still intend to provide binary
kernels that work on both, with just overriding a few functions?
If a kernel gets built only for one architecture or another, a compile-time
switch would be quicker than a runtime switch here.

A common way to express this kind of runtime dependency is to put all
the function pointers into a single data structure and just flip a
single pointer at boot time, e.g.

struct score_cpu_ops {
	void (*flush_cache_all)(void);
	void (*flush_cache_mm)(struct mm_struct *mm);
	void (*flush_cache_range)(struct vm_area_struct *vma,
	                            unsigned long start, unsigned long end);
	void (*flush_cache_page)(struct vm_area_struct *vma,
                           unsigned long page, unsigned long pfn);
	void (*flush_cache_sigtramp)(unsigned long addr);
	void (*flush_icache_all)(void);
	void (*flush_icache_range)(unsigned long start, unsigned long end);
	void (*flush_data_cache_page)(unsigned long addr);
};

extern struct score_cpu_ops *score_cpu_ops;

static inline flush_cache_all(void)
{
	return score_cpu_ops->flush_cache_all();
}
...

	Arnd <><
