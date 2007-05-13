Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXEMTaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXEMTaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbXEMTaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:30:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071AbXEMTaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:30:03 -0400
Date: Sun, 13 May 2007 12:29:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] fix epoll single pass code and add wait-exclusive
 flag ...
Message-Id: <20070513122950.e30f2c80.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.27693.1178937031.1>
References: <send-serie.davidel@xmailserver.org.27693.1178937031.1>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 19:30:31 -0700 Davide Libenzi <davidel@xmailserver.org> wrote:

> Fixes the epoll single pass code. During the unlocked event delivery
> (to userspace) code, the poll callback can re-issue new events, and
> we must receive them correctly. Since we loop in a lockless fashion,
> we want to be O(nready), and we don't want to flash on/off the spinlock
> for every event, we have the poll callback to use a secondary list to
> queue events while we're inside the event delivery loop.
> The rw_semaphore has been turned into a mutex.
> This patch also adds the wait-exclusive flag, as suggested by Davi Arnaut.
> 
> ...
> @@ -534,6 +547,8 @@
>  	}
>  
>  	mutex_unlock(&epmutex);
> +
> +	mutex_destroy(&ep->mtx);
>  }

It's a little alarming to see a dereference of `ep' right at the end of a
function called ep_free(ep).

Code is OK, but perhaps the kfree(ep) should be moved into ep_free()?

I'm a bit stunned at the size of these two patches.
