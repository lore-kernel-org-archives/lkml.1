Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbXE3PnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbXE3PnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXE3PnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:43:11 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:39562 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXE3PnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Io4sIGmW7jPJvsYf31N0m36EPLZgSqL5/yHrfJrNKw+X9WfWUmFIbh/wtFXBhLEx3bmaYLIf3TPNDRtIvk/OpsdAN6A45pyEz/VbbvIBCkv3ZK4/IbwUPCqFpPO7vM63h1ayHItL688pI0Pt6siVQ+2gboK6WDAiKrW4K994+xU=
Message-ID: <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
Date: Wed, 30 May 2007 21:11:29 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: dealing with gcc 'comparison is always false' warnings (was: [PATCH] drivers/infiniband: fix comparsion between unsigned and negative)
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
In-Reply-To: <adazm3mqqh3.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	 <adazm3mqqh3.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Roland Dreier <rdreier@cisco.com> wrote:
> thanks... I'm wondering if there's a consensus among kernel hackers
> about changes like:
>
>  > -    if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
>  > +    if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
>  >              return -EINVAL;
>
> I understand that new gcc sees that hdr.cmd is unsigned and hence
> can't be < 0, and generates a warning for that, and having a build
> cluttered with warnings hides bugs and so on.  However the code here
> looks quite sensible to me -- otherwise we end up with missing range
> checking if hdr.cmd ever changes to a signed type.  This seems like a
> good way to introduce bugs: delete valid range checking code to shut
> up a silly gcc warning, and then change the type of a variable.

You're *absolutely* correct about the issue that these "fixes" that remove
such conditions end up remove range-checking making the code more
flakey / less readable.

However, gcc is _just as correct_. It is only crying about seeing a condition
that the programmer could have written with some purpose in mind but which
is being completely compiled away by it when generating the code because
of it being a tautology / contradiction ...

> Can't we just make gcc shut up about the comparison and generate no
> code for it because it knows it can't be true?

No, shutting gcc up wouldn't be the right thing, IMHO. These warnings are
a good reminder to the programmer to go and see if there is a real bug
somewhere and if something really needs to be done with the code (could
be simply to change the type of a variable to signed that was mistakenly
declared unsigned, f.e.).

But yes, the kind of "fixes" you pointed out that _remove_ these conditions
are definitely *not* what we would want to do.

Satyam
