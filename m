Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYHaKgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYHaKgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYHaKgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:36:00 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:15811 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbYHaKf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h2XdJBwA46UnOuG3Vq7PWvLDgsrdJOOpEUqB38xgajvQrgvh157IRXqifvAC/SZdcK
         kDg+4l0qaHnGLEcW4rX5Xoa32S22yfbw2g6XpXr7f0z27ivCfNOWV/2UWjovNPwteFYt
         46LMA0Ec/0Gjqdu/xTXH/O4j2qF4DD1mROOJk=
Message-ID: <19f34abd0808310335u12242a3fode17effccf1e9533@mail.gmail.com>
Date: Sun, 31 Aug 2008 12:35:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v2
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org, neilb@suse.de
In-Reply-To: <20080831100806.GD7391@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080831100806.GD7391@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 12:08 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Vegard Nossum reported
> ----------------------
>> I noticed that something weird is going on with /proc/sys/sunrpc/transports.
>> This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
>> I "cat" this file, I get the expected output:
>>    $ cat /proc/sys/sunrpc/transports
>>    tcp 1048576
>>    udp 32768
>
>> But I think that it does not check the length of the buffer supplied by
>> userspace to read(). With my original program, I found that the stack was
>> being overwritten by the characters above, even when the length given to
>> read() was just 1.
>
> David Wagner added (among other things) that copy_to_user could be
> probably used here.
>
> The conclusion is that proc_do_xprt doesn't check for userside buffer
> size indeed so fix. Also set lenp to number of bytes were really written.
>
> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: David Wagner <daw@cs.berkeley.edu>
> ---
>
> Please review.

read() returns the correct number of bytes written in to the buffer.
read() does not overwrite the buffer past the length that the user supplied.
Too small buffer results in a partial data.

But trying to call read() twice results in first a partial buffer, then EOF:

open("/proc/sys/sunrpc/transports", O_RDONLY) = 3
read(3, "tc", 2)                        = 2
read(3, "", 2)                          = 0

Maybe this can be fixed later.

Tested-by: Vegard Nossum <vegard.nossum@gmail.com>


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
