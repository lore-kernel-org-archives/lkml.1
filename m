Return-Path: <linux-kernel-owner+w=401wt.eu-S935430AbXGLVUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935430AbXGLVUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761341AbXGLVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:20:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:56850 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761240AbXGLVU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:20:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Joshua Wise <jwise@google.com>
Subject: Re: [x86_64 MCE] [RFC] mce.c race condition (or: when evil hacks are the only options)
Date: Thu, 12 Jul 2007 23:20:19 +0200
User-Agent: KMail/1.9.6
Cc: akpm@google.com, linux-kernel@vger.kernel.org,
       Tim Hockin <thockin@google.com>, Mike Waychison <mikew@google.com>
References: <Pine.LNX.4.64.0707121309520.617@internets.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0707121309520.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122320.19489.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 22:24:36 Joshua Wise wrote:
> Some time after my first[1] patch to mce.c, I had continued testing using
> the test method described there (inject hundreds of thousands of single-bit
> errors while reading from /dev/mcelog), and I came across a strange issue. 
> Once every couple test cycles (i.e., every hundred-thousand injects), the
> system would begin behaving very strangely. The serial port would stop
> responding entirely, and my SSH sessions would respond, but to one keystroke
> behind what I had typed. After two minutes, the watchdog timer would reboot
> the system.

Thanks for the analysis.

I guess at some point it would make sense to model the whole thing in spin or 
similar and find even the last race. Anyone interested? @)

> 
> At this point, mce_read() and mce_log() are blocking on each other, and will
> be for all eternity. mce_log() is waiting for the on_each_cpu() to complete
> so that the loop can complete, and on_each_cpu() (from mce_read()) is
> waiting for mce_log() to finish.

I suspect the right fix is to get rid of collect_tscs(). 

One possible way would be to get the TSCs from the mce_log table
before the synchronization instead of asking the CPUs.

Or switch it over to the NMI supporting RCU that was recently posted.


> -- there may be other edge cases other than 
> this one. I'm actually surprised that this wasn't a ring buffer to start
> with -- it certainly seems like it wanted to be one. 

The problem with a ring buffer is that it would lose old entries; but 
for machine checks you really want the first entries because
the later ones might be just junk.

-Andi
