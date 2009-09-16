Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZIPLas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZIPLas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZIPLar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:30:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZIPLaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:30:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify as syscalls
Date: Wed, 16 Sep 2009 13:30:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Jamie Lokier <jamie@shareable.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org,
       torvalds@linux-foundation.org
References: <20090911.114620.260824240.davem@davemloft.net> <20090915201620.GB32192@ioremap.net> <1253051699.5213.18.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1253051699.5213.18.camel@dhcp231-106.rdu.redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909161330.26815.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+boMJfX4Gj69FYtYjkQ2pMumU627LFdO/Fwsr
 9FZs2g1o99se1sTcHjDNDZrMv58PSygXDroguQv/O2cYuQqXa2
 ku0+JEuaoVbhUu4jN6lsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009, Eric Paris wrote:
> fanotify_modify_mark_at() --- like inotify_add_watch and rm_watch
> fanotify_modify_mark_fd() --- same but with an fd instead of a path

I think these two can be merged into one without adding complexity,
in the same way that sys_utimensat can take a file descriptor or
a path or both.

> fanotify_response() --- userspace tells the kernel what to do if requested/allowed
>    (could probably be done using write() to the fanotify fd)
> fanotify_exclude() --- a horrid syscall which might be better as an ioctl since it isn't strongly typed....

Please don't use an ioctl here. While ioctl is fine for character devices
and sort of fine for sockets, I think it would be very bad style to use
it on file descriptors that you get back from specialized syscalls like
fanotify_init. Do one or the other, but do it consistently.

Why is it not strongly typed anyway? Something like

int fanotify_ignore_sb(int fanotify_fd, unsigned int flag,
                       long f_type, fsid_t f_fsid);

would be type safe, although I think it would be better to only handle
one of the two cases. Can you think of a case that you can't handle if
you have to decide between them and only do one interface (f_type or fsid)?

	Arnd <><
