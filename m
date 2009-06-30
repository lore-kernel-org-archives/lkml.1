Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZF3IsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZF3IsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZF3IsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:48:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZF3IsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:48:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tUODUU9Evp0961Wxhlf3LEWBgxJKk2skNKoSB8vwgb87rYKoCV3lN9rC3czj4/IvM
	kYOlKjZUDsSpXAtpGJ+iA==
Date: Tue, 30 Jun 2009 01:48:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <alpine.DEB.2.00.0906300404210.13871@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0906300143030.16291@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.KGF.HjASKB@chimera> <alpine.DEB.2.00.0906291659550.17663@chino.kir.corp.google.com> <alpine.DEB.2.00.0906300404210.13871@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Justin Piszcz wrote:

> The current value is 10, what value do you suggest I try?
> 
> $ cat /proc/sys/vm/dirty_background_ratio
> 10
> 

Looking at your initial bug report, it doesn't look like a background 
writeout issue:

[415964.022375] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.022375]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.022375]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.022375] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.022375] lowmem_reserve[]: 0 3246 7980 7980
[415964.022375] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.022375] lowmem_reserve[]: 0 0 4734 4734
[415964.022375] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.022375] lowmem_reserve[]: 0 0 0 0
...
[415964.022375] 2277376 pages RAM

Ignore the all_unreclaimable information, this is a GFP_ATOMIC allocation 
so we can't reclaim.

You have an 8G machine and only 437K is dirty (which is why pdflush hasn't 
kicked in yet).  You do have over 3.5G of slab allocated, however.

This appears related to http://bugzilla.kernel.org/show_bug.cgi?id=13518, 
but that could be confirmed with slabtop.
