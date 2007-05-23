Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXEWHvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXEWHvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbXEWHvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:51:08 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:17864 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEWHvF (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:51:05 -0400
Message-ID: <4653F264.1030807@de.ibm.com>
Date: Wed, 23 May 2007 09:51:00 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: richard.griffiths@windriver.com, Richard Griffiths <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
In-Reply-To: <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> But we'd expected and hoped that flash-based XIP would be able to use
> the existing xip infrastructure, in mm/filemap_xip.c.  Not possible?
Thanks for the heads up Andrew. Reading the cramfs patch, I've found a 
lot of similarities between the current mainline xip stack and this 
nice piece of work. I also observed interresting differences:

The current xip stack does use the block device abstraction added with 
an extra direct memory access operation. The cramfs patch does not 
abstract between the memory segment and the file system, it rather 
uses an address as mount parameter.
Both methods can coexist, and a file system that does not use the 
block device abstraction may still provide get_xip_page address space 
operation and benefit from the xip stack infrastructure. Each method 
makes sense in the context of the corresponding file systems.

The current xip stack relies on having struct page behind the memory 
segment. This causes few impact on memory management, but occupies 
some more memory. The cramfs patch chose to modify copy on write in 
order to deal with vmas that don't have struct page behind.
So far, Hugh and Linus have shown strong opposition against copy on 
write with no struct page behind. If this implementation is acceptable 
to the them, it seems preferable to me over wasting memory. The xip 
stack should be modified to use this vma flag in that case.

This implementation extends cramfs while the current xip stack extends 
ext2. I would love to see a cramfs implementation based on 
filemap_xip, choice is always a good thing. To me, it looks like this 
work can be modified to use filemap_xip.

so long,
Carsten
