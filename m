Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbZCHMP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbZCHMP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 08:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZCHMPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 08:15:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZCHMPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:15:11 -0400
Message-ID: <49B3B6CC.2010304@redhat.com>
Date: Sun, 08 Mar 2009 14:15:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove static declaration from wall clock version
References: <1235677340-3139-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1235677340-3139-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Matt T. Yourst noted that we're currently having a dumb
> race for no reason in paravirtual wall clock. This is due
> to the use of a static variable to hold the counting.
>
> This can race with multiple guests reading wallclock
> at the same time, since the static variable value would
> then be accessible to all callers. This wasn't noted
> before because it is a rather rare scenario.
>
> Instead, just use a normal stack variable. This will
> mean that each caller will have it's version written
> separatedly. No need for a global counter.
>
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2511708..d7236f6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -548,15 +548,13 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  
>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>  {
> -	static int version;
> +	int version = 1;
>  	struct pvclock_wall_clock wc;
>  	struct timespec now, sys, boot;
>  
>  	if (!wall_clock)
>  		return;
>  
> -	version++;
> -
>  	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
>  

Suppose currently version == 2.

guest: read version (2)
guest: read sec
    host: write version (1)
    host: write sec
    host: write nsec
    host: write version (2)
guest: read nsec
guest: read version (2)

So now we have inconsistent time (sec from old data, nsec from new data).

We need to make version a per-vm value.  Best to read it from guest 
memory, so nothing special needs to be done for live migration.  Also 
use mutual exclusion in kvm_write_wall_clock() - sequence locks don't 
support multiple writers.

-- 
error compiling committee.c: too many arguments to function

