Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbZARSQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbZARSQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbZARSQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:16:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:53337 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbZARSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r+r09q86yWwyn9XwcMqH31tx+Cy4HzHjj+r4uswv+38v5o58zfP+9gMC5tqw+OilMO
         iq0YRhHjBN+hNm3zpxY+sh2dx5ze7SiTKUfK7MioJW/+7FpGlPNyfR5Src1z4w5tE2Zi
         UjUbHFUJt95gtC4WprZ+dog2yXX0Y7PXLCQig=
MIME-Version: 1.0
In-Reply-To: <1232296759-2253-4-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
	 <1232296759-2253-4-git-send-email-tj@kernel.org>
Date: Sun, 18 Jan 2009 13:16:33 -0500
Message-ID: <73c1f2160901181016t61cd1954s3ced677ab5b3b28a@mail.gmail.com>
Subject: Re: [PATCH 03/12] x86-64: Convert irqstacks to per-cpu
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 11:39 AM, Tejun Heo <tj@kernel.org> wrote:
> From: Brian Gerst <brgerst@gmail.com>
>
> Move the irqstackptr variable from the PDA to per-cpu.  Make the
> stacks themselves per-cpu, removing some specific allocation code.
> Add a seperate flag (is_boot_cpu) to simplify the per-cpu boot
> adjustments.
>
> tj: * sprinkle some underbars around.
>
>    * irq_stack_ptr is not used till traps_init(), no reason to
>      initialize it early.  On SMP, just leaving it NULL till proper
>      initialization in setup_per_cpu_areas() works.  Dropped
>      is_boot_cpu and early irq_stack_ptr initialization.

And it adds more #ifdefs.  All these conditional initializations on
CONFIG_SMP are really cluttering up the code.  It also conflicts with
one of my goals with these patches: have as much state as possible
already prepared when a cpu boots.  For the boot cpu this means static
initialization.  For secondary cpus, that means setting up the values
in setup_per_cpu_areas().  This eliminates any window where the state
isn't ready yet, as you've already seen with per_cpu_offset.

And is_boot_cpu was a worthwhile optimization on its own.  I had plans
on using it in more places later.

--
Brian Gerst
