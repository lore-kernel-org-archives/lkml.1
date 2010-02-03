Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0BCU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:26:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50105 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab0BCU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:26:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NHcERsRuLiG84pmRurEtwfv/QU9A/UVNnPjlGWub577mumEbalzjbBIdpffDQyDUZ
	4U1l3SikOihLViPcLg6BA==
Date: Wed, 3 Feb 2010 12:26:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frans Pop <elendil@planet.nl>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       l.lunak@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Improving OOM killer
In-Reply-To: <201002032112.33908.elendil@planet.nl>
Message-ID: <alpine.DEB.2.00.1002031220070.750@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <201002032029.34145.elendil@planet.nl> <alpine.DEB.2.00.1002031141350.27853@chino.kir.corp.google.com> <201002032112.33908.elendil@planet.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Frans Pop wrote:

> That doesn't take into account:
> - applications where the oom_adj value is hardcoded to a specific value
>   (for whatever reason)
> - sysadmin scripts that set oom_adj from the console
> 

The fundamentals are the same: negative values mean the task is less 
likely to be preferred and positive values mean the task is more likely, 
only the scale is different.  That scale is exported by the kernel via 
OOM_ADJUST_MIN and OOM_ADJUST_MAX and has been since 2006.  I don't think 
we need to preserve legacy applications or scripts that use hardcoded 
values without importing linux/oom.h.

> I would think that oom_adj is a documented part of the userspace ABI and 
> that the change you propose does not fit the normal backwards 
> compatibility requirements for exposed tunables.
> 

The range is documented (but it should have been documented as being from 
OOM_ADJUST_MIN to OOM_ADJUST_MAX) but its implementation as a bitshift is 
not; it simply says that positive values mean the task is more preferred 
and negative values mean it is less preferred.  Those semantics are 
preserved.

> I think that at least any user who's currently setting oom_adj to -17 has a 
> right to expect that to continue to mean "oom killer disabled". And for 
> any other value they should get a similar impact to the current impact, 
> and not one that's reduced by a factor 66.
> 

If the baseline changes as we all agree it needs to such that oom_adj no 
longer represents the same thing it did in the first place (it would 
become a linear bias), I think this breakage is actually beneficial.  
Users will now be able to tune their oom_adj values based on a fraction of 
system memory to bias their applications either preferrably or otherwise.

I think we should look at Linux over the next couple of years and decide 
if we want to be married to the current semantics of oom_adj that are 
going to change (as it would require being a factor of 66, as you 
mentioned) when the implementation it was designed for has vanished.
