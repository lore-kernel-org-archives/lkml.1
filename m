Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbYLLTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbYLLTtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYLLTs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:48:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:64779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYLLTs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:48:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Date: Fri, 12 Dec 2008 20:47:30 +0100
User-Agent: KMail/1.9.9
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org>
In-Reply-To: <20081212152929.GM26095@parisc-linux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812122047.31405.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+obr6Bwgd8AI+RYP0JEnEYw381EHQYmQtW8WU
 UGMsq9uLBLUqpSl2SqOcSODVd7WgGicXllSlBUMCWpYLGAwrnM
 lmB2dy3mHBslONyQrZmoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008, Matthew Wilcox wrote:
> Things will go much better if we can prototype these as:
> 
> asmlinkage ssize_t sys_preadv(unsigned int fd, const struct iovec __user *vec,
>                                 loff_t pos, unsigned long vlen);
> asmlinkage ssize_t sys_pwritev(unsigned int fd, const struct iovec __user *vec,
>                                 loff_t pos, unsigned long vlen);

I would vote for doing it the same way as sys_llseek, which avoids
this issue entirely by passing the upper half of pos sepearately:


asmlinkage ssize_t sys_preadv(unsigned long fd,
                               const struct iovec __user *vec,
                               unsigned long vlen,
			       unsigned long pos_high, unsigned long pos_low);
asmlinkage ssize_t sys_pwritev(unsigned long fd,
                               const struct iovec __user *vec,
                               unsigned long vlen,
			       unsigned long pos_high, unsigned long pos_low);

This is the only way I can see that lets us use a shared 
compat_sys_preadv/pwritev across all 64 bit architectures.

The libc can then add a trivial wrapper around the syscalls
to get the regular calling conventions.

Aside from that, have you considered doing something even more flexible,
like this?

struct piovec {
	void __user *iov_base;
	__kernel_size_t	iov_len;
	__kernel_loff_t pos;
};

asmlinkage ssize_t sys_pwritev(unsigned long fd,
                               const struct piovec __user *vec,
                               unsigned long vlen);

	Arnd <><
