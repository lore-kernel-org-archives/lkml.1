Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbZBECb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbZBECb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZBECbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:31:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbZBECbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:31:48 -0500
Date: Wed, 4 Feb 2009 18:31:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.29-rc3: weird process after resume
Message-Id: <20090204183142.11e6f661.akpm@linux-foundation.org>
In-Reply-To: <87hc39ejx2.fsf@sycorax.lbl.gov>
References: <878womf727.fsf@sycorax.lbl.gov>
	<20090204153954.844ac67b.akpm@linux-foundation.org>
	<87hc39ejx2.fsf@sycorax.lbl.gov>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 17:45:13 -0800 Alex Romosan <romosan@sycorax.lbl.gov> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Wed, 04 Feb 2009 09:25:20 -0800
> > Alex Romosan <romosan@sycorax.lbl.gov> wrote:
> >
> >> this is on a thinkpad t61p with an intel core2 cpu. i just noticed
> >> that after resuming from suspending to memory i get a weirdly named
> >> process. i did a ps before and after and the only difference was that
> >> before i had this process:
> >> 
> >>   [hda0/1]
> >> 
> >> and after this one:
> >> 
> >>   [__?__;??____D__"?______]
> >> 
> >> with everything else being the same. the laptop seems to be working
> >> fine and the problem could have been there for a while but i just
> >> didn't notice it. i am including my .config file. let me know if you
> >> need anything else.
> >
> > Were earlier kernels OK?  If so, which version?
> 
> i just tried 2.6.28 and there was no [hda0] kernel thread. 2.6.29-rc1
> and rc2 never resumed from suspend so i couldn't really try it.
> 
> > What the heck is that kernel thread anyway?  It looks like something
> > derived from an IDE device.
> 
> i have no idea. hda is the cdrom (the disk is sata and shows up as
> sda).
> 

<rummages through a 68MB diff for a while>

<finds a plum>

+       snprintf(qname, sizeof(qname), "hda%d", card->number);
+       bus->workq = create_workqueue(qname);
+       if (!bus->workq) {
+               snd_printk(KERN_ERR "cannot create workqueue %s\n", qname);
+               kfree(bus);
+               return -ENOMEM;
+       }

so it's not IDE after all.

commit 6acaed38a32e8571e92cfc832b971f9e4450c207
Author:     Takashi Iwai <tiwai@suse.de>
AuthorDate: Mon Jan 12 10:09:24 2009 +0100
Commit:     Takashi Iwai <tiwai@suse.de>
CommitDate: Mon Jan 12 10:33:56 2009 +0100

    ALSA: hda - Use own workqueue

