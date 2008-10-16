Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYJPLxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYJPLxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYJPLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:52:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:61108 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYJPLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:52:57 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH 2/4] timers: new framework for identifying
	cpu-pinned timers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org
In-Reply-To: <20081016114830.GC7641@linux.vnet.ibm.com>
References: <20081016114830.GC7641@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 13:53:02 +0200
Message-Id: <1224157982.28131.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 17:18 +0530, Arun R Bharadwaj wrote:
> This patch creates the necessary framework for identifying cpu-pinned
> regular timers and hrtimers.
> 
> For regular timers a new flag called TBASE_PINNED_FLAG is created.
> Since the last 3 bits of the tvec_base is guaranteed to be 0, and
> since the last bit is being used to indicate deferrable timers, I'm
> using the second last bit to indicate cpu-pinned regular timers.
> The implementation of functions to manage the TBASE_PINNED_FLAG is
> similar to those which manage the TBASE_DEFERRABLE_FLAG.
> 
> For hrtimers, there is no clear interface to queue a hrtimer as a
> per-cpu hrtimer. But there are instances where, if an hrtimer is queued
> on a particular cpu, it expects to run on the same cpu.
> The hrtimer hrtick_timer is one such example.
> 
> So, in this regard, I've created a new interface called
> hrtimer_start_pinned which can be used to queue cpu-pinned hrtimer.
> In the hrtimer structure, there is a variable called *state* which
> is used to indicate the state of a hrtimer - inactive, enqueued,
> callback function running and callback pending. Currently, since only
> 5 bits are being used in the state variable, I've used the 6th bit
> to represent the cpu-pinned state of the hrtimer
> 
> 
> Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>

Thomas recently created HRTIMER_CB_IRQSAFE_PERCPU which serves this
purpose to close some cpu-hotplug timer races.

> @@ -97,6 +96,7 @@ enum hrtimer_cb_mode {
>  #define HRTIMER_STATE_CALLBACK	0x02
>  #define HRTIMER_STATE_PENDING	0x04
>  #define HRTIMER_STATE_MIGRATE	0x08
> +#define HRTIMER_CPU_PINNED	0X16

Hehe, may I suggest 0x10 :-)

