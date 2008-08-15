Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYHOV0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYHOV0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYHOV0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:26:30 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:62713 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYHOV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bM3IVUWydVgaWhYkuSlu1KZiifleAAKOimWtGbA1jdB1R4ZxX+OlLtyxqbo+pfHTB7
         DTegaQcbkJ637FKsW3/jRsrgSh2XR2g7ngs+ybxXKU2EtQFSyUbxFkhrNI3jW68AU4KK
         kUzIm9dWZC+S3JonSSDYyA0A86F5EkIKHPF4A=
Message-ID: <19f34abd0808151426i69256b59m25a9a0676b50a6ba@mail.gmail.com>
Date: Fri, 15 Aug 2008 23:26:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not allocated
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	 <19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
	 <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 5:28 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> ida_remove called for id=112 which is not allocated.
>> ida_remove called for id=67 which is not allocated.
>> ida_remove called for id=191 which is not allocated.
>> ida_remove called for id=23 which is not allocated.
>>
>> ..and with no backtrace, so I guess it means "not harmful". Sorry for the noise.
>
> Thats definitely not good and wants digging into further.

Hi,

I've now been digging. This reproduces it accurately:

# mknod fubar c 128 42
# cat fubar
<ctrl-c>

idr_remove called for id=42 which is not allocated.

Major nr. 128 is UNIX98_PTY_MASTER_MAJOR. The
Documentation/devices.txt tells us to access these through /dev/ptmx
only. So when we don't follow that rule, tty_open() is called instead
of ptmx_open() when the device is opened. ptmx_open() would allocate a
new id to use. But since we call tty_open(), it will use tty->index
which is set from get_tty_driver() -- calculated using the minor
number that we provided!

The only thing I don't understand is why we don't get _two_ errors on
close() -- I would expect to get one for the slave too. But maybe the
slave is never created. What do you think of this theory?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
