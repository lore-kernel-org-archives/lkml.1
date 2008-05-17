Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYEQU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYEQU23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYEQU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:28:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:18630 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYEQU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WcW4QX6/7igek1jiAYD1fmmHvpEuKTqAUXC74atjszyOa1+X7/KYyDNub7vWrpUVE1dntSf7rWDHz6tFCkoUEraGlzHUVJiQkgjeANlx1fMEZJF+rA6W+jvuQHo/OTnSuMK2FGNaqvjyAvNavLMTA7XEWdBL7yCDCd4DE5WQT34=
Message-ID: <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com>
Date: Sat, 17 May 2008 21:28:18 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080517192200.GA6914@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080517192200.GA6914@cvg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/17 Cyrill Gorcunov <gorcunov@gmail.com>:
> +/* a few helper functions */
> +#ifdef CONFIG_X86_64
> +
> +static inline unsigned int get_nmi_count(int cpu)
> +{
> +       return cpu_pda(cpu)->__nmi_count;
> +}
> +
> +static inline int mce_in_progress(void)
> +{
> +#ifdef CONFIG_X86_MCE
> +       return atomic_read(&mce_entry) > 0;
> +#endif
> +       return 0;
> +}
> +
> +static inline void __die_nmi(char *str, struct pt_regs *regs, int do_panic)
> +{
> +       die_nmi(str, regs, do_panic);
> +}
> +
> +#else /* !CONFIG_X86_64 */
> +
> +static inline unsigned int get_nmi_count(int cpu)
> +{
> +       return nmi_count(cpu);
> +}
> +
> +static inline int mce_in_progress(void)
> +{
> +       return 0;
> +}
> +
> +static inline void __die_nmi(char *str, struct pt_regs *regs, int do_panic)
> +{
> +       die_nmi(regs, str);
> +}
> +
> +#endif /* !CONFIG_X86_64 */

Hi,

I've always wondered if it's cleaner to define variants of functions
like this with the conditionals inside the function, as opposed to one
big conditional encapsulating all these functions.  IMO, it's cleaner
to define the function with conditionals to define it's particular
behaviour in the two different cases, because that way there is one
definition of the function with both different behaviours inside,
e.g.:

static inline unsigned int get_nmi_count(int cpu)
{
#ifdef CONFIG_X86_64
        return cpu_pda(cpu)->__nmi_count;
#else
        return nmi_count(cpu);
#endif
}

I know it introduces a lot of these conditionals, but at least there
is one place to look for the get_nmi_count function, instead of
searching for all variants of the function.

Just a thought!

-- 
Regards,
Tom Spink
