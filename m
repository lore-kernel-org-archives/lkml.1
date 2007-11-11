Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXKKFeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXKKFeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 00:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXKKFd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 00:33:59 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:48184 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXKKFd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 00:33:58 -0500
Date: Sun, 11 Nov 2007 06:33:57 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       WU Fengguang <wfg@mail.ustc.edu.cn>
Subject: Re: Temporary lockup on loopback block device
In-Reply-To: <Pine.LNX.4.64.0711110454050.26435@artax.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0711110624110.10210@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz>
 <20071110145444.a6993df1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711110114300.18189@artax.karlin.mff.cuni.cz>
 <Pine.LNX.4.64.0711110454050.26435@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Arguably we just have the wrong backing-device here, and what we 
> > > should do is to propagate the real backing device's pointer through 
> > > up into the filesystem.  There's machinery for this which things 
> > > like DM stacks use.

Just thinking about the new implementation --- you shouldn't really 
propagate physical block device's backing_device into loopback device.

If you leave it as is (each loop device has it's own backing store), you 
can nicely avoid the long-standing loopback deadlock coming from the fact 
that flushing one page on loopback device can generate several more dirty 
pages on the filesystem.

If you let loopback device and physical device have the same backing 
store, then it can go wild creating more and more dirty pages up to a 
memory exhaustion. If you let them have different backing stores, it can't 
happen --- loopback flushing will just wait until the pages on the 
filesystem are written.

Mikulas

> So I compiled it and I don't see any more lock-ups. The writeback loop 
> doesn't depend on any global page count, so the above scenario can't 
> happen here. Good.
> 
> Mikulas
> 
