Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZDXVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZDXVAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbZDXU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:59:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:12617 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZDXU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:59:54 -0400
Message-ID: <49F22843.7040800@gawab.com>
Date: Fri, 24 Apr 2009 13:59:47 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [bisected regression] 2.6.30rc2 horizontal strips of the screen frozen
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I've discovered a regression in 2.6.30-rc2+ related to the graphic 
display. It usually happens after playing a video for a little bit.
Several horizontal sections of the screen become frozen. The only way to 
fix it is to switch to a virtual console and then back. The screen 
refreshes but this is only a temporary fix, as in less than a few 
minuets the screen gets corrupted again.

Effected Version: 2.6.30-rc2+
Picture of corrupt screen: http://ecs.fullerton.edu/~cs351a15/badscreen.jpg

My System:
Ubuntu 9.4 with 943/940GML [8086:27a2] Intel graphic card
UXA/GEM/DRI2 enable. Full info at 
http://jdserver.homelinux.org/bugreports/004/

Syslog Messages:
None, but switching virtual consoles gives
[drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for 
disabled pipe 0
But I think that is another bug introduced with .30-rc1.


Bisecting gave me the following (verified) commit

280b713b5b0fd84cf2469098aee88acbb5de859c is first bad commit
commit 280b713b5b0fd84cf2469098aee88acbb5de859c
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Mar 12 16:56:27 2009 -0700

drm/i915: Allow tiling of objects with bit 17 swizzling by the CPU.

Save the bit 17 state of the pages when freeing the page list, and
reswizzle them if necessary when rebinding the pages (in case they were
swapped out).  Since we have userland with expectations that the swizzle
enums let it pread and pwrite contents accurately, we can't expose a new
swizzle enum for bit 17 (which it would have to GTT map to handle), so 
we handle it down in pread and pwrite by swizzling the copy when bit 17
of the page address is set.

Signed-off-by: Eric Anholt <eric@anholt.net>

:040000 040000 32f68f62b336326cee85e22f068d4410197994ef
e820ef2a2fd3f9133960f390f27c79caa5ec83d2 M      drivers
:040000 040000 573ade35bd21d9c37c43f470d8ab718f728ef101
32642903c265079acfa20b71d4ec2ee427a70c3a M      include

Justin Madru


