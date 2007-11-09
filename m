Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXKICMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXKICMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXKICM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:12:29 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:7703 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXKICM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RNx0NdPafPSPmSkF03PuYld+w0yIS2k+aT8yHbfebYECL9o2Or6iH3WHpSds0lBtn5nbB5gi+F4ZsuUp8XNqUa923KndMY3M8QB+G4yujpP70emRe+7q1bA/igbMMgWJScgh4Ld+LEEuGwQKwksz4OFprMEJmNNBsiNzUEb/010=
Message-ID: <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>
Date: Thu, 8 Nov 2007 20:12:25 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Przemyslaw Wegrzyn" <czajnik@czajsoft.pl>
Subject: Re: Fw: Buffer overflow in CIFS VFS.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org
In-Reply-To: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You are correct that the CIFS code calls SendReceive in cases in which
the buffer may be too small to fit a large SMB response, and that
should be fixed (e.g. to avoid possible overflows due to a server
bug), None of the eight cases (SMB TreeDisconnect, SMB uLogoff, SMB
Close, SMB FindClose etc.) in which a small buffer is passed in to
SendReceive return more than a few dozen bytes (and they are fixed
size responses), but I agree that we have to be safe (and we have seen
at least one server corrupt the bcc in the ulogoffX response and
another on the NTCreateX response) so it would be good to fix.

There are probably better ways to handle this though than passing in
the buffer size as your patch does.   Since there are only two buffer
sizes that CIFS uses - it would be easier to pass in (or out) a flag
which indicates the buffer size.  But the function SendReceive2
already does that - and the easier way to handle this seems to be
changing the eight places in fs/cifs/cifssmb.c which call
small_smb_init and then call SendReceive, to call SendReceive2
instead.

> From: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
> To: linux-kernel@vger.kernel.org
> Subject: Buffer overflow in CIFS VFS.
>
> just to find something that looks like a buffer overflow  bug.
> The problem is in SendReceive() function in transport.c - it memcpy's
> message payload into a buffer passed via out_buf param. The function
> assumes that all buffers are of size (CIFSMaxBufSize +
> MAX_CIFS_HDR_SIZE) , unfortunately it is also called with smaller
> (MAX_CIFS_SMALL_BUFFER_SIZE) buffers.
>
> To check this finding I patched Samba server to send oversized logoffX
> messages. With ~ 16kB messages the client running 2.6.23.1 crashed upon
> unmounting.
>
> I've done a quick fix, available here:
> http://czajnick.sitenet.pl/cifs-buffer-overflow-fix.patch.gz



-- 
Thanks,

Steve
