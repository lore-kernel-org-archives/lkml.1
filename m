Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYC0NVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYC0NVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYC0NVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:21:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:23828 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYC0NVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=ZlhQPu8fbUYBKQQMohr3egKEjURC/1oS7t+hlKjTa+W7NXVajhXZ6sU5LAAK4CE3dxVO6mTPZYe1QY0qXI5GOBCfvbqiNfp/8Bb3tXzRz6P+yvS/UWGXN++TJB6tLHcNmiOmLOCN22niCn6bYDFATrv6c8ClooIAB3WMJR2WT0c=
Message-ID: <170fa0d20803270621k7723ae47n337011beafe87cdb@mail.gmail.com>
Date: Thu, 27 Mar 2008 09:21:23 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: nbd: Oops because nbd doesn't prevent NBD_CLEAR_SOCK while sock_xmit() is working on a receive
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47EB94AB.6090608@steeleye.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6011_5403341.1206624083869"
References: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>
	 <47EB94AB.6090608@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6011_5403341.1206624083869
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Mar 27, 2008 at 8:35 AM, Paul Clements
<paul.clements@steeleye.com> wrote:
> Mike Snitzer wrote:
>
>  > In practice this looks like:
>  >
>  > nbd1: NBD_DISCONNECT
>  > nbd1: Send control failed (result -32)
>  > end_request: I/O error, dev nbd1, sector 0
>  > end_request: I/O error, dev nbd1, sector 8032264
>  > md: super_written gets error=-5, uptodate=0
>  > raid1: Disk failure on nbd1, disabling device.
>  >         Operation continuing on 1 devices
>  > Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>  >  [<ffffffff88b1e125>] :nbd:sock_xmit+0x9d/0x301
>
>  > The fact that sock_xmit() in receive mode is unprotected seems to be
>  > the WHY a NULL pointer is possible; but I'm still trying to identify
>  > the HOW.
>
>  Do you know who is setting the socket NULL? Is it already NULL when you
>  get to this point? Is it the nbd-client -d? Is it the original
>  nbd-client/kernel that does it? Figuring that out would help narrow down
>  the cause.

I believe that NBD_CLEAR_SOCK from 'nbd-client -d' sets it to NULL.
lo->sock is already NULL on entry to sock_xmit().

So simply checking if the sock_xmit's 'sock' is NULL _should_ avoid
any possibility of a NULL pointer Oops because sock can't be !NULL
after the negative check (because of the sock = lo->sock assignment).
That is, unless I'm missing somewhere in the rest of the kernel (not
nbd) that would take action to set a socket to NULL?

The attached patch seems reasonable.  I'll be testing today to verify
it fixes the problem.

>  > But for me this begs the question:  why isn't the nbd_device's socket
>  > always protected during sock_xmit() for both
>  > transmits and receives; rather than just transmits (via tx_lock)!?
>
>  It would deadlock if we held the lock over both. Generally we don't have
>  to worry about receives, since they're always done in the nbd-client
>  process, so we have control over when and how it exits and cleans up.
>  The odd case, as you've discovered, is when another process (nbd-client
>  -d) comes along and starts mucking with the queue and socket. Would
>  "kill -9 <nbd-client-pid>" work for you instead? That is what I use to
>  break the connection, and it's safe, as it tells the original nbd-client
>  to exit (which it does cleanly and safely).

I'm aware tx_lock can't be held over both; I was suggesting maybe
another lock but that feels like overkill.

I use 'nbd-client -d' and then resort to 'kill -9' IFF 'nbd-client -d'
returned non-zero.
But it sounds like simply using 'kill -9' could be a near-term
workaround, I'll try this as well and will report back.

thanks,
Mike

------=_Part_6011_5403341.1206624083869
Content-Type: text/x-patch; name=nbd_sock_xmit_oops.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_febcqjwh0
Content-Disposition: attachment; filename=nbd_sock_xmit_oops.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbmJkLmMgYi9kcml2ZXJzL2Jsb2NrL25iZC5jCmlu
ZGV4IGI1M2ZkYjAuLjU4Zjc3YjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYmxvY2svbmJkLmMKKysr
IGIvZHJpdmVycy9ibG9jay9uYmQuYwpAQCAtMTUzLDYgKzE1MywxMiBAQCBzdGF0aWMgaW50IHNv
Y2tfeG1pdChzdHJ1Y3QgbmJkX2RldmljZSAqbG8sIGludCBzZW5kLCB2b2lkICpidWYsIGludCBz
aXplLAogCXN0cnVjdCBrdmVjIGlvdjsKIAlzaWdzZXRfdCBibG9ja2VkLCBvbGRzZXQ7CiAKKwlp
ZiAodW5saWtlbHkoIXNvY2spKSB7CisJCXByaW50ayhLRVJOX0VSUiAiJXM6IEF0dGVtcHRlZCAl
cyBvbiBjbG9zZWQgc29ja2V0IGluIHNvY2tfeG1pdFxuIiwKKwkJICAgICAgIGxvLT5kaXNrLT5k
aXNrX25hbWUsIChzZW5kID8gInNlbmQiIDogInJlY3YiKSk7CisJCXJldHVybiAtRUlOVkFMOwor
CX0KKwkKIAkvKiBBbGxvdyBpbnRlcmNlcHRpb24gb2YgU0lHS0lMTCBvbmx5CiAJICogRG9uJ3Qg
YWxsb3cgb3RoZXIgc2lnbmFscyB0byBpbnRlcnJ1cHQgdGhlIHRyYW5zbWlzc2lvbiAqLwogCXNp
Z2luaXRzZXRpbnYoJmJsb2NrZWQsIHNpZ21hc2soU0lHS0lMTCkpOwo=
------=_Part_6011_5403341.1206624083869--
