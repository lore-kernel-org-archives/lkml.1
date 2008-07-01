Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbYGADeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbYGADeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 23:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYGADeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 23:34:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbYGADeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:05 -0400
Date: Mon, 30 Jun 2008 20:34:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Fix the case of jiffies wrapping in mm/pdflush.c
Message-Id: <20080630203401.f9bcfe84.akpm@linux-foundation.org>
In-Reply-To: <a553a85a3e848699d00711608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
	<555b858b3e848699cff511608.ps@mail.parknet.co.jp>
	<670df4283e848699cff611608.ps@mail.parknet.co.jp>
	<a553a85a3e848699d00711608.ps@mail.parknet.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008 11:57:04 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> 
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  mm/pdflush.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN mm/pdflush.c~pdfluh-jiffies-check-fix mm/pdflush.c
> --- linux-2.6/mm/pdflush.c~pdfluh-jiffies-check-fix	2008-07-01 10:19:07.000000000 +0900
> +++ linux-2.6-hirofumi/mm/pdflush.c	2008-07-01 10:19:07.000000000 +0900
> @@ -130,7 +130,7 @@ static int __pdflush(struct pdflush_work
>  		 * Thread creation: For how long have there been zero
>  		 * available threads?
>  		 */
> -		if (jiffies - last_empty_jifs > 1 * HZ) {
> +		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
>  			/* unlocked list_empty() test is OK here */
>  			if (list_empty(&pdflush_list)) {
>  				/* unlocked test is OK here */
> @@ -151,7 +151,7 @@ static int __pdflush(struct pdflush_work
>  		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
>  			continue;
>  		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
> -		if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
> +		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
>  			/* Limit exit rate */
>  			pdf->when_i_went_to_sleep = jiffies;
>  			break;					/* exeunt */

I don't think this actually "fixes" anything, does it?  The old code
should be correct at runtime.

I renamed the patch to "pdflush: use time_after() instead of open-coding it".

