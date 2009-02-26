Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbZBZWAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbZBZWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZBZWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:00:43 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:60486 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZBZWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vo3YXOHS+G0IHA3lz9QF1i4QkG2U+O+3lj3EPCGxAHYnkZ3NxVbZF9xrLwzEGlboZi
         U5KemcwZmdpk38stMVzywAPO9lrAbiaErungnDGUgjXWN8OEUBB4o8zavLIdHBp0egOB
         TyBLbLoLWb+6kd86CL+3y+Chk+gozNsuoEs7Y=
Message-ID: <49A71105.4050001@gmail.com>
Date: Thu, 26 Feb 2009 23:00:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
References: <20090224175518.GA15616@elte.hu> <1235508093-18063-1-git-send-email-jirislaby@gmail.com> <49A524D3.3090408@gmail.com> <20090225111002.GA15453@elte.hu>
In-Reply-To: <20090225111002.GA15453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.2.2009 12:10, Ingo Molnar wrote:
> * Jiri Slaby<jirislaby@gmail.com>  wrote:
>> In that case, the callers code is buggy, since it passes
>> online_cpu masks even on machines, where apics are not on the
>> same clusters.
>
> It's most likely confusion in the old code. This used to be
> copy&paste-ed versions of different snapshots of the
> mach-default-code, hacked to make work on weird platforms.
> Mainline fixes/updates werent merged in consistently.
>
> So could you please send a patch that fixes this?

I've sent 4 more patches, but there are still issues:
* es7000 + summit: I haven't solved calling with all bits set (only all 
online is sufficient to trigger this). Some of the processors needn't be 
on the same apic cluster. It will scream now (again -- it did before 
adding the "optimisation"). Actually I don't know how to solve this. How 
the caller would know the correct mask, ANDing with a apic->target_cpus 
retval?

* es7000: target_cpus_cluster returns CPU_MASK_ALL and hence it will 
choke itself, because es7000_cpu_mask_to_apicid doesn't count with that. 
Invoked by setup_timer_IRQ0_pin this way.

* set_desc_affinity doesn't expect apic->cpu_mask_to_apicid_and to 
return BAD_APICID and silently sets desc->affinity. Again, I see no 
straightforward solution (rollback of assign_irq_vector and 
set_extra_move_desc needed).
