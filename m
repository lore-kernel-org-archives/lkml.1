Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZJUNLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZJUNLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZJUNLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:11:06 -0400
Received: from ozlabs.org ([203.10.76.45]:43563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZJUNLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:11:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Problems with string (charp) module parameters
Date: Wed, 21 Oct 2009 23:41:03 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <s5haazv1sw5.wl%tiwai@suse.de>
In-Reply-To: <s5haazv1sw5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910212341.06025.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 09:07:46 pm Takashi Iwai wrote:
> While I tried to add some debug option to a driver, I found that a module
> parameter taking a string (charp) gives Oops when set via sysfs:

Hi Takashi,

   Always nice to receive a good analysis like this: thanks!

> * Each struct kernel_param instance is defined as const, and is put
>   into __param section, which is read-only.
>   I guess this causes the page fault above.  And...

Ah yes, that's bad, but we could fix that.

> * The above NULL check is invalid.  It should be
> 		if (!*(char **)kp->arg)
> 			return -ENOMEM
>   This is easy, however...

Good spotting.

> * The handling of parameter array is pretty buggy now.
>   kp->perm and kp->flags aren't properly initialized in
>   param_array().  Thus, you might call kfree() with invalid pointers,
>   or pass a wrong type for bool.

Yes, an array of charp isn't going to work.  Erk, I switched one bug for
another :(

> So, the situation looks messy right now, not only about the section
> issue.  If we allow kmalloc of each parameter array element, the flag
> must be associated to each element, not a global one to the array.
> 
> Thoughts?

Yes, that's hard.  There's only one place which currently has a writable
array parameter: drivers/usb/atm/ueagle-atm.c, and it's root only.

OK, for 2.6.32, we remove the const.  In the longer term, I'm reworking how
this is done entirely.

Thanks!
Rusty.
