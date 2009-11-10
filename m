Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZKJW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZKJW3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbZKJW3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:29:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304AbZKJW3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:29:15 -0500
Message-ID: <4AF9E851.2000406@zytor.com>
Date: Tue, 10 Nov 2009 14:25:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
References: <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com> <20091110174622.GK5129@outflux.net> <4AF9B6AD.8020505@zytor.com> <20091110194304.GW5129@outflux.net> <4AF9C627.1070206@zytor.com> <20091110205544.GZ5129@outflux.net> <4AF9D98A.90808@zytor.com> <20091110221537.GB5129@outflux.net>
In-Reply-To: <20091110221537.GB5129@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:15 PM, Kees Cook wrote:
> On Tue, Nov 10, 2009 at 01:22:18PM -0800, H. Peter Anvin wrote:
>> Yes, it should be.  set_nx() and check_efer() are doing the same thing,
>> except in different ways, and they are - IMO - *both* doing something
>> dumb -- although check_efer() is saner.
> 
> BTW, it seems like set_nx() should move from init_memory_mapping to
> setup_arch, since init_memory_mapping can be called twice, but I don't
> think set_nx needs to be.
> 

We already have call points in setup_arch for check_efer(), which are
where this code needs to be called.

As I said, check_efer() and set_nx() are the 64- and 32-bit versions of
*exactly the same thing*.  Furthermore, it looks to me that set_nx() is
simply broken; it forces the bit set in EFER even though it is already
set in head_32.S.

Thus, what we *should* do is:

a) remove set_nx() completely;
b) enable check_efer() on 32 bits;
c) rename check_efer() to something sane, like x86_configure_nx();

Optionally we should just use cpu_has_nx instead of reading EFER.

	-hpa
