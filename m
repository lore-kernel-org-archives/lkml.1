Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYAZGYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYAZGYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 01:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYAZGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 01:24:14 -0500
Received: from ns.suse.de ([195.135.220.2]:36047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYAZGYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 01:24:13 -0500
Date: Fri, 25 Jan 2008 22:22:46 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, jacob.shin@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Message-ID: <20080126062246.GB27012@suse.de>
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com> <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu> <20080125230802.GA25074@suse.de> <86802c440801251520h29965fa4neaa4d17ebca955c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801251520h29965fa4neaa4d17ebca955c3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:20:45PM -0800, Yinghai Lu wrote:
> On Jan 25, 2008 3:08 PM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
> ..
> > Also, can someone enable CONFIG_KOBJECT_DEBUG and send me the output of
> > the startup of this code?  That should help explain what order things
> > are happening it.
> 
> Calling initcall 0xffffffff80ba1dee: threshold_init_device+0x0/0x3f()
> kobject: 'threshold_bank4' (ffff8108265450c0): kobject_add_internal: parent: 'machinecheck0', set: '<NULL>'
> kobject: 'misc0' (ffff810425497418): kobject_add_internal: parent: 'threshold_bank4', set: '<NULL>'
> kobject: 'misc1' (ffff810425497498): kobject_add_internal: parent: 'threshold_bank4', set: '<NULL>'
> kobject: 'misc2' (ffff810425497518): kobject_add_internal: parent: 'threshold_bank4', set: '<NULL>'
> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: [<ffffffff8045d443>] kobject_uevent_env+0x31/0x45f

2 of these work just fine, and the third blows up in kobject_uevent().
So wierd, let me dig further...

Hm, it's when we unwind that we blow up on the kobject_uevent, as that's
the first time it is called (gotta love recursion here...)  So it is
really never working for these objects at all, what a mess.

As a work-around for now, you can probably just comment out the
'kobject_uevent() in the file arch/x86/kernel/cpu/mcheck/mcd_amd_64.c
and everything should work just fine, as there never really was an event
being properly generated before, no one would miss it now :)

I'll keep digging...

thanks,

greg k-h
