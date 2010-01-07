Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434Ab0AGNly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0AGNly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222Ab0AGNlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:41:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46696 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0AGNlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u5NU6L0CVvdCb7lKduZJC5fQDyuonp0BRsAp1fF+U9VbAAbWCkP5w9ZRGbHlTOug7O
         l3LDRZnE31dIaiqXY7hr1raonLeNrTFtL67EGtGE1jeDn0sRnzXWu5PsxoZav5uGZmyX
         z1T3xiS6L5Hla5rxA0JDQ+pEDXJAyEQr08F8s=
MIME-Version: 1.0
In-Reply-To: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
References: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
Date: Thu, 7 Jan 2010 14:41:51 +0100
Message-ID: <4e5e476b1001070541y30cae741ofe16ab82670b2633@mail.gmail.com>
Subject: Re: Multi-file USB mass-storage copy from PC to Nokia N900 slow when 
	using CFQ
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Paul Hartman <paul.hartman+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 5:07 PM, Paul Hartman
<paul.hartman+linux@gmail.com> wrote:
> Hi,
>
> Copying more than one file from my PC (kernel 2.6.32) to my Nokia N900
> over USB mass storage mode is very slow when CFQ is the i/o scheduler.
> The target uses vfat filesystem.
>
> I am using iotop to monitor the I/O in general, plus I performed the
> following test. file1 and file2 are each 700M and both housed on a
> ramdrive for this test. They were deleted from the destination between
> runs.
>
> # one file at a time with sync in-between, fast speeds:
> $ sync; time sh -c "cp file1 /mnt/usb; sync; cp file2 /mnt/usb; sync"
>
> real    1m25.697s
> user    0m0.005s
> sys     0m2.509s
>
> # copy two files in a row, then sync, speed is bad:
> $ sync; time sh -c "cp file1 file2 /mnt/usb; sync"
>
> real    6m51.439s
> user    0m0.007s
> sys     0m2.615s
>
>
> Using all I/O schedulers, the speed of the first test was the same. So
> it's only related to writing more than 1 file to the N900. The timing
> results for the second test ended up as such:
>
> cfq: 6m51.439s
> noop: 3m0.733s
> anticipatory: 1m44.348s
> deadline: 1m36.804s
>
>
> Also, in 2.6.31 the speed was four times slower, so the removal of old
> pdflush code may have made a difference in this case. Copying 1
> gigabyte takes about 1 minute at optimal speed, about 5 minutes using
> CFQ in kernel 2.6.32, and took about 20 minutes using CFQ in kernel
> 2.6.31.
>
> I thought you may be interested in case there's room to improve the
> scheduler.  If you want any other info let me know!

Can you try setting:
/sys/block/**your_device** /queue/iosched/fifo_expire_sync
to a large number, e.g. 5000 ?
CFQ operates pretty much like deadline w.r.t. normal writes, but uses
a much shorter interval to switch between two streams of writes, to
reduce latency of data hitting disk, and this could cause low
performance on flash devices, where writes that do not cover whole
blocks are painfully slow.

Corrado
>
> Thanks
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
