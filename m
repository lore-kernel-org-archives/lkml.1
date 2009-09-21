Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZIUEX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZIUEX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 00:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZIUEXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 00:23:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:41239 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751699AbZIUEXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 00:23:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4NIAga564zF0hrHdWPQRmDqbRU48IRCuymy3u6C
	gL8xouHJt3pjiA
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB6C73C.1030004@gmail.com>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <20090920080728.73bfe2a1@infradead.org>
	 <4AB5ECD0.7010903@datenparkplatz.de>
	 <1253475521.9224.43.camel@marge.simson.net>  <4AB6C73C.1030004@gmail.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 06:23:54 +0200
Message-Id: <1253507034.23414.90.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 17:22 -0700, Justin P. Mattock wrote:
> Wow, at first I did not notice anything
> from your *.sh script, but then a few moments
> later, the system became vary sluggish. firefox
> takes about 15 seconds to load. OS is mint linux
> with the latest HEAD on an imac9,1.

CFQ inherits IO priority from the parent on fork(), so nicing a shell or
the dd should (and does) help a LOT.  It also inherits the CPU scheduler
class.  I just checked, and IO does indeed inherit SCHED_IDLE as well as
the RT classes (SCHED_BATCH does nothing).  Setting the dd to SCHED_IDLE
makes a big difference, as it should, so there's a bigger hammer than
nice + ionice.  SCHED_IDLE is CPU_adorable + IO_nicest.

Anyway, the problem seems to have to have at least two facets:
1.  streaming IO causing pagecache reclaim.  That problem doesn't seem
to want to go away.  Fixing that won't help 2 one bit though.

2.  reads are sync, more heavily affected by seek latency than writes.
If the disk your binaries live on is seeking a lot, you pay a LOT.  

Hohum, IO + VM = haaaaard ;-)

	-Mike

