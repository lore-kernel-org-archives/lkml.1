Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbYGQSCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbYGQSCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbYGQSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:02:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305AbYGQSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:02:34 -0400
Date: Thu, 17 Jul 2008 11:01:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 and Configfs updates for 2.6.27
In-Reply-To: <20080717175146.GH28014@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
References: <20080717175146.GH28014@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Mark Fasheh wrote:
> 
> The only two things that could be described as features would be:
> 
> - Joel updated configfs's ->make_item() and ->make_group() callbacks to
>   return more descriptive error types. This update is responsible for the
>  changes to drivers/net/netconsole.c and fs/dlm/config.c as shown in the diffstat.


.. I really dislike how this was done.

This commit:

11c3b79218390a139f2d474ee1e983a672d5839a ("configfs: Allow ->make_item() 
and ->make_group() to return detailed errors.")

is just ugly. Returning one value by passing a pointer to a pointer, and 
the error value by returning an 'int' errno is _not_ how we do things in 
the kernel.

No, we use error pointers. 

IOW, you should have left the calling convention for "(*make_item)()" and 
"(*make_group)()" alone, but allowed people to just do

	return ERR_PTR(-ENOMEM);

etc for errors, and then in the caller you just check for IS_ERR().

That would have made the result much cleaner, and avoided that whole 
"return two different things" issue.

I pulled it, but I want to register my protest.

			Linus
