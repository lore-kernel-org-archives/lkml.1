Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZHAApp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZHAApp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 20:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZHAApo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 20:45:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZHAApn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 20:45:43 -0400
Message-ID: <4A738FFD.8020705@redhat.com>
Date: Fri, 31 Jul 2009 20:44:45 -0400
From: Jim Paradis <jparadis@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Dirty page tracking & on-the-fly memory mirroring
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are two patches against 2.6.31-rc3 which implement dirty page 
tracking and on-the-fly memory mirroring.  The idea is to be able to 
copy the entire physical memory over to another processor node or memory 
module while the system is running.  Stratus makes use of this 
functionality to bring a new partner node online.  Supercomputer 
applications can use this to allow a failing module to gracefully bring 
up and cut over to a hot spare.

The overall method is as follows: An initial scan is made to copy over 
all of physical memory.  During that time, some pages may have been 
dirtied so we have to go back and copy them again.  Lather, rinse, 
repeat for a set number of passes.  Finally, quiesce the system so that 
we can copy over the last of the dirtied pages.  Note that we only want 
to copy over pages that have been RE-dirtied since our last scan.  If a 
page was dirty in the first scan but no *additional* data has been 
written to it, there's no need to copy it over again.

The first patch implements dirty page tracking and re-dirty detection.  
We use one of the programmer bits in the PTE to implement a "soft dirty" 
bit.  In the VM subsystem, all tests for dirty pages check the logical 
OR of the hardware dirty bit and the "soft dirty" bit; if either one is 
set the page is considered "dirty" for VM purposes.  To speed up the 
scanning passes this patch also implements a bitmapped side-list of 
dirty physical pages.

The second patch is a reference implementation of a memory-mirroring 
module ("pagesync").  It is the same code that Stratus uses minus some 
hardware-specific bits.  This module scans through physical memory, 
clearing the hardware dirty bit of any dirty page and setting the 
software dirty bit.  If a dirty page has the *hardware* dirty bit set on 
a subsequent scan, we know that the page has been re-dirtied and it is a 
candidate for being copied again.

Jim Paradis
Red Hat Stratus onsite partner rep
