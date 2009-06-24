Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbZFXUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbZFXUlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbZFXUlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:41:03 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59723 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761659AbZFXUlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ivMBP9MQ/Tv6znzDzKUSkSVu4B/EvWF9mYmallGmGQ5CuVhF4b3jqVzYHb9Vmgtwym
         T2YRtAdJ3FizFjUue2w5WZxNqhx/H9sYIjHt02yVCbkhoVU7Y1yCyHHHMbvRAyMrKpK4
         mOXRtgsL+QsUgPxZYWjr9Plry9NHtf7iyo4nE=
MIME-Version: 1.0
In-Reply-To: <20090624130441.1c25c40e@jbarnes-g45>
References: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com>
	 <200906242130.07583.rjw@sisk.pl>
	 <20090624195030.GS19977@parisc-linux.org>
	 <20090624130441.1c25c40e@jbarnes-g45>
Date: Wed, 24 Jun 2009 13:41:03 -0700
Message-ID: <dd18b0c30906241341r387dcaaaie437df2ff28ae1d8@mail.gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 6: no parent found for of device 
	[0xfffe0000-0xffffffff]
From: Justin Mattock <justinmattock@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 1:04 PM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> On Wed, 24 Jun 2009 13:50:30 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
>
>> On Wed, Jun 24, 2009 at 09:30:07PM +0200, Rafael J. Wysocki wrote:
>> > (Adding CC to linux-pci)
>>
>> Thanks Rafael.
>>
>> > On Wednesday 24 June 2009, Justin Mattock wrote:
>> > > (just pulled the latest git)
>> > > And am seeing this:
>> >
>> > Where pci 0000:01:00.0 and 0000:02:00.0 are what?
>> >
>> > > [    0.696001] pci 0000:01:00.0: BAR 6: no parent found for of
>> > > device [0xfffe0000-0xffffffff]
>>
>> So the message is coming from pci_claim_resource, and
>> if you bother to bisect, you'll track it back to my commit
>> a76117dfd687ec4be0a9a05214f3009cc5f73a42 .  What's going on here,
>> since this is BAR 6, is we have a ROM which has been mapped high, and
>> then not unmapped.  The BAR doesn't fit in the parent's window, so
>> the code is rightly declining to allocate the BAR.
>>
>> Before my patch, we silently didn't allocate the BARs.  Now we print
>> a message.  I wonder what to do ... we could silence this warning in
>> pci_claim_resource (patch below).  Or we could declare this to be a
>> bug, and fix it by disabling the ROM BAR (by clearing bit 0).
>>
>> I'm agnostic ... anyone have any preferences?
>
> Well, given that sometimes the ROM is important, it seems like an
> error.  Really we should be smarter about re-allocating things as
> necessary...
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>

I guess the easiest would be to silence the problem,
(but personally I don work that way)
So I opt for the second choice:
we could declare this to be a
bug, and fix it by disabling the ROM BAR (by clearing bit 0).

So If and when, I can test out a patch.

-- 
Justin P. Mattock
