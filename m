Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbXKIK75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbXKIK75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 05:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXKIK7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 05:59:48 -0500
Received: from bravo667.server4you.de ([85.25.132.126]:56001 "EHLO
	mail.sitenet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXKIK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 05:59:47 -0500
Message-ID: <47343DA2.90306@czajsoft.pl>
Date: Fri, 09 Nov 2007 11:59:46 +0100
From: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org
Subject: Re: Fw: Buffer overflow in CIFS VFS.
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com> <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>
In-Reply-To: <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> You are correct that the CIFS code calls SendReceive in cases in which
> the buffer may be too small to fit a large SMB response, and that
> should be fixed (e.g. to avoid possible overflows due to a server
> bug), None of the eight cases (SMB TreeDisconnect, SMB uLogoff, SMB
> Close, SMB FindClose etc.) in which a small buffer is passed in to
> SendReceive return more than a few dozen bytes (and they are fixed
> size responses), but I agree that we have to be safe (and we have seen
> at least one server corrupt the bcc in the ulogoffX response and
> another on the NTCreateX response) so it would be good to fix.
>   
Well, mounting shares from untrusted server is quite uncommon, still
buffer overrun shall be considered a serious issue, imho. If the buffer
was on the stack, that would be directly exploitable.
> There are probably better ways to handle this though than passing in
> the buffer size as your patch does.   Since there are only two buffer
> sizes that CIFS uses - it would be easier to pass in (or out) a flag
> which indicates the buffer size.  But the function SendReceive2
> already does that - and the easier way to handle this seems to be
> changing the eight places in fs/cifs/cifssmb.c which call
> small_smb_init and then call SendReceive, to call SendReceive2
> instead.
>   
That is mostly a matter of taste. SendReceive takes buffer pointer and
SendReceive2 takes kvec  - I'd rather prefer to stay with  the same
function used for both small and large buffers, using two different
functions just because 2 different buffer sizes are passed around is
ugly, imho, nonorthogonal at least.  I guess that initial intention was
to use SendReceive2 in places where kvec is really needed. Also these
functions are almost identical, maybe SendReceive should wrap
SendReceive2 preparing kvec with a buffer pointer passed to it?

Obviously it is up to you, as a maintainer. I'd prefer adding a small
header to each buffer with the buffer size and perhaps a type, or even a
destructor function pointer. Simple macros could be used to obtain
buffer size, given the buffer body pointer, or to dispose the buffer.
That would save from checking the buffer type all over the code
explicitly, or even worse, make strange assumptions about the type of
buffer being passed - as we can see this is error-prone. That for a
little cost of a few additional bytes per buffer.


