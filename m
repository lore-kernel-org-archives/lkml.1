Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZEKRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZEKRdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZEKRdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:33:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61779 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZEKRdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:33:02 -0400
MIME-Version: 1.0
In-Reply-To: <20090511094151.6014cafb@infradead.org>
References: <20090509143742.GA27663@kroah.com> <m1pregmkld.fsf@fess.ebiederm.org> 
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk> <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com> 
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk> <ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com> 
	<20090511094151.6014cafb@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 19:32:42 +0200
Message-ID: <ac3eb2510905111032u13051b74g81573a18e3545a81@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 18:41, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 11 May 2009 18:28:20 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> It isn't slow. It's just that bootstrapping/re-constructing something
>> later can obviously never be faster than doing it when the device is
>> created.
>
> the performance gains from doing stuff in batches is obviously well
> established; CPU caches cause that. Not saying that's a hot factor
> here, the total only takes 0.01 second after all, but "obviously" isn't
> true here.

I'm just saying that we don't need any batch, we are in the context of
the device and can do the work there, while we are doing much more and
similar stuff anyway. You can apply your cache argument there too,
because the iterator for your list would need to get the context of
every device first, and we have that already.

>> I don't know of any obvious fixes to udev, otherwise I would have
>> implemented them.
>
> there's not much to fix afaics. It'd be nice if it was the 0.06 seconds
> that Eric gets, but 0.20 isn't all that bad either.

Good.

>> > sh < /sys/initial-device-list
>>
>> And you still need to cope with the races, and bring up the event
>> listener before that.
>
> so ?

As said, you need to listen to events before you look what's already
there, otherwise you may miss stuff in-between, and you might wait for
exactly that event.

The same applies when you leave initiramfs, the in-initramfs udevd
copy is killed, and the one from the real root is started. You may
miss events in-between, and need to run a full coldplug again, not
only to apply the policy, but also to make sure that all nodes are
there. The policy can run in the background for most things just fine,
the missing node may cause trouble.

>> This is less reliable and always slower than the
>> kernel provided nodes, besides that your /sys/initial-device-list will
>> be the same amount of code we need for the node creation right away,
>> without any of the other benefits, and will require another
>> special-case tool we don't use today.
>
> it's not about the amount of code. It's about in how many useful ways
> the code can be used!

Yeah, and I mentioned many other ways this is useful, to do stuff in
parallel, to be able to rescue, and to have custom systems which do
not need a full udev at all, where many embedded systems use mbox,
which can be made much simpler.

Thanks,
Kay
