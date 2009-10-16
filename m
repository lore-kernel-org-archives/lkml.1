Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbZJPTnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbZJPTnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZJPTnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:43:03 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60659 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZJPTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wv1A+gNw0Sni1ofpZoCJ+m2hjtOl9sh5bbATEYGIeqmsrqBvCA2/WyBnSBMCAVu2On
         GxyfCTg3JG9qQ0Z1swn7c6mBRYId/Lp+2TB+TFedhA8RB4y6dpad+V3+6K/IIKQ3hmyu
         6NkVWw033o7gVJvuh34lzdixVDyncQ9UTzIBI=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 6/7] um: Convert mmapper to unlocked_ioctl
Date: Fri, 16 Oct 2009 21:42:50 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
References: <20091015083906.716130653@linutronix.de> <200910151500.34820.arnd@arndb.de> <20091015162926.25a99cab@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015162926.25a99cab@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910162142.50618.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, Alan Cox wrote:
> On Thu, 15 Oct 2009 15:00:34 +0200
> Arnd Bergmann <arndbergmann@googlemail.com> wrote:
>
> > However, returning -ENOIOCTLCMD from an *unlocked_ioctl* function
> > automatically gets turned into -EINVAL. It does this to allow
> > the same functions to be used for unlocked_ioctl and compat_ioctl.
> > In effect, this patch is functionally identical to removing the
> > ioctl function, which I think is what should be done here.
> 
> That is wrong.
> 
> SuS requires an unknown ioctl code returns -ENOTTY. If the code is
> currently remapping it to EINVAL then it wants fixing.

Right, I forgot about the EINVAL/ENOTTY difference. The code currently
returns -ENOIOCTLCMD, which is worse. Thomas' patch makes it return
-EINVAL, which as you said is still wrong. Removing the ioctl function
will do the right thing and return -ENOTTY, so that should be done
here in um/mmapper, with an appropriate changelog.

For the common code in fs/ioctl.c, I think the current behaviour is
correct. It returns -EINVAL if the driver returns -ENOIOCTLCMD, iow
"the request [...] argument is not valid for this device", as specified
by http://www.opengroup.org/onlinepubs/009695399/functions/ioctl.html.

Drivers returning ENOIOCTLCMD for every request are broken and should
be changed to have no ioctl function.
	
	Arnd <><
