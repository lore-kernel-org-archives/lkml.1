Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZLRB1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZLRB1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZLRB1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:27:31 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:54205 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZLRB1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lVN2Y90J8Q6kBTmG5YzTDigwkCQeGu1zTg3WgGW11yVGpGtYB5YnS8PwEMrDsN5du6
         ZtH6Gf8yayNzbXBr64OUbak62ecgQw3hxLMth+V6U2Jp7ZW4mAtc3iZMuS55kPG2Lcb/
         XEQdDN0wrlDkKZ3wTO1vlI8NxiPUltzIvUWYY=
MIME-Version: 1.0
In-Reply-To: <200912162217.09577.arnd@arndb.de>
References: <200912162217.09577.arnd@arndb.de>
Date: Fri, 18 Dec 2009 11:27:29 +1000
Message-ID: <21d7e9970912171727i7576b1d9q1a8195ad884592a1@mail.gmail.com>
Subject: Re: [PATCH] drm: convert drm_ioctl to unlocked_ioctl
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 8:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> drm_ioctl is called with the Big Kernel Lock held,
> which shows up very high in statistics on vfs_ioctl.
>
> Moving the lock into the drm_ioctl function itself
> makes sure we blame the right subsystem and it gets
> us one step closer to eliminating the locked version
> of fops->ioctl.
>
> Since drm_ioctl does not require the lock itself,
> we only need to hold it while calling the specific
> handler. The 32 bit conversion handlers do not
> interact with any other code, so they don't need
> the BKL here either and can just call drm_ioctl.
>
> As a bonus, this cleans up all the other users
> of drm_ioctl which now no longer have to find
> the inode or call lock_kernel.
>

This looks good, I've taken this and I've squashed
the generic pieces of your RFC into this (i.e.
I haven't modified the drivers, but just added the
flag to allow the ioctls to be unlocked if the driver
selects them).

Do you think we should try and get this in soon,
its seems like it shouldn't have any regressions
unless we start switching drivers over.

Dave.
