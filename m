Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYAPLXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYAPLXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYAPLWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:22:52 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:62009 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYAPLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YCQ4oo+M211sINUAHu77Ih4sX9fU24Z2A7rQuLfl0COR/+5YwgcYcieiTU/Yb/qVnUYefBrx0MqkGzVaDOJ0tNPBhJPh8VZfIwNAIIuk4j7iv5oGIUI5BzzrKaid8osPs6PeQoejwiflPQawNHsdVYvfH3Yp7rAJhPPpA3pNJRM=
Message-ID: <4df4ef0c0801160322j31645554oa6faec5cca64509d@mail.gmail.com>
Date: Wed, 16 Jan 2008 14:22:49 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Rogier Wolff" <R.E.Wolff@bitwizard.nl>
Subject: Re: mtime updates for mmapped files.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080116094640.GA2071@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080116094640.GA2071@bitwizard.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/16, Rogier Wolff <R.E.Wolff@bitwizard.nl>:
>
> Hi,
>
> I  wrote a small app yesterday that updates a file by mmapping the
> file (RW), changing the thing around, and then exiting.
>
> This did not trigger a change in the mtime of the file. Thus rsync
> didn't pick up that the file had changed.
>
> I understand that tracking every change to a RW mmapped file is
> costly, and thus unfeasable, but shouldn't then the close cause a
> mtime update?
>
> The server where this happened is running 2.6.21, so my apologies if
> this has already been corrected.

Unfortunately, this issue has not been fully fixed yet.

My last attempt (http://lkml.org/lkml/2008/1/15/202) to solve
this problem has a couple of drawbacks:

1) calling a possibly sleeping function from atomic context -
I've already corrected this;

2) there's a very special case with retouching the memory-mapped data
after a call to msync() with MS_ASYNC.

I'm still working on the latter case, but I guess that I have found a solution.

If you badly need a quick fix, I can send my working unreleased patch to you.
I reckon that your particular problem will be fixed by this patch.
Let me know if you want that.

However, if your application calls msync() with the MS_ASYNC flag,
it's better to wait a little bit more - I'll release the next version
of my solution
shortly.

>
>         Roger.
>
> --
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement.
> Does it sit on the couch all day? Is it unemployed? Please be specific!
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
