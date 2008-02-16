Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYBQAAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYBQAAH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYBPX7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 18:59:55 -0500
Received: from www.tglx.de ([62.245.132.106]:35373 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYBPX7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 18:59:54 -0500
Date: Sun, 17 Feb 2008 00:59:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <021620082137.23325.47B757B400051FE100005B1D2209224627CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802162353210.7583@apollo.tec.linutronix.de>
References: <021620082137.23325.47B757B400051FE100005B1D2209224627CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Quel Qun wrote:
> > Please also enable CONFIG_DEBUG_LIST=y, which should catch the place
> > where a list corruption happens.
>
> Thank you for the hand holding. I must admit I do not anything
> about kernel debugging.
>
> With or without nohz=off, the crashes are very similar. It looks
> like it fails to execute list_add_tail(&timer->entry, vec), line 294
> of kernel/timer.c.

Yup, that's what I suspected. The list is corrupted:

> list_add corruption. prev->next should be next (c047e704), but was 00000000. (prev=ddcca118).

> list_add corruption. prev->next should be next (c047e77c), but was 00000001. (prev=f644bd98).

Unfortunately we only see that the list is corrupted but not which
code caused it. This looks like something forgot to delete the timer
before freeing the datastructure which contains it.

Can you please enable CONFIG_SLUB_DEBUG=y and CONFIG_SLUB_DEBUG_ON=y
and give it another try?

If we can not catch it that way, I'll whip up a patch which points us
to the code which added the offending timer.

Thanks,

	tglx
