Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZKNIdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZKNIdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 03:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZKNIdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 03:33:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60571 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZKNIdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 03:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nKXwnkhCAUIDm+KANvH20+2+Ti7S6BJ3HPNDAZeShDHiIy72Z3QN1MtMko0V5SGmqk
         SyrlbcZp35hWAC8l2Yb5LIbjELUJdsUVYfoERWMkkx5YRRHmyOegoWBnrmktKCWr/2AO
         kVtQcxfBcxVmtMnblGbsdMCI1My/4tFubXj8o=
Message-ID: <4AFE6A14.4010507@gmail.com>
Date: Sat, 14 Nov 2009 09:28:04 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>	 <4AFC4D31.2000101@gmail.com>	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>	 <20091113091031.3f6d4bba@marrow.netinsight.se> <1258112748.21596.1227.camel@localhost>
In-Reply-To: <1258112748.21596.1227.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think in general the procedure should be: at startup or event (for
example acquired IP address from DHCP) user applications write in flash
(better in persistent ram) a log with a tag or a timestamp or something
like this, when there is a kernel panic, it is captured in a file stored
together the log and when possible the system should send all via
network for example. Are there problems that I can't see to follow this
approach? When David says "...so this looks much more like a real file
than a sysctl file" I quite agree, it seems a normal application/system
log indeed.

Marco

Artem Bityutskiy wrote:
> On Fri, 2009-11-13 at 09:10 +0100, Simon Kagstrom wrote:
>> On Thu, 12 Nov 2009 16:56:49 -0500
>> David VomLehn <dvomlehn@cisco.com> wrote:
>>
>>> Good question. Some more detail on our application might help. In some
>>> situations, we may have no disk and only enough flash for the bootloader.
>>> The kernel is downloaded over the network. When we get to user space, we
>>> initialize a number of things dynamically. For example, we dynamically
>>> compute some MAC address, and most of the IP addresses are obtained with
>>> DHCP. This are very useful to have for panic analysis.
>>>
>>> Since there is neither flash nor disk, user space has no place to store
>>> this information, should the kernel panic. When we come back up, we will get
>>> different MAC and IP addresses. Storing them in memory is our only hope.
>>>
>>> Fortunately, there is a section of RAM that the bootloader promises not
>>> to overwrite. On a panic, we capture the messages written on the console
>>> and store them in the protected area. If the information from the
>>> /proc file is written as part of the panic, we will capture it, too.
>> Can't you solve this completely from userspace using phram and mtdoops
>> instead? I.e., setup two phram areas
>>
>> 	modprobe phram 4K@start-of-your-area,4K@start-of-your-area+4K    # Can't remember the exact syntax!
>>
>> you'll then get /dev/mtdX and /dev/mtdX+1 for these two. You can then do
>>
>> 	modprobe mtdoops mtddev=/dev/mtdX+1 dump_oops=0
>>
>> to load mtdoops to catch the panic in the second area, and just write
>> your userspace messages to /dev/mtdX.
> 
> This might work for them, not sure, but not for us. We store panics on
> flash, and later they are automatically sent to the panic collection
> system via the network. And the complications are:
> 
> 1. There may be many panics before the device has network access and has
> a chance to send the panics.
> 2. User can re-flash the device with different SW inbetween.
> 
> So we really need to print some user-space supplied information during
> the panic, and then we store it on flash with mtdoops, and the later,
> when the device has network access we send whole bunch of oopses via the
> network.
> 
>> One thing probably have to be fixed though: I don't think phram has a
>> panic_write, which will be needed by mtdoops to catch the panic - this
>> should be trivial to add though since it's plain RAM.
> 
