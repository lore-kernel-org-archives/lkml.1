Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZEaHRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZEaHRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 03:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZEaHRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 03:17:31 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:35176 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZEaHRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 03:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AVnLT26LeeofiED3/4M2gpD8BbYpRpzzHjmwvguh1M4vQ35H+mljHyM67xgyeXcIBB
         nGh33xIL8kKDQhSn5OxX/ClKW9tOHR5QCmeDjTXrL4AYKrWH/6wz/9cqfI8dH0VK4uat
         Sir1oVNt4RrHGcITQGEhyRzvmXNgM+l5zjKMI=
MIME-Version: 1.0
In-Reply-To: <20090530213311.GM6535@oblivion.subreption.com>
References: <20090530075033.GL29711@oblivion.subreption.com>
	 <20090530082048.GM29711@oblivion.subreption.com>
	 <20090530173428.GA20013@elte.hu>
	 <20090530180333.GH6535@oblivion.subreption.com>
	 <20090530182113.GA25237@elte.hu>
	 <20090530184534.GJ6535@oblivion.subreption.com>
	 <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com>
	 <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
	 <20090530213311.GM6535@oblivion.subreption.com>
Date: Sun, 31 May 2009 10:17:31 +0300
X-Google-Sender-Auth: 753ce8dfce9ef568
Message-ID: <84144f020905310017o3c2b8c52s7d62187cf794e854@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Larry H." <research@subreption.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 12:33 AM, Larry H. <research@subreption.com> wrote:
> While we are at it, did any of you (Pekka, Ingo, Peter) bother reading
> the very first paper I referenced in the very first patch?:
>
> http://www.stanford.edu/~blp/papers/shredding.html/#kernel-appendix
>
> Could you _please_ bother your highness with an earthly five minutes
> read of that paper? If you don't have other magnificent obligations to
> attend to. _Please_.
>
> PS: I'm still thanking myself for not implementing the kthread /
> multiple page pool based approach. Lord, what could have happened if I
> did.

Something like that might make sense for fast-path code.

I think we could make GFP_SENSITIVE mean that allocations using it
force the actual slab pages to be cleaned up before they're returned
to the page allocator. As far as I can tell, we could then recycle
those slab pages to GFP_SENSITIVE allocations without any clearing
whatsoever as long as they're managed by slab. This ensures critical
data in kmalloc()'d memory is never leaked to userspace.

This doesn't fix all the cases Alan pointed out (unconditional
memset() in page free is clearly superior from security pov) but
should allow us to use GFP_SENSITIVE in fast-path cases where the
overhead of kzfree() is unacceptable.

                                      Pekka
