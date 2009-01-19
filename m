Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZASH7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZASH7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZASH7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:59:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34212 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbZASH7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:59:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <497432B0.1080201@s5r6.in-berlin.de>
Date: Mon, 19 Jan 2009 08:58:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbmem: fix copy_from/to_user() with mutex held
References: <20090117231925.GA28055@redhat.com> <20090118020038.GA17489@cmpxchg.org> <49738E4B.1030200@gmail.com>
In-Reply-To: <49738E4B.1030200@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> +struct fb_info *get_fb_info(struct fb_info *info)
> +__acquires(&info->lock)
> +{
> +	mutex_lock(&info->lock);
> +	if (!info->fbops) {
> +		mutex_unlock(&info->lock);
> +		return NULL;
> +	}
> +	return info;
> +}
> +
> +void put_fb_info(struct fb_info *info)
> +__releases(&info->lock)
> +{
> +	mutex_unlock(&info->lock);
> +}
> +

These are IMO bad function names.  get_... and put_... sound too much
like functions that either read or write data, or increment and
decrement the reference count of data.  These names don't reflect that
the sole purpose of these functions is to lock and unlock a mutex (i.e.
to serialize some critical sections).

*If* you really need to hide mutex_(un)lock(&info->lock) inside
wrappers, then the names of these wrappers should clearly state what
they do, so that everybody knows immediately what is going on at the
call sites.
-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/
