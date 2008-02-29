Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbYB2LRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbYB2LRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYB2LR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:17:26 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbYB2LRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:17:25 -0500
Date: Fri, 29 Feb 2008 03:16:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
Message-Id: <20080229031656.1abac83a.akpm@linux-foundation.org>
In-Reply-To: <1202007623.1844.44.camel@brick>
References: <1202007623.1844.44.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2008 19:00:23 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.  s390 is changed to pass
> error_code in this patch.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, 1/2 is low risk, 2/2 has been tested on x86-32 and 64,
> but the !preemptible invariant seems correct.
> 
>  arch/arm/mm/fault.c     |   25 +------------------------
>  arch/avr32/mm/fault.c   |   21 +--------------------
>  arch/ia64/mm/fault.c    |   24 +-----------------------
>  arch/powerpc/mm/fault.c |   25 +------------------------
>  arch/s390/mm/fault.c    |   25 +------------------------
>  arch/sparc64/mm/fault.c |   23 +----------------------
>  arch/x86/mm/fault.c     |   26 ++------------------------
>  include/linux/kprobes.h |   20 ++++++++++++++++++++
>  8 files changed, 28 insertions(+), 161 deletions(-)

Breaks the ia64 build:

include/linux/kprobes.h: In function `kprobe_handle_fault':
include/linux/kprobes.h:234: error: implicit declaration of function `kprobe_fault_handler'                                                                     

and ia64 doesn't implement kprobe_fault_handler() so there's no easy fix
here.

There's too much inlining in linux/kprobes.h, btw.
