Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYJGJYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYJGJYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYJGJYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:24:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYJGJYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:24:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: perfmon2-devel@lists.sourceforge.net, eranian@gmail.com
Subject: Re: [perfmon2] perfmon3 interface overview
Date: Tue, 7 Oct 2008 11:24:17 +0200
User-Agent: KMail/1.9.9
Cc: "David Gibson" <david@gibson.dropbear.id.au>, linux-kernel@vger.kernel.org
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <20081005055339.GC469@yookeroo.seuss> <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
In-Reply-To: <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810071124.17946.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/E7VUA49IYIVwZkt71PJjsswADvoWBqFFBn1Z
 +QQXyTf/S4qF1A3ZUUiKVzCxjzA18hgCFmfYeqWFiaPeGH6ZfR
 G2lNZvFYk3mWLU0fcmHPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008, stephane eranian wrote:
> If I summarize our discussion. It seems we can define the API as follows:
> 
>     int pfm_create_session(int fd, uint64_t flags, pfarg_sinfo_t *sif,
> [ char *smpl_name, void *smpl_arg, size_t arg_size]);
>     int pfm_read_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
>     int pfm_write_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
>     int pfm_attach_session(int fd, uint64_t flags, int target);   /*
> attach, detach with target=-1 */
>     int pfm_control_session(int fd, uint64_t flags);   /* for start/stop */
>     int pfm_control_sets(int fd, uint64_t flags, void *sets, size_t sz);


There are two problems with uint64_t arguments to system calls:

1. You have to mandate the use of stdint.h before including the
perfmon header file. This is a minor problem as long as all callers
go through libpfm, but you can avoid it entirely by using the kernel
__u32 instead of uint32_t style types everywhere in your interface.

2. The calling conventions for passing 64 bit values on 32 bit
architecture are complex, every architecture enforces different
rules here. On the syscall interface, bettwe always use native
types like 'unsigned long' instead of '__u64'. This is different
from the case where you pass a pointer to data, in which case
a '__u64 *' is much preferred over a 'unsigned long *'.

I did not understand the reason for going to a 64 bit flags parameter,
but I think that you would do everyone a favour if you can instead
use two 32-bit flags or a unsigned long flags parameter.

	Arnd <><
