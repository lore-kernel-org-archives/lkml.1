Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYBQUrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYBQUrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYBQUra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:47:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYBQUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:47:28 -0500
Date: Sun, 17 Feb 2008 12:46:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080217124650.576990ce@laptopd505.fenrus.org>
In-Reply-To: <200802171025.30590.elendil@planet.nl>
References: <200802171025.30590.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:25:30 +0100
Frans Pop <elendil@planet.nl> wrote:

> Yesterday, after spending quite a few hours over the last days on
> bisecting some serious regressions and finding workarounds for them,
> I thought I could start using 2.6.25-rc2 as the new kernel for my
> desktop. Unfortunately I found that I cannot because it would make my
> other main activity - working on the Debian installation system -
> impossible.
> 
> For my work on the Debian Installer I heavily rely on emulators to
> run test installs and ATM my emulator of choice is VirtualBox (the
> fully open "ose" version). This requires the vboxdrv kernel module,
> but unfortunately: vboxdrv: Unknown symbol change_page_attr
> 
> At first I traced this to:
> e1271f68
>  x86: deprecate change_page_attr() for drivers
>  With the introduction of the new API, no driver or non-archcore code
> needs to use c-p-a anymore, so this patch also deprecates the
> EXPORT_SYMBOL of CPA (it's a horrible API after all).
> which had:
> -EXPORT_SYMBOL(change_page_attr);
> +EXPORT_UNUSED_SYMBOL(change_page_attr); /* to be removed in 2.6.27 */
> 
> Which seemed entirely reasonable but left me wondering about the
> error I got.
> 
> But then I found:
> d1028a15
>  x86: make various pageattr.c functions static
>  change_page_attr_add is only used in pageattr.c now, so we can
>  make this function static.
>  change_page_attr() isn't used anywere at all anymore; this function
>  is a really bad API anyway so just remove the bloat entirely.
> 
> Which removed the entire function (without even properly mentioning
> it in the shortlog).
> 

the initial plan was for a depreciation period. Sadly it was untenable since the API
was changing entirely to fix bugs and add a really important feature
(the ability to clflush the exact range rather than wbinvd'ing the caches of all cpus in the system), 
at which point we had to pull the function right away.

As for virtualbox; a fix for that already exists, and it consists of removing 25 lines of workarounds
for c-p-a bugs, and just using set_memory_x / set_memory_nx.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
