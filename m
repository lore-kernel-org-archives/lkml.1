Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbXLCXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbXLCXrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXLCXrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:47:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXLCXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:47:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Freezer: Fix JFFS2 garbage collector freezing issue (was: Re: JFFS2 garbage collection threads not freezing?)
Date: Tue, 4 Dec 2007 01:05:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pete MacKay" <armlinux@architechnical.net>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <36289.69.30.123.186.1196443476.squirrel@architechnical.net> <200712012114.10881.rjw@sisk.pl>
In-Reply-To: <200712012114.10881.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712040105.32771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 1 of December 2007, Rafael J. Wysocki wrote:
> On Friday, 30 of November 2007, Pete MacKay wrote:
[--snip--]
> ---
> Subject: Freezer: Fix JFFS2 garbage collector freezing issue
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
> "freezer: do not send signals to kernel threads" in
> jffs2_garbage_collect_thread() that assumed it would be sent signals
> by the freezer.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pete MacKay <armlinux@architechnical.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/jffs2/background.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/fs/jffs2/background.c
> ===================================================================
> --- linux-2.6.orig/fs/jffs2/background.c
> +++ linux-2.6/fs/jffs2/background.c
> @@ -103,15 +103,17 @@ static int jffs2_garbage_collect_thread(
>  		   get there first. */
>  		yield();
>  
> +		/* If system suspend is in progress, go to the refrigerator and
> +		   start again when the suspend is done */
> +		if (try_to_freeze())
> +			goto again;
> +

This still has the problem that, if the freeze request comes exactly here, the
loop below will not allow us to freeze.

>  		/* Put_super will send a SIGKILL and then wait on the sem.
>  		 */
>  		while (signal_pending(current)) {
>  			siginfo_t info;
>  			unsigned long signr;
>  
> -			if (try_to_freeze())
> -				goto again;
> -
>  			signr = dequeue_signal_lock(current, &current->blocked, &info);
>  
>  			switch(signr) {
> --

I'll send another patch for this in a while.

Greetings,
Rafael
