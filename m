Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYE2Msv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYE2Msv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYE2Msm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:48:42 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51979 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYE2Msm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:48:42 -0400
Message-ID: <483EA5EF.70906@de.ibm.com>
Date: Thu, 29 May 2008 14:47:43 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Martin_Jetter=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Christian Borntraeger <CBORNTRA@de.ibm.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
References: <20080523195506.084894989@redhat.com>
In-Reply-To: <20080523195506.084894989@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
> 
> Against 2.6.26-rc2-mm1
> 
> This patch series improves VM scalability by:
> 
> 1) putting filesystem backed, swap backed and non-reclaimable pages
>    onto their own LRUs, so the system only scans the pages that it
>    can/should evict from memory
> 
> 2) switching to SEQ replacement for the anonymous LRUs, so the
>    number of pages that need to be scanned when the system
>    starts swapping is bound to a reasonable number
> 
> 3) keeping non-reclaimable pages off the LRU completely, so the
>    VM does not waste CPU time scanning them.  Currently only
>    ramfs and SHM_LOCKED pages are kept on the noreclaim list,
>    mlock()ed VMAs will be added later
I think I've run into #2 with kvm on s390 lately. I've tried a large 
setup with 200 guests running WebSphere. The guest memory is stored in 
anonymous pages, all guests are started up from a script so everything 
is dirty initially. I use 200gig swap with 45 gig main memory for the 
scenario. Everything runs perfect except when vmscan is triggered for 
the first time: it starts to writeback, and the whole system freezes 
until it has paged out the 15gig in the inactive list. From there on, 
everything runs smooth again with a constant swap rate.
I'd like to try your patchset to see how that behave in this scenario. 
Do you have a version that applies against current git, 2.6.26-rc3 or 
similar?
