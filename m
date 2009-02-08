Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZBHWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZBHWFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZBHWAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:00:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53840 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZBHWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=w6F7Nmf6Yky61bhIzQLBPRwWSiSidmEq+5/oMy8NAxA3UiFxwYtVKAOXEtOzzsmFRu
         LuYx0egg316PVgVYocuI3PoJVmvy3dimW7DwUmCN62niENhNAV9vH2pU9ocOkuJ0+OZ7
         ydmI/aQnqwop1pr1MIwxWm7x6pOv2WBoUTleE=
Message-ID: <498F55F1.3000405@gmail.com>
Date: Sun, 08 Feb 2009 23:00:17 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Bug #12606] fb_mmap: circular locking dependency on hibernation
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.bKG.120jJB@chimera>
In-Reply-To: <sWhNs83kKPE.A.bKG.120jJB@chimera>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-08 20:21, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12606
> Subject		: fb_mmap: circular locking dependency on hibernation
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> Date		: 2009-01-27 18:37 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=123308162731408&w=4
> Handled-By	: Andrea Righi <righi.andrea@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123365581406194&w=2

This is fixed by:

commit 1f5e31d7e55ac7fbd4ec5e5b20c8868b0e4564c9
Author: Andrea Righi <righi.andrea@gmail.com>
Date:   Wed Feb 4 15:12:03 2009 -0800

    fbmem: don't call copy_from/to_user() with mutex held

    Avoid calling copy_from/to_user() with fb_info->lock mutex held in fbmem
    ioctl().

    fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
    fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
    copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
    deadlock.

    NOTE: it doesn't push down the fb_info->lock in each own driver's
    fb_ioctl(), so there are still potential deadlocks elsewhere.

    Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
    Cc: Dave Jones <davej@redhat.com>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Cc: Johannes Weiner <hannes@saeurebad.de>
    Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
    Cc: Harvey Harrison <harvey.harrison@gmail.com>
    Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
