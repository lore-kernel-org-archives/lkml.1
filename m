Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYCaGPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYCaGPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 02:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYCaGPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 02:15:43 -0400
Received: from mxsf03.insightbb.com ([74.128.0.64]:28271 "EHLO
	mxsf03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYCaGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 02:15:42 -0400
X-IronPort-AV: E=Sophos;i="4.25,580,1199682000"; 
   d="scan'208";a="283135229"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMke8Edi3KTd/2dsb2JhbACnYg
X-IronPort-AV: E=Sophos;i="4.25,580,1199682000"; 
   d="scan'208";a="125088598"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting disconnected
Date: Mon, 31 Mar 2008 02:15:39 -0400
User-Agent: KMail/1.9.9
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803310215.39414.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sunday 30 March 2008, Linus Torvalds wrote:
> 
> On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
> >
> > I can't reproduce the bug on my UP box and currently can't afford
> > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > guess it needs SMP to crash), so while this doesn't show any new
> > problems, I can't tell whether it actually fixes anything. Testers
> > welcome!
> 
> Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
> really really hope somebody can figure out what made this all start to 
> trigger. It does smell like some core device layer change, because we do 
> not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
> seem relevant.
> 
> Greg, are there any refcounting changes that would cause the input devices 
> to be free'd earlier or something?
> 

The following commit changed lifetime runes on kobjects breaking input:

commit 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Wed Dec 19 01:40:42 2007 +0100

    Kobject: auto-cleanup on final unref

    We save the current state in the object itself, so we can do proper
    cleanup when the last reference is dropped.

    If the initial reference is dropped, the object will be removed from
    sysfs if needed, if an "add" event was sent, "remove" will be send, and
    the allocated resources are released.

    This allows us to clean up some driver core usage as well as allowing us
    to do other such changes to the rest of the kernel.

    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Before we dropped reference to kobject's parent only when child kobject
was released (in kobject_cleanup). The changeset above moves the release
to kobject_del() which is way too early in my opinion. The kobject is only
marked for deletion at that time, not really deleted.

I will look how to properly fix evdev and the rest of input interfaces
tomorrow.

-- 
Dmitry
