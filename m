Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXBKXSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXBKXSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXBKXSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:18:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4325 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbXBKXSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:18:09 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Feb 2007 15:18:06 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch] add epoll compat code to kernel/compat.c ...
In-Reply-To: <20070211214734.GB8631@osiris.ibm.com>
Message-ID: <Pine.LNX.4.64.0702111504020.24568@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702111155180.24568@alien.or.mcafeemobile.com>
 <20070211214734.GB8631@osiris.ibm.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007, Heiko Carstens wrote:

> On Sun, Feb 11, 2007 at 12:15:24PM -0800, Davide Libenzi wrote:
> > 
> > Add epoll compat_ code to kernel/compat.c. IA64 and ARM-OABI are currently 
> > using their own version of epoll compat_ code and they could probably wire 
> > to the new common code. Patch over 2.6.20.
> > + * epoll (fs/eventpoll.c) compat bits follow ...
> > + */
> > +struct compat_epoll_event {
> > +	u32 events;
> > +	u32 data[2];
> > +};
> > +
> >[...]
> > +
> > + * We need the compat layer over the epoll_event structure, only if the offset
> > + * of the __u64 data member is not 4 (size of the events member that precedes the
> > + * data one).
> > + */
> > +#define EPOLL_NEED_EVENT_COMPAT() (offsetof(struct epoll_event, data) != 4)
> 
> With
> 
> struct epoll_event {
>         __u32 events;
>         __u64 data;
> };
> 
> this won't work on s390. offsetof(struct epoll_event, data) is 8 on both
> 31 bit and 64 bit. So it will do the conversion and corrupt all the data.
> Actually we would only need the compat conversion for the sigset_t stuff.

Yup, that's broken not only on s390, but on every arch with alignof(u64) == 8
in 32 bits mode.
The assumption was that for cases like the above, you simply wouldn't wire 
the compat_ version. That is true for epoll_wait and epoll_ctl, where the 
only need for compat was the "struct epoll_event". But that's not true for 
epoll_pwait, since this one needs to be wired because of the sigset_t.
On top of sigset_t, epoll_pwait may need "struct epoll_event" translation.
Now, that *really* sux because two versions of compat_epoll_pwait are 
needed, once that does sigset_t translation only, and one that does 
sigset_t + "struct epoll_event".



> But then again I thought most 32 bit architectures would add a 4 byte
> pad between events and data, no?

i386 does not, for example ;)



> Maybe we need some arch dependent struct compat_epoll_event and have
> something like
> #define EPOLL_NEED_EVENT_COMPAT() \
> (offsetof(struct epoll_event, data) != offsetof(struct compat_epoll_event, data))
> 
> ?

No, it won't work. Unless there is (or we define) a per-arch macro that 
tells us how the 32 bits mode align an u64, I'm afraid we can't do any 
smart tricks and we need to have the double compat_epoll_pwait.



- Davide


