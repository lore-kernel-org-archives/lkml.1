Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYDWGwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYDWGwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYDWGwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:52:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYDWGwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:52:23 -0400
Date: Tue, 22 Apr 2008 23:51:48 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, gregkh@suse.de, penberg@cs.helsinki.fi,
       zaitcev@redhat.com
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Message-Id: <20080422235148.c49dc6b7.zaitcev@redhat.com>
In-Reply-To: <20080422134034.GF7311@elte.hu>
References: <200804212310.41729.elendil@planet.nl>
	<20080422134034.GF7311@elte.hu>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 15:40:34 +0200, Ingo Molnar <mingo@elte.hu> wrote:

> > I got the following warning while running sched-devel/latest.
> > WARNING: at mm/slub.c:2443 kmem_cache_destroy+0x168/0x1a9()

> >  [<ffffffff80293c5d>] kmem_cache_destroy+0x168/0x1a9
> >  [<ffffffff803974d8>] mon_text_release+0x89/0xae
> >  [<ffffffff80299254>] __fput+0xb9/0x161
> >  [<ffffffff8029957b>] fput+0x14/0x16
> >  [<ffffffff80296892>] filp_close+0x66/0x71
> >  [<ffffffff80239eea>] put_files_struct+0x77/0xcb
> >  [<ffffffff80239f72>] __exit_files+0x34/0x39

> Cc:-ing USB folks as the kmem_cache_destroy() comes from 
> drivers/usb/mon/mon_text.c.

I looked at this whole day today, but found nothing.

The code analysis for usbmon shows nothing. Anyone wants to have
a look?

Reproduction does not work either. I tried various loads, loops
of opening/closing while pushing events from USB, nothing.

BTW, I tried to create memory pressure with mem=300MB, result:

top: page allocation failure. order:4, mode:0xc0d0
Pid: 2337, comm: top Not tainted 2.6.25-ub #33

Call Trace:
 [<ffffffff8027450d>] __alloc_pages+0x32f/0x352
 [<ffffffff80272252>] rmqueue_bulk+0x8a/0x9b
 [<ffffffff80273a3d>] __get_free_pages+0xe/0x4d
 [<ffffffff802ddd14>] show_stat+0x25/0x4f1
 [<ffffffff80252f6f>] __lock_acquire+0xd95/0xda4
 [<ffffffff80252f6f>] __lock_acquire+0xd95/0xda4
 [<ffffffff802b349c>] seq_read+0x37/0x2a7
 [<ffffffff80251a2a>] mark_held_locks+0x57/0x73
 [<ffffffff802b349c>] seq_read+0x37/0x2a7
 [<ffffffff80470fff>] mutex_lock_nested+0x23a/0x256
 [<ffffffff80251bd4>] trace_hardirqs_on+0xf9/0x123
 [<ffffffff8047100c>] mutex_lock_nested+0x247/0x256
 [<ffffffff80470fff>] mutex_lock_nested+0x23a/0x256
 [<ffffffff8047100c>] mutex_lock_nested+0x247/0x256
 [<ffffffff802b3579>] seq_read+0x114/0x2a7
 [<ffffffff802b3465>] seq_read+0x0/0x2a7
 [<ffffffff802d74a7>] proc_reg_read+0x80/0x9b

The error is not just advisory, the application (top) dies because
/proc/stat cannot be read. I'm surprised that you people managed
to get the warning at 2443, because things start unravel way earlier
for me.

-- Pete
