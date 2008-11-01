Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYKARRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYKARRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYKARQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:16:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbYKARQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:16:51 -0400
Date: Sat, 1 Nov 2008 10:16:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <20081101090154.3d014f57@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org> <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net> <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
 <20081101090154.3d014f57@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Nov 2008, Jonathan Corbet wrote:

> Networking is fine in the absence of NFS.  I retried things and
> stress-tested it in a few ways with no trouble.  I think your last patch
> fixes the network card just fine.
> 
> Then I tried NFS again, watching more closely this time around.
> Everything locks up.  In fact, the soft lockup watchdog starts to
> scream:

Interesting. I wonder why it happens for NFS, but not apparently for all 
your other modules.

It does look very much like a ftrace issue, though, not NFS or 
network-related. Steven? Is this something that you are aware of already, 
with what looks like a lockup in ftrace_record_ip()?

> So methinks I'll add Steven to the Cc on this one :)  Looks like a
> different problem for sure.

Agreed. Looks unlikely to be related.

> > Oh, and getting the old (2.6.27) and new (2.6.28-rc2+patch) 
> > /proc/iomem would be nice.
> 
> For completeness, here they are.

Wow. Your BIOS really does screw up massively. The one reserved region 
difference is:

Old kernel (with lots of resources just re-assigned elsewhere):

> e0000000-fed003ff : reserved
>   fec00000-fec00fff : IOAPIC 0
>   fed00000-fed003ff : HPET 0

New kernel:

> e0000000-fed003ff : reserved
>   fe800000-fe8fffff : PCI Bus 0000:01
>   fe9d9b00-fe9d9bff : 0000:00:1f.3
>   fe9d9c00-fe9d9fff : 0000:00:1a.7
>     fe9d9c00-fe9d9fff : ehci_hcd
>   fe9da000-fe9dafff : 0000:00:03.3
>   fe9db000-fe9dbfff : 0000:00:19.0
>     fe9db000-fe9dbfff : e1000e
>   fe9dc000-fe9dffff : 0000:00:1b.0
>     fe9dc000-fe9dffff : ICH HD audio
>   fe9e0000-fe9fffff : 0000:00:19.0
>     fe9e0000-fe9fffff : e1000e
>   fea00000-fea7ffff : 0000:00:02.0
>   fea80000-feafffff : 0000:00:02.1
>   feb00000-febfffff : 0000:00:02.0
>   fec00000-fec00fff : IOAPIC 0
>   fed00000-fed003ff : HPET 0

ie the BIOS had marked a _lot_ of PCI allocations that it did as being 
reserved, and there was actually no partial overlap in your case. The old 
kernel would end up re-assigning all the resources (except for the magic 
non-PCI-BAR ones like the IOAPIC and the HPET) because of that BIOS 
reservation.

I do think that the new layout looks better, and I also think that 
"insert_resource_expand_to_fit()" did a much better and more logical job 
than "reserve_region_with_split()" did. So it looks like an improvement. I 
wonder who else with have breakage though - EVERY SINGLE TIME we do 
resource allocation cleanups/fixes, some odd firmware inevtiably breaks.

It's really sad. I worry that the old-style reserved handling hid bus 
where the firmware had assigned resources to insane locations (and then 
the reserved area code ended up forcing us to re-assign them to better 
ones). But my second patch at least -conceptually- makes sense, and 
obviously fixes your case, so I'm inclined to just commit it.

And either of the above two resource listings look saner than the plain 
-rc2 version (using reserve_region_with_split):

> e0000000-fe7fffff : reserved
> fe800000-fe8fffff : PCI Bus 0000:01
>  fe800000-fe8fffff : reserved
> fe900000-fe9d9aff : reserved
> fe9d9b00-fe9d9bff : 0000:00:1f.3
>  fe9d9b00-fe9d9bff : reserved
> fe9d9c00-fe9d9fff : 0000:00:1a.7
>  fe9d9c00-fe9d9fff : reserved
> fe9da000-fe9dafff : 0000:00:03.3
>  fe9da000-fe9dafff : reserved
> fe9db000-fe9dbfff : 0000:00:19.0
>  fe9db000-fe9dbfff : reserved
> fe9dc000-fe9dffff : 0000:00:1b.0
>  fe9dc000-fe9dffff : reserved
> fe9e0000-fe9fffff : 0000:00:19.0
>  fe9e0000-fe9fffff : reserved
> fea00000-fea7ffff : 0000:00:02.0
>  fea00000-fea7ffff : reserved
> fea80000-feafffff : 0000:00:02.1
>  fea80000-feafffff : reserved
> feb00000-febfffff : 0000:00:02.0
>  feb00000-febfffff : reserved
> fec00000-fed003ff : reserved
>  fec00000-fec00fff : IOAPIC 0
>  fed00000-fed003ff : HPET 0

.. which is just really messy, but is the same e0000000-fed003ff
"reserved" e820 entry just split and moved into each resource. 

I hate firmware. 

			Linus
