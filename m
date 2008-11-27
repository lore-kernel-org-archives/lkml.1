Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbYK0Jvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbYK0Jvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYK0Jvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:51:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:64210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYK0Jvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Y8beQP/6o7XvzE69R3zdcRccH/OCQV8FFHx+tkroarsHyp3zAjGeHpjIy/uOe/EeAK
         wbQxKiCifmY0laiW//X6YSLGljmIzc8HRLYuPTtA8yyXk+Kt4ug+03nFJS+ZvwEqU1B2
         d7rm1XIiROLnW/87B+8EoztH4X39N8uKI0HOo=
Message-ID: <7c86c4470811270151i33ffaa44mb5d9bd79f9d73968@mail.gmail.com>
Date: Thu, 27 Nov 2008 10:51:36 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org
In-Reply-To: <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <20081126113309.GS6703@one.firstfloor.org>
	 <20081126230529.ab37fb32.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>
	 <7c86c4470811260556l3b161f1fx639d7ee02285a93@mail.gmail.com>
	 <alpine.LFD.2.00.0811261727200.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Nov 26, 2008 at 5:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Stephane,
>
> On Wed, 26 Nov 2008, stephane eranian wrote:
>> > I have not yet found a good reason why it needs to use u64 instead of
>> > using what's there already.
>> >
>> There is a good reason why we cannot use unsigned long. We must make sure
>> all data structures exchanged between user mode and the kernel have fixed size.
>> This way, we can have a 32-bit tool run unmodified on top of a 64-bit kernel AND
>> we do not need trampoline code to marshall/unmarshall the parameters.
>
> That's not a good reason at all. We have in kernel interfaces and
> kernel-userspace interfaces. Making them the same is nice if it works,
> but horrible if it imposes crappy hackery like the bitops wrappers.
>
>> And yes, the abstraction for bitmask ops was introduced because of issues
>> casting u64 -> unsigned long on Big-Endian32-bit machines such as PPC32.
>
> Sorry, I think it is simply stupid.
>
> You can keep the userspace interface u64 and use unsigned long for the
> bitmasks in the kernel and take care of it in the user space interface
> code and do the BE32 conversion when you copy stuff from and to user.
>
> That's a single well defined place and does not add extra crappola
> over the kernel especially not into hot pathes like the interrupt.
>
> Why do you want to do u64 -> u32 BE32 magic on every interrupt,
> context switch etc., if you can do it once in the userspace interface ?
>
I think we agree as to why the user visible structures have to have fixed size.

Some structures have bitfields in them (no in the current patchset yet).
Here is an example:

#define PFM_PMD_BV   (256/sizeof(__u64))

struct pfarg_pmd_attr {
        __u16 reg_num;          /* which register */
        __u16 reg_set;          /* which event set */
        __u32 reg_flags;        /* REGFL flags */
        __u64 reg_value;        /* 64-bit value */
        __u64 reg_long_reset;   /* write: value to reload after notification */
        __u64 reg_short_reset;  /* write: reset after counter overflow */
        __u64 reg_random_mask;  /* write: bitmask used to limit random value */
        __u64 reg_smpl_pmds[PFM_PMD_BV];  /* write: record in sample */
        __u64 reg_reset_pmds[PFM_PMD_BV]; /* write: reset on overflow */
        __u64 reg_ovfl_swcnt;   /* write: # of overflows before switch */
        __u64 reg_smpl_eventid; /* write: opaque event identifier */
        __u64 reg_last_value;   /* read : return: PMD last reset value */
        __u64 reg_reserved[8];  /* for future use */
};

So you are advocating keeping that layout for the user level code,
i.e., the user level perfmon.h.
But then, in the kernel, you'd have a different version of the same
structure with the same name
and the size but with the bitmask defined as unsigned long instead.
All internal only bitmask
would also be unsigned long. So the structure would like as follows:

#define PFM_PMD_BV  (256/sizeof(unsigned long))
struct pfarg_pmd_attr {
        __u16 reg_num;          /* which register */
        __u16 reg_set;          /* which event set */
        __u32 reg_flags;        /* REGFL flags */
        __u64 reg_value;        /* 64-bit value */
        __u64 reg_long_reset;   /* write: value to reload after notification */
        __u64 reg_short_reset;  /* write: reset after counter overflow */
        __u64 reg_random_mask;  /* write: bitmask used to limit random value */
        unsigned long reg_smpl_pmds[PFM_PMD_BV];  /* write: record in sample */
        unsigned long reg_reset_pmds[PFM_PMD_BV]; /* write: reset on overflow */
        __u64 reg_ovfl_swcnt;   /* write: # of overflows before switch */
        __u64 reg_smpl_eventid; /* write: opaque event identifier */
        __u64 reg_last_value;   /* read : return: PMD last reset value */
        __u64 reg_reserved[8];  /* for future use */
};

Then we could not directly export include/linux/perfmon.h to user
via Kbuild.
