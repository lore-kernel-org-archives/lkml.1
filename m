Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYIJQtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYIJQtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYIJQta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:49:30 -0400
Received: from gw.goop.org ([64.81.55.164]:38112 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYIJQta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:49:30 -0400
Message-ID: <48C7FA91.9050302@goop.org>
Date: Wed, 10 Sep 2008 09:49:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu>
In-Reply-To: <20080910115525.GA31692@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> So i'd suggest a different, more carful approach: keep the new code 
>> you wrote, but print a WARN()ing if prev_map is not unmapped yet when 
>> the next mapping is acquired. That way the ACPI code can be fixed 
>> gradually and without breaking existing functionality.
>>     
>
> ok, i stuck in your patches into tip/master today and -tip testing 
> quickly found an early-ioremap leak:
>
> [   36.625100] calling  check_early_ioremap_leak+0x0/0x3d
> [   36.630253] ------------[ cut here ]------------
> [   36.634884] WARNING: at arch/x86/mm/ioremap.c:577 check_early_ioremap_leak+0x28/0x3d()
> [   36.642811] Debug warning: early ioremap leak of 1 areas detected.
>
> find the full log below with ioremap-leak-tracing turned on. I've 
> excluded these commits for now from tip/master.
>   

Yes, that leak is expected, unfortunately.  __acpi_map_table() has no
corresponding unmap, and only maintains one mapping.  So it will leak
its last mapping when it switches over from using __acpi_map_table() to
ioremap().

So, yes, its ugly, but its guaranteed to be a single leaked mapping. 
But I'm not sure what the best approach to deal with it is.

(All those other backtraces are just informational, right?)

    J
