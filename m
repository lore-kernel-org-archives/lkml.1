Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbYDOTt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbYDOTt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYDOTtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:49:47 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:15629 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYDOTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:49:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkBAGuiBEjEAmHEgWdsb2JhbACRWQEBECaafQ
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
Date: Tue, 15 Apr 2008 21:50:24 +0200
User-Agent: KMail/1.9.9
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <alpine.LFD.1.00.0804140759190.2820@woody.linux-foundation.org> <alpine.LFD.1.00.0804140808530.2820@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804140808530.2820@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804152150.25060.bonganilinux@mweb.co.za>
X-Original-Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
X-Scan-Signature: 03ab43a89cea09dc618624639d94ea3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 17:09:41 Linus Torvalds wrote:
> On Mon, 14 Apr 2008, Linus Torvalds wrote:
> > Since you cannot see this on -rc9, can you go back to -rc8 and test this
> > patch [...]
>
> Oh, maybe I should actually include the patch too ;)
>
> 			Linus
> ---
>  kernel/printk.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index c46a20a..4476879 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -643,8 +643,20 @@ static int
> acquire_console_semaphore_for_printk(unsigned int cpu) {
>  	int retval = 0;
>
> -	if (can_use_console(cpu))
> -		retval = !try_acquire_console_sem();
> +	if (!try_acquire_console_sem()) {
> +		retval = 1;
> +
> +		/*
> +		 * If we can't use the console, we need to release
> +		 * the console semaphore by hand to avoid flushing
> +		 * the buffer
> +		 */
> +		if (!can_use_console(cpu)) {
> +			console_locked = 0;
> +			up(&console_sem);
> +			retval = 0;
> +		}
> +	}
>  	printk_cpu = UINT_MAX;
>  	spin_unlock(&logbuf_lock);
>  	return retval;
> --

Sorry for the late response, we have a electric situation in the country, the 
patch fixes the problem for me (tested on rc8).

Thanx
