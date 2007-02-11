Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXBKVsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXBKVsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbXBKVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:48:46 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:50308 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbXBKVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:48:45 -0500
Date: Sun, 11 Feb 2007 22:47:34 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch] add epoll compat code to kernel/compat.c ...
Message-ID: <20070211214734.GB8631@osiris.ibm.com>
References: <Pine.LNX.4.64.0702111155180.24568@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702111155180.24568@alien.or.mcafeemobile.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 12:15:24PM -0800, Davide Libenzi wrote:
> 
> Add epoll compat_ code to kernel/compat.c. IA64 and ARM-OABI are currently 
> using their own version of epoll compat_ code and they could probably wire 
> to the new common code. Patch over 2.6.20.
> + * epoll (fs/eventpoll.c) compat bits follow ...
> + */
> +struct compat_epoll_event {
> +	u32 events;
> +	u32 data[2];
> +};
> +
>[...]
> +
> + * We need the compat layer over the epoll_event structure, only if the offset
> + * of the __u64 data member is not 4 (size of the events member that precedes the
> + * data one).
> + */
> +#define EPOLL_NEED_EVENT_COMPAT() (offsetof(struct epoll_event, data) != 4)

With

struct epoll_event {
        __u32 events;
        __u64 data;
};

this won't work on s390. offsetof(struct epoll_event, data) is 8 on both
31 bit and 64 bit. So it will do the conversion and corrupt all the data.
Actually we would only need the compat conversion for the sigset_t stuff.

But then again I thought most 32 bit architectures would add a 4 byte
pad between events and data, no?

Maybe we need some arch dependent struct compat_epoll_event and have
something like
#define EPOLL_NEED_EVENT_COMPAT() \
(offsetof(struct epoll_event, data) != offsetof(struct compat_epoll_event, data))

?
