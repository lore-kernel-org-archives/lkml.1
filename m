Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYDFOM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYDFOM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 10:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYDFOMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 10:12:49 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:6986 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751598AbYDFOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 10:12:48 -0400
Message-ID: <47F8DA44.3070008@tungstengraphics.com>
Date: Sun, 06 Apr 2008 16:12:20 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: dri-devel <dri-devel@lists.sourceforge.net>
Subject: [RFC] Use kernel_map_pages() to avoid illegal page aliasing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For a long time now, the agpgart module has been creating illegal 
mapping aliases, since the user-space mappings of the pages in the gart 
are usually write-combined, whereas the kernel linear mapping of the 
same pages are uc for x86, and may even be wb for some architectures.

In order to fix this, and to facilitate fast insertion and removal of 
pages into / from the gart I'd like to disable all default kernel 
mappings for those pages, which would in effect, make them behave as 
highmem pages from our point of view.

As prevously discussed, the x86 set_memory_xxx() interface wasn't 
suitable for this, since it handles only a single mapping, and the pages 
may have more than one default kernel mapping.

But it turns out that there is an interface that does exactly this. 
kernel_map_pages(). But it is only available  with 
CONFIG_DEBUG_PAGEALLOC. I'd like to make that function exported by 
default, but with some minor alterations as the original functions does 
some debug checks as well, that aren't desirable for the purpose 
mentioned above:

As with highmem pages, if the driver sets up user-space mappings with 
non-standard caching attributes, those mappings need to be killed at 
suspend time, since the suspend code would otherwise create temporary 
incompatible mappings.

On x86 this all would probably work fine. Does kernel_map_pages() work 
identically on other architectures? Specifically: Will it always work 
with a 4K page granularity?

Thanks,
Thomas


/*
* Enable / disable all default kernel mappings of a number of contigous 
pages.
* This is an alias for kernel_map_pages() but with debug checks removed.
*/

int kernel_default_map_pages(struct page *page, int numpages, int enable);
EXPORT_SYMBOL(kernel_default_map_pages);

/*
* Enable / disable all default kernel mappings of a number of single pages.
*/
int kernel_default_map_pagearray(struct page **pages, int numpages, int 
enable);
EXPORT_SYMBOL(kernel_default_map_pagearray);




