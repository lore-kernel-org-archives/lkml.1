Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZFAOxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZFAOxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFAOxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:53:31 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:55660 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZFAOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CPFIHE9UAb/HZ9/I8WFriltCIpKLP4c7UZlElSvjfxa5ham17J/PIr/UIrl047OFzq
         poZUvyfcdQ4uy6rUKiWYYk/Ilft60giwLvituLzwWnes0Ep38sIFAEFZnSQHhz/EkR0w
         wTxqqt+GB1giypavYJOnYnyjbf1p0bLXZRaho=
Date: Mon, 1 Jun 2009 16:53:26 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090601145326.GA28260@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
	mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
	mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A218761.5080607@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Obviously not, since it's a relatively new opcode.  However, it is
> supported by both Intel and AMD with the opcode F3 0F B8 /r.
> 
> The "/r" is the real problem ... it means one can't just mimic it with
> hard-coding .byte directives without fixing the arguments (which means a
> performance hit.)  Furthermore, the 0F B8 opcode is JMPE, which doesn't
> take the same arguments either.

How about we pin the src/dst into a register:

#define popcnt_spelled(x)                                       \
({                                                              \
        typeof(x) __ret;                                        \
        __asm__(".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t"    \
                ".byte 0xb8\n\t.byte 0xc0\n\t"                  \
                : "=a" (__ret)                                  \
                : "0" (x));                                     \
        __ret;                                                  \
})

which generates

  40055e:       48 8b 45 e8             mov    -0x18(%rbp),%rax
  400562:       f3 48 0f b8 c0          popcnt %rax,%rax
  400567:       48 89 45 f8             mov    %rax,-0x8(%rbp)

here.

For < 64bit operand sizes, the operands get zero-extended so that
garbage in the high 32/48 bits of %rax doesn't corrupt the result.
We might even want to do the movzwq explicitly so that some compiler
doesn't decide to take the version with the "0f b6" opcode which
zero-extends only the 16-/32-bit register. This way, you can popcnt even
single bytes although the popcnt implementation doesn't allow single
byte operands.

  400572:       0f b7 45 f2             movzwl -0xe(%rbp),%eax
  400579:       f3 48 0f b8 c0          popcnt %rax,%rax
  40057e:       66 89 45 f6             mov    %ax,-0xa(%rbp)


So, in addition to popcnt itself, we have two movs added. This is still
less than the 30+ ops (+ function call overhead) that hweight* get
translated into. I'll redo my kernel build benchmarks tomorrow to get
some more recent numbers on the performance gain.

-- 
Regards/Gruss,
    Boris.
