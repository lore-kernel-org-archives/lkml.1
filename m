Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZGMRba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZGMRba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbZGMRba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:31:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbZGMRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:31:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon2] I.1 - System calls - ioctl
Date: Mon, 13 Jul 2009 19:30:23 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622125837.GA9429@infradead.org> <1247482393.7529.74.camel@twins>
In-Reply-To: <1247482393.7529.74.camel@twins>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907131930.23840.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DeNcU6AqgiPw10SJfcBEnlPbGvUB+VXQnj5W
 ol/YAlESXCtPvym4lOyoOktIzr7H97MFbJPGQF1zrrf5NqC23O
 xWfIBANrzgVd+sVJmWGxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Peter Zijlstra wrote:
> On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
> > But talking about syscalls the sys_perf_counter_open prototype is
> > really ugly - it uses either the pid or cpu argument which is a pretty
> > clear indicator it should actually be two sys calls.
> 
> Would something like the below be any better?
> 
> It would allow us to later add something like PERF_TARGET_SOCKET and
> things like that.

I don't think it helps on the ugliness side. You basically make the
two arguments a union, but instead of adding another flag and directly
passing a union, you also add interface complexity.

A strong indication for the complexity is that you got it wrong ;-) :

> +struct perf_counter_target {
> +	__u32			id;
> +	__u64			val;
> +};

This structure is not compatible between 32 and 64 bit user space on x86,
because everything except i386 adds implicit padding between id and val.

Other than that, making it extensible sounds reasonable. How about just
using a '__u64 *target' and a bit in the 'flags' argument?

	Arnd <><
