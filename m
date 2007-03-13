Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXCMQZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXCMQZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXCMQZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:25:08 -0400
Received: from 25.mail-out.ovh.net ([213.186.37.103]:46531 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030767AbXCMQZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:25:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 12:25:00 EDT
Date: 13 Mar 2007 16:18:06 -0000
To: davem@davemloft.net
Subject: Re: irda rmmod lockdep trace.
X-IlohaMail-Blah: samuel@sortiz.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: OVH (On: ssl0.ovh.net)
Message-ID: <8tejGYZp.1173802686.7158480.samuel@sortiz.org>
In-Reply-To: <20070312.164921.71090866.davem@davemloft.net>
From: "Samuel Ortiz" <samuel@sortiz.org>
Bounce-To: "Samuel Ortiz" <samuel@sortiz.org>
CC: "davej@redhat.com" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/12/2007, "David Miller" <davem@davemloft.net> wrote:

>From: Samuel Ortiz <samuel@sortiz.org>
>Date: Mon, 12 Mar 2007 02:38:43 +0200
>
>> On Sat, Mar 10, 2007 at 07:43:26PM +0200, Samuel Ortiz wrote:
>> > Hi Dave,
>> >
>> > On Thu, Mar 08, 2007 at 05:54:36PM -0500, Dave Jones wrote:
>> > > modprobe irda ; rmmod irda in 2.6.21rc3 gets me the spew below..
>> > Well it seems that we call __irias_delete_object() from hashbin_delete(). Then
>> > __irias_delete_object() calls itself hashbin_delete() again. We're trying to
>> > get the lock recursively.
>> Looking at the code more carefully, this seems to be a false positive:
>> iriap_cleanup and and __irias_delete_object are taking 2 different locks from
>> 2 different hashbin instances. The locks belong to the same lock class but
>> they are hierarchically different. We need to tell the validator about it and
>> the following patch does that. Comments are welcomed as I'm planning to push
>> it to netdev soon:
>
>I would strongly caution against adding any run-time overhead just to
>cure a false lockdep warning.  Even adding a new function argument
>is too much IMHO.
>
>Make the cost show up for lockdep only, perhaps by putting each
>hashbin lock into a seperate locking class?
I considered that solution as well, and thought that it would then
prevent the hasbin locks from being ever validated by lockdep.
OTOH, the hashbin code is not likely to change anytime soon and is
currently validated.
Also, you will eventually push this code upstream, so I'd rather go for
that fix ;-)

Thanks for the comment.

Cheers,
Samuel.
