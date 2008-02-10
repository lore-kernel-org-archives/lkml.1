Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYBJMY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYBJMY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYBJMYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:24:18 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:13921 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbYBJMYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:24:17 -0500
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 07:24:16 EST
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47AEE6D1.4070402@tremplin-utc.net>
Date: Sun, 10 Feb 2008 12:58:09 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20080207)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: dsdt@gaugusch.at, len.brown@intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, trenn@suse.de
Subject: Re: acpi dsts loading and populate_rootfs
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de>
In-Reply-To: <20080210071454.GA23428@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding some CC's)
Christoph Hellwig wrote:
> On Sun, Feb 10, 2008 at 08:12:26AM +0100, Christoph Hellwig wrote:
>> Folks, moving this call around hidden behing in completely unreviewed
>> acpi junk is not acceptable.
>>
>> Either populate_rootfs _is_ safe to be called earlier and then we should
>> do it always or it's not.  Either way such a change should be posted
>> separately and reviewd on lkml.
Hi,

I agree with you, the order of the initialization should not be changed 
by some config options. Either it works, or it doesn't! So the question 
now is : "is fine to move populate_rootfs() earlier?"

Some data points:
* It used to be called earlier. It was moved to be called later about a 
year ago by Linus (8d610dd52dd1da696e199e4b4545f33a2a5de5c6) with this log:
>     Make sure we populate the initroot filesystem late enough
>     
>     We should not initialize rootfs before all the core initializers have
>     run.  So do it as a separate stage just before starting the regular
>     driver initializers.
So there must be some good reasons to keep it late enough...

* This patch is used in SuSE, and it seems noone has ever had a problem 
with the initramfs early init.

I guess the problem that Linus solved by moving populate_rootfs() 
happens only rarely or on only few configurations. Linus, do you 
remember what kind of problem it was? How can I reproduce it?

One different solution that I implemented [1] was to have an 
"early_populate_rootfs()" before the acpi_early_init(), leaving 
populate_rootfs() at the normal place. If the early version fails, it's 
ok: we can't override the DSDT, but the later version will work as usual 
anyway. This solution also seems to work quite often (it's used in 
Ubuntu, Mandriva and PCLinuxOS)

Would that seem an acceptable solution? Or what other way exists?


>> Len, can you please revert "ACPI: basic initramfs DSDT override support"
>> aka commit 71fc47a9adf8ee89e5c96a47222915c5485ac437 until we've sorted
>> this out properly?  Thanks.
> 
> And while we're at it the file reading thing in there is utter crap
> aswell.  You really should be using the firmware loader which works
> perfectly fine if you initramfs is set up for it.  So please folks,
> back to the drawing board, do it properly and send it out to lkml
> for review please.
Christoph, if you have seen this part of the code, you have probably 
also read the big fat warning explaining why this cannot be done by 
firmware loader (ie: userspace cannot be run at this early time, 
corresponding to acpi_early_init()). However, you probably know the 
kernel ten times better than me. Could you explain what I misunderstood 
when writing this warning, and give me some hints about how to use the 
firmware loader in this case?

See you,
Eric


[1] : 
http://gaugusch.at/acpi-dsdt-initrd-patches/acpi-dsdt-initrd-v0.8.4-2.6.21.patch

