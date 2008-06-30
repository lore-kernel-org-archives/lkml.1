Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYF3PMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYF3PMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYF3PMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:12:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:64345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYF3PMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ejpvFrRRL3ViA3nj4gTf1vBPX57BPtUzGwTUSa/JbUTkYfuMSFCUlsZoPR4AKt94gF
         S1oaJZ4iNRuB6UqtVKfrX7Noy6NspR4NKH8Fva0UQPI0lxVe5luGSQLq6XfCUeIwvAHP
         AGuesLRygenlXTjGzO50fhz/gKif4hXlFz408=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Fix copy_user on x86_64
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
Date: Mon, 30 Jun 2008 17:12:10 +0200
In-Reply-To: <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	(Linus Torvalds's message of "Sat, 28 Jun 2008 11:26:24 -0700 (PDT)")
Message-ID: <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> Added copy_user_64.c instead of copy_user_64.S and
>> copy_user_nocache_64.S
>
> Grr, your patches are as attachements, which means that answering to 
> themmakes quoting them much harder. 

Sorry... But what was mentioned in Documentation/SubmittingPatches with:

"For this reason, all patches should be submitting e-mail "inline".
WARNING:  Be wary of your editor's word-wrap corrupting your patch,
if you choose to cut-n-paste your patch."

My first thought was "should be attached inline".

> Hmm? Sorry for being such a stickler. This code does end up being fairly 
> critical, both for correctness and for performance. A lot of user copies 
> are actually short (smallish structures, or just small reads and writes), 
> and I'd like to make sure that really basic infrastructure like this is 
> just basically "known to be optimal", so that we can totally forget about 
> it for a few more years.

Agreed. Code was reworked again, will test it a bit more. Two more
questions to you and Andi:

1. Do you see any reasons to do fix alignment for destination as it was
done in copy_user_generic_unrolled (yes, I know, access to unaligned
address is slower)? It tries to byte-copy unaligned bytes first and then
to do a normal copy. I think, most times destination addresses will be
aligned and this check is not so necessary. If it is necessary, then
copy_user_generic_string should do the same.

2. What is the purpose of "minor optimization" in commit
3022d734a54cbd2b65eea9a024564821101b4a9a?

ENTRY(copy_user_generic_string)
        CFI_STARTPROC
        movl %ecx,%r8d          /* save zero flag */
        movl %edx,%ecx
        shrl $3,%ecx
        andl $7,%edx
        jz   10f
1:      rep
        movsq
        movl %edx,%ecx
2:      rep
        movsb
9:      movl %ecx,%eax
        ret
        
        /* multiple of 8 byte */
10:     rep
        movsq
        xor %eax,%eax
        ret

I don't think CPU is able to speculate with 'rep movs*' in both
branches, and I'm not sure if conditional jump is cheaper then empty
'rep movsb' (when ecx is 0). I want to eliminate it if you don't have
any objections.

Thanks.
-- 
wbr, Vitaly
