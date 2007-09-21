Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbXIUMol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbXIUMol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXIUMob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:44:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063AbXIUMo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:44:29 -0400
Message-ID: <46F3BC3A.8060703@redhat.com>
Date: Fri, 21 Sep 2007 14:42:34 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, Gerd Hoffmann <kraxel@suse.de>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Yinghai.Lu@Sun.COM, bryan.wu@analog.com, dilinger@queued.net,
       lethal@linux-sh.org, rgetz@blackfin.uclinux.org, vapier.adi@gmail.com,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl> <20070921010349.2caee558.akpm@linux-foundation.org>
In-Reply-To: <20070921010349.2caee558.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 20 Sep 2007 18:28:49 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> 
>>  Move the hadover message to after the boot console has been released to 
>> avoid bad interactions between it and the real console.

[ longish problem discussion snipped ]

>> considered fully disabled.  Below is a change which makes the problem 
>> disappear for me, but I suppose there was a deliberate reason for placing 
>> the printk() where it is now and nowhere else.

Well, I placed the printk there is for user interface reasons.  I think
especially in case the early console and the real console go to
different physical devices it is useful to have the reason it stops
printing messages displayed on the early console.  So people don't think
the computer hangs although it just prints messages elsewhere ...

If that isn't going to work due to two instances not knowing each other
(kernel & firmware) should not mess with the same physical device, then
I'd just drop the printk.  And I see no pretty and easy way around that
issue :-(

We could do the printk and unregister before we setup the new console.
Which has the drawback that we are in trouble in case the setup() call
for the new console fails ...

We could split the printk into two, one early ("trying to setup new
console foo") which goes to the boot console, then (assuming the setup
worked ok) unregister silently and print a message about the successful
init and boot console unregister on the new console only.  Which results
in two lines being printed for the handover when both consoles address
the same physical device.  Not that nice IMHO, but maybe still the best
way to handle it.

cheers,
  Gerd


