Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbXKOVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbXKOVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbXKOVkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:40:32 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:12548 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbXKOVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZpR1bXp19CiaovbnRQm2ENp2JxpMmorDeCgV7ezkwDb3nsS8zsLUkQCwDI1qyoPMK8plOjHDEApd+nNJBce7UqhM0o1JnwzxIBXjJfXw+GcJY/bSMDW0GxzHG1dJ7Gn/cLtDQ6p8Bupdd6n9ig/xiyLyTk6cazL5OTB+KFF+mFg=
Message-ID: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
Date: Thu, 15 Nov 2007 22:40:13 +0100
From: "Jonas Danielsson" <the.sator@gmail.com>
To: "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0 (was: Strange behavior in arp probe reply, bug or feature?)
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071115154032.GA30391@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
	 <20071115154032.GA30391@ms2.inr.ac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I started to look at this code when I was working on a project of
rewriting a dhcp-client.
I wanted to make the client use arp to determine if the offered
address was free or in use.
Thats when I  noticed that linux machines responded in this, for me, odd way.

The problem is not really the target ip address in the reply, it is
the fact that the target hardware address is set to the hardware
address of the machines that is sending the reply.
The target hardware address should be the same as the destination
address in the ethernet frame.

The dhcp clients I examined, and the implementation of the arpcheck
that I use will compare the target hardware field of the arp-reply and
match it against its own mac, to verify the reply. And this fails with
the current implementation in the kernel.

As for the the target ip set to 0, that is the behavior I saw in
Windows and OpenBSD machines and figured it was a valid approach. The
main thing is however that the target machine address in the arp reply
in this case will confuse dhcp-clients trying to verify the reply.

And even if your arping implementation will work with any variant,
other implementation of this approach of duplicate ip detection
expects a differeant behavior.

Is there a reason that the target hardware address isn't the target
hardware address?

-Jonas

2007/11/15, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Hello!
>
> > Send a correct arp reply instead of one with sender ip and sender
> > hardware adress in target fields.
>
> I do not see anything more legal in setting target address to 0.
>
>
> Actually, semantics of target address in ARP reply is ambiguous.
> If it is a reply to some real request, it is set to address of requestor
> and protocol requires recipient of this arp reply to test that the address
> matches its own address before creating new entry triggered by unsolicited
> arp reply. That's all.
>
> In the case of duplicate address detection, requestor does not have
> any address, so that it is absolutely not essential what we use as target
> address. The only place, which could depend on this is the tool, which
> tests for duplicate address. At least, arping written by me, should
> work with any variant.
>
> So, please, could you explain what did force you to think that use of 0
> is better?
>
> Alexey
>
