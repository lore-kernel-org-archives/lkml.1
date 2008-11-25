Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYKYBFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYKYBFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYKYBFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:05:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYKYBFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:05:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=UhHUMBq7YUlN76490xd9bH10niFTXA9yHc7kL/7xG1u93eCOJ50YCUbleW1GwTaY9
	ACTLxpidScf1g5WxmBjrA==
Date: Mon, 24 Nov 2008 17:05:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       david@fromorbit.com, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes
 sysctls
In-Reply-To: <492B4C43.8020506@oracle.com>
Message-ID: <alpine.DEB.2.00.0811241702040.1550@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com> <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com> <20081124153843.d3c4782c.akpm@linux-foundation.org> <492B4C43.8020506@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Randy Dunlap wrote:

> >> -	if (background_ratio >= dirty_ratio)
> >> -		background_ratio = dirty_ratio / 2;
> >> +		dirty_ratio = vm_dirty_ratio;
> >> +		if (dirty_ratio < 5)
> >> +			dirty_ratio = 5;
> >> +		dirty = (dirty_ratio * available_memory) / 100;
> >> +	}
> >> +
> >> +	if (dirty_background_bytes)
> >> +		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;
> > 
> > DIV_ROUND_UP()?
> 
> Note that DIV_ROUND_UP() would make that
> 
> 		background = (dirty_background_byte + PAGE_SIZE - 1) / PAGE_SIZE;
> 
> but that's usually what is needed/intended.
> 

Good point.  If we were to do this, then dirty_bytes and 
dirty_background_bytes should use 1 instead of 0 as the minimum acceptable 
value in proc_dointvec_minmax().  Otherwise, get_dirty_limits() would 
return 0 pages for the dirty limit when 0 is written to either file since 
integer division truncates and we'd be in a constant state of writeback :)
