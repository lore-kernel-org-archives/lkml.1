Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXLASno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXLASno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXLASna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:43:30 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbXLASna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:43:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=cyE2AezvVUo7nxZNYhCwU6SXQ/iOZnvaUyplH0ng3p8HSJ2h+OdMifTdtmtmlVMCn
	E3HsMKRHj+l261eZSKUGw==
Date: Sat, 1 Dec 2007 10:42:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
In-Reply-To: <20071201092037.GA32544@elte.hu>
Message-ID: <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com>
References: <20071201092037.GA32544@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007, Ingo Molnar wrote:

> this patch extends the soft-lockup detector to automatically
> detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
> printed the following way:
> 

Wouldn't a natural extension of this feature be to mark these hung 
TASK_UNINTERRUPTIBLE tasks with a new thread flag such as TIF_HUNG for the 
purposes of the OOM killer?

Right now, the OOM killer will become a no-op when any candidate task that 
it scans through is found to have the TIF_MEMDIE flag when selecting a 
task to kill.  So any hung task in this state could cause the OOM killer 
to infinitely loop.

If lockdep could set_tsk_thread_flag(g, TIF_HUNG), this could be detected 
in the OOM killer and not only could we prevent the infinite looping but 
we could also clear TIF_MEMDIE and reduce the increased timeslice that the 
OOM killer gives to the tasks it kills.

		David
