Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZFEAYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZFEAYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFEAYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:24:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:46830 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFEAYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SY/gcDDbOHF+AJvWthb40YLDDNSkEon5X7s43HgXPFUldxMMul7P0iC7LEukH7P9r4
         OUE1zJ9PCOLVbehz4Iy71l6KYSXEWfVPQW/jPvofZ0OXBEPqQmOaFOM7TIjYJiWD4u9N
         MNpvDEKrqXChNT0pnyRyVP7NYleqQqIQASxbY=
Message-ID: <4A2865BF.1080301@gmail.com>
Date: Thu, 04 Jun 2009 18:24:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Julian Phillips <julian@quantumfyre.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: A question about using a private anonymous mmap
References: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk>
In-Reply-To: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Phillips wrote:
> I have a program which creates a reasonably large private anonymous map. 
> The program then writes into a few places in the map, but ends up 
> reading from all of them.
> 
> When I run this program on a system running 2.6.20.7 the process only 
> ever seems to use enough memory to hold the data that has actually been 
> written (well - in units of PAGE_SIZE).  When I run the program on a 
> system running 2.6.24.5 then as it reads the map the amount of memory 
> used continues to increase until the complete map has actually been 
> allocated (and since the total size is greater than the physically 
> available RAM causes swapping).  Basically I seem to be seeing 
> copy-on-read instead of copy-on-write type behaviour.
> 
> Is this an expected change, and is there any option I can tweak to get 
> the old behaviour back?

Looks like this was as a result of the ZERO_PAGE removal:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=557ed1fa2620dc119adb86b34c614e152a629a80

The commit comment notes: "Inserting a ZERO_PAGE for anonymous read 
faults appears to be a false optimisation: if an application is 
performance critical, it would not be doing many read faults of new 
memory, or at least it could be expected to write to that memory soon 
afterwards. If cache or memory use is critical, it should not be working 
with a significant number of ZERO_PAGEs anyway (a more compact 
representation of zeroes should be used)."
