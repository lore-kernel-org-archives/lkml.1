Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXEAPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXEAPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXEAPlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:41:19 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:58084 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXEAPlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:41:18 -0400
Date: Tue, 1 May 2007 17:41:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.
In-Reply-To: <200704271707.l3RH7H5Z032671@hera.kernel.org>
Message-ID: <Pine.LNX.4.64.0705011734410.27246@anakin>
References: <200704271707.l3RH7H5Z032671@hera.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Linux Kernel Mailing List wrote:
>     [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.
>     
>     Make the in-kernel AFS filesystem use AF_RXRPC instead of the old RxRPC code.

> --- a/fs/afs/fsclient.c
> +++ b/fs/afs/fsclient.c

> +		if (call->count < PAGE_SIZE) {
> +			buffer = kmap_atomic(call->reply3, KM_USER0);
                                             ^^^^^^^^^^^^

This causes a compile failure on m68k:

| linux/fs/afs/fsclient.c: In function 'afs_deliver_fs_fetch_data':
| linux/fs/afs/fsclient.c:269: warning: dereferencing 'void *' pointer
| linux/fs/afs/fsclient.c:269: error: request for member 'virtual' in something not a structure or union

Probably you wanted to assign call->reply3 to a struct page pointer first, like you do for the call->unmarshall == 2 case.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

--- linux-m68k-2.6.21/fs/afs/fsclient.c
+++ linux-m68k-2.6.21/fs/afs/fsclient.c
@@ -266,7 +266,8 @@ static int afs_deliver_fs_fetch_data(str
 		call->unmarshall++;
 
 		if (call->count < PAGE_SIZE) {
-			buffer = kmap_atomic(call->reply3, KM_USER0);
+			page = call->reply3;
+			buffer = kmap_atomic(page, KM_USER0);
 			memset(buffer + PAGE_SIZE - call->count, 0,
 			       call->count);
 			kunmap_atomic(buffer, KM_USER0);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
