Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZGMRyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZGMRyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZGMRyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:54:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbZGMRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:54:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [perfmon2] I.1 - System calls - ioctl
Date: Mon, 13 Jul 2009 19:53:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: perfmon2-devel@lists.sourceforge.net,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <200907131930.23840.arnd@arndb.de> <1247506440.7500.43.camel@twins>
In-Reply-To: <1247506440.7500.43.camel@twins>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907131953.45786.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19viJykIL8B060Q6fRakSXoqbJYP0/c1Pe5rq4
 z0wU2g9ywTxw/3VT+sa84gERhs4yDcoMQlaf1AlFGJOKumGxV9
 qjdj03dnq3Fg4MqSuLjgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Peter Zijlstra wrote:
> On Mon, 2009-07-13 at 19:30 +0200, Arnd Bergmann wrote:
> > > +struct perf_counter_target {
> > > +	__u32			id;
> > > +	__u64			val;
> > > +};
> > 
> > This structure is not compatible between 32 and 64 bit user space on x86,
> > because everything except i386 adds implicit padding between id and val.
> 
> Humm, __u64 doesn't have natural alignment? That would break more than
> just this I think -- it sure surprises me.

Yes, nobody expects this, so it is a frequent source of bugs in the ABI.
Look for compat_u64 and __packed in the definition of compat ioctl and
syscall interfaces for how we had to work around this elsewhere.

> > Other than that, making it extensible sounds reasonable. How about just
> > using a '__u64 *target' and a bit in the 'flags' argument?
> 
> Would there still be a point in having it a pointer in that case?, but
> yeah, that might work too?

passing u64 bit arguments directly to system calls is a bit complicated,
because some 32 bit architectures can only pass them in certain
register pairs, see the trouble we go through for llseek, sync_file_range
or preadv.

If you can directly pass an 'unsigned long' instead, that would work fine
though.

	Arnd <><
