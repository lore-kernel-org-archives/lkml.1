Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXINQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXINQfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXINQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:35:39 -0400
Received: from highlandsun.propagation.net ([66.221.212.168]:1754 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbXINQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:35:38 -0400
Message-ID: <46EAB7DA.10507@symas.com>
Date: Fri, 14 Sep 2007 09:33:30 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9a8pre) Gecko/2007082216 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: MTRR initialization
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, was wondering if anyone else has been tripped up by this... I've got 4GB of 
RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By 
default, my system boots up with these MTRR settings:

reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1

The X server and various other programs try to add a mapping for my video 
card's buffer, at 0xd0000000, size=256MB, type=write-combining, and this always 
fails with a type mismatch error (old type is write-back). Apparently it's 
conflicting with mapping register 0. I can't just disable the existing settings 
and re-add them; the system hangs soon after disabling reg01.

I guess the kernel must be getting the initial setup from the BIOS. I've hacked 
around this in mtrr/generic.c by explicitly changing the MTRR state in 
get_mtrr_state to split the first mapping into two; one at base 0 size 2048M 
and one at base 2048M size 1024M. So now I have this, which is pretty much what 
I wanted:

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg03: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg04: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
reg05: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

So the question is - was there an easier/correct way to do this?

It might have been nice if the MTRR ioctls allowed the register number to be 
specified on the Set commands, though I'm not sure that would have helped in 
this case.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP     http://www.openldap.org/project/
