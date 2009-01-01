Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZAAOWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZAAOWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 09:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbZAAOWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 09:22:41 -0500
Received: from customer-vserver-jkruis-1.all2all.org ([62.58.108.47]:55363
	"EHLO jkruis.all2all.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZAAOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 09:22:40 -0500
X-Greylist: delayed 1226 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2009 09:22:40 EST
Message-ID: <495CCCDF.3030606@samwel.tk>
Date: Thu, 01 Jan 2009 15:02:07 +0100
From: Bart Samwel <bart@samwel.tk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Johnson <dave-lkml-01@centerclick.org>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>
In-Reply-To: <18779.58377.160214.225792@wellington.i202.centerclick.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Johnson wrote:
> Since upgrading from 2.6.23.1 to 2.6.27.8, I'm now seeing kjournald
> perform a write 2 seconds after each read to an ext3 fs.
> 
> laptop mode is on and filesystem is mounted with noatime and a large
> commit time (6 hours).
> 
> Did I miss something or is this expected?

This is the defined behaviour for laptop_mode. Whenever a *physical*
READ takes place, this is taken to indicate that the disk is spun up at
that time. The laptop_mode functionality then takes that opportunity to
sync any dirty data to disk, two seconds (or whatever value you put in
/proc/sys/vm/laptop_mode) after the physical disk activity has ceased.
The rationale behind this is that you want to sync your stuff when the
disk is spun up, and then you want to hold back writing back stuff for a
very long while. And the only way it can detect that the disk is spun up
is when there is physical disk activity.

This is exactly what happens in your case. The READ activity reported by
block_dump is *physical* read activity: some data was needed that was
not cached in memory. block_dump does not show you what data was
retrieved from the ext3 fs *without* having to access the disk, it only
shows actual physical disk I/O.

Cheers,
Bart
