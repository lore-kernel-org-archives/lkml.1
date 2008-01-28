Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYA1MZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYA1MZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYA1MZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:25:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50788 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbYA1MY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:24:59 -0500
Date: Mon, 28 Jan 2008 13:24:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128122434.GA24757@elte.hu>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201477122-4541-2-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@suse.de> wrote:

> This problem is due to the kobject rework recently done in this file.
> 
> The mce_amd_64.c code uses some wierd forward calls to back out of the 
> recursive way the code creates kobjects.  Because of this, we need to 
> verify that we have really created a kobject before calling 
> kobject_uevent().
> 
> Many thanks to Yinghai Lu <yhlu.kernel@gmail.com> for reporting the 
> problem and testing.

> -	kobject_uevent(&b->kobj, KOBJ_ADD);
> +	if (b)
> +		kobject_uevent(&b->kobj, KOBJ_ADD);

Acked-by: Ingo Molnar <mingo@elte.hu>

and please let me insert a minor kobject rant here: i do think it's way 
too hard to figure out relatively minor-looking kobj bugs like this. It 
took serious dedication from Yinghai Lu and yourself to nail this down, 
and we wont always have that much luck in the future.

CONFIG_DEBUG_KOBJECT is way too feeble and does not actually attempt to 
catch bugs like this. The effects of the bug were quite serious, and 
this hasnt been the first time such hard-to-find kobj bugs occured - 
every one of those incidents was in essence unnecessary.

Couldnt DEBUG_KOBJECT do better than this - just like we have list 
debugging, PAGEALLOC and all the other debug checks?

	Ingo
