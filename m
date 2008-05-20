Return-Path: <linux-kernel-owner+w=401wt.eu-S934469AbYETWDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbYETWDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934297AbYETWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:03:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:58923 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbYETWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gb2Mn2Rotk/EuV1O+UqZd33mTJT5ERVdHepj7jCQ8+6uSsINUOk0Htp+eRWa7KNFKk4YG3o4jfQR2ZrpcsC9L7vWk9brlOK0jPpuSh01c4gFkjsXBQwd0IWmn/Y+DRkAyLGR2zzdVK8ow94B5tLaXVZCCY2KyAH5SFDbAXk5qiU=
Message-ID: <7b9198260805201503j333963c4ya19b84f16b31d0fd@mail.gmail.com>
Date: Tue, 20 May 2008 23:03:10 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520212735.GA13319@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
	 <20080520161047.GA9598@c2.user-mode-linux.org>
	 <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
	 <20080520175624.GA10889@c2.user-mode-linux.org>
	 <7b9198260805201101x5b0fabf8h4944a29c6a4cae96@mail.gmail.com>
	 <20080520192436.GA12102@c2.user-mode-linux.org>
	 <7b9198260805201242p1adf4651kb4c434d73884b6c1@mail.gmail.com>
	 <20080520212735.GA13319@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 08:42:54PM +0100, Tom Spink wrote:
>> And this is what I did:
>
> Looks OK, but I need a Signed-off-by.
>
> Some style comments, which I can take care of if you don't feel like it:
>        there's only one use of PROC_MMAP_MIN_ADDR, so you might as
> well inline the filename
>        the stat is unnecessary - open failing will tell you what you
> need to know
>        the strtoul needs some error checking
>        I'd change the mmap_min_addr[8] to [sizeof("12345678")] to
> make it clear what's expected to fit into it
>
> On a less-stylistic note, this thing does have to work in the absence
> of /proc since UML is commonly run inside chroot.  So, I'm thinking we
> still need the loop looking for the bottom of the address space in
> this case.  And, if you have it, you might as well use it, as that's
> less code, and it makes sure the loop is exercised.  That grieves me a
> little, as I'd like to just read mmap_min_addr and be done with it in
> the normal case.
>
>                        Jeff
>
> --
> Work email - jdike at linux dot intel dot com
>

I was re-writing the patch, but after reading over the function, is
the return value correct? I did a quick run through on paper about
what would happen if the (real) bottom = 5 and the (real) top = 15,
and the (initial) top = 20.  So this is a size of 10 pages, which is
what the function should return... but:

top = 20, bottom = 5
test = 12
bottom = 12
(top - bottom) = 8

top = 20, bottom = 12
test = 16
top = 16
(top - bottom) = 4

top = 16, bottom = 12
test = 14
bottom = 14
(top - bottom) = 2

top = 16, bottom = 14
test = 15
bottom = 15
(top - bottom) = 1

<loop exits>

return 16 << UM_KERN_PAGE_SHIFT;

Hmm.  Are my calculations wrong?

-- 
Tom Spink
