Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXC1MFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXC1MFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXC1MFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:05:16 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:47950 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbXC1MFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:05:14 -0400
Date: Wed, 28 Mar 2007 14:05:11 +0200
Message-Id: <909027047@web.de>
MIME-Version: 1.0
From: Peter Bier <peter_bier@web.de>
To: linux-kernel@vger.kernel.org
Subject: miniroot ramdisk corruption during intense memory usage
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following sympthom occured in a variant of the Knoppix-like linux appliance.

I get a corrupted miniroot ramdisk filesystem under kernel version 2.6.19.1 under intense memory usage during early startup of the system. 

In the course of a lengthy investigation of this behavior, I found out that the memory pages containing the miniroot ramdisk are freed during the initial installation 

process due to a memory shortage. It turned out, that shrink_active_list() calls pagevec_strip(), which in turn calls try_to_release_page() which finally calls try_to_free_buffers() which drops the corresponding buffers; if this succeeds, it seems to cause the page to become freed later. 

This causes pointers of indirect blocks of the filesystem of the miniroot ramdisk to be replaced by zero-filled pages later in the the system's history.

I fixed this by adding a new flag PG_ramdisk in the include file page-flags.h, setting the flag during ramdisk loading in ramdisk_commit_write() and checking for the flag in try_to_free_buffers() and retruning 0 as result immediately without freeing the buffers. 

I am not aware if that is the adequate way to solve the problem or if there is a solution that requires fewer and more localized changes of the system, avoiding to give the ramdisk pages a specific treatment

 

 

I did not observe this problem prior to kernel version 2.6.19.1, but I'm not sure whether ths was simply caused by coincidental circumstances during startup. 

 

 

 

Peter Bier

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

