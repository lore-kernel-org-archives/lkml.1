Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0BHP1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:27:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab0BHP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:27:53 -0500
Subject: Re: [PATCH] kmemcheck: Test the full object in
	kmemcheck_is_obj_initialized()
From: Catalin Marinas <catalin.marinas@arm.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christian Casteyde <casteyde.christian@free.fr>
In-Reply-To: <25e057c01002080638g149c974r759f50365cd05233@mail.gmail.com>
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
	 <25e057c01002080638g149c974r759f50365cd05233@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 08 Feb 2010 15:27:00 +0000
Message-Id: <1265642820.4020.109.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 15:27:01.0399 (UTC) FILETIME=[29107270:01CAA8D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 14:38 +0000, roel kluin wrote:
> On Mon, Feb 8, 2010 at 12:16 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > This is a fix for bug #14845 (bugzilla.kernel.org). The
> > update_checksum() function in mm/kmemleak.c calls
> > kmemcheck_is_obj_initialised() before scanning an object. When
> > KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
> > the crc32_le() reads smaller intervals (32-bit) for which
> > kmemleak_is_obj_initialised() may be false leading to a kmemcheck
> > warning.
> >
> > Note that kmemcheck_is_obj_initialized() is currently only used by
> > kmemleak before scanning a memory location.
> 
> >  enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
> >  {
> > +#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
> >        uint8_t *x;
> >        unsigned int i;
> >
> >        x = shadow;
> >
> > -#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
> >        /*
> >         * Make sure _some_ bytes are initialized. Gcc frequently generates
> >         * code to access neighboring bytes.
> > @@ -139,13 +139,25 @@ enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
> >                if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
> >                        return x[i];
> >        }
> > +
> > +       return x[0];
> >  #else
> > +       return kmemcheck_shadow_test_all(shadow, size);
> > +#endif
> > +}
> > +
> > +enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow, unsigned int size)
> > +{
> > +       uint8_t *x;
> > +       unsigned int i;
> > +
> > +       x = shadow;
> > +
> >        /* All bytes must be initialized. */
> >        for (i = 0; i < size; ++i) {
> >                if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
> >                        return x[i];
> >        }
> > -#endif
> >
> >        return x[0];
> >  }
> 
> Are we certain that size cannot be 0 in kmemcheck_shadow_test()
> and kmemcheck_shadow_test_all() or other functions in
> arch/x86/mm/kmemcheck/shadow.c with these unsigned
> comparisons in loops?

At least in the kmemleak use-case, I don't think one can allocate a
zero-size object, so it should be safe. I can't tell about the other
cases but AFAICT, this function is called as a result of a memory access
which is always greater than 0.

Thanks.

-- 
Catalin

