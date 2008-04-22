Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbYDVPC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbYDVPC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764874AbYDVPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:02:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764861AbYDVPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:02:10 -0400
Date: Tue, 22 Apr 2008 08:01:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
In-Reply-To: <20080422145105.GJ12774@kernel.dk>
Message-ID: <alpine.LFD.1.10.0804220759020.2779@woody.linux-foundation.org>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org> <20080422145105.GJ12774@kernel.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jens Axboe wrote:
> > 
> > You forgot to free the "data" here? The waiter must also free the object, 
> > since now the callee does not.
> 
> The ipi interrupt handler does that, see kfree() in
> generic_smp_call_function_single_interrupt() or call_func_data_free() in
> generic_smp_call_function_interrupt().

Hell no, it does *not*.

Doing that for the waiting case would be a *huge* bug, since the waiter 
needs to wait until the flag is clear - and if the waitee free's the 
allocation, that will never happen.

So the rule *must* be:
 - waiter frees
 - ipi interrupt frees non-waiting ones.
because anything else cannot work.

And you must have known that, because the code you pointed me to does 
*not* free the data at all. It just clears the FLAG_WAIT flag:

	+               if (data->csd.flags & CSD_FLAG_WAIT) {
	+                       smp_wmb();
	+                       data->csd.flags &= ~CSD_FLAG_WAIT;
	+               } else
	+                       call_func_data_free(data);

So please think about this some more. 

		Linus
