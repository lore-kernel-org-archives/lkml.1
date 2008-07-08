Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYGHJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYGHJ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYGHJ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:28:43 -0400
Received: from saeurebad.de ([85.214.36.134]:51899 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYGHJ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:28:42 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Dangerous code in cpumask_of_cpu?
References: <200807081816.40623.rusty@rustcorp.com.au>
	<87myksn587.fsf@saeurebad.de> <87iqvgn4c1.fsf@saeurebad.de>
	<87ej64n3xt.fsf@saeurebad.de>
Date: Tue, 08 Jul 2008 11:28:32 +0200
In-Reply-To: <87ej64n3xt.fsf@saeurebad.de> (Johannes Weiner's message of "Tue,
	08 Jul 2008 11:03:10 +0200")
Message-ID: <877ibwn2rj.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ fixed christoph's address in cc]

Johannes Weiner <hannes@saeurebad.de> writes:

>> I guess because we dereference it immediately again, the location is not
>> clobbered yet.  At least in my test case, gcc assembled it to code that
>> puts the address in eax and derefences it immediately, before eax is
>> reused:
>
> Gee, just ignore this bs.  The address is in eax, not the value.

My theory was half-right.  Since the code is a macro, there is no call
and hence no stack clean-up.  And although it is UB, it works correctly
as the value is not yet clobbered when we access it again.  Converting
foo to a macro yields this:

        movl    $42, -8(%ebp)
        leal    -8(%ebp), %eax
        movl    (%eax), %eax
	...
	ret

gcc only emits a warning if the scope we leak a local address from is
that of a function.

	Hannes
