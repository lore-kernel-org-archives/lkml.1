Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYCNWvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYCNWvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYCNWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:50:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:31067 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbYCNWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:50:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47DB013D.3060102@tremplin-utc.net>
Date: Fri, 14 Mar 2008 23:50:37 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>, Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>	 <1205525184.12763.32.camel@nimitz.home.sr71.net>	 <47DAE55C.3080506@tremplin-utc.net> <1205530551.8167.20.camel@nimitz.home.sr71.net>
In-Reply-To: <1205530551.8167.20.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-03-14 at 21:51 +0100, Eric Piel wrote:
>> I'm not sure it would be possible to delay acpi_early_init() until after 
>> the fs initcalls. Maybe Len knows. How about trying the opposite: what 
>> is the barely minimum to initialize so that the rootfs can be populated 
>> and read? Would it be possible to have a kind of 
>> early_mnt_writer_initialize() that would do that?
> 
> I *can* probably do it earlier, maybe even statically, but I think
> you're missing the point a bit here.  We've just been super lucky so far
> that populate_rootfs() doesn't depend on any other initcalls (or at
> least BUG_ON() because of them).  There may be some more buglets hiding
> around.
Actually, each time I look at init/main.c I feel like we are super lucky 
that Linux boots ;-)

> 
> It'd be a shame to have to have "super_early_fs_initcall()" logic for
> every part of the VFS or any other initcall for that matter that you
> might need.  How do we tell all future VFS hackers that they have to do
> this so that the next guy doesn't break it?  I certainly missed it. :)
Well, my point was that actually populate_rootfs() does _very_ little 
with regard to FS manipulation, acpi_find_dsdt_initrd() even less. The 
task of checking that everything needed is available beforehand is 
certainly not the same magnitude as the one of the Danaides as you 
seemed to implied ;-)

The fact is, this patch has been tested a lot, because it's been used by 
several distributions for a long time. I expect that the only potential 
problems are corner cases that are possible to work around.

> 
> We could separate out the initcalls and just have the fs ones run before
> the rest do.  But, I'm not sure what interactions *THAT* might have.
> There are arch-specific initcalls, and I have no idea if the fs init
> code depends on *those*.  That's a lot of code to check.
Yes, we agree on this. That would be crazy :-)

> 
> It is nailed when you the patch says:
> 
> +       /*
> +        * Never do this at home, only the user-space is allowed to open a file.
> +        * The clean way would be to use the firmware loader. But this code must be run
> +        * before there is any userspace available. So we need a static/init firmware
> +        * infrastructure, which doesn't exist yet...
> +        */
> 
> I think requiring FS access this early in the boot processes is just
> broken.  It seems like the author of the patch knew a better way and
> tried to get away with a hack.  I think it backfired. :)
I'm actually the author of this comment... The static/init firmware 
infrastructure that I mentioned was more just about a way to hide the fs 
access in a special part of the kernel, not avoiding it. We used to have 
a different way but it was even uglier: append the DSDT after the 
initramfs, and then access it _directly_. This implies teaching 
populate_rootfs() to not panic when seeing DSDTs and loosing the benefit 
of the compression.

That said, I'm really not against any complete different approach. All 
that is needed is being able to read a file early at boot (the DSDT) 
without having to recompile the kernel each time the file is modified. 
For instance someone had once mentioned modifying the in-kernel DSDT by 
unlinking and relinking the bzimage. If one can show me how to do that 
I'd be happy to implement it...

Eric
