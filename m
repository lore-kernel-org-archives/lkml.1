Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZJEC5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZJEC5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbZJEC5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:57:21 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:47358 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZJEC5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:57:20 -0400
Date: Sun, 4 Oct 2009 21:55:50 -0500
From: David Fries <david@fries.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, d.stussy@yahoo.com,
       Joao Ramos <joao.ramos@inov.pt>, Linus Torvalds <torvalds@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
Message-ID: <20091005025549.GA32331@spacedout.fries.net>
References: <20091003025415.GA28295@spacedout.fries.net> <4AC7F306.2040409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC7F306.2040409@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 04 Oct 2009 21:55:55 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 06:57:42PM -0600, Robert Hancock wrote:
> On 10/02/2009 08:54 PM, David Fries wrote:
>> I just did a git bisection from 2.6.30 to 2.6.31 because 2.6.31 will
>> not boot on this system.  d.stussy@yahoo.com's post September 12th
>> looks the same, different CPU but both have sis5513 IDE chips.  His
>> would normally init the ethernet chip next, mine would do PS/2 next,
>> both hang right after the Uniform CD-ROM message.
>>
>> This was bisected down to chaging PIO mode 0 for probing.  What
>> problem was that patch trying to solve?  Reverting just that patch at
>> the top of 2.6.31 tree works.  I can test patches.
>>
>> Assigned bugzilla.kernel.org bug 14310
>
> Well, it's the right thing to do (libata does it) but presumably doing  
> that in old IDE is triggering some kind of bug. Unless there's a  
> specific problem it was solving, or someone is interested in debugging  
> in detail (I'm certainly not interested in drivers/ide) it should likely  
> be reverted as we've done without it for so long..

First, if I'm going to do much debugging, how would I force the
ethernet device to come up first so I have netconsole?

How is the problem patch,
+       ide_port_for_each_dev(i, drive, hwif) {
+               if (port_ops && port_ops->set_pio_mode)
+                       port_ops->set_pio_mode(drive, 0);
+       }

Different from using hdparm to set the mode?  I do this,
hdparm -p 0 /dev/hda
hdparm -X pio0 /dev/hda
and the benchmarks give me about what I would expect 7MB/s instead of
the normal 40MB/s.

Then I can re-enable with,
hdparm -p 4 /dev/hda
hdparm -X udma5 /dev/hda
hdparm -d 1 /dev/hda
hda: UDMA/100 mode selected
and the drive is back up to speed, and obviously the kernel didn't
freeze.  Should there be anything different between what the patch
tried, and and hdparm's doing, other than kernel initiated and start
and a user program later on?

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
