Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbZDHOv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbZDHOv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbZDHOvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:51:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765031AbZDHOvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:51:38 -0400
Date: Wed, 8 Apr 2009 11:55:45 -0300
From: Glauber Costa <glommer@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
Message-ID: <20090408145545.GA25323@poweredge.glommer>
References: <1239161017-7398-1-git-send-email-glommer@redhat.com> <49DC24C2.7000608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC24C2.7000608@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 09:14:58PM -0700, H. Peter Anvin wrote:
> Glauber Costa wrote:
> > While in real mode, sti does not block interrupts from the subsequent
> > instruction. This is stated at Intel SDM Volume 2b, page 4-432
> 
> I don't see how you're getting that idea from the STI documentation --
> and I am quite sure that that is not the case.  Quite on the contrary.
> The only differences between protected mode and real mode has to do with
> the handling of VIF when CPL=3 (this rather naturally falls out if one
> considers CPL=0 in real mode).
> 
> The text is:
> 
> "If protected-mode virtual interrupts are not enabled, STI sets the
> interrupt flag (IF) in the EFLAGS register. After the IF flag is set,
> the processor begins responding to external, maskable interrupts after
> the next instruction is executed. The delayed effect of this instruction
> is provided to allow interrupts to be enabled just before returning from
> a procedure (or subroutine). For instance, if an STI instruction is
> followed by an RET instruction, the RET instruction is allowed to
> execute before external interrupts are recognized1. If the STI
> instruction is followed by a CLI instruction (which clears the IF flag),
> the effect of the STI instruction is negated."
> 
> Obviously, in real mode, "protected-mode virtual interrupts" are not
> enabled, as is also confirmed by Table 4-5.

I get the idea from the pseudocode in sti description.
It says:
IF PE = 0 (* Executing in real-address mode *)
    THEN
        IF <- 1; (* Set Interrupt Flag *)
    ELSE (* Executing in protected mode or virtual-8086 mode *)

There is no mention to any other activity besides setting the if flag.
Also, sti is used extensively in many places like the linux kernel for the
guest, and it works just fine in kvm. So I was led to believe that real mode
in fact behaving differently.

I'll take a look at avi's suggestion.

