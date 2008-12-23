Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYLWFw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYLWFw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 00:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYLWFwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 00:52:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:60310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYLWFwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 00:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=M/Wbz/ji1CvbmytH4M1/HPHKyTMvCHOuL/GwduG0ZB6J/GliquDmWl51rgkNrNJLqG
         UAOm6tr5L6mg8Kb5R/3uhgXumYRk4cjDkAh6OomJQ6BVbZbrbKaBRIXVY08XdyFWANa4
         G8OfyvI4ZYlr6YSpvcPetEgaE479fnXanoMG0=
Message-ID: <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com>
Date: Mon, 22 Dec 2008 21:52:19 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: parsing mem=700M broken
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
X-Google-Sender-Auth: 03c99b448be1cd00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 7:06 PM, Hugh Dickins <hugh@veritas.com> wrote:
> Hi Rusty,
>
> I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
> and have bisected it down to your patch below; but now I'm off to bed
> without working out just what goes wrong (I'll bet it's the "=").
>
> Hugh
>
> commit 5c886584a758edba7e25ad9df974cf15a4a1f59d
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Dec 3 13:34:34 2008 +1030
>
>    Call early_param earlier.
>
>    We delete all the arch calls: we call it from start_kernel earlier
>    now.  We also no longer take a temporary copy, but parse in place.
>
>    Note: IA64 needs to parse "machvec=" before other commandline options
>    but machvec_init_from_cmdline() needs efi_init() and io_port_init(),
>    so they are all moved into arch_get_boot_command_line().
>

yeah, you are right.

static int __init parse_memopt(char *p)
{
        u64 mem_size;

        if (!p)
                return -EINVAL;

#ifdef CONFIG_X86_32
        if (!strcmp(p, "nopentium")) {
                setup_clear_cpu_cap(X86_FEATURE_PSE);
                return 0;
        }
#endif

        userdef = 1;
        mem_size = memparse(p, &p);
        e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);

        return 0;
}
early_param("mem", parse_memopt);


in x86 we use that param analyser much later ( after we check the e820 table..)

other cpu flag will be overwrite too..

anyway, this patch is not go through x86 tip..., some strange!

YH
